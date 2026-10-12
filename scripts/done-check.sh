#!/usr/bin/env bash
# Deterministic half of the mithril done check. The reviewer does the model-judged
# half (write a check per line, run it, record evidence); this script owns the parts
# that must not vary: pulling the "What done looks like" lines out of a ticket, the
# skipped/flagged wording, and the verdict rule over the reviewer's per-line table.
#
#   done-check.sh extract [ticket]   print one "N<TAB>line" per done line
#   done-check.sh verdict <table> [ticket]
#       table rows: N<TAB>STATUS<TAB>check<TAB>evidence   (STATUS: DONE|NOT DONE|N/A|UNCHECKABLE)
#
# Exit: 0 done lines printed / verdict SHIP IT / skipped, 1 verdict NEEDS WORK,
#       2 flagged (no done section, ticket unreadable) or usage error.
set -euo pipefail

TAB="$(printf '\t')"

usage() { echo "usage: done-check.sh extract [ticket] | verdict <table> [ticket]" >&2; exit 2; }

# The lines under the "What done looks like" heading (any # level, any case, or a bold or
# "What done looks like:" lead line). Items are bullets (-, *, +), numbered lines, or a prose
# paragraph (one line). A bullet with sub-bullets is a lead-in: its children are the lines, each
# prefixed "lead-in: child". Fenced code is ignored; the section ends at the next heading.
extract_lines() {
  awk '
    function flush() { if (pend != "") { print pend; pend = "" } kind = "" }
    function trim(t) { sub(/^[ \t]+/, "", t); sub(/[ \t]+$/, "", t); return t }
    { gsub(/\r/, "") }
    /^[ \t]*(```|~~~)/ { fence = !fence; next }
    fence { next }
    !in_sec {
      low = tolower($0)
      if (low ~ /^#+[ \t]+what done looks like[ \t]*:?[ \t]*$/) { in_sec = 1; next }
      if (low ~ /^(\*\*|__)?what done looks like(\*\*|__)?:(\*\*|__)?/) {
        in_sec = 1; rest = $0
        sub(/^[^:]*:(\*\*|__)?[ \t]*/, "", rest)
        if (trim(rest) != "") { pend = trim(rest); kind = "prose" }
      }
      next
    }
    /^#+[ \t]/ { exit }
    /^[ \t]*$/ { if (kind == "prose") flush(); next }
    /^[-*+][ \t]+|^[0-9]+[.)][ \t]+/ {
      flush(); t = $0; sub(/^([-*+]|[0-9]+[.)])[ \t]+/, "", t)
      pend = t; kind = "bullet"; lead = t; haskids = 0; next
    }
    /^[ \t]+([-*+]|[0-9]+[.)])[ \t]+/ {
      t = $0; sub(/^[ \t]+([-*+]|[0-9]+[.)])[ \t]+/, "", t)
      if (!haskids) { sub(/:[ \t]*$/, "", lead); haskids = 1; pend = ""; kind = "" }
      flush(); print lead ": " t; next
    }
    { # continuation of the open item, or the start of a prose paragraph
      t = trim($0)
      if (pend != "") pend = pend " " t
      else { pend = t; kind = "prose" }
    }
    END { flush() }
  ' "$1"
}

cmd_extract() {
  local ticket="${1:-}"
  if [[ -z "$ticket" ]]; then echo "Done check: skipped (no ticket)"; return 0; fi
  if [[ ! -r "$ticket" ]]; then echo "Done check: flagged, ticket not readable: $ticket"; return 2; fi
  local lines; lines="$(extract_lines "$ticket")"
  if [[ -z "$lines" ]]; then echo "Done check: flagged, ticket has no done section"; return 2; fi
  printf '%s\n' "$lines" | awk '{ printf "%d\t%s\n", NR, $0 }'
}

cmd_verdict() {
  local table="${1:-}" ticket="${2:-}"
  [[ -n "$table" && -r "$table" ]] || usage
  local expected=0
  if [[ -n "$ticket" ]]; then
    expected="$(extract_lines "$ticket" | wc -l | tr -d ' ')"
  fi
  local rows=0 bad=0 id status check evidence eff
  echo "| # | Status | Check | Evidence |"; echo "|---|--------|-------|----------|"
  while IFS="$TAB" read -r id status check evidence || [[ -n "${id:-}" ]]; do
    [[ -z "${id:-}" ]] && continue
    rows=$((rows+1)); eff="$status"
    case "$status" in
      DONE) # DONE only with the check and its evidence on record
        if [[ -z "${check:-}" || -z "${evidence:-}" ]]; then eff="NOT DONE (no evidence)"; fi ;;
      "N/A") # N/A only with a reason
        if [[ -z "${evidence:-}" ]]; then eff="NOT DONE (N/A without reason)"; fi ;;
      "NOT DONE"|UNCHECKABLE) ;;
      *) eff="NOT DONE (unknown status '$status')" ;;
    esac
    case "$eff" in DONE|"N/A") ;; *) bad=$((bad+1)) ;; esac
    echo "| $id | $eff | ${check:-} | ${evidence:-} |"
  done < "$table"
  if (( expected > rows )); then
    bad=$((bad + expected - rows))
    echo "| - | NOT DONE (missing rows) | $((expected - rows)) of $expected done lines have no row | |"
  fi
  if (( rows == 0 && expected == 0 )); then bad=1; echo "| - | NOT DONE (empty table) | | |"; fi
  if (( bad > 0 )); then
    echo "Done check: $bad line(s) not met"; echo "Done verdict: NEEDS WORK"; return 1
  fi
  echo "Done check: all $rows line(s) met"; echo "Done verdict: SHIP IT"
}

case "${1:-}" in
  extract) shift; cmd_extract "$@" ;;
  verdict) shift; cmd_verdict "$@" ;;
  *) usage ;;
esac
