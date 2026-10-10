"""A pool of vLLM servers (everyone's seats), and one streamed chat request against it.

Each seat serves with MAX_NUM_SEQS=4, so more than ~4 requests in flight per seat only queue.
The pool hands each request to the least-busy healthy seat, and a seat that errors is benched
for 15 s while the request is retried on another one.
"""
import json
import os
import threading
import time
import urllib.request


def normalise(u):
    u = u.strip().rstrip("/")
    return u if u.endswith("/v1") else u + "/v1"


def base_url():
    """Default endpoint when neither --endpoints nor endpoints.txt names one."""
    return normalise(os.environ.get("RTL_AGENT_BASE_URL") or os.environ.get("KERNEL_AGENT_BASE_URL")
                     or "http://localhost:8000")


def get_json(url, timeout=5):
    with urllib.request.urlopen(url, timeout=timeout) as r:
        return json.loads(r.read())


class Endpoint:
    def __init__(self, url, slots):
        self.url, self.slots = url, slots
        self.inflight = 0
        self.down_until = 0.0
        self.model = None
        self.requests = self.errors = 0


class Pool:
    def __init__(self, urls, slots=4, bench_secs=15):
        self.cv = threading.Condition()
        self.bench_secs = bench_secs
        self.eps = []
        for u in dict.fromkeys(normalise(u) for u in urls if u.strip()):
            ep = Endpoint(u, slots)
            try:
                ep.model = get_json(u + "/models")["data"][0]["id"]
                self.eps.append(ep)
                print(f"  endpoint up:   {u}  ({ep.model})", flush=True)
            except Exception as e:
                print(f"  endpoint DOWN: {u}  ({type(e).__name__}: {e})", flush=True)
        if not self.eps:
            raise SystemExit("No endpoint answered /v1/models. Is serve.sh running?")
        models = {ep.model for ep in self.eps}
        if len(models) > 1:
            print(f"  WARNING: endpoints serve different models: {models}", flush=True)
        self.model = self.eps[0].model

    @property
    def total_slots(self):
        return sum(ep.slots for ep in self.eps)

    def acquire(self):
        with self.cv:
            while True:
                now = time.time()
                free = [ep for ep in self.eps if ep.inflight < ep.slots and ep.down_until <= now]
                if free:
                    ep = min(free, key=lambda e: e.inflight / e.slots)
                    ep.inflight += 1
                    ep.requests += 1
                    return ep
                self.cv.wait(timeout=1.0)

    def release(self, ep, ok=True):
        with self.cv:
            ep.inflight -= 1
            if not ok:
                ep.errors += 1
                ep.down_until = time.time() + self.bench_secs
            self.cv.notify_all()

    def chat(self, prompt, guard=None, retries=3, **kw):
        last = None
        for _ in range(retries):
            ep = self.acquire()
            try:
                out = stream_chat(ep.url, self.model, prompt, guard=guard, **kw)
                self.release(ep, ok=True)
                out["endpoint"] = ep.url
                return out
            except Exception as e:
                self.release(ep, ok=False)
                last = e
                print(f"  request failed on {ep.url}: {type(e).__name__}: {e}; retrying",
                      flush=True)
        raise RuntimeError(f"request failed {retries} times: {last}")

    def summary(self):
        return {ep.url: {"requests": ep.requests, "errors": ep.errors} for ep in self.eps}


def stream_chat(url, model, prompt, max_tokens, temperature, seed, guard=None, timeout=600):
    """Stream one completion. guard(text_so_far) -> None (undecided), True (fine, stop asking),
    False (cancel now). Returns text, finish_reason, tokens, ttft and whether it was cancelled."""
    body = {
        "model": model,
        "messages": [{"role": "user", "content": prompt + "\n/no_think"}],
        "max_tokens": max_tokens,
        "temperature": temperature,
        "stream": True,
        "stream_options": {"include_usage": True},
        # Qwen3 thinking mode measured at 446 s/round with no usable code (03 README). Off.
        "chat_template_kwargs": {"enable_thinking": False},
    }
    if seed is not None:  # off by default: a per-request seed killed the Neuron vLLM engine
        body["seed"] = seed
    req = urllib.request.Request(url + "/chat/completions", data=json.dumps(body).encode(),
                                 headers={"Content-Type": "application/json"})
    t0 = time.time()
    ttft, parts, chunks, finish, usage, cancelled = None, [], 0, None, None, False
    with urllib.request.urlopen(req, timeout=timeout) as r:
        for raw in r:
            line = raw.decode("utf-8", "replace").strip()
            if not line.startswith("data:"):
                continue
            data = line[5:].strip()
            if data == "[DONE]":
                break
            msg = json.loads(data)
            if msg.get("usage"):
                usage = msg["usage"]
            for ch in msg.get("choices") or []:
                delta = (ch.get("delta") or {}).get("content") or ""
                if delta:
                    if ttft is None:
                        ttft = time.time() - t0
                    parts.append(delta)
                    chunks += 1
                finish = ch.get("finish_reason") or finish
            if guard is not None and parts:
                verdict = guard("".join(parts))
                if verdict is False:
                    cancelled, finish = True, "cancelled"
                    break  # leaving the with-block closes the socket; vLLM aborts the request
                if verdict is True:
                    guard = None
    usage = usage or {}
    return {
        "text": "".join(parts),
        "finish_reason": finish,
        "cancelled": cancelled,
        "prompt_tokens": usage.get("prompt_tokens"),
        "completion_tokens": usage.get("completion_tokens", chunks),
        "ttft_s": round(ttft, 3) if ttft is not None else None,
        "latency_s": round(time.time() - t0, 3),
    }
