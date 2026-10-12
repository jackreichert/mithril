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

# A git-free copy of the repo: install and healthcheck then agree on one root, so a fresh
# install is healthy even when $here is a linked worktree.
full="$tmp/full"; mkdir -p "$full"
(cd "$here" && tar --exclude=.git -cf - .) | tar -xf - -C "$full"
fhc() { CLAUDE_HOME="$1" GROK_HOME="$2" bash "$full/healthcheck.sh" "${@:3}"; }

# --- --strict never penalises a machine without Grok ---
sh_="$tmp/strict-nogrok"; mkdir -p "$sh_"
bash "$full/scripts/install-local.sh" --home "$sh_/.claude" >/dev/null 2>&1
fhc "$sh_/.claude" "$sh_/.grok" --strict >/dev/null 2>&1
check "--strict exits 0 on a correct install with no Grok home" "0" "$?"
check "a missing Grok home is not reported" "0" "$(fhc "$sh_/.claude" "$sh_/.grok" 2>&1 | grep -c 'nothing deployed to .*\.grok')"

# --- --strict: a healthy install passes; drift is a warning unless --strict is given ---
dh="$tmp/strict-drift"; mkdir -p "$dh/.grok"
bash "$full/scripts/install-local.sh" --home "$dh/.claude" >/dev/null 2>&1
bash "$full/scripts/install-local.sh" --home "$dh/.grok" >/dev/null 2>&1
fhc "$dh/.claude" "$dh/.grok" --strict >/dev/null 2>&1; check "--strict exits 0 before any drift" "0" "$?"
echo drift > "$dh/.claude/commands/mithril.md"
fhc "$dh/.claude" "$dh/.grok" >/dev/null 2>&1; check "drift alone exits 0 by default" "0" "$?"
fhc "$dh/.claude" "$dh/.grok" --strict >/dev/null 2>&1; check "--strict exits 1 on drift" "1" "$?"
# --- retired or renamed mithril-* links are flagged and pruned ---
sl="$tmp/stale"; mkdir -p "$sl/.grok"
bash "$full/scripts/install-local.sh" --home "$sl/.claude" >/dev/null 2>&1
bash "$full/scripts/install-local.sh" --home "$sl/.grok" >/dev/null 2>&1
check "install links smells and lint-fix into skills/" "yes" "$([[ "$(readlink "$sl/.claude/skills/mithril-smells")" == "$full/skills/smells.md" && -L "$sl/.claude/skills/mithril-lint-fix" ]] && echo yes || echo no)"
check "install links tutor into skills/" "yes" "$([[ -L "$sl/.claude/skills/mithril-tutor" ]] && echo yes || echo no)"
fhc "$sl/.claude" "$sl/.grok" --strict >/dev/null 2>&1; check "--strict exits 0 on a fresh install with skills links" "0" "$?"
old="$tmp/oldcheckout/skills"; mkdir -p "$old"; echo live > "$old/oldone.md"
# Retired in THIS checkout (target gone): ours. Tutor as an agent: ours, live, not current.
ln -s "$full/skills/retired.md" "$sl/.claude/agents/mithril-retired.md"
ln -s "$full/skills/retired.md" "$sl/.claude/skills/mithril-retired"
ln -s "$full/skills/tutor.md" "$sl/.claude/agents/mithril-tutor.md"
# Another checkout's links, live or dangling: not ours.
ln -s "$old/oldone.md" "$sl/.claude/agents/mithril-oldone.md"
ln -s "$tmp/gone/skills/gone.md" "$sl/.claude/agents/mithril-gone.md"
ln -s "$tmp/elsewhere.md" "$sl/.claude/agents/mithril-foreign.md"
echo plain > "$sl/.claude/agents/mithril-plain.md"
fhc "$sl/.claude" "$sl/.grok" --strict >/dev/null 2>&1; check "--strict exits 1 on stale and dangling mithril-* links" "1" "$?"
out="$(fhc "$sl/.claude" "$sl/.grok" 2>&1)"
check "healthcheck names the retired agent link" "yes" "$(grep -q 'mithril-retired.md is a dangling link' <<<"$out" && echo yes || echo no)"
check "healthcheck names the retired skills link" "yes" "$(grep -q 'mithril-retired is a dangling link' <<<"$out" && echo yes || echo no)"
check "healthcheck names the stale live link" "yes" "$(grep -q 'mithril-tutor.md is a stale link' <<<"$out" && echo yes || echo no)"
check "advice for a dangling link the installer does not own is remove-by-hand" "yes" "$(grep -q 'mithril-gone.md is a dangling link .*does not manage; remove it by hand' <<<"$out" && echo yes || echo no)"
check "advice for a dangling link the installer owns is re-run" "yes" "$(grep -q 'mithril-retired.md is a dangling link .*run scripts/install-local.sh' <<<"$out" && echo yes || echo no)"
check "healthcheck reports a live link into another checkout" "yes" "$(grep -q 'mithril-oldone.md points into another checkout' <<<"$out" && echo yes || echo no)"
iout="$(bash "$full/scripts/install-local.sh" --home "$sl/.claude" 2>&1)"
check "install removes retired agent link" "no" "$([[ -L "$sl/.claude/agents/mithril-retired.md" ]] && echo yes || echo no)"
check "install removes retired skills link" "no" "$([[ -L "$sl/.claude/skills/mithril-retired" ]] && echo yes || echo no)"
check "install removes the stale tutor agent link" "no" "$([[ -L "$sl/.claude/agents/mithril-tutor.md" ]] && echo yes || echo no)"
check "install leaves a live link into another checkout" "yes" "$([[ -L "$sl/.claude/agents/mithril-oldone.md" ]] && echo yes || echo no)"
check "install leaves a dangling link into another checkout" "yes" "$([[ -L "$sl/.claude/agents/mithril-gone.md" ]] && echo yes || echo no)"
check "install reports the link it left alone" "yes" "$(grep -q 'leaving .*mithril-oldone.md' <<<"$iout" && echo yes || echo no)"
rm "$sl/.claude/agents/mithril-oldone.md" "$sl/.claude/agents/mithril-gone.md"
check "install keeps a plain file" "yes" "$([[ -f "$sl/.claude/agents/mithril-plain.md" && ! -L "$sl/.claude/agents/mithril-plain.md" ]] && echo yes || echo no)"
check "install keeps current links" "yes" "$([[ -e "$sl/.claude/agents/mithril-review.md" && -e "$sl/.claude/skills/mithril-review" ]] && echo yes || echo no)"
# lite links: pruned only once the checkout ships skills/lite. Own copy, lite stripped, so
# this holds whether or not $full has lite agents (they land with the lite-agents branch).
nl="$tmp/nolite"; mkdir -p "$nl"
(cd "$full" && tar -cf - .) | tar -xf - -C "$nl"
rm -rf "${nl:?}/skills/lite"
ln -s "$nl/skills/lite/old.md" "$sl/.claude/agents/mithril-lite-old.md"
bash "$nl/scripts/install-local.sh" --home "$sl/.claude" >/dev/null 2>&1
check "lite link is left alone when the checkout has no lite agents" "yes" "$([[ -L "$sl/.claude/agents/mithril-lite-old.md" ]] && echo yes || echo no)"
mkdir -p "$nl/skills/lite"; cp "$nl/skills/review.md" "$nl/skills/lite/review.md"
bash "$nl/scripts/install-local.sh" --home "$sl/.claude" >/dev/null 2>&1
check "retired lite link is removed once the checkout has lite agents" "no" "$([[ -L "$sl/.claude/agents/mithril-lite-old.md" ]] && echo yes || echo no)"

# --- healthcheck rejects unknown arguments ---
fhc "$sl/.claude" "$sl/.grok" --stirct >/dev/null 2>&1; check "healthcheck rejects an unknown argument" "2" "$?"
check "healthcheck prints usage for it" "yes" "$(fhc "$sl/.claude" "$sl/.grok" --stirct 2>&1 | grep -q 'usage: healthcheck.sh' && echo yes || echo no)"
# --- a missing skills/ link in a managed home is drift ---
ml="$tmp/missing"; mkdir -p "$ml"
bash "$full/scripts/install-local.sh" --home "$ml/.claude" >/dev/null 2>&1
fhc "$ml/.claude" "$ml/.grok" --strict >/dev/null 2>&1; check "--strict exits 0 on a clean install before a link is removed" "0" "$?"
rm "$ml/.claude/skills/mithril-smells"
fhc "$ml/.claude" "$ml/.grok" --strict >/dev/null 2>&1; check "--strict exits 1 when a skills link is missing" "1" "$?"
check "healthcheck names the missing link" "yes" "$(fhc "$ml/.claude" "$ml/.grok" 2>&1 | grep -q 'mithril-smells link is missing' && echo yes || echo no)"
fhc "$tmp/noclaude/.claude" "$tmp/noclaude/.grok" --strict >/dev/null 2>&1
check "a machine with no Claude home gets no missing-link warnings" "0" "$(fhc "$tmp/noclaude/.claude" "$tmp/noclaude/.grok" 2>&1 | grep -c 'link is missing')"
# --- a missing agent link in a managed home is drift, in Claude and in Grok ---
ag="$tmp/agentlink"; mkdir -p "$ag/.grok"
bash "$full/scripts/install-local.sh" --home "$ag/.claude" >/dev/null 2>&1
bash "$full/scripts/install-local.sh" --home "$ag/.grok" >/dev/null 2>&1
fhc "$ag/.claude" "$ag/.grok" --strict >/dev/null 2>&1; check "--strict exits 0 on a clean Claude+Grok install" "0" "$?"
rm "$ag/.claude/agents/mithril-smells.md"
fhc "$ag/.claude" "$ag/.grok" --strict >/dev/null 2>&1; check "--strict exits 1 when a Claude agent link is missing" "1" "$?"
check "healthcheck names the missing Claude agent link" "yes" "$(fhc "$ag/.claude" "$ag/.grok" 2>&1 | grep -q 'Claude: mithril-smells.md link is missing' && echo yes || echo no)"
bash "$full/scripts/install-local.sh" --home "$ag/.claude" >/dev/null 2>&1
fhc "$ag/.claude" "$ag/.grok" --strict >/dev/null 2>&1; check "re-install restores --strict 0" "0" "$?"
rm "$ag/.grok/agents/mithril-smells.md"
fhc "$ag/.claude" "$ag/.grok" --strict >/dev/null 2>&1; check "--strict exits 1 when a Grok agent link is missing" "1" "$?"
check "healthcheck names the missing Grok agent link" "yes" "$(fhc "$ag/.claude" "$ag/.grok" 2>&1 | grep -q 'Grok: mithril-smells.md link is missing' && echo yes || echo no)"
exit $((fails > 0))
