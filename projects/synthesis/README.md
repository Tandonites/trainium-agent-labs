# Synthesis check (proof of concept)

The stage after simulation. Once a model's design passes its testbench (`../testbenches/`), Yosys synthesizes it to gates and flip-flops and reports whether it is real hardware.

```
model writes Verilog ──► simulation testbench ──pass──► synth_check.py ──► verdict + size
                         (../testbenches/parse_log.py)    (Yosys)
```

## Why simulation is not enough

Icarus runs whatever Verilog it is given, including code that has no hardware equivalent. Yosys builds the circuit and reports these:

| Check | Example | Simulation | Hardware |
|---|---|---|---|
| Latch inferred | `always @*` that doesn't assign an output on every path | holds the old value, tests pass | needs a latch: glitchy, timing problems, usually a bug |
| Multiple drivers | one `reg` written from two `always` blocks | last write wins | two outputs shorted together |
| Combinational loop | `assign w = a ^ w;` | may settle or hang | oscillator / undefined |
| Synthesis error | missing module, bad parameter, unsupported construct | may never be exercised | can't be built |

`examples/latch_bug.v` is a sequence detector that **passes all 21 simulation tests** but infers a latch:

```sh
python3 ../testbenches/parse_log.py --run seq_det_overlap examples/latch_bug.v   # "status": "pass"
python3 synth_check.py examples/latch_bug.v --top seq_det_overlap                # "verdict": "lint_fail"
#   "latches": ["seq_det_overlap.match"]
```

## Usage

```sh
python3 synth_check.py <design.v> --top <module> [--param NAME=VALUE ...] [--keep-log]

python3 synth_check.py ../testbenches/uart_tx/golden.v --top uart_tx --param CLKS_PER_BIT=16
python3 synth_check.py model_out.v --top seq_det_overlap --param "PATTERN=8'hAA"
python3 synth_check.py model_out.v --top mem_ctrl --param READ_LATENCY=3
```

It prints one JSON object and exits 0 only when `verdict` is `pass`:

```json
{"top": "uart_tx", "params": {}, "verdict": "pass",
 "latches": [], "multi_driven": [], "comb_loops": [], "errors": [], "warnings": [],
 "cells_total": 146, "flops": 30, "cells": {"$_SDFFE_PP0P_": 20, "$_NOR_": 46, "...": 0},
 "seconds": 0.12}
```

| Field | Meaning |
|---|---|
| `verdict` | `pass`, `lint_fail` (latch / multi-driver / loop found), or `synth_fail` (Yosys error) |
| `latches`, `multi_driven`, `comb_loops` | offending signals, as `module.signal` |
| `errors` | Yosys `ERROR` lines (`synth_fail` only) |
| `warnings` | other Yosys warnings, reported but not failing |
| `cells_total`, `flops`, `cells` | size of the synthesized design: generic gates and flip-flops by type |

From Python: `from synth_check import check; check("design.v", "uart_tx", {"CLKS_PER_BIT": "4"})`.

In a loop: run the testbench first, and call `synth_check` only when it passes. The verdict and the offending signal names can go straight into the model's retry feedback ("latch inferred for `match`: assign it on every path").

### Current results on the reference designs

| Design | Verdict | Cells | Flops |
|---|---|---|---|
| `uart_tx/golden.v` | pass | 146 | 30 |
| `seq_det_overlap/golden.v` | pass | 30 | 12 |
| `seq_det_nonoverlap/golden.v` | pass | 35 | 12 |
| `mem_ctrl/golden.v` | pass (tri-state warning) | 108 | 56 |
| `mem_ctrl/alt_pipelined.v` | pass (tri-state warning) | 53 | 46 |
| `examples/latch_bug.v` | **lint_fail** (latch on `match`) | 31 | 12 |

`mem_ctrl` warns "limited support for tri-state logic" because of its `inout` data bus. That's expected for a bidirectional pad and isn't a failure.

## Install

- **Mac:** `brew install yosys` (0.69).
- **Hackathon pod:**
  - Install: `kubectl exec seat-120 -- pip install yowasp-yosys`. This is Yosys compiled to WebAssembly: no root or apt needed, and the first run takes about a minute to compile. `synth_check.py` uses `yosys` if it's on PATH and falls back to `yowasp-yosys`.
  - Pod installs disappear on restart; add the package to the seat image if that matters.
- **Simulation:** the simulation stage also needs `iverilog` wherever it runs.

## Next steps (not built)

1. **Gate-level re-simulation:** run the same testbench on the synthesized netlist, to catch designs whose RTL simulation and synthesized hardware disagree (sensitivity lists, X-optimism).
2. **Real area:** map to the sky130hd standard-cell library (`~/or-dffram/test/sky130hd/*.lib`) with `abc -liberty` / `stat -liberty` to get area in µm².
3. **Physical design:** place, route and run timing with OpenROAD (installed at `~/install/OpenROAD`), reporting post-route slack and Fmax.
