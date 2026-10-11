#!/usr/bin/env bash
# Install this checkout into a local tool home (default ~/.claude) without the plugin.
# Agents are symlinked to skills/*.md, so edits are live. The /mithril command cannot
# be a symlink: it references ${CLAUDE_PLUGIN_ROOT}, which only the plugin sets, so it
# is rendered with this checkout's absolute path. Re-run after editing the command.
# Idempotent. Usage: bash scripts/install-local.sh [--home DIR]
# Default: ~/.claude, plus ~/.grok when it exists. --home DIR installs only into DIR.
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Links must outlive this checkout: refuse from a linked git worktree, which is disposable.
# (MITHRIL_ALLOW_WORKTREE=1 overrides, for tests that install into a throwaway home.)
gd="$(cd "$root" && git rev-parse --git-dir 2>/dev/null || true)"
gc="$(cd "$root" && git rev-parse --git-common-dir 2>/dev/null || true)"
if [[ -z "${MITHRIL_ALLOW_WORKTREE:-}" && -n "$gd" && -n "$gc" ]] \
  && [[ "$(cd "$root" && cd "$gd" && pwd -P)" != "$(cd "$root" && cd "$gc" && pwd -P)" ]]; then
  echo "mithril: $root is a linked git worktree; links would dangle once it is removed." >&2
  echo "mithril: run scripts/install-local.sh from the main checkout: $(cd "$root" && cd "$gc" && cd .. && pwd -P)" >&2
  exit 1
fi
# Default: Claude home, plus the Grok home when it already exists. --home DIR: only DIR.
homes=("${CLAUDE_HOME:-$HOME/.claude}")
[[ -d "${GROK_HOME:-$HOME/.grok}" ]] && homes+=("${GROK_HOME:-$HOME/.grok}")
[[ "${1:-}" == "--home" ]] && homes=("${2:?--home needs a directory}")

for home in "${homes[@]}"; do
  mkdir -p "$home/agents" "$home/commands"
  for f in "$root"/skills/*.md; do
    base="$(basename "$f")"
    [[ "$base" == "tutor.md" ]] && continue
    ln -sfn "$f" "$home/agents/mithril-$base"
  done
  sed "s|\${CLAUDE_PLUGIN_ROOT}|$root|g" "$root/claude/commands/mithril.md" > "$home/commands/mithril.md"
  echo "mithril: linked agents and rendered command into $home from $root"
done
