# 04-runner: the experiment engine

For every **task × feedback style × rep** the runner runs one episode:

```
model writes module → check(code) → feedback(verdict, style) → model fixes   (up to --fixes 3 times)
                    → hidden(final code) → log
```

Inside an episode the steps are serial. Many episodes run at once, spread across every seat
listed in `endpoints.txt`. Every attempt is one JSON line in `results/<run_id>.jsonl`, plus one
`"kind": "final"` line per episode with the hidden-test result.

## Run it (inside your pod)

```bash
cd /workspace/projects/04-runner
python runner.py --dry-run --tasks uart_tx,uart_rx --reps 2        # fake model: checks the plumbing
curl -s http://seat-122.seat.default.svc.cluster.local:8000/v1/models   # each teammate's seat answers?
nohup python runner.py --tasks uart_tx,uart_rx --styles full,score,none --reps 5 \
      --run-id base > run_base.log 2>&1 < /dev/null &
tail -f run_base.log
python stats.py results/base.jsonl
```

**Crashed or killed?** Rerun the same command with the same `--run-id`. Finished episodes are
skipped. Half-finished ones rerun, and their model replies come back from the cache
(`results/cache.sqlite`), so a rerun costs nothing. A different variant needs a new `--run-id`.

## Speed

| what | how |
|---|---|
| parallel requests | `--slots 4` in flight per seat (serve.sh uses MAX_NUM_SEQS=4; more only queues) |
| many seats | `endpoints.txt`; least-busy seat gets each request; a failing seat is benched 60 s and the request retried elsewhere |
| caching | model replies keyed by (model, prompt, temperature, max_tokens, seed); verdicts keyed by code. `--no-verdict-cache` after a checker change |
| early stop | stop when the check passes. `--stop-on-repeat` also stops when the model returns the same code twice (a trick to measure: those episodes get fewer fixes) |
| resume | `--run-id` |

Seeds are fixed per (task, style, rep, attempt), so two variants of the same grid see paired
samples and the comparison is fair.

## Throughput experiments

Run the same grid with each trick and compare `correct/h` in `stats.py` (on fresh runs, not cache replays):

```bash
python runner.py ... --run-id base
python runner.py ... --run-id cancel --early-cancel   # stop the reply once its port list is wrong
python runner.py ... --run-id patch  --patch-mode     # fixes are SEARCH/REPLACE edits, not whole modules
python runner.py ... --run-id repeat --stop-on-repeat # end an episode when the model repeats itself
python stats.py results/base.jsonl results/cancel.jsonl results/patch.jsonl
```

## Plugging in the real checker / feedback / hidden tests

`tasks.py` defines the contract. Write a function that returns `Task`s and pass it by name:

```python
# myteam.py
from tasks import Task, header_of
def tasks():
    return [Task(id="spi_tx", prompt=P, header=header_of(P), check=check_fn,
                 feedback=feedback_fn, hidden=hidden_fn)]
```

```bash
python runner.py --tasks myteam:tasks --styles full,score
```

Until then, `--tasks uart_tx,uart_rx` wraps the 03-protocol-agent levels. Their **hidden test is
a stub** (the checker's own pass/fail), and every final line says so with `hidden_is_stub: true`.
