#!/usr/bin/env bash
# Link the mithril-lite agents from skills/lite/ into a Claude agents dir, so the repo
# is the only copy and edits are live. Replaces plain-file copies with symlinks.
# Idempotent. Usage: bash scripts/install-lite.sh [--home DIR]   (default ~/.claude)
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
home="${CLAUDE_HOME:-$HOME/.claude}"
[[ "${1:-}" == "--home" ]] && home="${2:?--home needs a directory}"

mkdir -p "$home/agents"
n=0
for f in "$root"/skills/lite/*.md; do
  ln -sfn "$f" "$home/agents/mithril-lite-$(basename "$f")"
  n=$((n + 1))
done
echo "mithril: linked $n lite agents into $home/agents from $root/skills/lite"
