# Testbenches

Self-checking Icarus Verilog testbenches for grading Verilog written by another model. **`SPEC.md` is the contract**: it lists the exact interface and behavior each testbench checks, for use when writing the prompts.

| Folder | DUT module | Reset |
|---|---|---|
| `seq_det_overlap/` | `seq_det_overlap #(PATTERN)` | async, active low `rst_n` |
| `seq_det_nonoverlap/` | `seq_det_nonoverlap #(PATTERN)` | async, active low `rst_n` |
| `uart_tx/` | `uart_tx #(CLKS_PER_BIT)` | sync, active high `rst` |
| `mem_ctrl/` | `mem_ctrl #(AW, DW, READ_LATENCY)` + external SRAM | async, active low `rst_n` |

Each folder holds:
- `tb.v`: the testbench.
- `golden.v`: a reference design that passes.
- `broken/*.v`: designs with one known bug each, which must fail. They show the testbench catches that class of bug.

`mem_ctrl/alt_pipelined.v` is a second correct design with different timing. It shows the memory testbench doesn't depend on the golden's latency.

## Running

```sh
python3 parse_log.py --run uart_tx model_out.v               # JSON result (exit 0 pass, 1 fail, 2 compile error)
python3 parse_log.py --run mem_ctrl model_out.v -P tb.L=3     # with a parameter override
./run.sh uart_tx model_out.v +VERBOSE=2                      # human view: per-cycle table
./run_all.sh                                                 # every golden / alt / broken design, all sweeps
```

Parameter sweeps that `run_all.sh` uses (pass them with `-P`):

| Module | Sweep |
|---|---|
| seq detectors | `tb.PATTERN=8'hB5, AA, 00, FF, 01, 80, E7, 6D` |
| uart_tx | `tb.CPB=1, 2, 3, 4, 16` |
| mem_ctrl | `tb.AW tb.DW tb.L` = `4 8 1`, `4 8 2`, `4 8 3`, `2 8 2`, `6 16 4` |

A design should be graded on every configuration. Some bugs only show up under some of them, for example a reversed pattern only when the pattern isn't a palindrome, or ignoring `READ_LATENCY` only when it's above 1.

## Log format (machine-readable)

Every machine line starts with an upper-case tag in column 0, followed by `key=value` tokens with no spaces in values. A `note=` token, when present, is always last and runs to the end of the line. Lines starting with spaces or `====` are for humans.

```
MISMATCH test=<t> cycle=<n> time_ns=<n> rel=<n> sig=<signal> exp=<hex> got=<hex> kind=func|timing <context...> note=<why>
TXN      test=<t> cycle=<n> type=<FRAME|DETECT|ACCEPT|SRAM_WR|SRAM_RD|RESPONSE|RESET|IMAGE_CHECK> <fields...> status=ok|MISMATCH
HANG     test=<t> cycle=<n> time_ns=<n> note=<why>
TEST     <name> PASS|FAIL func_mismatches=<n> timing_mismatches=<n>
RESULT   tests_passed=<n> tests_total=<n> func_tests_passed=<n> func_mismatches=<n> timing_mismatches=<n>
```

- **`<context>` on a MISMATCH** is a snapshot of the inputs and state at the failure:
  - Sequence detectors: `rst_n din last8 n pattern`.
  - UART: `rst valid data ready tx exp_ready exp_tx frame_byte phase bit_cycle`.
  - Memory controller: all host and SRAM pins, whether the SRAM is driving and with what, and the pending counts.
- **`exp` / `got`** are hex. X and Z bits print as `x` / `z` (fully unknown values as `X` / `Z`).
- **`kind`:** `func` means the behavior is wrong. `timing` means it works but a cycle count is off. Only UART has timing checks.
- **Printing limits:** at most `+MAXPRINT` (default 10) MISMATCH lines are printed per test and kind. All of them are counted in TEST/RESULT.
- **HANG:** a hang prints a `HANG` line plus a `RESULT`, and the remaining tests are skipped.

This format is a superset of `07-verilog-protocols/protocols/problems/common.vh`, so `checker.py` still parses it.

`parse_log.py` turns a log into JSON: `status`, `result`, `tests`, `failed_tests`, `mismatches` (each a dict of all keys above), `hang`, and `txns` with `--txns`. Example mismatch:

```json
{"test": "async_reset_clears_output_immediately", "cycle": 515, "time_ns": 5153, "sig": "detected",
 "exp": "0", "got": "1", "kind": "func", "rst_n": "0", "din": "1", "last8": "00000000", "n": "0",
 "pattern": "10110101", "note": "not 0 within 1ns of rst_n falling (reset must be asynchronous)"}
```

### Plusargs

| Plusarg | Effect |
|---|---|
| `+VERBOSE=0` | failures and totals only (what `parse_log.py --run` uses by default) |
| `+VERBOSE=1` | default; adds TXN lines for directed tests and, for the detectors, aligned `din/got/exp` rows |
| `+VERBOSE=2` | per-cycle tables for directed tests, TXN lines for heavy (exhaustive/random) tests |
| `+VERBOSE=3` | per-cycle tables everywhere |
| `+MAXPRINT=n` | MISMATCH lines per test and kind (default 10) |
| `+SEED=n` | seed for the random tests |
| `+VCD` | write `tb.vcd` |

## What each testbench covers

**Sequence detectors** (`common/seq_det_body.vh`, 21 tests). A cycle-exact reference model is checked mid-cycle and just before every rising edge, plus:
- `detected` may change only at a rising edge or when `rst_n` falls.
- `detected` must be 0 within 1 ns of `rst_n` falling.

Tests:
- Async reset: power-on async reset, reset pulses between edges that must clear history, a reset that must drop an active `detected` at once, and resets asserted at 6 clock phases.
- Reset placement: partial pattern after reset, reset mid-pattern at every split, reset on the completing edge, and a long reset with the pattern on `din`.
- Matching: single and back-to-back matches, self-overlap at every offset 1 to 7, every single-bit near miss, and prefix-then-pattern.
- Output timing: `din` glitches between edges.
- Exhaustive and random: a De Bruijn sequence (all 256 windows), random streams, injected patterns, and random resets.

**UART TX** (14 tests). A line decoder rebuilds each frame and compares it with the accepted byte (func). A cycle-exact reference checks `tx`/`ready` every cycle (timing).

Tests:
- Directed: idle, boundary bytes, walking one, back-to-back with `valid` held, a 1-cycle `valid`, inputs churning while busy, `valid` held through reset, and reset mid-frame.
- Reset sweep: reset at every cycle offset of a frame.
- Exhaustive and random: all 256 bytes (gapped and back-to-back), and 300 random frames.

**Memory controller** (20 tests). The testbench owns the SRAM model and a memory image kept in acceptance order. It checks:
- Command order, address and data.
- Response data and order.
- Bus ownership and contention, mid-cycle.
- `oe_n`, async reset behavior, X/Z, latency bounds, and a full-memory compare.

Tests:
- Hazards: read-after-write, write-after-write and write-after-read on the same address, back-to-back.
- Bus turnaround: read then write, and alternating streams.
- Input handling: garbage on the bus with `req_valid=0`, and fields changing before acceptance.
- Reset: async reset at every cycle of a read and of a write, and at 6 clock phases.
- Exhaustive and random: write-all/read-all, 3000 random ops, and random ops with resets.

## Validation (`./run_all.sh`)

All goldens and `alt_pipelined.v` pass every configuration. Every broken design fails at least one:

- **Sequence detectors:**
  - Matching: naive FSM restart (no KMP fallback), no sample count after reset, LSB-first pattern.
  - Output: Mealy output, sticky output.
  - Reset: synchronous reset, async reset that keeps history.
  - Mode: overlap/non-overlap swapped, dead cycle after a match.
- **UART:** late start, long bit, MSB first, data not latched, partial reset, short stop, accepting while busy.
- **Memory controller:**
  - Bus: drives the bus on reads, `oe_n` never low, write data a cycle late.
  - Read timing: captures a cycle early, ignores `READ_LATENCY`.
  - Reset: synchronous reset, reset keeps FSM state.
  - Handshake: address not latched, ready while busy, sticky response.
