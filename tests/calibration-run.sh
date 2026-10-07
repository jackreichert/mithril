#!/usr/bin/env bash
# Tests for calibration/run.sh: the printed review command follows the case's mode.
set -u
here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script="$here/calibration/run.sh"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
export TMPDIR="$tmp"
fails=0

check() { # name expected-substring actual
  if [[ "$3" == *"$2"* ]]; then echo "ok   $1"; else echo "FAIL $1: want '$2' got '$3'"; fails=$((fails+1)); fi
}
check_absent() { # name unexpected-substring actual
  if [[ "$3" != *"$2"* ]]; then echo "ok   $1"; else echo "FAIL $1: did not want '$2'"; fails=$((fails+1)); fi
}

out="$(bash "$script" exec-only-pagination 2>&1)"
check "execute case runs review execute" "/mithril review execute" "$out"
check "execute case passes its contract" "rounds up" "$out"
staged="$(git -C "$(echo "$tmp"/mithril-cal-exec-only-pagination.*)" diff --cached --name-only)"
check_absent "contract is not part of the staged diff" "contract.md" "$staged"

out="$(bash "$script" idor-orders 2>&1)"
check "default case runs plain /mithril" "'/mithril'" "$out"
check_absent "default case is not execute mode" "review execute" "$out"

# A contract with an apostrophe must still print a command the shell can parse.
mkdir -p "$tmp/cal/cases/quoted/base" "$tmp/cal/cases/quoted/changed"
cp "$script" "$tmp/cal/run.sh"
printf 'mode: execute\n' > "$tmp/cal/cases/quoted/expected.yaml"
printf "The author's rule holds.\n" > "$tmp/cal/cases/quoted/contract.md"
echo x > "$tmp/cal/cases/quoted/base/f"; echo y > "$tmp/cal/cases/quoted/changed/f"
line="$(bash "$tmp/cal/run.sh" quoted 2>&1 | grep 'claude -p')"
check "apostrophe in contract survives quoting" "The author's rule holds." "$(eval "printf '%s' ${line#*claude -p }")"

[ "$fails" -eq 0 ] || { echo "$fails failure(s)"; exit 1; }
