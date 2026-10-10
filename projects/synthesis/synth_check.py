#!/usr/bin/env python3
"""Synthesis check with Yosys: run AFTER a design passes the simulation testbench.

    python3 synth_check.py design.v --top uart_tx [--param CLKS_PER_BIT=16] [--keep-log]

Simulation (Icarus) happily runs code that is not real hardware. Yosys synthesizes the design to
generic gates and flip-flops and reports what a chip could not build:
  - latches inferred from combinational blocks that do not assign every output on every path
  - signals with multiple conflicting drivers (e.g. one reg written from two always blocks)
  - combinational logic loops
  - errors: unsynthesizable or unsupported constructs, missing modules, bad parameters
and how big the result is (cells, flip-flops, cells by type).

Prints one JSON object. verdict: "pass" | "lint_fail" | "synth_fail". Exit 0 only on "pass".
Uses `yosys` if on PATH, else `yowasp-yosys` (pip install yowasp-yosys; no root needed).
"""
import argparse
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import time


def find_yosys():
    for exe in ("yosys", "yowasp-yosys"):
        if shutil.which(exe):
            return exe
    sys.exit("yosys not found: brew install yosys, or pip install yowasp-yosys")


def yosys_script(design, top, params):
    lines = [f"read_verilog -sv {design}"]
    for name, value in params.items():
        lines.append(f"chparam -set {name} {value} {top}")
    lines += [
        f"hierarchy -check -top {top}",   # missing modules / ports are errors
        "proc",                            # always blocks -> flip-flops, muxes, latches
        "check",                           # multiple drivers, undriven wires, logic loops
        f"synth -top {top}",               # generic gates + flip-flops
        "check",
        "tee -o stat.json stat -json",
    ]
    return "\n".join(lines) + "\n"


def parse_log(log):
    latches, multi, loops, warnings, errors = set(), set(), set(), [], []
    found_loop = False
    lines = log.splitlines()
    for i, line in enumerate(lines):
        m = re.search(r"Latch inferred for signal `\\?([^']+)'", line)
        if m:
            latches.add(m.group(1).replace("\\", ""))
            continue
        m = re.search(r"multiple conflicting drivers for (\S+?):?$", line)
        if m:
            multi.add(m.group(1).replace("\\", ""))
            continue
        if "found logic loop" in line:
            # the loop's wires are listed on the following indented lines
            for nxt in lines[i + 1:i + 20]:
                if not nxt.startswith(" "):
                    break
                w = re.match(r"\s+wire \\?(\S+)", nxt)
                if w:
                    loops.add(w.group(1))
            found_loop = True
            continue
        if line.startswith("ERROR:") or re.match(r"^\S+:\d+: ERROR:", line):
            errors.append(line.strip())
        elif "Warning:" in line and not line.startswith("ABC:") and line.strip() not in warnings:
            warnings.append(line.strip())   # ABC's own warnings are internal noise
    if found_loop and not loops:
        loops.add("(loop with no named wire)")
    return sorted(latches), sorted(multi), sorted(loops), warnings, errors


def check(design, top, params=None, timeout=120, keep_log=False):
    params = params or {}
    out = {"top": top, "params": params, "verdict": "synth_fail", "latches": [],
           "multi_driven": [], "comb_loops": [], "errors": [], "warnings": [],
           "cells_total": None, "flops": None, "cells": {}, "seconds": None}
    design = os.path.abspath(design)
    with tempfile.TemporaryDirectory() as tmp:
        with open(os.path.join(tmp, "run.ys"), "w") as f:
            f.write(yosys_script(design, top, params))
        t0 = time.time()
        try:
            p = subprocess.run([find_yosys(), "-s", "run.ys"], cwd=tmp, capture_output=True,
                               text=True, timeout=timeout)
            log = p.stdout + p.stderr
        except subprocess.TimeoutExpired:
            out["errors"] = [f"yosys exceeded {timeout}s"]
            return out
        out["seconds"] = round(time.time() - t0, 2)
        latches, multi, loops, warnings, errors = parse_log(log)
        out.update(latches=latches, multi_driven=multi, comb_loops=loops, warnings=warnings)
        if keep_log:
            out["log"] = log
        if p.returncode != 0 or errors:
            out["errors"] = errors or [log.strip().splitlines()[-1]]
            return out
        stat_path = os.path.join(tmp, "stat.json")
        if os.path.exists(stat_path):
            with open(stat_path) as f:
                stat = json.load(f)
            mod = next(iter(stat["modules"].values()))
            cells = mod.get("num_cells_by_type", {})
            out["cells"] = cells
            out["cells_total"] = mod.get("num_cells")
            out["flops"] = sum(n for c, n in cells.items() if "DFF" in c or "SDFF" in c)
    out["verdict"] = "lint_fail" if (latches or multi or loops) else "pass"
    return out


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("design")
    ap.add_argument("--top", required=True, help="top module name")
    ap.add_argument("--param", action="append", default=[], metavar="NAME=VALUE",
                    help="override a parameter, e.g. CLKS_PER_BIT=16 or PATTERN=8'hAA")
    ap.add_argument("--timeout", type=int, default=120)
    ap.add_argument("--keep-log", action="store_true", help="include the full Yosys log in the JSON")
    a = ap.parse_args()
    params = dict(p.split("=", 1) for p in a.param)
    res = check(a.design, a.top, params, a.timeout, a.keep_log)
    json.dump(res, sys.stdout, indent=1)
    print()
    sys.exit(0 if res["verdict"] == "pass" else 1)


if __name__ == "__main__":
    main()
