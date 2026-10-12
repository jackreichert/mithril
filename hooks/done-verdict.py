#!/usr/bin/env python3
"""Run the done-check verdict when a mithril review expands and when it concludes.

The command prompt can only ask a model to call scripts/done-check.sh. This hook
is the process that actually runs it. Hosts that do not load hooks/hooks.json
never start this file.
"""

from __future__ import annotations

import json
import os
import re
import shlex
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DONE = ROOT / "scripts" / "done-check.sh"
ROW_RE = re.compile(r"^\d+\t")
CLAIM_RE = re.compile(r"Done verdict:|Verdict: SHIP IT|Verdict: NEEDS WORK|Verdict: SIGNIFICANT ISSUES")


def emit(text: str, stream: str) -> None:
    print(text, file=sys.stdout if stream == "out" else sys.stderr, end="" if text.endswith("\n") else "\n")


def state_dir(session: str) -> Path:
    base = Path(os.environ.get("MITHRIL_DONE_STATE") or (Path(os.environ.get("TMPDIR", "/tmp")) / "mithril-done"))
    safe = session if re.fullmatch(r"[A-Za-z0-9._-]{1,80}", session) else "nosession"
    path = base / safe
    path.mkdir(parents=True, exist_ok=True)
    return path


def load_meta(path: Path) -> dict | None:
    meta = path / "meta.json"
    if not meta.is_file():
        return None
    return json.loads(meta.read_text())


def save_meta(path: Path, meta: dict) -> None:
    (path / "meta.json").write_text(json.dumps(meta))


def clear_state(path: Path) -> None:
    if not path.is_dir():
        return
    for child in path.iterdir():
        child.unlink(missing_ok=True)
    path.rmdir()


def is_mithril_command(name: str) -> bool:
    """True for /mithril and the plugin-scoped mithril:mithril form."""
    bare = name.strip().lstrip("/").split(":")[-1]
    return bare == "mithril"


def is_review_agent(agent: str) -> bool:
    """True for the review agent, including the plugin-scoped mithril:mithril-review form."""
    bare = agent.strip().split(":")[-1]
    return bare in {"mithril-review", "mithril-lite-review"}


def secret_path(ticket: Path) -> bool:
    name = ticket.name
    return name == ".env" or name.startswith(".env.") or (name.startswith("ssm-") and name.endswith(".json"))


def run_done(args: list[str]) -> tuple[int, str]:
    proc = subprocess.run([str(DONE), *args], capture_output=True, text=True, check=False)
    text = proc.stdout if proc.stdout else proc.stderr
    return proc.returncode, text


def parse_done(args: str) -> str | None:
    """Return the ticket token after a standalone ``done``, or '' if done has no path.

    None means this expansion is not a done check.
    """
    try:
        tokens = shlex.split(args)
    except ValueError:
        tokens = args.split()
    for i, token in enumerate(tokens):
        if token != "done":
            continue
        if i + 1 >= len(tokens):
            return ""
        return tokens[i + 1]
    return None


def resolve_ticket(token: str, cwd: str) -> Path:
    path = Path(token)
    if not path.is_absolute():
        path = Path(cwd or ".") / path
    return path


def on_expand(data: dict) -> int:
    if not is_mithril_command(str(data.get("command_name") or "")):
        return 0
    ticket_token = parse_done(str(data.get("command_args") or data.get("prompt") or ""))
    if ticket_token is None:
        return 0
    session = state_dir(str(data.get("session_id") or "nosession"))
    rows = session / "rows.tsv"
    rows.write_text("")
    if ticket_token == "":
        message = "Done check: skipped (no ticket)"
        save_meta(session, {"mode": "skipped", "message": message, "rows": str(rows)})
        emit(message + "\n", "out")
        return 0
    ticket = resolve_ticket(ticket_token, str(data.get("cwd") or ""))
    if secret_path(ticket):
        message = "Done check: flagged, ticket not readable"
        save_meta(session, {"mode": "flagged", "message": message, "ticket": str(ticket), "rows": str(rows)})
        emit(message + "\n", "out")
        return 0
    rc, text = run_done(["extract", str(ticket)])
    meta = {"mode": "pending", "ticket": str(ticket), "rows": str(rows), "message": text.rstrip("\n")}
    if rc != 0:
        meta["mode"] = "flagged"
    save_meta(session, meta)
    emit(text if text.endswith("\n") else text + "\n", "out")
    if rc == 0:
        emit(f"Rows file: {rows}\n", "out")
    return 0


def rows_from_message(message: str) -> str:
    lines = [line for line in message.splitlines() if ROW_RE.match(line)]
    return "\n".join(lines) + ("\n" if lines else "")


def store_verdict(session: Path, meta: dict, rc: int, text: str) -> None:
    meta["verdict"] = text
    meta["rc"] = rc
    save_meta(session, meta)


def on_subagent(data: dict) -> int:
    if not is_review_agent(str(data.get("agent_type") or "")):
        return 0
    session = state_dir(str(data.get("session_id") or "nosession"))
    meta = load_meta(session)
    if not meta or meta.get("mode") != "pending" or meta.get("verdict"):
        return 0
    body = rows_from_message(str(data.get("last_assistant_message") or ""))
    if not body.strip():
        return 0
    rows = Path(meta["rows"])
    rows.write_text(body)
    rc, text = run_done(["verdict", str(rows), meta["ticket"]])
    store_verdict(session, meta, rc, text)
    return 0


def emit_verdict(text: str, rc: int) -> int:
    body = text if text.endswith("\n") else text + "\n"
    # A Stop additionalContext continues the turn. A pass must be plain text and
    # exit 0 so the host can stop. A fail exits 2; the host feeds stderr back.
    if rc == 0 and "Done verdict: SHIP IT" in body and "Done verdict: NEEDS WORK" not in body:
        emit(body, "out")
        return 0
    emit(body, "err")
    return 2


def on_stop(data: dict) -> int:
    session = state_dir(str(data.get("session_id") or "nosession"))
    if data.get("stop_hook_active") is True:
        clear_state(session)
        return 0
    meta = load_meta(session)
    if not meta:
        return 0
    if meta.get("verdict"):
        rc = int(meta.get("rc") or 1)
        text = str(meta["verdict"])
        clear_state(session)
        return emit_verdict(text, rc)
    rows = Path(meta.get("rows") or "")
    if meta.get("mode") == "pending" and rows.is_file() and rows.stat().st_size > 0:
        rc, text = run_done(["verdict", str(rows), meta["ticket"]])
        clear_state(session)
        return emit_verdict(text, rc)
    if meta.get("mode") == "skipped":
        clear_state(session)
        emit(str(meta.get("message") or "Done check: skipped (no ticket)") + "\n", "err")
        return 2
    if meta.get("mode") == "flagged":
        ticket = str(meta.get("ticket") or "")
        # Never hand a secret-named path to done-check.sh; that script reads the file.
        if ticket and secret_path(Path(ticket)):
            clear_state(session)
            return emit_verdict("Done check: flagged, ticket not readable\nDone verdict: NEEDS WORK\n", 1)
        empty = session / "empty.tsv"
        empty.write_text("")
        rc, text = run_done(["verdict", str(empty), ticket]) if ticket else (1, "Done verdict: NEEDS WORK\n")
        clear_state(session)
        return emit_verdict(text, rc or 1)
    message = str(data.get("last_assistant_message") or "")
    if meta.get("mode") == "pending" and CLAIM_RE.search(message):
        rows.write_text("")
        rc, text = run_done(["verdict", str(rows), meta["ticket"]])
        clear_state(session)
        return emit_verdict(text, rc or 1)
    return 0


def main() -> int:
    raw = sys.stdin.read()
    if not raw.strip():
        return 0
    try:
        data = json.loads(raw)
    except json.JSONDecodeError:
        return 0
    event = data.get("hook_event_name")
    if event == "UserPromptExpansion":
        return on_expand(data)
    if event == "SubagentStop":
        return on_subagent(data)
    if event == "Stop":
        return on_stop(data)
    return 0


if __name__ == "__main__":
    sys.exit(main())
