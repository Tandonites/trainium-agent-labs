`timescale 1ns/1ps
// Testbench for uart_tx (UART 8N1 transmitter, spec in golden.v).
//   func:   a line decoder rebuilds every frame from tx (start 0, 8 bits LSB first, stop 1, each
//           bit exactly CPB cycles) and compares it with the bytes the DUT accepted (valid&&ready).
//   timing: tx and ready are compared every cycle with a cycle-exact reference of the spec.
// Override the bit time with: iverilog -Ptb.CPB=<n> ...  (run_all.sh sweeps 1, 2, 3, 4, 16)
module tb;
  parameter CPB = 4;
  reg clk = 0, rst = 1, valid = 0;
  reg [7:0] data = 8'h00;
  wire ready, tx;
  integer cycle = 0;

  uart_tx #(.CLKS_PER_BIT(CPB)) dut (.clk(clk), .rst(rst), .data(data), .valid(valid),
                                     .ready(ready), .tx(tx));
  always #5 clk = ~clk;
  always @(posedge clk) cycle <= cycle + 1;

  `include "tb_common.vh"

  task automatic flush_trace; endtask

  // ---------------------------------------------------------------- cycle-exact reference
  reg r_busy = 0; reg [9:0] r_fr; integer r_t = 0;
  always @(posedge clk) begin
    if (rst) begin r_busy <= 0; r_t <= 0; end
    else if (!r_busy) begin
      if (valid) begin r_busy <= 1; r_fr <= {1'b1, data, 1'b0}; r_t <= 0; end
    end else if (r_t == 10*CPB - 1) r_busy <= 0;
    else r_t <= r_t + 1;
  end
  wire r_tx = r_busy ? r_fr[r_t / CPB] : 1'b1;
  wire r_ready = !r_busy;

  // Line as transmitted, in time order: start_d0..d7_stop (d0 first, so the byte appears reversed).
  function automatic string line_str(input [9:0] b);
    line_str = $sformatf("%b_%b%b%b%b%b%b%b%b_%b", b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7], b[8], b[9]);
  endfunction

  // Context for MISMATCH lines: inputs now, and where the reference is in the frame.
  function automatic string uctx;
    string ph;
    if (!r_busy) ph = "idle";
    else if (r_t / CPB == 0) ph = "start";
    else if (r_t / CPB == 9) ph = "stop";
    else ph = $sformatf("d%0d", r_t / CPB - 1);
    uctx = $sformatf("rst=%b valid=%b data=%02h ready=%b tx=%b exp_ready=%b exp_tx=%b frame_byte=%02h phase=%0s bit_cycle=%0d",
                     rst, valid, data, ready, tx, r_ready, r_tx, r_fr[8:1], ph, r_busy ? r_t % CPB : 0);
  endfunction

  // inputs as sampled on the last edge, for the trace
  reg s_rst = 1, s_valid = 0; reg [7:0] s_data = 0;
  always @(posedge clk) begin s_rst <= rst; s_valid <= valid; s_data <= data; end

  // ---------------------------------------------------------------- bytes the DUT accepted
  reg [7:0] acc_q [0:63];
  integer acc_wr = 0, acc_rd = 0, acc_count = 0, n_frames = 0;
  always @(posedge clk)
    if (!rst && valid && ready === 1'b1) begin
      acc_q[acc_wr % 64] = data; acc_wr = acc_wr + 1; acc_count = acc_count + 1;
      txn("ACCEPT", $sformatf("data=%02h", data), 1);
    end

  // ---------------------------------------------------------------- checks + trace, every negedge
  reg checking = 0, frame_bad = 0;
  integer d_state = 0, d_t = 0; reg d_cur; reg [9:0] d_bits;
  string phase;
  always @(negedge clk) if (checking) begin
    cyc_bad = 0;
    // timing: cycle-exact against the reference
    if (tx !== r_tx)       err(0, "tx",    r_tx,    tx,    uctx(), "tx differs from cycle-exact reference");
    if (ready !== r_ready) err(0, "ready", r_ready, ready, uctx(), "ready differs from cycle-exact reference");

    // func: decode the line
    if (s_rst) begin
      if (d_state == 1) txn("RESET", $sformatf("frame_abandoned_after_cycles=%0d", d_t), 1);
      d_state = 0; acc_rd = acc_wr;            // the frame in flight is abandoned
      if (tx !== 1'b1) err(1, "tx", 1, tx, uctx(), "tx must be 1 after a reset edge");
    end else begin
      if (d_state == 0) begin
        if (tx === 1'b0) begin d_state = 1; d_t = 0; frame_bad = 0; end
        else if (tx !== 1'b1) err(1, "tx", 1, tx, uctx(), "tx is X/Z while idle");
      end
      if (d_state == 1) begin
        if (d_t % CPB == 0) begin d_cur = tx; d_bits[d_t / CPB] = tx; end
        else if (tx !== d_cur) begin
          err(1, "tx", d_cur, tx, uctx(), "level changed inside a bit period (bit width != CLKS_PER_BIT)");
          frame_bad = 1;
        end
        d_t = d_t + 1;
        if (d_t == 10*CPB) begin
          d_state = 0; n_frames = n_frames + 1;
          if (d_bits[9] !== 1'b1) begin err(1, "tx_stop", 1, d_bits[9], uctx(), "stop bit is not 1"); frame_bad = 1; end
          if (acc_rd == acc_wr) begin
            err(1, "tx_frame", 0, d_bits[8:1], uctx(), "frame sent with no accepted byte");
            txn("FRAME", $sformatf("exp=none got=%02h line=%0s", d_bits[8:1], line_str(d_bits)), 0);
          end else begin
            if (d_bits[8:1] !== acc_q[acc_rd % 64]) begin
              err(1, "tx_byte", acc_q[acc_rd % 64], d_bits[8:1], uctx(),
                  "decoded byte != accepted byte (bit order? data not latched?)");
              frame_bad = 1;
            end
            txn("FRAME", $sformatf("exp=%02h got=%02h line=%0s", acc_q[acc_rd % 64], d_bits[8:1],
                line_str(d_bits)), !frame_bad);
            acc_rd = acc_rd + 1;
          end
        end
      end
    end

    if (cyc_on) begin
      if (!r_busy) phase = "idle";
      else if (r_t / CPB == 0) phase = "start";
      else if (r_t / CPB == 9) phase = "stop";
      else phase = $sformatf("d%0d", r_t / CPB - 1);
      $display("  c=%5d t=%4d  rst=%b valid=%b data=%02h | ready=%b tx=%b | exp ready=%b tx=%b | %0s.%0d%0s",
               cycle, cycle - test_start, s_rst, s_valid, s_data, ready, tx, r_ready, r_tx,
               phase, r_busy ? r_t % CPB : 0, cyc_bad ? "  <-- MISMATCH" : "");
    end
  end

  // ---------------------------------------------------------------- stimulus helpers
  // Present a byte and hold valid until the DUT accepts it. keep=1 leaves valid high afterwards.
  task automatic send(input [7:0] b, input bit keep);
    integer n0, n;
    begin
      @(negedge clk); #1; valid = 1; data = b;
      n0 = acc_count; n = 0;
      while (acc_count == n0) begin
        @(posedge clk); #1; n = n + 1;
        if (n > 30*CPB) hang("DUT never accepted a byte (ready stuck low?)");
      end
      if (!keep) begin valid = 0; data = ~b; end   // change data right away: must be latched
    end
  endtask

  task automatic drain;   // wait until the line is idle and every accepted byte came out
    integer n;
    begin
      n = 0;
      while (!(d_state == 0 && acc_rd == acc_wr && ready === 1'b1 && r_ready)) begin
        @(negedge clk); n = n + 1;
        if (n > 30*CPB + 30) begin
          err(1, "tx_frame", acc_wr - acc_rd, 0, uctx(), "accepted byte(s) never transmitted, or ready never returned");
          acc_rd = acc_wr; n = 0;
          disable drain;
        end
      end
      repeat (3) @(negedge clk);
    end
  endtask

  task automatic do_reset(input integer n);
    begin
      @(negedge clk); #1; rst = 1; valid = 0;
      repeat (n) @(negedge clk);   // rst is seen by n rising edges
      #1; rst = 0;
    end
  endtask

  task automatic idle(input integer n); repeat (n) @(negedge clk); endtask

  integer i, k, off;
  initial begin
    repeat (2) @(negedge clk);
    #1; rst = 0; checking = 1;
    $display("CLKS_PER_BIT=%0d", CPB);

    begin_test("idle_after_reset", 0); idle(12); end_test;

    begin_test("single_byte_0x35", 0); send(8'h35, 0); drain; end_test;

    begin_test("boundary_bytes", 0);
    send(8'h00, 0); drain; send(8'hFF, 0); drain; send(8'h80, 0); drain; send(8'h01, 0); drain;
    send(8'hAA, 0); drain; send(8'h55, 0); drain;
    end_test;

    begin_test("walking_one", 0);
    for (i = 0; i < 8; i = i + 1) begin send(8'h1 << i, 0); drain; end
    end_test;

    begin_test("back_to_back_valid_held", 0);
    send(8'hA5, 1); send(8'h3C, 1); send(8'h0F, 1); send(8'hE1, 0); drain;
    end_test;

    begin_test("valid_one_cycle_pulse", 0);
    @(negedge clk); #1; valid = 1; data = 8'h69;
    @(negedge clk); #1; valid = 0; data = 8'h00;
    drain;
    end_test;

    // data and valid scrambled every cycle while busy: the frame must carry the latched byte,
    // and a valid pulse while ready=0 must be ignored.
    begin_test("inputs_churn_while_busy", 0);
    send(8'hC2, 0);
    repeat (10*CPB - 2) begin @(negedge clk); #1; valid = $random(seed); data = $random(seed); end
    @(negedge clk); #1; valid = 0;
    drain;
    end_test;

    begin_test("valid_held_during_reset", 0);
    @(negedge clk); #1; rst = 1; valid = 1; data = 8'h5A;
    idle(5);
    #1; rst = 0;          // valid still 1: accepted on the first edge after reset
    @(negedge clk); #1; valid = 0;
    drain;
    end_test;

    begin_test("reset_mid_frame_then_send", 0);
    send(8'h96, 0); idle(3*CPB + 1); do_reset(1);
    idle(5); send(8'h4B, 0); drain;
    end_test;

    begin_test("reset_held_long", 0);
    send(8'h3C, 0); idle(2); do_reset(20); idle(3); send(8'hC3, 0); drain;
    end_test;

    // Reset at every cycle offset of a frame, each followed by a clean frame.
    begin_test("reset_at_every_offset", 1);
    for (off = 0; off < 10*CPB + 2; off = off + 1) begin
      send(8'hB4 ^ off, 0); idle(off); do_reset(1); send(8'h2D ^ off, 0); drain;
    end
    end_test;

    begin_test("all_256_bytes_gapped", 1);
    for (i = 0; i < 256; i = i + 1) begin send(i, 0); drain; end
    end_test;

    begin_test("all_256_bytes_back_to_back", 1);
    for (i = 0; i < 255; i = i + 1) send(i, 1);
    send(255, 0); drain;
    end_test;

    begin_test("random_traffic", 1);
    for (i = 0; i < 300; i = i + 1) begin
      send($random(seed), $random(seed));
      k = ($random(seed) & 32'h7fffffff) % 4;
      if (k == 0) idle(($random(seed) & 32'h7fffffff) % (12*CPB));
      if (k == 1) begin @(negedge clk); #1; valid = 0; end
    end
    @(negedge clk); #1; valid = 0; drain;
    end_test;

    $display("frames decoded=%0d", n_frames);
    finish_all;
  end

  initial begin #(CPB * 2000000 + 1000000); hang("global timeout"); end
endmodule
