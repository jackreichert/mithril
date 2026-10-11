#!/usr/bin/env bash
# Tests for scripts/install-local.sh against a throwaway home.
set -u
here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
fails=0
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
exit $((fails > 0))
