// Body shared by seq_det_overlap/tb.v and seq_det_nonoverlap/tb.v.
// The wrapper declares: parameter PATTERN, localparam OVERLAP, clk/rst_n/din/detected, `cycle`,
// instantiates the DUT, and includes tb_common.vh before this file.
//
// Clock: period 10 ns, rising edges at 5, 15, 25, ... The stimulus "cursor" sits 1 ns after each
// falling edge: din (and rst_n release) change there, half a cycle away from the rising edge.
//
// Reference model (cycle exact):
//   rst_n falls  : immediately (asynchronously) history cleared, n=0, detected=0.
//   rising edge with rst_n=1: shift din into an 8-bit window (oldest bit = PATTERN[7]), n += 1;
//                detected <= (n >= 8) && window == PATTERN.
//                Overlapping:     n keeps counting after a match.
//                Non-overlapping: n restarts at 0 after a match, so the next match needs 8 new bits.
//
// Checks on `detected`:
//   - mid-cycle (falling edge) and just before each rising edge, against the model;
//   - any change of `detected` must happen within 1 ns of a rising edge or of rst_n falling
//     (a Mealy / combinational output that follows din fails this);
//   - 1 ns after rst_n falls, detected must already be 0 (reset must be asynchronous);
//   - at power-on, detected must be 0 before the first clock edge (async reset at time 0).

  reg [7:0] r_win = 0;   // last 8 samples, newest in bit 0
  integer   r_n = 0;     // samples that may still take part in a match
  reg       r_det = 0;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      r_win <= 0; r_n <= 0; r_det <= 0;
    end else begin
      r_win <= {r_win[6:0], din};
      if (r_n + 1 >= 8 && {r_win[6:0], din} == PATTERN) begin
        r_det <= 1; r_n <= OVERLAP ? r_n + 1 : 0;
      end else begin
        r_det <= 0; r_n <= r_n + 1;
      end
    end
  end

  // inputs as seen by the last rising edge, and edge/reset times, for checks and trace
  reg s_rst = 1, s_din = 0;
  realtime t_pos = -100, t_rstfall = 0;
  bit pulse_seen = 0;    // rst_n fell since the last trace column (shown as '!')
  integer n_det_exp = 0, n_det_got = 0;
  reg checking = 0;

  always @(posedge clk) begin
    // pre-edge check: values held through the whole cycle that is ending
    if (checking && detected !== r_det)
      err(1, "detected", r_det, detected, ctx(),
          "wrong just before the rising edge (output changed during the cycle?)");
    t_pos = $realtime; s_rst <= !rst_n; s_din <= din;
  end

  always @(negedge rst_n) begin
    t_rstfall = $realtime; pulse_seen = 1;
    #1;
    if (checking && !rst_n && detected !== 1'b0)
      err(1, "detected", 0, detected, ctx(), "not 0 within 1ns of rst_n falling (reset must be asynchronous)");
  end

  always @(detected)
    if (checking && $realtime - t_pos > 1.0 && $realtime - t_rstfall > 1.0)
      err(1, "detected", r_det, detected, ctx(),
          "changed between clock edges (output must be registered, not driven from din)");

  function automatic string ctx;
    ctx = $sformatf("rst_n=%b din=%b last8=%b n=%0d pattern=%b", rst_n, din, r_win, r_n, PATTERN);
  endfunction

  // ---------------------------------------------------------------- mid-cycle check + trace
  // Verbosity 1 also prints the bit stream as aligned rows (R = reset held over that edge,
  // ! = rst_n pulse between edges, ^ = mismatch):
  //   din : R10110101 0110...
  //   got : 000000001 0000...
  //   exp : 000000001 0000...
  string l_in = "", l_got = "", l_exp = "", l_bad = "", tag;
  bit any_bad = 0;
  task automatic flush_trace;
    begin
      if (l_in.len() > 0) begin
        $display("  din : %0s", l_in);
        $display("  got : %0s", l_got);
        $display("  exp : %0s", l_exp);
        if (any_bad) $display("        %0s", l_bad);
      end
      l_in = ""; l_got = ""; l_exp = ""; l_bad = ""; any_bad = 0;
    end
  endtask

  function automatic string bitch(input b);
    if (b === 1'b1) bitch = "1"; else if (b === 1'b0) bitch = "0";
    else if (b === 1'bz) bitch = "z"; else bitch = "x";
  endfunction

  always @(negedge clk) if (checking) begin
    cyc_bad = 0;
    if (detected !== r_det)
      if (r_det) err(1, "detected", 1, detected, ctx(), "missed a match");
      else if (detected === 1'b1) err(1, "detected", 0, 1, ctx(), "false detection");
      else err(1, "detected", 0, detected, ctx(), "detected is X/Z");
    if (r_det) n_det_exp = n_det_exp + 1;
    if (detected === 1'b1) n_det_got = n_det_got + 1;
    if (r_det || detected !== 1'b0)
      txn("DETECT", $sformatf("last8=%b n=%0d exp=%b got=%b", r_win, r_n, r_det, detected), detected === r_det);
    if (cyc_on) begin
      if (cyc_bad) tag = "  <-- MISMATCH"; else if (r_det) tag = "  match"; else tag = "";
      $display("  c=%5d t=%4d  rst_at_edge=%b din=%b | last8=%b_%b n=%3d | detected=%b exp=%b%0s%0s",
               cycle, cycle - test_start, s_rst, s_din, r_win[7:4], r_win[3:0],
               r_n > 999 ? 999 : r_n, detected, r_det, pulse_seen ? "  (rst_n pulse)" : "", tag);
      pulse_seen = 0;
    end else if (txn_on) begin
      if (pulse_seen && !s_rst) begin
        l_in = {l_in, "!"}; l_got = {l_got, " "}; l_exp = {l_exp, " "}; l_bad = {l_bad, " "};
      end
      pulse_seen = 0;
      if (s_rst) l_in = {l_in, "R"}; else l_in = {l_in, bitch(s_din)};
      l_got = {l_got, bitch(detected)};
      l_exp = {l_exp, bitch(r_det)};
      if (cyc_bad) l_bad = {l_bad, "^"}; else l_bad = {l_bad, " "};
      if (cyc_bad) any_bad = 1;
      if (l_in.len() >= 96) flush_trace;
    end else pulse_seen = 0;
  end

  // ---------------------------------------------------------------- stimulus helpers
  // Every helper starts and ends at the cursor (1 ns after a falling edge).

  // Drive one bit; the next rising edge samples it.
  task automatic send_bit(input b);
    begin din = b; @(negedge clk); #1; end
  endtask

  // Same, but din glitches three times before settling (all at least 1 ns before the edge).
  task automatic send_bit_glitchy(input b);
    begin
      din = ~b; #0.7 din = b; #0.7 din = ~b; #0.7 din = b;
      @(negedge clk); #1;
    end
  endtask

  // Send the low n bits of `bits`, most significant first.
  task automatic send_bits(input [63:0] bits, input integer n);
    integer i;
    for (i = n - 1; i >= 0; i = i - 1) send_bit(bits[i]);
  endtask

  task automatic send_pattern; send_bits(PATTERN, 8); endtask

  // rst_n low across n rising edges (din random, must be ignored); released at the cursor.
  task automatic reset_cycles(input integer n);
    integer i;
    begin
      rst_n = 0;
      for (i = 0; i < n; i = i + 1) begin din = $random(seed); @(negedge clk); #1; end
      rst_n = 1;
    end
  endtask

  // rst_n pulsed low for 2 ns between rising edges (no edge sees it low). Only an asynchronous
  // reset notices; the model clears its history.
  task automatic reset_pulse;
    begin #1 rst_n = 0; #2 rst_n = 1; @(negedge clk); #1; end
  endtask
  // Note: the falling edge right after the pulse samples nothing, but the rising edge between
  // the pulse and that falling edge samples din (held from before) - so a pulse costs one sample.
  // To pulse without consuming a sample, use reset_pulse_no_sample (pulse, then resume at cursor+3).
  task automatic reset_pulse_no_sample;
    begin #1 rst_n = 0; #2 rst_n = 1; end   // ends at cursor+3, still 1 ns before the rising edge
  endtask

  // Assert rst_n `ph` ns after the cursor (any phase of the clock), hold over n rising edges.
  task automatic reset_at_phase(input real ph, input integer n);
    integer i;
    begin
      #(ph) rst_n = 0;
      for (i = 0; i < n; i = i + 1) begin din = $random(seed); @(negedge clk); end
      #1 rst_n = 1;
    end
  endtask

  // One more sample, so the last driven bit is checked at both points before the test ends.
  task automatic settle; send_bit(din); endtask

  // De Bruijn sequence B(2,8) by the prefer-one rule: every 8-bit window appears exactly once.
  task automatic de_bruijn;
    reg seen [0:255];
    reg [7:0] w;
    integer i;
    begin
      for (i = 0; i < 256; i = i + 1) seen[i] = 0;
      w = 0; seen[0] = 1; send_bits(0, 8);
      for (i = 0; i < 255; i = i + 1) begin
        if (!seen[{w[6:0], 1'b1}]) w = {w[6:0], 1'b1};
        else w = {w[6:0], 1'b0};
        seen[w] = 1; send_bit(w[0]);
      end
      for (i = 0; i < 256; i = i + 1)
        if (!seen[i]) err(1, "tb_de_bruijn", i, 0, "", "testbench bug: window not generated");
    end
  endtask

  function automatic integer urand(input integer m);
    urand = ($random(seed) & 32'h7fffffff) % m;
  endfunction

  // Random bits; with probability inject_pct% per step a whole PATTERN is inserted instead.
  task automatic random_stream(input integer n, input integer inject_pct);
    integer i;
    for (i = 0; i < n; i = i + 1)
      if (urand(100) < inject_pct) send_pattern;
      else send_bit($random(seed));
  endtask

  // ---------------------------------------------------------------- tests
  integer k, j;
  real ph;
  initial begin
    #0.2 rst_n = 0; checking = 1;
    if (OVERLAP) $display("PATTERN=%b (oldest bit first), overlapping", PATTERN);
    else $display("PATTERN=%b (oldest bit first), non-overlapping", PATTERN);

    // rst_n falls at 0.2 ns; the first rising edge is at 5 ns.
    begin_test("power_on_async_reset", 0);
    #1;
    if (detected !== 1'b0) err(1, "detected", 0, detected, ctx(), "not 0 1ns after rst_n fell at power-on, before any clock edge (reset must be asynchronous)");
    @(negedge clk); #1; reset_cycles(2); repeat (12) send_bit(0); end_test;

    begin_test("idle_ones", 0);
    reset_cycles(1); repeat (20) send_bit(1); settle; end_test;

    begin_test("single_match", 0);
    reset_cycles(1); send_pattern; send_bits(~PATTERN, 8); settle; end_test;

    begin_test("match_right_after_reset_release", 0);
    reset_cycles(3); send_pattern; settle; end_test;

    begin_test("three_back_to_back", 0);
    reset_cycles(1); send_pattern; send_pattern; send_pattern; settle; end_test;

    // PATTERN followed by its own last k bits: a second match at offset k exists exactly when the
    // pattern overlaps itself by 8-k bits. Overlap mode must report it, non-overlap must not.
    begin_test("self_overlap_offsets_1_to_7", 0);
    for (k = 1; k <= 7; k = k + 1) begin reset_cycles(1); send_pattern; send_bits(PATTERN, k); settle; end
    end_test;

    // Fewer than 8 samples since reset can never match, whatever the reset value of the history.
    begin_test("partial_after_reset", 0);
    for (k = 1; k <= 7; k = k + 1) begin reset_cycles(1); send_bits(PATTERN, k); settle; end
    end_test;

    // Start the pattern, reset partway (over a clock edge), finish it: no match. Then a full match.
    begin_test("reset_mid_pattern", 0);
    for (k = 1; k <= 7; k = k + 1) begin
      reset_cycles(1); send_bits(PATTERN >> (8 - k), k);
      reset_cycles(1); send_bits(PATTERN, 8 - k); settle;
      send_pattern; settle;
    end
    end_test;

    // rst_n pulsed between edges partway through the pattern: an async reset clears the history,
    // so finishing the pattern must NOT match. A synchronous reset never sees the pulse and fails.
    begin_test("async_pulse_between_edges_clears_history", 0);
    for (k = 1; k <= 7; k = k + 1) begin
      reset_cycles(1); send_bits(PATTERN >> (8 - k), k);
      reset_pulse_no_sample; din = PATTERN[7 - k]; @(negedge clk); #1;
      send_bits(PATTERN, 7 - k); settle;
      send_pattern; settle;
    end
    end_test;

    // detected is high for the cycle after a match; rst_n falls in that cycle: it must drop at once.
    begin_test("async_reset_clears_output_immediately", 0);
    for (k = 0; k < 3; k = k + 1) begin
      reset_cycles(1); send_pattern;            // detected=1 now, until the next rising edge
      reset_pulse_no_sample; din = ~PATTERN[7]; @(negedge clk); #1;
      send_pattern; settle;
    end
    end_test;

    // rst_n asserted at different phases of the clock (just after the cursor, near the rising edge,
    // just after the rising edge, near the falling edge), mid-pattern, held over 2 edges.
    begin_test("reset_asserted_at_various_phases", 0);
    for (k = 0; k < 6; k = k + 1) begin
      case (k) 0: ph = 0.0; 1: ph = 2.0; 2: ph = 3.5; 3: ph = 4.5; 4: ph = 6.0; default: ph = 8.5; endcase
      reset_cycles(1); send_bits(PATTERN >> 3, 5);
      reset_at_phase(ph, 2);
      send_bits(PATTERN, 3); send_pattern; settle;
    end
    end_test;

    // rst_n low on the edge that would sample the 8th bit: no match.
    begin_test("reset_on_completing_edge", 0);
    reset_cycles(1); send_bits(PATTERN >> 1, 7);
    rst_n = 0; din = PATTERN[0]; @(negedge clk); #1; rst_n = 1;
    send_bits(PATTERN, 1); settle; send_pattern; settle;
    end_test;

    begin_test("long_reset_with_pattern_on_din", 0);
    rst_n = 0;
    for (k = 0; k < 3; k = k + 1) for (j = 7; j >= 0; j = j - 1) begin din = PATTERN[j]; @(negedge clk); #1; end
    rst_n = 1; send_bit(~PATTERN[7]); settle;
    end_test;

    // Every single-bit corruption of the pattern, each isolated by a reset.
    begin_test("near_misses_one_bit_flipped", 0);
    for (k = 0; k < 8; k = k + 1) begin reset_cycles(1); send_bits(PATTERN ^ (8'h1 << k), 8); settle; end
    end_test;

    // Pattern preceded by its own first k bits.
    begin_test("pattern_after_prefix_of_itself", 0);
    for (k = 1; k <= 7; k = k + 1) begin reset_cycles(1); send_bits(PATTERN >> (8 - k), k); send_pattern; settle; end
    end_test;

    // din glitches between edges; only the value at the rising edge counts, and detected must
    // not move between edges.
    begin_test("din_glitches_between_edges", 0);
    reset_cycles(1);
    for (k = 0; k < 3; k = k + 1) for (j = 7; j >= 0; j = j - 1) send_bit_glitchy(PATTERN[j]);
    for (k = 0; k < 40; k = k + 1) send_bit_glitchy($random(seed));
    settle; end_test;

    begin_test("de_bruijn_all_256_windows", 1);
    reset_cycles(1); de_bruijn; settle; end_test;

    begin_test("de_bruijn_twice_no_reset", 1);
    reset_cycles(1); de_bruijn; de_bruijn; settle; end_test;

    begin_test("random_4000_bits", 1);
    reset_cycles(1); random_stream(4000, 0); settle; end_test;

    begin_test("random_with_injected_patterns", 1);
    reset_cycles(1); random_stream(3000, 8); settle; end_test;

    begin_test("random_with_random_resets", 1);
    reset_cycles(1);
    for (k = 0; k < 300; k = k + 1) begin
      case (urand(12))
        0: reset_cycles(1 + urand(2));
        1: reset_pulse_no_sample;
        2: begin ph = urand(90) / 10.0; if (ph > 3.5 && ph < 4.5) ph = ph + 1.0; reset_at_phase(ph, 1 + urand(2)); end   // not on the rising edge
        default: ;
      endcase
      if ($random(seed) & 1) send_pattern; else send_bits($random(seed), 8);
    end
    settle; end_test;

    $display("detections: expected=%0d got=%0d", n_det_exp, n_det_got);
    finish_all;
  end

  initial begin #2000000; hang("global timeout"); end
