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
equals() { # name, exact expected, actual
  if [[ "$2" == "$3" ]]; then echo "ok   $1"; else echo "FAIL $1: want '$2' got '$3'"; fails=$((fails+1)); fi
}
code() { # name, want-exit, got-exit
  if [[ "$2" == "$3" ]]; then echo "ok   $1"; else echo "FAIL $1: want exit $2, got $3"; fails=$((fails+1)); fi
}

# extract: leaf bullets only, lead-in prefixed, other sections ignored.
out="$("$script" extract "$fx/ticket-pass.md")"; rc=$?
code "extract exits 0" 0 "$rc"
equals "exactly the three done lines, nothing else" $'1\tThe greeting script prints hello and exits 0.\n2\tTests cover it: the happy path prints hello\n3\tTests cover it: an unknown flag exits 2' "$out"
check "plain bullet is line 1" $'1\tThe greeting script prints hello and exits 0.' "$out"
check "nested bullet carries its lead-in" $'2\tTests cover it: the happy path prints hello' "$out"
check "second nested bullet is line 3" $'3\tTests cover it: an unknown flag exits 2' "$out"
absent "bullets outside the section are ignored" "Not a done line" "$out"

# The script must exist for any of the above to mean anything.
if [[ -x "$script" ]]; then echo "ok   script exists"; else echo "FAIL script exists: $script"; fails=$((fails+1)); fi

# Real tickets vary: numbered lines, star bullets, prose paragraphs, any heading level and
# case, CRLF line endings, fenced code, and an inline "What done looks like:" lead.
out="$("$script" extract "$fx/ticket-numbered.md")"
equals "numbered, star and plus items under an uppercase ### heading" $'1\tThe first numbered line.\n2\tThe second numbered line.\n3\tA star bullet.\n4\tA plus bullet.' "$out"
out="$("$script" extract "$fx/ticket-prose.md")"
equals "each prose paragraph is one line, mixed-case heading" $'1\tThe tool prints hello and exits 0 when run with no arguments.\n2\tIt exits 2 on an unknown flag.' "$out"
out="$("$script" extract "$fx/ticket-crlf.md")"
equals "CRLF endings are stripped and the section still ends at the next heading" $'1\tLine one.\n2\tLine two.' "$out"
out="$("$script" extract "$fx/ticket-fence.md")"
equals "headings and bullets inside fences are ignored" $'1\tLine before the fence.\n2\tLine after the fence.' "$out"
out="$("$script" extract "$fx/ticket-inline.md")"
equals "inline 'What done looks like:' lead is one line" $'1\tthe script exits 0 and prints hello.' "$out"
out="$("$script" extract "$fx/ticket-fenced-only.md")"; rc=$?
code "a fenced decoy heading is not a section" 2 "$rc"
equals "fenced-only ticket is flagged" "Done check: flagged, ticket has no done section" "$out"

# No ticket: skipped, plainly, never a pass.
out="$("$script" extract)"; rc=$?
code "no ticket exits 0" 0 "$rc"
check "no ticket says skipped" "Done check: skipped (no ticket)" "$out"
equals "no ticket prints only the skipped line" "Done check: skipped (no ticket)" "$out"

# No done section: flagged, criteria never guessed.
out="$("$script" extract "$fx/ticket-nosection.md")"; rc=$?
code "no section exits 2" 2 "$rc"
check "no section is flagged" "Done check: flagged, ticket has no done section" "$out"
equals "no section prints only the flagged line" "Done check: flagged, ticket has no done section" "$out"
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
out="$("$script" verdict "$fx/table-weak.tsv" "$fx/ticket-pass.md")"; rc=$?
code "weak table exits 1" 1 "$rc"
check "DONE without evidence is NOT DONE" "| 1 | NOT DONE (no evidence) |" "$out"
check "N/A without reason is NOT DONE" "| 2 | NOT DONE (N/A without reason) |" "$out"
check "UNCHECKABLE blocks" "| 3 | UNCHECKABLE |" "$out"
check "weak table verdict" "Done verdict: NEEDS WORK" "$out"
out="$("$script" verdict "$fx/table-short.tsv" "$fx/ticket-pass.md")"; rc=$?
code "dropped lines exit 1" 1 "$rc"
check "dropped line 2 is NOT DONE" "| 2 | NOT DONE (missing row) |" "$out"
check "dropped line 3 is NOT DONE" "| 3 | NOT DONE (missing row) |" "$out"
printf '' > "${TMPDIR:-/tmp}/done-check-empty.$$"
out="$("$script" verdict "${TMPDIR:-/tmp}/done-check-empty.$$" "$fx/ticket-pass.md")"; rc=$?; rm -f "${TMPDIR:-/tmp}/done-check-empty.$$"
code "empty table exits 1" 1 "$rc"
check "empty table never passes: every line is missing" "| 1 | NOT DONE (missing row) |" "$out"

# The ids are matched, not counted: the table cannot satisfy the ticket by length alone.
out="$("$script" verdict "$fx/table-dup.tsv" "$fx/ticket-pass.md")"; rc=$?
code "three rows all id 1 exit 1" 1 "$rc"
check "duplicate id is NOT DONE" "| 1 | NOT DONE (duplicate id) |" "$out"
check "lines 2 and 3 are missing" "| 3 | NOT DONE (missing row) |" "$out"
check "duplicate-id verdict" "Done verdict: NEEDS WORK" "$out"
out="$("$script" verdict "$fx/table-unknown.tsv" "$fx/ticket-pass.md")"; rc=$?
code "ids 9/8/7 exit 1" 1 "$rc"
check "unknown id is NOT DONE" "| 9 | NOT DONE (unknown id) |" "$out"
check "line 1 is missing" "| 1 | NOT DONE (missing row) |" "$out"
check "unknown-id verdict" "Done verdict: NEEDS WORK" "$out"
out="$("$script" verdict "$fx/table-extra.tsv" "$fx/ticket-pass.md")"; rc=$?
code "a row beyond N exits 1" 1 "$rc"
check "extra row is an unknown id" "| 4 | NOT DONE (unknown id) |" "$out"

# Whitespace is not evidence or a reason, and an empty check cannot be DONE.
out="$("$script" verdict "$fx/table-blank.tsv" "$fx/ticket-pass.md")"; rc=$?
code "blank evidence exits 1" 1 "$rc"
check "space evidence is no evidence" "| 1 | NOT DONE (no evidence) |" "$out"
check "space reason is no reason" "| 2 | NOT DONE (N/A without reason) |" "$out"
check "empty check keeps its column (not shifted)" "| 3 | NOT DONE (no evidence) |" "$out"

# A ticket is required, and one with nothing to check fails rather than passing on zero lines.
"$script" verdict "$fx/table-pass.tsv" >/dev/null 2>&1; rc=$?
code "verdict without a ticket is a usage error" 2 "$rc"
out="$("$script" verdict "$fx/table-pass.tsv" "$fx/ticket-nosection.md")"; rc=$?
code "verdict on a no-section ticket exits 1" 1 "$rc"
check "no-section ticket is flagged in the verdict" "Done check: flagged, ticket has no done section" "$out"
check "flagged forces NEEDS WORK" "Done verdict: NEEDS WORK" "$out"
out="$("$script" verdict "$fx/table-pass.tsv" "$fx/missing.md")"; rc=$?
code "verdict on an unreadable ticket exits 1" 1 "$rc"
absent "an unreadable ticket never says SHIP IT" "SHIP IT" "$out"

echo
if (( fails )); then echo "$fails failure(s)"; exit 1; fi
echo "all passed"
