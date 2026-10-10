#!/usr/bin/env python3
"""Parse testbench logs into JSON, or compile + simulate a design and parse the result.

    python3 parse_log.py sim.log                      # parse a saved vvp log
    vvp sim | python3 parse_log.py -                  # parse stdin
    python3 parse_log.py --run uart_tx my_uart.v [-P tb.CPB=16] [+VERBOSE=0] [--timeout 60]

Output (JSON on stdout):
    status       "pass" | "fail" | "compile_error" | "no_result" | "timeout"
    result       totals from the RESULT line (tests_passed, tests_total, func_tests_passed,
                 func_mismatches, timing_mismatches); absent if the run never finished
    tests        {name: {"status": "PASS"|"FAIL", "func_mismatches": n, "timing_mismatches": n}}
    failed_tests [names of failing tests, in run order]
    mismatches   [{test, cycle, time_ns, rel, sig, exp, got, kind, <context keys>..., note}]
    hang         {test, cycle, time_ns, note} or null
    txns         [{test, cycle, type, status, <fields>...}]  (only with --txns; can be large)
    compile_log  compiler output (compile_error only)

Exit status: 0 = pass, 1 = fail / no_result / timeout, 2 = compile error.
The line format is described in common/tb_common.vh.
"""
import argparse
import json
import os
import re
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
KV = re.compile(r"(\w+)=(\S+)")


def _kv(text):
    """key=value tokens, with a trailing note=... taken verbatim to end of line."""
    head, sep, note = text.partition(" note=")
    d = dict(KV.findall(head))
    if sep:
        d["note"] = note.strip()
    for k in ("cycle", "time_ns", "rel"):
        if k in d and d[k].lstrip("-").isdigit():
            d[k] = int(d[k])
    return d


def parse(text, keep_txns=False):
    out = {"status": "no_result", "tests": {}, "failed_tests": [], "mismatches": [], "hang": None}
    if keep_txns:
        out["txns"] = []
    for line in text.splitlines():
        if line.startswith("MISMATCH "):
            out["mismatches"].append(_kv(line[9:]))
        elif line.startswith("TXN ") and keep_txns:
            out["txns"].append(_kv(line[4:]))
        elif line.startswith("HANG "):
            out["hang"] = _kv(line[5:])
        elif line.startswith("TEST "):
            parts = line.split()
            if len(parts) >= 3 and parts[2] in ("PASS", "FAIL"):
                t = {"status": parts[2]}
                t.update({k: int(v) for k, v in KV.findall(" ".join(parts[3:]))})
                out["tests"][parts[1]] = t
                if parts[2] == "FAIL":
                    out["failed_tests"].append(parts[1])
        elif line.startswith("RESULT "):
            out["result"] = {k: int(v) for k, v in KV.findall(line[7:])}
    r = out.get("result")
    if r is not None:
        ok = r["tests_passed"] == r["tests_total"] and out["hang"] is None
        out["status"] = "pass" if ok else "fail"
    return out


def run(module, design, params=(), plusargs=(), timeout=120, keep_txns=False):
    tb = os.path.join(HERE, module, "tb.v")
    if not os.path.exists(tb):
        raise SystemExit(f"no testbench at {tb}")
    with tempfile.TemporaryDirectory() as tmp:
        sim = os.path.join(tmp, "sim")
        cmd = ["iverilog", "-g2012", "-Wno-timescale", "-I", os.path.join(HERE, "common"), "-o", sim]
        cmd += ["-P" + p for p in params] + [tb, design]
        c = subprocess.run(cmd, capture_output=True, text=True)
        if c.returncode != 0:
            return {"status": "compile_error", "compile_log": (c.stdout + c.stderr).strip(),
                    "tests": {}, "failed_tests": [], "mismatches": [], "hang": None}
        try:
            v = subprocess.run(["vvp", "-n", sim, *plusargs], capture_output=True, text=True,
                               timeout=timeout, cwd=tmp)
        except subprocess.TimeoutExpired as e:
            res = parse((e.stdout or b"").decode(errors="replace") if isinstance(e.stdout, bytes)
                        else (e.stdout or ""), keep_txns)
            res["status"] = "timeout"
            return res
        return parse(v.stdout, keep_txns)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("log", nargs="?", help="log file to parse, or - for stdin")
    ap.add_argument("--run", nargs=2, metavar=("MODULE", "DESIGN"), help="compile and simulate first")
    ap.add_argument("-P", dest="params", action="append", default=[], help="parameter override, e.g. tb.CPB=16")
    ap.add_argument("--timeout", type=int, default=120, help="wall-clock seconds for vvp")
    ap.add_argument("--txns", action="store_true", help="include TXN lines in the output")
    ap.add_argument("plusargs", nargs="*", help="vvp plusargs such as +VERBOSE=0 +SEED=3")
    a, extra = ap.parse_known_args()
    plus = [x for x in (a.plusargs + extra) if x.startswith("+")]
    if a.run:
        if a.log and a.log.startswith("+"):
            plus.insert(0, a.log)
        res = run(a.run[0], a.run[1], a.params, plus or ["+VERBOSE=0"], a.timeout, a.txns)
    elif a.log:
        text = sys.stdin.read() if a.log == "-" else open(a.log).read()
        res = parse(text, a.txns)
    else:
        ap.error("give a log file, - for stdin, or --run MODULE DESIGN")
    json.dump(res, sys.stdout, indent=1)
    print()
    sys.exit({"pass": 0, "compile_error": 2}.get(res["status"], 1))


if __name__ == "__main__":
    main()
