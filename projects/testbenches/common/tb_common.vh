// Shared reporting and tracing for every testbench in this folder.
// `include inside the tb module, after `cycle` is declared. Each tb also defines
// `task automatic flush_trace` (prints any buffered human-readable trace; may be empty).
//
// Plusargs:
//   +VERBOSE=0   machine lines for failures and totals only: MISMATCH / HANG / TEST / RESULT
//   +VERBOSE=1   (default) also TXN lines (one per transaction) in directed tests
//   +VERBOSE=2   also human-readable per-cycle tables in directed tests, TXN lines in heavy tests
//   +VERBOSE=3   per-cycle tables everywhere
//   +MAXPRINT=n  MISMATCH lines printed per test and kind (default 10); all are still counted
//   +SEED=n      seed for the random tests
//   +VCD         dump waves to tb.vcd
//
// ---------------------------------------------------------------- machine-readable lines
// Every machine line starts with an upper-case tag in column 0, followed by key=value tokens with
// no spaces in values. A `note=` token, when present, is always last and runs to end of line.
// Lines starting with spaces or "====" are for humans; parse_log.py ignores them.
//
//   MISMATCH test=<t> cycle=<n> time_ns=<n> rel=<cycles since test start> sig=<s> exp=<hex> got=<hex>
//            kind=func|timing [<context key=value>...] note=<why>
//   TXN      test=<t> cycle=<n> type=<FRAME|DETECT|ACCEPT|SRAM_WR|...> [<key=value>...] status=ok|MISMATCH
//   HANG     test=<t> cycle=<n> time_ns=<n> note=<why>          (the run stops; later tests skipped)
//   TEST     <t> PASS|FAIL func_mismatches=<n> timing_mismatches=<n>
//   RESULT   tests_passed=<n> tests_total=<n> func_tests_passed=<n> func_mismatches=<n> timing_mismatches=<n>
//
// kind=func:   the behavior is wrong (bad data, wrong order, missing or extra pulse, bus misuse, hang).
// kind=timing: the behavior works but a cycle count differs from the exact spec.
// exp/got are hex; an X or Z bit prints as x / z.

  string  test_name = "power_on";
  integer test_start = 0, n_tests = 0, n_pass = 0, n_func_pass = 0;
  integer t_func = 0, t_timing = 0, tot_func = 0, tot_timing = 0, pf = 0, pt = 0;
  integer verbose = 1, seed = 1, maxprint = 10;
  bit     txn_on = 1, cyc_on = 0;   // transaction-level and cycle-level tracing for the current test
  bit     cyc_bad = 0;              // set by err(), so the per-cycle row can flag itself

  initial begin
    if (!$value$plusargs("VERBOSE=%d", verbose)) verbose = 1;
    if (!$value$plusargs("SEED=%d", seed)) seed = 1;
    if (!$value$plusargs("MAXPRINT=%d", maxprint)) maxprint = 10;
    txn_on = verbose >= 1;
    if ($test$plusargs("VCD")) begin $dumpfile("tb.vcd"); $dumpvars(0, tb); end
  end

  // heavy=1 for exhaustive / random tests, whose traces are only shown at higher verbosity.
  task automatic begin_test(input string name, input bit heavy);
    begin
      test_name = name; test_start = cycle; t_func = 0; t_timing = 0; pf = 0; pt = 0;
      txn_on = verbose >= (heavy ? 2 : 1);
      cyc_on = verbose >= (heavy ? 3 : 2);
      if (verbose >= 1) $display("==== TEST %0s ====", name);
    end
  endtask

  task automatic end_test;
    begin
      flush_trace;
      n_tests = n_tests + 1;
      if (t_func == 0) n_func_pass = n_func_pass + 1;
      if (t_func == 0 && t_timing == 0) n_pass = n_pass + 1;
      $display("TEST %0s %0s func_mismatches=%0d timing_mismatches=%0d", test_name,
               (t_func == 0 && t_timing == 0) ? "PASS" : "FAIL", t_func, t_timing);
    end
  endtask

  // ctx: space-separated key=value tokens describing the inputs/state at the failure ("" for none).
  task automatic err(input bit is_func, input string sig, input [63:0] exp, input [63:0] got,
                     input string ctx, input string note);
    string sep;
    begin
      cyc_bad = 1;
      if (is_func) begin t_func = t_func + 1; tot_func = tot_func + 1; end
      else begin t_timing = t_timing + 1; tot_timing = tot_timing + 1; end
      if (is_func ? pf < maxprint : pt < maxprint) begin
        if (is_func) pf = pf + 1; else pt = pt + 1;
        if (ctx.len() > 0) sep = " "; else sep = "";
        $display("MISMATCH test=%0s cycle=%0d time_ns=%0d rel=%0d sig=%0s exp=%0h got=%0h kind=%0s%0s%0s note=%0s",
                 test_name, cycle, $time, cycle - test_start, sig, exp, got,
                 is_func ? "func" : "timing", sep, ctx, note);
      end
    end
  endtask

  // One machine-readable line per transaction. fields: space-separated key=value tokens.
  task automatic txn(input string typ, input string fields, input bit ok);
    if (txn_on)
      $display("TXN test=%0s cycle=%0d type=%0s %0s status=%0s", test_name, cycle, typ, fields,
               ok ? "ok" : "MISMATCH");
  endtask

  task automatic finish_all;
    begin
      $display("RESULT tests_passed=%0d tests_total=%0d func_tests_passed=%0d func_mismatches=%0d timing_mismatches=%0d",
               n_pass, n_tests, n_func_pass, tot_func, tot_timing);
      $finish;
    end
  endtask

  // A design that hangs (never ready, never responds) must still produce a result line.
  task automatic hang(input string what);
    begin
      $display("HANG test=%0s cycle=%0d time_ns=%0d note=%0s", test_name, cycle, $time, what);
      pf = 0;   // the hang's own MISMATCH line always prints
      err(1, "hang", 0, 0, "", what);
      end_test;
      finish_all;
    end
  endtask
