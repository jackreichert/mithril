#!/usr/bin/env bash
# Tests for scripts/done-check.sh: section extraction, the skipped/flagged wording, and
# the verdict rule over a per-line table. The model-judged half (writing and running a
# check per line) is not testable here; it is carried by the review agents' contract,
# which healthcheck.sh checks.
set -u
here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script="$here/scripts/done-check.sh"
fx="$here/tests/fixtures/done-check"
fails=0
check() { # name, want-substring, actual
  if [[ "$3" == *"$2"* ]]; then echo "ok   $1"; else echo "FAIL $1: want '$2' in '$3'"; fails=$((fails+1)); fi
}
absent() { # name, unwanted-substring, actual
  if [[ "$3" != *"$2"* ]]; then echo "ok   $1"; else echo "FAIL $1: unexpected '$2'"; fails=$((fails+1)); fi
}
code() { # name, want-exit, got-exit
  if [[ "$2" == "$3" ]]; then echo "ok   $1"; else echo "FAIL $1: want exit $2, got $3"; fails=$((fails+1)); fi
}

# extract: leaf bullets only, lead-in prefixed, other sections ignored.
out="$("$script" extract "$fx/ticket-pass.md")"; rc=$?
code "extract exits 0" 0 "$rc"
check "plain bullet is line 1" $'1\tThe greeting script prints hello and exits 0.' "$out"
check "nested bullet carries its lead-in" $'2\tTests cover it: the happy path prints hello' "$out"
check "second nested bullet is line 3" $'3\tTests cover it: an unknown flag exits 2' "$out"
absent "lead-in is not a line on its own" $'\tTests cover it:'$'\n' "$out"
absent "bullets outside the section are ignored" "Not a done line" "$out"

# No ticket: skipped, plainly, never a pass.
out="$("$script" extract)"; rc=$?
code "no ticket exits 0" 0 "$rc"
check "no ticket says skipped" "Done check: skipped (no ticket)" "$out"
absent "no ticket never says SHIP IT" "SHIP IT" "$out"

# No done section: flagged, criteria never guessed.
out="$("$script" extract "$fx/ticket-nosection.md")"; rc=$?
code "no section exits 2" 2 "$rc"
check "no section is flagged" "Done check: flagged, ticket has no done section" "$out"
absent "no section invents criteria" "Do the thing" "$out"
out="$("$script" extract "$fx/missing.md")"; rc=$?
code "unreadable ticket exits 2" 2 "$rc"
check "unreadable ticket is flagged" "Done check: flagged, ticket not readable" "$out"

# verdict: all pass -> SHIP IT; one failing line -> NEEDS WORK, per-line table intact.
out="$("$script" verdict "$fx/table-pass.tsv" "$fx/ticket-pass.md")"; rc=$?
code "all-pass exits 0" 0 "$rc"
check "all-pass verdict" "Done verdict: SHIP IT" "$out"
check "table has a row per line" "| 3 | DONE |" "$out"
check "table carries evidence" 'exit 0, 1 passed' "$out"
out="$("$script" verdict "$fx/table-fail.tsv" "$fx/ticket-fail.md")"; rc=$?
code "failing line exits 1" 1 "$rc"
check "failing line forces NEEDS WORK" "Done verdict: NEEDS WORK" "$out"
check "failing row is shown" "| 2 | NOT DONE |" "$out"
check "met rows are still reported met" "| 1 | DONE |" "$out"

# verdict rules that stop a quiet pass.
out="$("$script" verdict "$fx/table-weak.tsv")"; rc=$?
code "weak table exits 1" 1 "$rc"
check "DONE without evidence is NOT DONE" "| 1 | NOT DONE (no evidence) |" "$out"
check "N/A without reason is NOT DONE" "| 2 | NOT DONE (N/A without reason) |" "$out"
check "UNCHECKABLE blocks" "| 3 | UNCHECKABLE |" "$out"
check "weak table verdict" "Done verdict: NEEDS WORK" "$out"
out="$("$script" verdict "$fx/table-short.tsv" "$fx/ticket-pass.md")"; rc=$?
code "dropped lines exit 1" 1 "$rc"
check "dropped lines are NOT DONE" "NOT DONE (missing rows)" "$out"
check "dropped lines count" "2 of 3 done lines have no row" "$out"
printf '' > "${TMPDIR:-/tmp}/done-check-empty.$$"
out="$("$script" verdict "${TMPDIR:-/tmp}/done-check-empty.$$")"; rc=$?; rm -f "${TMPDIR:-/tmp}/done-check-empty.$$"
code "empty table exits 1" 1 "$rc"
check "empty table never passes" "NOT DONE (empty table)" "$out"

echo
if (( fails )); then echo "$fails failure(s)"; exit 1; fi
echo "all passed"
