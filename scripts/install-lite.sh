#!/usr/bin/env bash
# Link the mithril-lite agents from skills/lite/ into a Claude agents dir, so the repo
# is the only copy and edits are live. Replaces plain-file copies with symlinks.
# Idempotent. Usage: bash scripts/install-lite.sh [--home DIR]   (default ~/.claude)
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Links must outlive this checkout: refuse from a linked git worktree, which is disposable.
# (MITHRIL_ALLOW_WORKTREE=1 overrides, for tests that install into a throwaway home.)
gd="$(cd "$root" && git rev-parse --git-dir 2>/dev/null || true)"
gc="$(cd "$root" && git rev-parse --git-common-dir 2>/dev/null || true)"
if [[ -z "${MITHRIL_ALLOW_WORKTREE:-}" && -n "$gd" && -n "$gc" ]] \
  && [[ "$(cd "$root" && cd "$gd" && pwd -P)" != "$(cd "$root" && cd "$gc" && pwd -P)" ]]; then
  echo "mithril: $root is a linked git worktree; links would dangle once it is removed." >&2
  echo "mithril: run scripts/install-lite.sh from the main checkout: $(cd "$root" && cd "$gc" && cd .. && pwd -P)" >&2
  exit 1
fi
home="${CLAUDE_HOME:-$HOME/.claude}"
while (( $# )); do
  case "$1" in
    --home) home="${2:?--home needs a directory}"; shift 2 ;;
    *) echo "mithril: unknown argument: $1 (usage: install-lite.sh [--home DIR])" >&2; exit 2 ;;
  esac
done

mkdir -p "$home/agents"
n=0
for f in "$root"/skills/lite/*.md; do
  ln -sfn "$f" "$home/agents/mithril-lite-$(basename "$f")"
  n=$((n + 1))
done
echo "mithril: linked $n lite agents into $home/agents from $root/skills/lite"
