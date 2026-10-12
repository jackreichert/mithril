#!/usr/bin/env bash
# Deterministic half of the mithril done check. The reviewer does the model-judged
# half (write a check per line, run it, record evidence); this script owns the parts
# that must not vary: pulling the "What done looks like" lines out of a ticket, the
# skipped/flagged wording, and the verdict rule over the reviewer's per-line table.
#
#   done-check.sh extract [ticket]   print one "N<TAB>line" per done line
#   done-check.sh verdict <table> <ticket>
#       table rows: N<TAB>STATUS<TAB>check<TAB>evidence   (STATUS: DONE|NOT DONE|N/A|UNCHECKABLE)
#       ids must be exactly 1..N for the ticket's N lines; a flagged ticket exits 1
#
# Exit: 0 done lines printed / verdict SHIP IT / skipped, 1 verdict NEEDS WORK,
#       2 flagged (no done section, ticket unreadable) or usage error.
set -euo pipefail

US="$(printf '\037')" # tab is whitespace to read, which would collapse empty fields

usage() { echo "usage: done-check.sh extract [ticket] | verdict <table> <ticket>" >&2; exit 2; }

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

trim() { local t="$1"; t="${t#"${t%%[![:space:]]*}"}"; printf '%s' "${t%"${t##*[![:space:]]}"}"; }

# One row per done line, matched by id: ids must be exactly 1..N for the N lines extract finds.
# The ticket is required, and a ticket that yields no lines is flagged and fails: the model's
# table can never be the source of how many lines there are.
cmd_verdict() {
  local table="${1:-}" ticket="${2:-}"
  [[ -n "$table" && -r "$table" && -n "$ticket" ]] || usage
  local ext rc=0
  ext="$(cmd_extract "$ticket")" || rc=$?
  if (( rc != 0 )); then echo "$ext"; echo "Done verdict: NEEDS WORK"; return 1; fi
  local expected; expected="$(printf '%s\n' "$ext" | wc -l | tr -d ' ')"
  local seen=" " bad=0 rows=0 id status check evidence eff
  echo "| # | Status | Check | Evidence |"; echo "|---|--------|-------|----------|"
  while IFS="$US" read -r id status check evidence || [[ -n "${id:-}" ]]; do
    id="$(trim "${id:-}")"; status="$(trim "${status:-}")"; check="$(trim "${check:-}")"; evidence="$(trim "${evidence:-}")"
    [[ -z "$id$status$check$evidence" ]] && continue
    rows=$((rows+1)); eff="$status"
    if [[ ! "$id" =~ ^[0-9]+$ ]] || (( 10#$id < 1 || 10#$id > expected )); then
      eff="NOT DONE (unknown id)"
    elif [[ "$seen" == *" $((10#$id)) "* ]]; then
      eff="NOT DONE (duplicate id)"
    else
      seen="$seen$((10#$id)) "
      case "$status" in
        DONE) [[ -z "$check" || -z "$evidence" ]] && eff="NOT DONE (no evidence)" ;;
        "N/A") [[ -z "$evidence" ]] && eff="NOT DONE (N/A without reason)" ;;
        "NOT DONE"|UNCHECKABLE) ;;
        *) eff="NOT DONE (unknown status '$status')" ;;
      esac
    fi
    case "$eff" in DONE|"N/A") ;; *) bad=$((bad+1)) ;; esac
    echo "| $id | $eff | $check | $evidence |"
  done < <(tr '\t' '\037' < "$table")
  local n
  for ((n = 1; n <= expected; n++)); do
    [[ "$seen" == *" $n "* ]] || { bad=$((bad+1)); echo "| $n | NOT DONE (missing row) | | |"; }
  done
  if (( bad > 0 )); then
    echo "Done check: $bad problem(s) across $expected line(s)"; echo "Done verdict: NEEDS WORK"; return 1
  fi
  echo "Done check: all $expected line(s) met"; echo "Done verdict: SHIP IT"
}

case "${1:-}" in
  extract) shift; cmd_extract "$@" ;;
  verdict) shift; cmd_verdict "$@" ;;
  *) usage ;;
esac
