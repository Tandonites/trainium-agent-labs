#!/usr/bin/env python3
"""The experiment engine.

For every task x feedback style x rep it runs one episode: the model writes the module, the
task's checker grades it, the task's feedback writer turns the grade into text, the model fixes,
up to --fixes times. Then the hidden tests run on the final module. Every attempt is one JSON
line in results/<run_id>.jsonl, plus one "final" line per episode.

Episodes run in parallel across every endpoint in the pool; inside one episode the steps are
serial (each needs the previous one's output).

  python runner.py --tasks uart_tx,uart_rx --styles full,score --reps 5
  python runner.py --run-id <id> ...          # resume: finished episodes are skipped
  python runner.py --dry-run ...              # fake model, no server needed
  python runner.py ... --early-cancel         # stop a reply whose port list is already wrong
  python runner.py ... --patch-mode           # fixes are SEARCH/REPLACE edits, not whole modules

Run long jobs in the background so a dropped kubectl session doesn't kill them:
  nohup python runner.py ... > run.log 2>&1 < /dev/null &
"""
import argparse
import concurrent.futures as cf
import hashlib
import json
import os
import re
import sys
import threading
import time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import tasks as tasklib  # noqa: E402
from cache import Cache, key_of  # noqa: E402
from endpoints import Pool, base_url  # noqa: E402


def extract_code(text):
    """The module from a reply: the longest fenced block containing 'module', else bare
    module...endmodule. Qwen3 <think> blocks are stripped first."""
    text = re.sub(r"<think>.*?</think>", "", text, flags=re.S)
    blocks = re.findall(r"```(?:verilog|systemverilog|v|sv)?\s*\n(.*?)```", text, flags=re.S)
    blocks = [b for b in blocks if "module" in b]
    if blocks:
        return max(blocks, key=len).strip()
    m = re.search(r"module\b.*?endmodule", text, flags=re.S)
    return m.group(0).strip() if m else ""


def sha(text):
    return hashlib.sha256(text.encode()).hexdigest()[:16]


def stable_seed(*parts):
    """Same (task, style, rep, attempt) -> same seed, so variants are compared on paired samples."""
    return int(key_of(*parts)[:8], 16) % (2 ** 31)


# --------------------------------------------------------------------------
# prompts
# --------------------------------------------------------------------------
PATCH_FORMAT = """Do not rewrite the whole module. Reply with only the edits, each in exactly this form,
where the SEARCH lines are copied exactly from your previous attempt:
<<<<<<< SEARCH
(lines to replace)
=======
(new lines)
>>>>>>> REPLACE"""


def repair_prompt(task, code, fb, patch):
    tail = (PATCH_FORMAT if patch else
            "Reply with only one ```verilog code block containing the complete corrected module.")
    return f"{task.prompt}\n\nYour previous attempt:\n```verilog\n{code}\n```\n\n{fb}\n\n{tail}"


PATCH_RE = re.compile(r"<{5,}\s*SEARCH\s*\n(.*?)\n={5,}\s*\n(.*?)\n?>{5,}\s*REPLACE", re.S)


def apply_patch(code, reply):
    """Apply SEARCH/REPLACE edits from reply to code. None if there are none or one misses."""
    edits = PATCH_RE.findall(reply)
    if not edits:
        return None
    for search, replace in edits:
        if search in code:
            code = code.replace(search, replace, 1)
            continue
        # tolerate indentation drift: match line by line ignoring surrounding whitespace
        lines, want = code.split("\n"), [l.strip() for l in search.strip("\n").split("\n")]
        for i in range(len(lines) - len(want) + 1):
            if [l.strip() for l in lines[i:i + len(want)]] == want:
                lines[i:i + len(want)] = replace.split("\n")
                break
        else:
            return None
        code = "\n".join(lines)
    return code


def variant_name(args):
    """Which throughput tricks are on, e.g. 'cancel+patch' ('' for none)."""
    return "+".join(v for v, on in (("cancel", args.early_cancel), ("patch", args.patch_mode),
                                    ("repeatstop", args.stop_on_repeat)) if on)


def port_guard(task):
    """Early cancel: decide as soon as the reply's module header is complete."""
    def guard(text):
        sig = tasklib.port_signature(text)
        if sig is not None:
            return sig == task.ports
        return True if len(text) > 2500 else None  # no header this far in: stop watching
    return guard


# --------------------------------------------------------------------------
# one episode
# --------------------------------------------------------------------------
class Runner:
    def __init__(self, args, pool, cache, log_path):
        self.args, self.pool, self.cache = args, pool, cache
        self.log_lock = threading.Lock()
        self.log = open(log_path, "a")
        self.variant = variant_name(args) or "base"

    def write(self, rec):
        with self.log_lock:
            self.log.write(json.dumps(rec) + "\n")
            self.log.flush()

    def llm(self, prompt, seed, guard):
        a = self.args
        k = key_of("llm", self.pool.model, prompt, a.temperature, a.max_tokens, seed,
                   guard is not None)
        return self.cache.memo(k, lambda: self.pool.chat(
            prompt, guard=guard, max_tokens=a.max_tokens, temperature=a.temperature,
            seed=seed if a.send_seed or a.dry_run else None))

    def verdict(self, task, fn, code):
        if self.args.no_verdict_cache:
            return getattr(task, fn)(code), False
        return self.cache.memo(key_of(fn, task.id, code), lambda: getattr(task, fn)(code))

    def episode(self, task, style, rep):
        a = self.args
        base = {"run_id": a.run_id, "task": task.id, "style": style, "rep": rep,
                "variant": self.variant, "model": self.pool.model}
        guard = port_guard(task) if a.early_cancel and task.ports else None
        prompt, code, prev_code, final_code = task.prompt, "", None, ""
        t_ep, stop, v = time.time(), "fixes_used", None
        for attempt in range(a.fixes + 1):
            t0 = time.time()
            seed = stable_seed(task.id, style, rep, attempt)
            patching = a.patch_mode and prev_code is not None
            r, hit = self.llm(prompt, seed, guard)
            patch_fallback = False
            if patching and not r["cancelled"]:
                patched = apply_patch(prev_code, r["text"])
                if patched is None and not extract_code(r["text"]):
                    # no usable edit and no module: ask again for the whole module
                    patch_fallback = True
                    whole = repair_prompt(task, prev_code, fb, patch=False)
                    r2, hit2 = self.llm(whole, seed, guard)
                    r = dict(r2, completion_tokens=(r2["completion_tokens"] or 0)
                             + (r["completion_tokens"] or 0))
                    hit = hit and hit2
                code = patched if patched is not None else extract_code(r["text"])
            else:
                code = extract_code(r["text"])
            if r["cancelled"]:
                v = {"score": 0.0, "passed": False, "stage": "ports",
                     "feedback": "The port list is wrong. Use exactly this header:\n" + task.header}
                vhit = False
            else:
                v, vhit = self.verdict(task, "check", code)
                final_code = code
            self.write({**base, "kind": "attempt", "attempt": attempt, "seed": seed,
                        "endpoint": r.get("endpoint"), "prompt_chars": len(prompt),
                        "prompt_tokens": r["prompt_tokens"],
                        "completion_tokens": r["completion_tokens"], "ttft_s": r["ttft_s"],
                        "latency_s": r["latency_s"], "finish_reason": r["finish_reason"],
                        "cancelled_early": r["cancelled"], "patch": patching,
                        "patch_fallback": patch_fallback, "cache_hit": hit, "verdict_cache_hit": vhit,
                        "code_sha": sha(code), "code_chars": len(code), "score": v["score"],
                        "stage": v["stage"], "passed": v["passed"], "feedback": v["feedback"],
                        "t_start": round(t0, 3), "t_end": round(time.time(), 3), "code": code})
            if v["passed"]:
                stop = "passed"
                break
            if a.stop_on_repeat and prev_code is not None and code == prev_code:
                stop = "repeat"
                break
            if attempt == a.fixes:
                break
            fb = task.feedback(v, style)
            if not r["cancelled"]:
                prev_code = code
            prompt = repair_prompt(task, prev_code or code, fb, patch=a.patch_mode and bool(prev_code))
        h, _ = self.verdict(task, "hidden", final_code)
        rec = {**base, "kind": "final", "attempts": attempt + 1, "stop": stop,
               "check_passed": v["passed"], "last_score": v["score"],
               "hidden_passed": bool(h.get("passed")), "hidden": h,
               "hidden_is_stub": task.hidden_is_stub, "t_start": round(t_ep, 3),
               "t_end": round(time.time(), 3), "code_sha": sha(final_code)}
        self.write(rec)
        return rec


# --------------------------------------------------------------------------
# dry run: a fake model, so the loop can be tested without a server
# --------------------------------------------------------------------------
class FakePool:
    """Replies with the level's reference design, sometimes broken first, streamed in chunks."""
    model = "fake"
    total_slots = 4

    def chat(self, prompt, guard=None, seed=0, **kw):
        name = tasklib.port_signature(tasklib.header_of(prompt))[0]
        with open(os.path.join(tasklib.LEVELS_DIR, name, "reference", f"{name}_ref.v")) as fh:
            ref = fh.read()
        first = "Your previous attempt" not in prompt
        if first and seed % 3 == 1:
            ref = ref.replace("clk", "clock", 1)          # wrong port name
        elif first and seed % 3 == 2:
            ref = ref.replace("CLKS_PER_BIT-1", "15")   # hard-coded timing
        text = f"```verilog\n{ref}\n```"
        out = {"text": text, "finish_reason": "stop", "cancelled": False, "prompt_tokens": 0,
               "completion_tokens": len(text) // 4, "ttft_s": 0.0, "latency_s": 0.0,
               "endpoint": "fake"}
        for i in range(40, len(text) + 40, 40):
            if guard is not None:
                g = guard(text[:i])
                if g is False:
                    return dict(out, text=text[:i], cancelled=True, finish_reason="cancelled",
                                completion_tokens=i // 4)
                if g is True:
                    guard = None
        return out

    def summary(self):
        return {}


# --------------------------------------------------------------------------
# main
# --------------------------------------------------------------------------
def resume(path):
    """Keep finished episodes, drop half-written ones (they rerun, replaying from the cache)."""
    if not os.path.exists(path):
        return set()
    with open(path) as fh:
        rows = [json.loads(l) for l in fh if l.strip()]
    done = {(r["task"], r["style"], r["rep"]) for r in rows if r["kind"] == "final"}
    keep = [r for r in rows if (r["task"], r["style"], r["rep"]) in done]
    tmp = path + ".tmp"
    with open(tmp, "w") as fh:
        fh.writelines(json.dumps(r) + "\n" for r in keep)
    os.replace(tmp, path)
    print(f"resume: {len(done)} episodes already finished, {len(rows) - len(keep)} "
          f"half-written lines dropped", flush=True)
    return done


def read_endpoints(args):
    if args.endpoints:
        return args.endpoints.split(",")
    f = os.path.join(HERE, "endpoints.txt")
    if os.path.exists(f):
        with open(f) as fh:
            urls = [l.split("#")[0].strip() for l in fh]
        if any(urls):
            return urls
    return [base_url()]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--tasks", default="uart_tx", help="comma list: level folder or module:func")
    ap.add_argument("--styles", default="full,score", help=f"comma list, e.g. {','.join(tasklib.STYLES)}")
    ap.add_argument("--reps", type=int, default=3)
    ap.add_argument("--fixes", type=int, default=3, help="fix attempts after the first try")
    ap.add_argument("--endpoints", help="comma list of base URLs (else endpoints.txt, else env)")
    ap.add_argument("--slots", type=int, default=4, help="requests in flight per endpoint")
    ap.add_argument("--max-tokens", type=int, default=3000)
    ap.add_argument("--temperature", type=float, default=0.7)
    ap.add_argument("--run-id", help="reuse to resume a run")
    ap.add_argument("--send-seed", action="store_true",
                    help="send the per-attempt seed to vLLM (crashed the Neuron engine; off by default)")
    ap.add_argument("--early-cancel", action="store_true")
    ap.add_argument("--patch-mode", action="store_true")
    ap.add_argument("--stop-on-repeat", action="store_true",
                    help="end an episode when the model returns the same code twice (saves rounds, "
                         "but the episode gets fewer than --fixes fixes)")
    ap.add_argument("--no-verdict-cache", action="store_true",
                    help="re-run checker/hidden even on code seen before (use after a checker change)")
    ap.add_argument("--dry-run", action="store_true", help="fake model, no server needed")
    ap.add_argument("--check-tasks", action="store_true",
                    help="only check that each task's check/feedback/hidden meet the contract")
    args = ap.parse_args()

    variant = variant_name(args)
    args.run_id = args.run_id or time.strftime("%H%M%S") + ("_" + variant if variant else "") \
        + ("_dry" if args.dry_run else "")
    os.makedirs(os.path.join(HERE, "results"), exist_ok=True)
    log_path = os.path.join(HERE, "results", f"{args.run_id}.jsonl")
    meta_path = os.path.join(HERE, "results", f"{args.run_id}.meta.json")
    if os.path.exists(meta_path):
        with open(meta_path) as fh:
            old = json.load(fh)
        differ = [k for k in ("early_cancel", "patch_mode", "stop_on_repeat", "fixes",
                              "temperature", "max_tokens", "dry_run") if old.get(k) != vars(args)[k]]
        if differ:
            sys.exit(f"run {args.run_id} was started with different {differ}; "
                     "use a new --run-id for a different variant")
    with open(meta_path, "w") as fh:
        json.dump(vars(args), fh, indent=1)

    task_list = tasklib.load_tasks(args.tasks)
    styles = [s.strip() for s in args.styles.split(",") if s.strip()]
    broken = False
    for t in task_list:
        problems = tasklib.validate(t, styles)
        print(f"contract {t.id}: {'OK' if not problems else ''}", flush=True)
        for p in problems:
            print(f"   - {p}", flush=True)
            broken |= "(warning)" not in p
    if broken or args.check_tasks:
        sys.exit("fix the task functions above before running" if broken else 0)
    pool = FakePool() if args.dry_run else Pool(read_endpoints(args), slots=args.slots)
    cache = Cache(os.path.join(HERE, "results", "cache.sqlite"))
    done = resume(log_path)
    grid = [(t, s, r) for r in range(args.reps) for t in task_list for s in styles
            if (t.id, s, r) not in done]
    # extra workers so checker time on one episode overlaps model time on another
    workers = max(1, pool.total_slots * 2)
    print(f"run {args.run_id}: {len(grid)} episodes to run ({len(done)} done), "
          f"model={pool.model}, workers={workers}, log={log_path}", flush=True)

    runner = Runner(args, pool, cache, log_path)
    t0, n, solved = time.time(), 0, 0
    with cf.ThreadPoolExecutor(workers) as ex:
        futs = {ex.submit(runner.episode, *g): g for g in grid}
        for f in cf.as_completed(futs):
            t, s, r = futs[f]
            n += 1
            try:
                rec = f.result()
            except Exception as e:  # one broken episode must not kill the run
                print(f"[{n}/{len(grid)}] {t.id} {s} rep{r}: ERROR {type(e).__name__}: {e}",
                      flush=True)
                continue
            solved += rec["hidden_passed"]
            hours = max(time.time() - t0, 1) / 3600
            print(f"[{n}/{len(grid)}] {t.id:10s} {s:6s} rep{r}: "
                  f"{'PASS' if rec['hidden_passed'] else 'fail'} after {rec['attempts']} "
                  f"({rec['stop']}, last {rec['last_score']:.2f})   "
                  f"correct/h {solved / hours:.0f}", flush=True)
    print(f"\ndone: {solved}/{n} hidden-passed in {time.time() - t0:.0f}s. "
          f"Summary: python stats.py results/{args.run_id}.jsonl", flush=True)
    print(f"endpoints: {pool.summary()}", flush=True)


if __name__ == "__main__":
    main()
