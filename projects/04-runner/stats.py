#!/usr/bin/env python3
"""Summarise one or more runner logs: solve rates and throughput.

  python stats.py results/*.jsonl

Per task x style x variant: episodes, hidden-passed (rate), attempts used when solved, model
tokens per correct module, average final score and how episodes stopped (passed / repeat /
fixes_used), which still separates the styles when nothing solves. Per variant: correct
modules per hour of wall time, and seconds / tokens saved by early cancel. Compare variants
on the same grid (same tasks, styles, reps).
"""
import json
import sys
from collections import Counter, defaultdict


def load(paths):
    rows = []
    for p in paths:
        with open(p) as fh:
            rows += [json.loads(l) for l in fh if l.strip()]
    return rows


def mean(xs):
    xs = [x for x in xs if x is not None]
    return sum(xs) / len(xs) if xs else float("nan")


def main(paths):
    rows = load(paths)
    finals = [r for r in rows if r["kind"] == "final"]
    attempts = [r for r in rows if r["kind"] == "attempt"]
    if not finals:
        sys.exit("no finished episodes yet")
    tok = defaultdict(int)
    for a in attempts:
        tok[(a["run_id"], a["task"], a["style"], a["rep"])] += a["completion_tokens"] or 0

    print(f"{'task':10s} {'style':6s} {'variant':12s} {'solved':>9s} {'rate':>5s} "
          f"{'att@solve':>9s} {'tok/correct':>11s} {'avg_last':>8s}  stops")
    groups = defaultdict(list)
    for f in finals:
        groups[(f["task"], f["style"], f["variant"])].append(f)
    for (t, s, v), fs in sorted(groups.items()):
        ok = [f for f in fs if f["hidden_passed"]]
        toks = sum(tok[(f["run_id"], f["task"], f["style"], f["rep"])] for f in fs)
        print(f"{t:10s} {s:6s} {v:12s} {len(ok):>4d}/{len(fs):<4d} {len(ok) / len(fs):5.2f} "
              f"{mean([f['attempts'] for f in ok]):9.2f} "
              f"{(toks / len(ok)) if ok else float('inf'):11.0f} "
              f"{mean([f['last_score'] for f in fs]):8.2f}  "
              f"{dict(Counter(f['stop'] for f in fs))}")

    print(f"\n{'variant':12s} {'run':22s} {'episodes':>8s} {'correct':>7s} {'wall_min':>8s} "
          f"{'correct/h':>9s} {'tok/s':>7s} {'cancelled':>9s} {'patch_fb':>8s} {'stub_hidden':>11s}")
    runs = defaultdict(list)
    for f in finals:
        runs[(f["variant"], f["run_id"])].append(f)
    for (v, rid), fs in sorted(runs.items()):
        ats = [a for a in attempts if a["run_id"] == rid]
        wall = max(f["t_end"] for f in fs) - min(f["t_start"] for f in fs)
        correct = sum(f["hidden_passed"] for f in fs)
        fresh = [a for a in ats if not a["cache_hit"]]
        toks = sum(a["completion_tokens"] or 0 for a in fresh)
        print(f"{v:12s} {rid:22s} {len(fs):8d} {correct:7d} {wall / 60:8.1f} "
              f"{correct / max(wall, 1) * 3600:9.1f} {toks / max(wall, 1):7.0f} "
              f"{sum(a['cancelled_early'] for a in ats):9d} "
              f"{sum(a.get('patch_fallback', False) for a in ats):8d} "
              f"{str(any(f['hidden_is_stub'] for f in fs)):>11s}")
    if any(a["cache_hit"] for a in attempts):
        print("\nnote: cached replies count as instant; compare correct/h only on fresh runs.")


if __name__ == "__main__":
    main(sys.argv[1:] or sys.exit(__doc__))
