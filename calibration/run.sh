#!/usr/bin/env bash
#
# calibration/run.sh <case-name> [--keep]
#
# Stages a golden case as a real git diff in a throwaway repo, so /mithril
# sees exactly what it would see on real work. Prints (or runs) the review.
#
#   bash calibration/run.sh idor-orders
#   bash calibration/run.sh idor-orders --keep    # keep the temp repo for inspection
#
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CASE="${1:?usage: run.sh <case-name> [--keep]}"
KEEP="${2:-}"
CASE_DIR="$SCRIPT_DIR/cases/$CASE"
[[ -d "$CASE_DIR/base" && -d "$CASE_DIR/changed" ]] || { echo "no such case: $CASE" >&2; exit 1; }

work="$(mktemp -d "${TMPDIR:-/tmp}/mithril-cal-$CASE.XXXXXX")"
echo "▸ staging case '$CASE' in $work"

cp -R "$CASE_DIR/base/." "$work/"
git -C "$work" init -q
# Throwaway repo: never inherit the user's signing / hook config.
git -C "$work" config commit.gpgsign false
git -C "$work" config core.hooksPath /dev/null
git -C "$work" add -A
git -C "$work" -c user.email=cal@local -c user.name=calibration commit -qm "base"
cp -R "$CASE_DIR/changed/." "$work/"
git -C "$work" add -A   # staged diff = the change under review

echo "▸ staged diff:"
git -C "$work" --no-pager diff --cached --stat
echo
echo "▸ expected findings: $CASE_DIR/expected.yaml"
echo
if command -v claude >/dev/null 2>&1; then
  echo "▸ run the review with:"
  echo "    cd $work && claude -p '/mithril'"
  echo "  then score against expected.yaml (see calibration/README.md protocol)."
else
  echo "▸ claude CLI not found — cd $work and run /mithril from a Claude Code session."
fi
[[ "$KEEP" == "--keep" ]] || echo "▸ (temp repo left in place; rm -rf $work when done)"
