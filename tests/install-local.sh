#!/usr/bin/env bash
# Tests for scripts/install-local.sh against a throwaway home.
set -u
here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
fails=0
# The checkout under test may itself be a linked worktree; the guard is exercised separately below.
export MITHRIL_ALLOW_WORKTREE=1
check() { if [[ "$2" == "$3" ]]; then echo "ok   $1"; else echo "FAIL $1: want '$2' got '$3'"; fails=$((fails+1)); fi; }

bash "$here/scripts/install-local.sh" --home "$tmp/h" >/dev/null
check "agent is a symlink into the checkout" "$here/skills/review.md" "$(readlink "$tmp/h/agents/mithril-review.md")"
check "tutor is not installed as an agent" "no" "$([[ -e "$tmp/h/agents/mithril-tutor.md" ]] && echo yes || echo no)"
check "command has no unresolved plugin root" "0" "$(grep -c 'CLAUDE_PLUGIN_ROOT}/' "$tmp/h/commands/mithril.md" | tr -d ' ')"
check "command carries the checkout path" "yes" "$(grep -q "$here/skills/tutor.md" "$tmp/h/commands/mithril.md" && echo yes || echo no)"
before="$(md5 -q "$tmp/h/commands/mithril.md" 2>/dev/null || md5sum "$tmp/h/commands/mithril.md" | cut -d' ' -f1)"
bash "$here/scripts/install-local.sh" --home "$tmp/h" >/dev/null
after="$(md5 -q "$tmp/h/commands/mithril.md" 2>/dev/null || md5sum "$tmp/h/commands/mithril.md" | cut -d' ' -f1)"
check "second run changes nothing" "$before" "$after"
CLAUDE_HOME="$tmp/h" GROK_HOME="$tmp/none" bash "$here/healthcheck.sh" 2>&1 | grep -q DRIFTED && d=drift || d=clean
check "healthcheck sees the installed copy as in sync" "clean" "$d"

# --- linked worktree: links must never point into a disposable worktree ---
main="$tmp/main"; mkdir -p "$main"
cp -R "$here/scripts" "$here/skills" "$here/claude" "$here/healthcheck.sh" "$main/"
git_t() { git -c core.hooksPath=/dev/null -c user.name=t -c user.email=t@example.com -C "$main" "$@"; }
git_t init -q . && git_t add -A && git_t commit -q -m init && git_t worktree add -q "$tmp/wt" -b wt >/dev/null 2>&1
env -u MITHRIL_ALLOW_WORKTREE bash "$tmp/wt/scripts/install-local.sh" --home "$tmp/hw" >/dev/null 2>&1; rc=$?
check "install from a linked worktree is refused" "1" "$rc"
check "refused install wrote nothing" "no" "$([[ -e "$tmp/hw" ]] && echo yes || echo no)"
env -u MITHRIL_ALLOW_WORKTREE bash "$main/scripts/install-local.sh" --home "$tmp/hm" >/dev/null 2>&1
git_t worktree remove --force "$tmp/wt"
dangling=0; for l in "$tmp"/hm/agents/*; do [[ -e "$l" ]] || dangling=$((dangling+1)); done
check "install from the main checkout survives worktree removal" "0" "$dangling"
exit $((fails > 0))
