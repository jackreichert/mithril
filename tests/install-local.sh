#!/usr/bin/env bash
# Tests for scripts/install-local.sh against a throwaway home.
set -u
here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(cd "$(mktemp -d)" && pwd -P)"; trap 'rm -rf "$tmp"' EXIT
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

hc() { CLAUDE_HOME="$1" GROK_HOME="$tmp/none" bash "$2/healthcheck.sh" 2>&1; }

# --- Grok home: installed by default when it exists, never created ---
fh="$tmp/fh"; mkdir -p "$fh/.grok"
env -u CLAUDE_HOME -u GROK_HOME HOME="$fh" bash "$here/scripts/install-local.sh" >/dev/null 2>&1
check "default install also links agents into an existing Grok home" "$here/skills/review.md" "$(readlink "$fh/.grok/agents/mithril-review.md")"
check "default install also renders the Grok command" "yes" "$([[ -s "$fh/.grok/commands/mithril.md" ]] && echo yes || echo no)"
nh="$tmp/nh"; mkdir -p "$nh"
env -u CLAUDE_HOME -u GROK_HOME HOME="$nh" bash "$here/scripts/install-local.sh" >/dev/null 2>&1
check "a missing Grok home is not created" "no" "$([[ -e "$nh/.grok" ]] && echo yes || echo no)"
oh="$tmp/oh"; mkdir -p "$oh/.grok"
env -u CLAUDE_HOME -u GROK_HOME HOME="$oh" bash "$here/scripts/install-local.sh" --home "$tmp/only" >/dev/null 2>&1
check "explicit --home installs only there" "no" "$([[ -e "$oh/.grok/agents" ]] && echo yes || echo no)"

# --- paths with sed metacharacters ---
odd="$tmp/we|ir&d\\x/repo"; mkdir -p "$odd"
cp -R "$here/scripts" "$here/skills" "$here/claude" "$here/healthcheck.sh" "$odd/"
bash "$odd/scripts/install-local.sh" --home "$tmp/ho" >/dev/null 2>&1; rc=$?
check "install from a path with | & and backslash succeeds" "0" "$rc"
check "command carries that path literally" "yes" "$(grep -qF "$odd/skills/tutor.md" "$tmp/ho/commands/mithril.md" && echo yes || echo no)"
check "command has no unresolved plugin root" "0" "$(grep -c 'CLAUDE_PLUGIN_ROOT}/' "$tmp/ho/commands/mithril.md" | tr -d ' ')"
hc "$tmp/ho" "$odd" | grep -q DRIFTED && d=drift || d=clean
check "healthcheck agrees on that path" "clean" "$d"

echo keep > "$tmp/ho/commands/mithril.md"
env -u CLAUDE_HOME -u GROK_HOME HOME="$tmp/hh" bash "$odd/scripts/install-local.sh" --hoem "$tmp/typo" >/dev/null 2>&1; rc=$?
check "an unknown argument is rejected" "2" "$rc"

# --- linked worktree: links must never point into a disposable worktree ---
main="$tmp/main"; mkdir -p "$main"
cp -R "$here/scripts" "$here/skills" "$here/claude" "$here/healthcheck.sh" "$main/"
git_t() { git -c core.hooksPath=/dev/null -c user.name=t -c user.email=t@example.com -C "$main" "$@"; }
git_t init -q . && git_t add -A && git_t commit -q -m init && git_t worktree add -q "$tmp/wt" -b wt >/dev/null 2>&1
env -u MITHRIL_ALLOW_WORKTREE bash "$tmp/wt/scripts/install-local.sh" --home "$tmp/hw" >/dev/null 2>&1; rc=$?
check "install from a linked worktree is refused" "1" "$rc"
check "refused install wrote nothing" "no" "$([[ -e "$tmp/hw" ]] && echo yes || echo no)"
env -u MITHRIL_ALLOW_WORKTREE bash "$main/scripts/install-local.sh" --home "$tmp/hm" >/dev/null 2>&1
hc "$tmp/hm" "$main" | grep -q DRIFTED && d=drift || d=clean
check "healthcheck sees the installed copy as in sync" "clean" "$d"
hc "$tmp/hm" "$tmp/wt" | grep -q DRIFTED && d=drift || d=clean
check "healthcheck from a worktree compares against the main checkout" "clean" "$d"
git_t worktree remove --force "$tmp/wt"
mkdir -p "$tmp/hd/agents"; ln -s "$tmp/gone.md" "$tmp/hd/agents/mithril-review.md"
hc "$tmp/hd" "$main" | grep -q 'dangling' && d=found || d=missed
check "healthcheck reports a dangling link" "found" "$d"
dangling=0; for l in "$tmp"/hm/agents/*; do [[ -e "$l" ]] || dangling=$((dangling+1)); done
check "install from the main checkout survives worktree removal" "0" "$dangling"

# --- --strict: with the repo healthy, drift is only a warning unless --strict is given ---
echo drift > "$tmp/hm/commands/mithril.md"
CLAUDE_HOME="$tmp/hm" GROK_HOME="$tmp/none" bash "$here/healthcheck.sh" >/dev/null 2>&1; check "drift alone exits 0 by default" "0" "$?"
CLAUDE_HOME="$tmp/hm" GROK_HOME="$tmp/none" bash "$here/healthcheck.sh" --strict >/dev/null 2>&1; check "--strict exits 1 on drift" "1" "$?"
exit $((fails > 0))
