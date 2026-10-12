#!/usr/bin/env bash
# The done verdict must be a process the review hook runs, not a sentence in the
# command prompt. These tests invoke hooks/done-verdict.sh with the hook JSON
# Claude Code passes (UserPromptExpansion, SubagentStop, Stop).
set -u
here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hook="$here/hooks/done-verdict.sh"
fx="$here/tests/fixtures/done-check"
fails=0
state="$(mktemp -d "${TMPDIR:-/tmp}/mithril-done-test.XXXXXX")"
trap 'rm -rf "$state"' EXIT

check() {
  if [[ "$3" == *"$2"* ]]; then echo "ok   $1"; else echo "FAIL $1: want '$2' in '$3'"; fails=$((fails+1)); fi
}
absent() {
  if [[ "$3" != *"$2"* ]]; then echo "ok   $1"; else echo "FAIL $1: unexpected '$2'"; fails=$((fails+1)); fi
}
code() {
  if [[ "$2" == "$3" ]]; then echo "ok   $1"; else echo "FAIL $1: want exit $2, got $3"; fails=$((fails+1)); fi
}

run_hook() { # session, json -> stdout in $out, stderr in $err, exit in $rc
  local session="$1" json="$2"
  rc=0
  out="$(MITHRIL_DONE_STATE="$state" "$hook" <<<"$json" 2>"$state/$session.err")" || rc=$?
  err="$(cat "$state/$session.err" 2>/dev/null || true)"
}
# Build hook JSON in Python. Brace expansion splits a shell-quoted object.
expand_json() { # session, ticket (empty means done with no path)
  python3 -c '
import json, sys
session, ticket, cwd = sys.argv[1:]
args = "review done" + ((" " + ticket) if ticket else "")
print(json.dumps({
    "hook_event_name": "UserPromptExpansion",
    "command_name": "mithril",
    "command_args": args,
    "session_id": session,
    "cwd": cwd,
}))
' "$1" "$2" "$here"
}

if [[ -x "$hook" ]]; then echo "ok   hook exists"; else echo "FAIL hook exists: $hook"; fails=$((fails+1)); fi

ticket="$fx/ticket-pass.md"
run_hook exp "$(expand_json exp "$ticket")"
code "expansion exits 0" 0 "$rc"
check "expansion runs extract" $'1\tThe greeting script prints hello and exits 0.' "$out"
check "expansion names a rows file" "Rows file:" "$out"

run_hook scoped "$(expand_json scoped "$ticket" | python3 -c 'import json,sys; data=json.load(sys.stdin); data["command_name"]="mithril:mithril"; print(json.dumps(data))')"
code "plugin-scoped command exits 0" 0 "$rc"
check "plugin-scoped command runs extract" $'1\tThe greeting script prints hello and exits 0.' "$out"

run_hook quiet '{"hook_event_name":"UserPromptExpansion","command_name":"mithril","command_args":"review","session_id":"quiet"}'
code "no done token exits 0" 0 "$rc"
absent "no done token prints nothing" "Done check:" "$out"

run_hook skip '{"hook_event_name":"UserPromptExpansion","command_name":"mithril","command_args":"review done","session_id":"skip"}'
code "no path exits 0" 0 "$rc"
check "no path says skipped" "Done check: skipped (no ticket)" "$out"
run_hook skipstop '{"hook_event_name":"Stop","session_id":"skip","stop_hook_active":false,"last_assistant_message":"Verdict: SHIP IT"}'
code "skipped stop blocks a silent pass" 2 "$rc"
check "skipped stop repeats skipped" "Done check: skipped (no ticket)" "$err"
absent "skipped stop is not a pass" "Done verdict: SHIP IT" "$err"

run_hook nosection "$(expand_json nosection "$fx/ticket-nosection.md")"
code "no section expansion exits 0" 0 "$rc"
check "no section is flagged at expansion" "Done check: flagged, ticket has no done section" "$out"
run_hook nosectstop '{"hook_event_name":"Stop","session_id":"nosection","stop_hook_active":false,"last_assistant_message":"Verdict: SHIP IT"}'
code "flagged stop is NEEDS WORK" 2 "$rc"
check "flagged stop verdict" "Done verdict: NEEDS WORK" "$err"

# The agent returns rows; the hook runs verdict. A failing line cannot pass.
printf '1\tNOT DONE\tbash tests\texit 1\n2\tDONE\tbash tests\texit 0\n3\tDONE\tbash tests\texit 0\n' > "$state/agent-rows.txt"
# Re-expand so session "fail" has a ticket, then feed the agent message.
run_hook fail "$(expand_json fail "$ticket")"
rows_json="$(python3 -c 'import json,sys; print(json.dumps({"hook_event_name":"SubagentStop","agent_type":"mithril-review","session_id":"fail","last_assistant_message":open(sys.argv[1]).read()}))' "$state/agent-rows.txt")"
run_hook failsub "$rows_json"
code "subagent stop exits 0" 0 "$rc"
run_hook failstop '{"hook_event_name":"Stop","session_id":"fail","stop_hook_active":false,"last_assistant_message":"Verdict: SHIP IT"}'
code "failing rows force exit 2" 2 "$rc"
check "failing rows are NEEDS WORK" "Done verdict: NEEDS WORK" "$err"
absent "hook verdict is not the model SHIP IT" "Done verdict: SHIP IT" "$err"

# All-pass rows: the hook runs verdict and the exit is the script's, not a grep.
run_hook pass "$(expand_json pass "$ticket")"
rows_path="$(printf '%s\n' "$out" | sed -n 's/^Rows file: //p')"
printf '1\tDONE\tbash hello\texit 0\n2\tDONE\tbash test\texit 0, 1 passed\n3\tDONE\tbash test\texit 0\n' > "$rows_path"
run_hook passstop '{"hook_event_name":"Stop","session_id":"pass","stop_hook_active":false,"last_assistant_message":"review finished"}'
code "passing rows exit 0" 0 "$rc"
check "passing rows are SHIP IT" "Done verdict: SHIP IT" "$out"

# A claimed SHIP IT with no rows is not a pass: the hook runs verdict on an empty table.
run_hook empty "$(expand_json empty "$ticket")"
run_hook emptystop '{"hook_event_name":"Stop","session_id":"empty","stop_hook_active":false,"last_assistant_message":"Verdict: SHIP IT"}'
code "claimed pass with no rows exits 2" 2 "$rc"
check "empty table is NEEDS WORK" "Done verdict: NEEDS WORK" "$err"

# A secret-named ticket is flagged and never opened. The marker must not come back.
secret="$state/secret-dir"
mkdir -p "$secret"
printf 'MARKER_NOT_A_TICKET\n' > "$secret/.env"
run_hook secretish "$(expand_json secretish "$secret/.env")"
code "secret-named ticket expansion exits 0" 0 "$rc"
check "secret-named ticket is flagged" "Done check: flagged, ticket not readable" "$out"
absent "secret-named ticket is not read at expansion" "MARKER_NOT_A_TICKET" "$out$err"
run_hook secretstop '{"hook_event_name":"Stop","session_id":"secretish","stop_hook_active":false,"last_assistant_message":"Verdict: SHIP IT"}'
code "secret-named stop is NEEDS WORK" 2 "$rc"
check "secret-named stop verdict" "Done verdict: NEEDS WORK" "$err"
absent "secret-named ticket is not read at stop" "MARKER_NOT_A_TICKET" "$out$err"

# In-progress stop (no verdict claim, no rows) must not fail-close.
run_hook mid "$(expand_json mid "$ticket")"
run_hook midstop '{"hook_event_name":"Stop","session_id":"mid","stop_hook_active":false,"last_assistant_message":"Spawning the review agent."}'
code "in-progress stop exits 0" 0 "$rc"
absent "in-progress stop does not verdict" "Done verdict:" "$out$err"

echo
if (( fails )); then echo "$fails failure(s)"; exit 1; fi
echo "all passed"
