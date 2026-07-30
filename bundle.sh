#!/usr/bin/env bash
#
# Legacy entry point: verify plugin manifests list every canonical runtime skill.
# Prompt content lives only in skills/*.md; there is no generated agent bundle.
#
# Usage:
#   bash bundle.sh [--check]
#   bash bundle.sh --help
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "${1:-}" in
  ""|--check) ;;
  --help|-h) sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'; exit 0;;
  *) echo "Unknown option: $1" >&2; exit 1;;
esac

expected="$(mktemp "${TMPDIR:-/tmp}/code-quality-bundle.XXXXXX")"
actual="$(mktemp "${TMPDIR:-/tmp}/code-quality-bundle.XXXXXX")"
trap 'rm -f "$expected" "$actual"' EXIT

find "$SCRIPT_DIR/skills" -maxdepth 1 -name '*.md' ! -name 'tutor.md' \
  -exec basename {} \; | sort > "$expected"

for manifest in .claude-plugin/plugin.json .grok-plugin/plugin.json; do
  grep -oE '"\./skills/[A-Za-z0-9._-]+\.md"' "$SCRIPT_DIR/$manifest" \
    | sed -E 's|"\./skills/||; s|"$||' | sort > "$actual"
  if ! cmp -s "$expected" "$actual"; then
    echo "plugin agent drift: $manifest does not match canonical runtime skills" >&2
    diff -u "$expected" "$actual" >&2 || true
    exit 1
  fi
done

count="$(wc -l < "$expected" | tr -d ' ')"
printf 'plugin manifests: %s canonical runtime skills verified\n' "$count"
