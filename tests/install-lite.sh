#!/usr/bin/env bash
# Tests for scripts/install-lite.sh against a throwaway home.
set -u
here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
fails=0
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
exit $((fails > 0))
