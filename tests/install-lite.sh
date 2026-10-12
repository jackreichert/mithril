#!/usr/bin/env bash
# Tests for scripts/install-lite.sh against a throwaway home.
set -u
here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(cd "$(mktemp -d)" && pwd -P)"; trap 'rm -rf "$tmp"' EXIT
fails=0
# The checkout under test may itself be a linked worktree; the guard is exercised separately below.
export MITHRIL_ALLOW_WORKTREE=1
check() { if [[ "$2" == "$3" ]]; then echo "ok   $1"; else echo "FAIL $1: want '$2' got '$3'"; fails=$((fails+1)); fi; }

mkdir -p "$tmp/h/agents"; echo stale > "$tmp/h/agents/mithril-lite-review.md"
bash "$here/scripts/install-lite.sh" --home "$tmp/h" >/dev/null
check "lite review is a symlink into the repo" "$here/skills/lite/review.md" "$(readlink "$tmp/h/agents/mithril-lite-review.md")"
check "a stale plain copy was replaced" "no" "$(grep -q stale "$tmp/h/agents/mithril-lite-review.md" && echo yes || echo no)"
check "every lite agent linked" "$(find "$here/skills/lite" -name '*.md' | wc -l | tr -d ' ')" "$(find "$tmp/h/agents" -name 'mithril-lite-*.md' | wc -l | tr -d ' ')"
bash "$here/scripts/install-lite.sh" --home "$tmp/h" >/dev/null
check "second run keeps the link" "$here/skills/lite/review.md" "$(readlink "$tmp/h/agents/mithril-lite-review.md")"
CLAUDE_HOME="$tmp/h" GROK_HOME="$tmp/none" bash "$here/healthcheck.sh" 2>&1 | grep -q 'lite.*DRIFTED' && d=drift || d=clean
check "healthcheck sees the links as in sync" "clean" "$d"

env -u CLAUDE_HOME HOME="$tmp/hh" bash "$here/scripts/install-lite.sh" --hoem "$tmp/typo" >/dev/null 2>&1; rc=$?
check "an unknown argument is rejected" "2" "$rc"
check "the rejected run wrote nothing" "no" "$([[ -e "$tmp/hh" ]] && echo yes || echo no)"

# --- linked worktree: links must never point into a disposable worktree ---
main="$tmp/main"; mkdir -p "$main"
cp -R "$here/scripts" "$here/skills" "$main/"
git_t() { git -c core.hooksPath=/dev/null -c user.name=t -c user.email=t@example.com -C "$main" "$@"; }
git_t init -q . && git_t add -A && git_t commit -q -m init && git_t worktree add -q "$tmp/wt" -b wt >/dev/null 2>&1
env -u MITHRIL_ALLOW_WORKTREE bash "$tmp/wt/scripts/install-lite.sh" --home "$tmp/hw" >/dev/null 2>&1; rc=$?
check "install from a linked worktree is refused" "1" "$rc"
check "refused install wrote nothing" "no" "$([[ -e "$tmp/hw" ]] && echo yes || echo no)"
env -u MITHRIL_ALLOW_WORKTREE bash "$main/scripts/install-lite.sh" --home "$tmp/hm" >/dev/null 2>&1
git_t worktree remove --force "$tmp/wt"
mkdir -p "$tmp/hd/agents"; ln -s "$tmp/gone.md" "$tmp/hd/agents/mithril-lite-review.md"
CLAUDE_HOME="$tmp/hd" GROK_HOME="$tmp/none" bash "$here/healthcheck.sh" 2>&1 | grep -q 'lite-review.*dangling' && d=found || d=missed
check "healthcheck reports a dangling lite link" "found" "$d"
dangling=0; for l in "$tmp"/hm/agents/*; do [[ -e "$l" ]] || dangling=$((dangling+1)); done
check "install from the main checkout survives worktree removal" "0" "$dangling"
exit $((fails > 0))
