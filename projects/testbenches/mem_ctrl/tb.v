`timescale 1ns/1ps
// Testbench for mem_ctrl: a memory controller driving an external synchronous SRAM (spec: ../SPEC.md).
//
// The tb owns the SRAM model and an "expected image" of memory that is updated in request-
// acceptance order. It does not assume any particular latency or throughput. Checks:
//   SRAM commands  every command (ce_n=0 at a rising edge) must be the next accepted request, in
//                  order: same op, same address, and for writes the same data on dq.
//                  No other commands. A command during reset is an error.
//   responses      every rsp_valid pulse must be the oldest pending read, carrying the value the
//                  image held when that read was accepted. No response without a pending read.
//   data bus       mid-cycle: when the SRAM is not driving, dq must be fully driven in a write
//                  command cycle and all Z otherwise (controller drives only for writes); when the
//                  SRAM drives read data, dq must equal it (no contention).
//   oe_n           low in every cycle the SRAM outputs read data, high in write command cycles.
//   reset          async active low: within 1 ns of rst_n falling, and for as long as it is low:
//                  ce_n=we_n=oe_n=1, rsp_valid=0, req_ready=0, dq released. Pending requests are
//                  dropped. After release, req_ready=1 within 4 cycles.
//   X/Z            control outputs never X/Z while out of reset.
//   bounds         a held request is accepted within 16 cycles; an accepted request reaches the
//                  SRAM within 16 cycles; a read is answered within READ_LATENCY+16 cycles.
//   image          at the end of many tests the whole SRAM must equal the expected image.
// All checks are kind=func.
//
// Override sizes / latency with: iverilog -Ptb.AW=<n> -Ptb.DW=<n> -Ptb.L=<n> ...  (L = READ_LATENCY, 1..8)
module tb;
  parameter AW = 4, DW = 8, L = 2;
  localparam DEPTH = 1 << AW, MAX_WAIT = 16;
  reg clk = 0, rst_n;                         // rst_n starts X and falls at 0.2 ns (power-on reset)
  reg req_valid = 0, req_we = 0;
  reg [AW-1:0] req_addr = 0;
  reg [DW-1:0] req_wdata = 0;
  wire req_ready, rsp_valid, sram_ce_n, sram_we_n, sram_oe_n;
  wire [DW-1:0] rsp_rdata;
  wire [AW-1:0] sram_addr;
  wire [DW-1:0] sram_dq;
  integer cycle = 0;

  mem_ctrl #(.AW(AW), .DW(DW), .READ_LATENCY(L)) dut (
    .clk(clk), .rst_n(rst_n),
    .req_valid(req_valid), .req_ready(req_ready), .req_we(req_we), .req_addr(req_addr),
    .req_wdata(req_wdata), .rsp_valid(rsp_valid), .rsp_rdata(rsp_rdata),
    .sram_ce_n(sram_ce_n), .sram_we_n(sram_we_n), .sram_oe_n(sram_oe_n),
    .sram_addr(sram_addr), .sram_dq(sram_dq));
  always #5 clk = ~clk;                       // rising edges at 5, 15, 25, ...
  always @(posedge clk) cycle <= cycle + 1;

  `include "tb_common.vh"

  task automatic flush_trace; endtask

  // ---------------------------------------------------------------- SRAM model
  // Command sampled at rising edge k when ce_n=0: we_n=0 writes dq to mem[addr]; we_n=1 reads
  // mem[addr], and the SRAM drives that data on dq for the cycle between edges k+L-1 and k+L
  // (only while oe_n=0). The controller captures it at edge k+L. Reset does not affect the SRAM.
  reg [DW-1:0] mem [0:DEPTH-1];
  reg [DW-1:0] img [0:DEPTH-1];               // expected contents, in acceptance order
  reg          pv  [0:8];                     // read pipeline: valid / live / data / address
  reg          pl  [0:8];                     // live = issued since the last reset (stale reads are not checked)
  reg [DW-1:0] pd  [0:8];
  reg [AW-1:0] pa  [0:8];
  reg sram_drv = 0, sram_live = 0; reg [DW-1:0] sram_out = 0; reg [AW-1:0] sram_out_a = 0;
  assign sram_dq = (sram_drv && sram_oe_n === 1'b0) ? sram_out : {DW{1'bz}};

  integer i0;
  initial begin
    for (i0 = 0; i0 < DEPTH; i0 = i0 + 1) begin mem[i0] = (i0 * 37 + 11) ^ (i0 << 3) ^ {DW/2{2'b10}}; img[i0] = mem[i0]; end
    for (i0 = 0; i0 <= 8; i0 = i0 + 1) begin pv[i0] = 0; pl[i0] = 0; end
  end

  // ---------------------------------------------------------------- scoreboard queues
  // cq: accepted requests not yet seen at the SRAM; rq: accepted reads not yet answered.
  reg          cq_we [0:255]; reg [AW-1:0] cq_a [0:255]; reg [DW-1:0] cq_d [0:255]; integer cq_t [0:255];
  reg [AW-1:0] rq_a  [0:255]; reg [DW-1:0] rq_d [0:255]; integer rq_t [0:255];
  integer cq_wr = 0, cq_rd = 0, rq_wr = 0, rq_rd = 0;
  integer n_acc = 0, n_rsp = 0, n_cmd = 0;
  reg checking = 0;

  function automatic string mctx;
    mctx = $sformatf("rst_n=%b req_valid=%b req_ready=%b req_we=%b req_addr=%0h req_wdata=%0h ce_n=%b we_n=%b oe_n=%b sram_addr=%0h dq=%0h sram_driving=%0b sram_data=%0h rsp_valid=%b rsp_rdata=%0h pending_cmds=%0d pending_reads=%0d",
                     rst_n, req_valid, req_ready, req_we, req_addr, req_wdata, sram_ce_n, sram_we_n,
                     sram_oe_n, sram_addr, sram_dq, sram_drv && sram_oe_n === 1'b0, sram_out,
                     rsp_valid, rsp_rdata, cq_wr - cq_rd, rq_wr - rq_rd);
  endfunction

  // Everything at a rising edge is evaluated from the values driven during the cycle that just
  // ended (the DUT's nonblocking updates have not landed yet). `e` is that edge's number.
  always @(posedge clk) begin : edge_eval
    integer e, i;
    reg ok;
    e = cycle + 1; cyc_bad = 0;

    // SRAM: shift the read pipeline, take this edge's command
    for (i = 8; i > 0; i = i - 1) begin pv[i] = pv[i - 1]; pl[i] = pl[i - 1]; pd[i] = pd[i - 1]; pa[i] = pa[i - 1]; end
    pv[0] = 0; pl[0] = 0;
    if (sram_ce_n === 1'b0) begin
      if (sram_we_n === 1'b0) mem[sram_addr] = sram_dq;
      else if (sram_we_n === 1'b1) begin pv[0] = 1; pl[0] = rst_n === 1'b1; pd[0] = mem[sram_addr]; pa[0] = sram_addr; end
    end
    sram_drv <= pv[L - 1]; sram_live <= pv[L - 1] && pl[L - 1]; sram_out <= pd[L - 1]; sram_out_a <= pa[L - 1];

    if (checking && rst_n === 1'b1) begin
      // 1. acceptance
      if (req_valid === 1'b1 && req_ready === 1'b1) begin
        n_acc = n_acc + 1;
        cq_we[cq_wr % 256] = req_we; cq_a[cq_wr % 256] = req_addr; cq_d[cq_wr % 256] = req_wdata;
        cq_t[cq_wr % 256] = e; cq_wr = cq_wr + 1;
        if (req_we) begin
          img[req_addr] = req_wdata;
          txn("ACCEPT", $sformatf("op=WR addr=%0h data=%0h", req_addr, req_wdata), 1);
        end else begin
          rq_a[rq_wr % 256] = req_addr; rq_d[rq_wr % 256] = img[req_addr]; rq_t[rq_wr % 256] = e;
          rq_wr = rq_wr + 1;
          txn("ACCEPT", $sformatf("op=RD addr=%0h expect=%0h", req_addr, img[req_addr]), 1);
        end
      end

      // 2. SRAM command
      if (sram_ce_n === 1'b0) begin
        n_cmd = n_cmd + 1;
        if (cq_rd == cq_wr) begin
          err(1, "sram_ce_n", 1, 0, mctx(), "SRAM command with no pending request");
          txn("SRAM_CMD", $sformatf("we_n=%b addr=%0h expected=none", sram_we_n, sram_addr), 0);
        end else begin
          ok = 1;
          if (sram_we_n !== !cq_we[cq_rd % 256]) begin
            ok = 0; err(1, "sram_we_n", !cq_we[cq_rd % 256], sram_we_n, mctx(), "SRAM command is the wrong operation (or out of order)");
          end
          if (sram_addr !== cq_a[cq_rd % 256]) begin
            ok = 0; err(1, "sram_addr", cq_a[cq_rd % 256], sram_addr, mctx(), "SRAM command address != accepted request address");
          end
          if (cq_we[cq_rd % 256] && sram_dq !== cq_d[cq_rd % 256]) begin
            ok = 0; err(1, "sram_dq", cq_d[cq_rd % 256], sram_dq, mctx(), "write data on dq at the command edge != accepted write data");
          end
          if (cq_we[cq_rd % 256])
            txn("SRAM_WR", $sformatf("addr=%0h data=%0h exp_addr=%0h exp_data=%0h", sram_addr, sram_dq,
                cq_a[cq_rd % 256], cq_d[cq_rd % 256]), ok);
          else
            txn("SRAM_RD", $sformatf("addr=%0h exp_addr=%0h", sram_addr, cq_a[cq_rd % 256]), ok);
          cq_rd = cq_rd + 1;
        end
      end else if (sram_ce_n !== 1'b1) err(1, "sram_ce_n", 1, sram_ce_n, mctx(), "ce_n is X/Z");

      // 3. response
      if (rsp_valid === 1'b1) begin
        n_rsp = n_rsp + 1;
        if (rq_rd == rq_wr) begin
          err(1, "rsp_valid", 0, 1, mctx(), "response with no pending read");
          txn("RESPONSE", $sformatf("got=%0h expected=none", rsp_rdata), 0);
        end else begin
          ok = rsp_rdata === rq_d[rq_rd % 256];
          if (!ok)
            err(1, "rsp_rdata", rq_d[rq_rd % 256], rsp_rdata,
                $sformatf("read_addr=%0h accepted_cycle=%0d %0s", rq_a[rq_rd % 256], rq_t[rq_rd % 256], mctx()),
                "read data != memory value at accept time (wrong capture cycle, bus not released, stale or reordered?)");
          txn("RESPONSE", $sformatf("addr=%0h got=%0h exp=%0h latency=%0d", rq_a[rq_rd % 256], rsp_rdata,
              rq_d[rq_rd % 256], e - rq_t[rq_rd % 256]), ok);
          rq_rd = rq_rd + 1;
        end
      end else if (rsp_valid !== 1'b0) err(1, "rsp_valid", 0, rsp_valid, mctx(), "rsp_valid is X/Z");

      // 4. bounds
      if (rq_rd != rq_wr && e - rq_t[rq_rd % 256] > L + MAX_WAIT) begin
        err(1, "rsp_valid", 1, 0, $sformatf("read_addr=%0h %0s", rq_a[rq_rd % 256], mctx()),
            "read not answered within READ_LATENCY+16 cycles of acceptance");
        rq_rd = rq_rd + 1;
      end
      if (cq_rd != cq_wr && e - cq_t[cq_rd % 256] > MAX_WAIT) begin
        err(1, "sram_ce_n", 0, 1, mctx(), "accepted request did not reach the SRAM within 16 cycles");
        cq_rd = cq_rd + 1;
      end

      if (cyc_on)
        $display("  c=%5d t=%4d  req v=%b rdy=%b we=%b a=%0h wd=%0h | sram ce_n=%b we_n=%b oe_n=%b a=%0h dq=%0h%0s | rsp v=%b rd=%0h%0s",
                 e, e - test_start, req_valid, req_ready, req_we, req_addr, req_wdata,
                 sram_ce_n, sram_we_n, sram_oe_n, sram_addr, sram_dq,
                 (sram_drv && sram_oe_n === 1'b0) ? " (sram)" : "", rsp_valid, rsp_rdata,
                 cyc_bad ? "  <-- MISMATCH" : "");
    end
  end

  // ---------------------------------------------------------------- mid-cycle bus / pin checks
  task automatic check_reset_outputs(input string when);
    begin
      if (sram_ce_n !== 1'b1) err(1, "sram_ce_n", 1, sram_ce_n, mctx(), {"ce_n must be 1 ", when});
      if (sram_we_n !== 1'b1) err(1, "sram_we_n", 1, sram_we_n, mctx(), {"we_n must be 1 ", when});
      if (sram_oe_n !== 1'b1) err(1, "sram_oe_n", 1, sram_oe_n, mctx(), {"oe_n must be 1 ", when});
      if (rsp_valid !== 1'b0) err(1, "rsp_valid", 0, rsp_valid, mctx(), {"rsp_valid must be 0 ", when});
      if (req_ready !== 1'b0) err(1, "req_ready", 0, req_ready, mctx(), {"req_ready must be 0 ", when});
      if (sram_dq !== {DW{1'bz}}) err(1, "sram_dq", {DW{1'bz}}, sram_dq, mctx(), {"dq must be released (Z) ", when});
    end
  endtask

  always @(negedge clk) if (checking) begin
    if (rst_n === 1'b0) check_reset_outputs("while rst_n is low");
    else if (rst_n === 1'b1) begin
      if (sram_live) begin                         // read data for a live command is due this cycle
        if (sram_oe_n !== 1'b0)
          err(1, "sram_oe_n", 0, sram_oe_n, $sformatf("data_addr=%0h %0s", sram_out_a, mctx()),
              "oe_n not low while the SRAM read data is due (READ_LATENCY handling?)");
        else if (sram_dq !== sram_out)
          err(1, "sram_dq", sram_out, sram_dq, mctx(), "bus contention: controller drives dq while the SRAM outputs read data");
      end
      if (!(sram_drv && sram_oe_n === 1'b0)) begin  // only the controller can be driving dq
        if (sram_ce_n === 1'b0 && sram_we_n === 1'b0) begin
          if ((^sram_dq) === 1'bx) err(1, "sram_dq", 0, sram_dq, mctx(), "write data not fully driven during the write command cycle");
          if (sram_oe_n !== 1'b1) err(1, "sram_oe_n", 1, sram_oe_n, mctx(), "oe_n low during a write command cycle");
        end else if (sram_dq !== {DW{1'bz}})
          err(1, "sram_dq", {DW{1'bz}}, sram_dq, mctx(), "controller drives dq outside a write command cycle");
      end
      if (sram_ce_n === 1'b0 && sram_we_n !== 1'b0 && sram_we_n !== 1'b1)
        err(1, "sram_we_n", 1, sram_we_n, mctx(), "we_n is X/Z during a command");
      if (sram_oe_n !== 1'b0 && sram_oe_n !== 1'b1) err(1, "sram_oe_n", 1, sram_oe_n, mctx(), "oe_n is X/Z");
      if (req_ready !== 1'b0 && req_ready !== 1'b1) err(1, "req_ready", 1, req_ready, mctx(), "req_ready is X/Z");
    end
  end

  // Reset: outputs must go inactive asynchronously; everything pending is dropped.
  always @(negedge rst_n) begin
    for (i0 = 0; i0 < DEPTH; i0 = i0 + 1) begin img[i0] = mem[i0]; end
    for (i0 = 0; i0 <= 8; i0 = i0 + 1) pl[i0] = 0;
    sram_live = 0;
    if (checking && (cq_rd != cq_wr || rq_rd != rq_wr))
      txn("RESET", $sformatf("dropped_cmds=%0d dropped_reads=%0d", cq_wr - cq_rd, rq_wr - rq_rd), 1);
    cq_rd = cq_wr; rq_rd = rq_wr;
    #1;
    if (checking && rst_n === 1'b0) check_reset_outputs("within 1ns of rst_n falling (reset must be asynchronous)");
  end

  // ---------------------------------------------------------------- stimulus helpers
  // Stimulus changes 1 ns after a falling edge (the "cursor"), half a cycle from the rising edge.

  // Present a request and hold it until accepted. keep=1 leaves req_valid high afterwards.
  task automatic req(input bit we, input [AW-1:0] a, input [DW-1:0] d, input bit keep);
    integer n0, n;
    begin
      @(negedge clk); #1; req_valid = 1; req_we = we; req_addr = a; req_wdata = d;
      n0 = n_acc; n = 0;
      while (n_acc == n0) begin
        @(posedge clk); #1; n = n + 1;
        if (n > MAX_WAIT) hang("request never accepted (req_ready stuck low?)");
      end
      // fields change right after acceptance: the controller must have latched them
      if (!keep) begin req_valid = 0; req_we = $random(seed); req_addr = $random(seed); req_wdata = $random(seed); end
    end
  endtask

  task automatic wr(input [AW-1:0] a, input [DW-1:0] d); req(1, a, d, 0); endtask
  task automatic rd(input [AW-1:0] a); req(0, a, 0, 0); endtask

  // Wait until nothing is pending and req_ready is back.
  task automatic drain;
    integer n;
    begin
      @(negedge clk); #1; req_valid = 0;
      n = 0;
      while (!(cq_rd == cq_wr && rq_rd == rq_wr && req_ready === 1'b1)) begin
        @(negedge clk); n = n + 1;
        if (n > 2 * MAX_WAIT + L) begin
          err(1, "drain", 0, 1, mctx(), "requests still pending or req_ready low long after traffic stopped");
          cq_rd = cq_wr; rq_rd = rq_wr;
          disable drain;
        end
      end
      repeat (L + 2) @(negedge clk);   // late responses / commands still get flagged in this test
      #1;
    end
  endtask

  task automatic wait_ready_after_reset;
    integer k;
    begin
      k = 0;
      while (req_ready !== 1'b1) begin
        @(negedge clk); k = k + 1;
        if (k > 4) begin err(1, "req_ready", 1, req_ready, mctx(), "req_ready not 1 within 4 cycles of reset release"); disable wait_ready_after_reset; end
      end
    end
  endtask

  // Assert rst_n `ph` ns after the call (any clock phase), hold over n rising edges, release at
  // the cursor, then wait for req_ready.
  task automatic reset_at_phase(input real ph, input integer n);
    begin
      #(ph) rst_n = 0; req_valid = 0;
      repeat (n) @(posedge clk);
      @(negedge clk); #1; rst_n = 1;
      wait_ready_after_reset;
    end
  endtask

  task automatic compare_image;
    integer i, bad;
    begin
      bad = 0;
      for (i = 0; i < DEPTH; i = i + 1)
        if (mem[i] !== img[i]) begin
          err(1, "sram_mem", img[i], mem[i], $sformatf("addr=%0h", i), "SRAM contents differ from the expected image (lost, extra or misaddressed write)");
          bad = bad + 1;
        end
      txn("IMAGE_CHECK", $sformatf("words=%0d differ=%0d", DEPTH, bad), bad == 0);
    end
  endtask

  task automatic idle(input integer n); repeat (n) @(negedge clk); endtask

  // Reset exactly on a rising edge is a race (a recovery/removal violation in hardware); keep
  // asserted phases at least 0.5 ns from the edges (cursor+4 = rising, cursor+9 = falling).
  function automatic real safe_phase(input real ph);
    if (ph > 3.5 && ph < 4.5) safe_phase = ph + 1.0;
    else if (ph > 8.5) safe_phase = 8.0;
    else safe_phase = ph;
  endfunction

  function automatic integer urand(input integer m);
    urand = ($random(seed) & 32'h7fffffff) % m;
  endfunction

  // ---------------------------------------------------------------- tests
  integer i, k, off;
  reg [AW-1:0] a;
  real ph;
  initial begin
    #0.2 rst_n = 0; checking = 1;
    $display("AW=%0d DW=%0d depth=%0d READ_LATENCY=%0d", AW, DW, DEPTH, L);

    begin_test("power_on_async_reset", 0);
    repeat (3) @(posedge clk);
    @(negedge clk); #1; rst_n = 1; wait_ready_after_reset;
    end_test;

    begin_test("idle_after_reset", 0);
    for (i = 0; i < 12; i = i + 1) begin
      @(negedge clk);
      if (req_ready !== 1'b1) err(1, "req_ready", 1, req_ready, mctx(), "req_ready must be 1 when idle");
    end
    end_test;

    begin_test("read_preloaded", 0);
    rd(0); rd(1); rd(DEPTH - 1); rd(DEPTH / 2); drain; end_test;

    begin_test("write_then_read", 0);
    wr(3, 8'hA5); rd(3); drain; end_test;

    begin_test("boundary_data_and_addresses", 0);
    wr(0, 0); wr(DEPTH - 1, {DW{1'b1}}); wr(1, {DW{1'b1}}); wr(DEPTH - 2, 0);
    rd(0); rd(DEPTH - 1); rd(1); rd(DEPTH - 2); drain; compare_image; end_test;

    begin_test("read_after_write_same_addr_back_to_back", 0);
    for (i = 0; i < 4; i = i + 1) begin req(1, i, 8'h30 + i, 1); req(0, i, 0, 1); end
    drain; end_test;

    begin_test("write_after_write_same_addr", 0);
    req(1, 5, 8'h11, 1); req(1, 5, 8'h22, 1); req(1, 5, 8'h33, 1); req(0, 5, 0, 0); drain;
    compare_image; end_test;

    begin_test("write_after_read_same_addr", 0);
    req(0, 6, 0, 1); req(1, 6, 8'h66, 1); req(0, 6, 0, 0); drain; end_test;

    // Read immediately followed by a write: the write data must not collide with the read data
    // on dq (bus turnaround), whatever READ_LATENCY is.
    begin_test("read_then_write_bus_turnaround", 0);
    for (i = 0; i < 6; i = i + 1) begin req(0, i, 0, 1); req(1, i + 8, 8'hC0 + i, 1); end
    drain; for (i = 0; i < 6; i = i + 1) rd(i + 8); drain; compare_image;
    end_test;

    begin_test("alternating_read_write_stream", 0);
    for (i = 0; i < 32; i = i + 1) req(i & 1, i / 2, i * 7 + 1, 1);
    drain; compare_image; end_test;

    begin_test("consecutive_reads", 0);
    for (i = 0; i < 8; i = i + 1) req(0, i, 0, 1);
    drain; end_test;

    begin_test("idle_bus_garbage", 0);
    for (i = 0; i < 40; i = i + 1) begin
      @(negedge clk); #1; req_valid = 0; req_we = $random(seed); req_addr = $random(seed); req_wdata = $random(seed);
    end
    drain; compare_image; end_test;

    // Fields change every cycle while req_valid waits for req_ready; only the accepted values count.
    begin_test("fields_change_before_accept", 0);
    req(0, 2, 0, 0);
    for (i = 0; i < 6; i = i + 1) begin
      @(negedge clk); #1; req_valid = 1; req_we = 1; req_addr = $random(seed); req_wdata = $random(seed);
    end
    drain; for (i = 0; i < DEPTH; i = i + 1) rd(i); drain; compare_image;
    end_test;

    // Reset at every cycle of a read (accepted, command, waiting for data, data cycle, after),
    // asserted mid-cycle: no response may follow, the bus must be released, a new read works.
    begin_test("reset_during_read_every_cycle", 0);
    for (off = 0; off < L + 4; off = off + 1) begin
      rd(off % DEPTH); idle(off); #2; reset_at_phase(0, 1); idle(L + 2); rd(off % DEPTH); drain;
    end
    end_test;

    begin_test("reset_during_write_every_cycle", 0);
    for (off = 0; off < 5; off = off + 1) begin
      wr((off + 9) % DEPTH, 8'hC0 + off); idle(off); #2; reset_at_phase(0, 1); idle(3);
      rd((off + 9) % DEPTH); drain; compare_image;
    end
    end_test;

    // Reset asserted at different clock phases (just before / just after a rising edge, etc.).
    begin_test("reset_at_various_phases", 0);
    for (k = 0; k < 6; k = k + 1) begin
      case (k) 0: ph = 0.5; 1: ph = 2.0; 2: ph = 3.5; 3: ph = 4.5; 4: ph = 6.0; default: ph = 8.5; endcase
      req(0, k, 0, 1); req(1, k + 4, 8'h50 + k, 0);
      reset_at_phase(ph, 1 + (k & 1));
      rd(k); rd(k + 4); drain; compare_image;
    end
    end_test;

    begin_test("write_all_read_all_gapped", 1);
    for (i = 0; i < DEPTH; i = i + 1) begin wr(i, i * 13 + 7); idle(i % 3); end
    for (i = 0; i < DEPTH; i = i + 1) begin rd(i); idle(i % 3); end
    drain; compare_image; end_test;

    begin_test("write_all_read_all_back_to_back", 1);
    for (i = 0; i < DEPTH; i = i + 1) req(1, i, ~(i * 29), 1);
    for (i = 0; i < DEPTH; i = i + 1) req(0, DEPTH - 1 - i, 0, 1);
    drain; compare_image; end_test;

    begin_test("random_traffic", 1);
    for (i = 0; i < 3000; i = i + 1) begin
      a = $random(seed);
      req($random(seed), a, $random(seed), $random(seed));
      if (urand(8) == 0) idle(urand(5));
    end
    drain; compare_image; end_test;

    begin_test("random_traffic_with_resets", 1);
    for (i = 0; i < 500; i = i + 1) begin
      a = $random(seed);
      req($random(seed), a, $random(seed), $random(seed));
      if (urand(30) == 0) begin ph = safe_phase(urand(90) / 10.0); reset_at_phase(ph, 1 + urand(2)); end
    end
    drain; compare_image; end_test;

    $display("accepted=%0d sram_commands=%0d responses=%0d", n_acc, n_cmd, n_rsp);
    finish_all;
  end

  initial begin #10000000; hang("global timeout"); end
endmodule
