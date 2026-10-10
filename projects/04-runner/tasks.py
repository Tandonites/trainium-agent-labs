"""Tasks the runner can run, and the contract a task has to meet.

The runner knows nothing about Verilog. A task is four things it can call:

  check(code)              -> {"score": float, "passed": bool, "stage": str, "feedback": str}
  feedback(verdict, style) -> str   the text the model sees before its next try
  hidden(code)             -> {"passed": bool, ...}   run once, on the final module
  prompt / header          the task text, and the exact module header (for early cancel)

Two ways to name tasks on the command line (--tasks a,b,c):
  uart_tx                  a level folder in ../03-protocol-agent (prompt.txt + checker.py)
  some.module:func         func() returns a Task or a list of Tasks (the teammates' real ones)
"""
import importlib
import importlib.util
import os
import re
import sys
from dataclasses import dataclass, field
from typing import Callable

HERE = os.path.dirname(os.path.abspath(__file__))
LEVELS_DIR = os.path.normpath(os.path.join(HERE, "..", "03-protocol-agent"))
STYLES = ("full", "score", "none")


@dataclass
class Task:
    id: str
    prompt: str
    header: str
    check: Callable
    feedback: Callable
    hidden: Callable
    hidden_is_stub: bool = False
    ports: tuple = field(init=False)

    def __post_init__(self):
        self.ports = port_signature(self.header)


# --------------------------------------------------------------------------
# module headers
# --------------------------------------------------------------------------
HEADER_RE = re.compile(r"\bmodule\s+(\w+)\s*(?:#\s*\(.*?\)\s*)?\((.*?)\)\s*;", re.S)


def strip_comments(text):
    return re.sub(r"//[^\n]*|/\*.*?\*/", "", text, flags=re.S)


def port_signature(text):
    """(module name, port names in order) of the first module header in text, or None."""
    m = HEADER_RE.search(strip_comments(text))
    if not m:
        return None
    names = []
    for item in m.group(2).split(","):
        words = re.findall(r"\w+", item)
        if words:
            names.append(words[-1])
    return (m.group(1), tuple(names))


def header_of(prompt):
    m = HEADER_RE.search(prompt)
    return m.group(0) if m else ""


# --------------------------------------------------------------------------
# adapter: a 03-protocol-agent level folder as a Task
# --------------------------------------------------------------------------
def level_feedback(verdict, style):
    if style == "full":
        return "Fix this one problem: " + verdict["feedback"]
    if style == "score":
        return f"That design scored {verdict['score']:.2f} out of 1.0. It is not correct yet."
    return "That design is not correct yet."


def load_level_task(name):
    d = os.path.join(LEVELS_DIR, name)
    spec = importlib.util.spec_from_file_location(f"checker_{name}", os.path.join(d, "checker.py"))
    mod = importlib.util.module_from_spec(spec)
    sys.path.insert(0, d)
    spec.loader.exec_module(mod)
    with open(os.path.join(d, "prompt.txt")) as fh:
        prompt = fh.read().strip()
    # Placeholder until the real hidden tests arrive: the checker's own pass/fail.
    return Task(id=name, prompt=prompt, header=header_of(prompt), check=mod.check,
                feedback=level_feedback, hidden=lambda code: {"passed": mod.check(code)["passed"]},
                hidden_is_stub=True)


def resolve(spec):
    """'uart_tx' or 'pkg.mod:func' -> list of Tasks."""
    if ":" in spec:
        mod_name, fn = spec.split(":", 1)
        sys.path.insert(0, HERE)
        got = getattr(importlib.import_module(mod_name), fn)()
        return list(got) if isinstance(got, (list, tuple)) else [got]
    return [load_level_task(spec)]


def load_tasks(specs):
    tasks = []
    for s in specs.split(","):
        if s.strip():
            tasks += resolve(s.strip())
    return tasks


# --------------------------------------------------------------------------
# contract check: run before any model call, so a teammate's function that returns the
# wrong shape fails in seconds with a clear message instead of an hour into a run
# --------------------------------------------------------------------------
SAMPLES = {"empty": "", "garbage": "this is not a module", "header only": None}


def validate(task, styles):
    """List of problems with task (empty if it meets the contract)."""
    bad = []
    if not isinstance(task.prompt, str) or not task.prompt.strip():
        bad.append("prompt is empty")
    if task.ports is None:
        bad.append("header has no 'module name (...);' -- early cancel cannot work (warning)")
    for label, code in SAMPLES.items():
        code = (task.header + "\nendmodule") if code is None else code
        try:
            v = task.check(code)
        except Exception as e:
            bad.append(f"check({label}) raised {type(e).__name__}: {e}")
            continue
        if not isinstance(v, dict):
            bad.append(f"check({label}) returned {type(v).__name__}, want dict")
            continue
        for k, typ in (("score", (int, float)), ("passed", bool), ("stage", str), ("feedback", str)):
            if not isinstance(v.get(k), typ):
                bad.append(f"check({label})[{k!r}] is {v.get(k)!r}, want {typ}")
        if isinstance(v.get("score"), (int, float)) and not 0 <= v["score"] <= 1:
            bad.append(f"check({label}) score {v['score']} is outside 0..1")
        if v.get("passed") is True:
            bad.append(f"check({label}) PASSED a non-design -- checker too lenient?")
        for s in styles:
            try:
                fb = task.feedback(v, s)
                if not isinstance(fb, str) or not fb.strip():
                    bad.append(f"feedback(verdict, {s!r}) returned {fb!r}, want non-empty str")
            except Exception as e:
                bad.append(f"feedback(verdict, {s!r}) raised {type(e).__name__}: {e}")
        try:
            h = task.hidden(code)
            if not isinstance(h, dict) or not isinstance(h.get("passed"), bool):
                bad.append(f"hidden({label}) returned {h!r}, want dict with bool 'passed'")
        except Exception as e:
            bad.append(f"hidden({label}) raised {type(e).__name__}: {e}")
    return bad
