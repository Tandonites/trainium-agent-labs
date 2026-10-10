"""Disk cache shared by every worker thread: model replies and checker verdicts.

A rerun of the same grid replays from here instead of asking the model again, which is what
makes resuming after a crash free.
"""
import hashlib
import json
import sqlite3
import threading


def key_of(*parts):
    return hashlib.sha256(json.dumps(parts, sort_keys=True).encode()).hexdigest()


class Cache:
    def __init__(self, path):
        self.lock = threading.Lock()
        self.db = sqlite3.connect(path, check_same_thread=False)
        self.db.execute("PRAGMA journal_mode=WAL")
        self.db.execute("CREATE TABLE IF NOT EXISTS kv (k TEXT PRIMARY KEY, v TEXT)")
        self.db.commit()

    def get(self, k):
        with self.lock:
            row = self.db.execute("SELECT v FROM kv WHERE k = ?", (k,)).fetchone()
        return json.loads(row[0]) if row else None

    def put(self, k, v):
        with self.lock:
            self.db.execute("INSERT OR REPLACE INTO kv VALUES (?, ?)", (k, json.dumps(v)))
            self.db.commit()

    def memo(self, k, fn):
        """(value, hit): cached value for k, else fn() stored under k."""
        v = self.get(k)
        if v is not None:
            return v, True
        v = fn()
        self.put(k, v)
        return v, False
