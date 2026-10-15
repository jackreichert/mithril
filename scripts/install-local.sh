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
gd="$(git -C "$root" rev-parse --git-dir 2>/dev/null || true)"
gc="$(git -C "$root" rev-parse --git-common-dir 2>/dev/null || true)"
if [[ -z "${MITHRIL_ALLOW_WORKTREE:-}" && -n "$gd" && -n "$gc" ]] \
  && [[ "$(cd "$root" && cd "$gd" && pwd -P)" != "$(cd "$root" && cd "$gc" && pwd -P)" ]]; then
  echo "mithril: $root is a linked git worktree; links would dangle once it is removed." >&2
  echo "mithril: run scripts/install-local.sh from the main checkout: $(cd "$root" && cd "$gc" && cd .. && pwd -P)" >&2
  exit 1
fi
# Default: Claude home, plus the Grok home when it already exists. --home DIR: only DIR.
homes=("${CLAUDE_HOME:-$HOME/.claude}")
[[ -d "${GROK_HOME:-$HOME/.grok}" ]] && homes+=("${GROK_HOME:-$HOME/.grok}")
while (( $# )); do
  case "$1" in
    --home) homes=("${2:?--home needs a directory}"); shift 2 ;;
    *) echo "mithril: unknown argument: $1 (usage: install-local.sh [--home DIR])" >&2; exit 2 ;;
  esac
done

# Escape \ & | so the path is a literal sed replacement; render to a temp file so a failure
# never truncates an existing command.
esc_root="$(printf '%s' "$root" | sed 's/[\\&|]/\\&/g')"

# A link is ours when it points into THIS checkout (skills/X.md or skills/lite/X.md) and is
# named for X (mithril-X[.md] / mithril-lite-X[.md]). A link into another checkout is not ours.
root_phys="$(cd "$root" && pwd -P)"
layout_link() {
  local l="$1" t x stem
  [[ -L "$l" ]] || return 1
  t="$(readlink "$l")"; x="$(basename "$t" .md)"; stem="$(basename "$l" .md)"
  case "$t" in
    */skills/lite/*.md) [[ "$stem" == "mithril-lite-$x" ]] ;;
    */skills/*.md) [[ "$stem" == "mithril-$x" ]] ;;
    *) return 1 ;;
  esac
}
owned_link() {
  local t
  layout_link "$1" || return 1
  t="$(readlink "$1")"
  case "$t" in
    "$root"/skills/*.md|"$root_phys"/skills/*.md) return 0 ;;
    *) return 1 ;;
  esac
}
# Is this link name current in this checkout? $2 is "agent" or "skill".
current_name() {
  local stem="$1" kind="$2" n
  if [[ "$stem" == mithril-lite-* ]]; then
    [[ "$kind" == agent && -f "$root/skills/lite/${stem#mithril-lite-}.md" ]]
  else
    n="${stem#mithril-}"
    [[ -f "$root/skills/$n.md" ]] && { [[ "$kind" == skill ]] || [[ "$n" != tutor ]]; }
  fi
}
# Remove owned links whose name is no longer current. Lite links are left alone until this
# checkout ships skills/lite, since a link into a newer checkout is not stale.
prune_stale() {
  local dir="$1" kind="$2" l stem
  for l in "$dir"/mithril-*; do
    [[ -L "$l" ]] || continue
    stem="$(basename "$l" .md)"
    [[ "$stem" == mithril-lite-* && ( "$kind" == skill || ! -d "$root/skills/lite" ) ]] && continue
    current_name "$stem" "$kind" && continue
    if owned_link "$l"; then rm -f "$l"; echo "mithril: removed stale link $l"
    elif layout_link "$l"; then echo "mithril: leaving $l, it points outside this checkout ($(readlink "$l")); remove it by hand if it is retired" >&2
    fi
  done
}

first_home="${homes[0]}"
for home in "${homes[@]}"; do
  mkdir -p "$home/agents" "$home/commands"
  prune_stale "$home/agents" agent
  # ~/.claude/skills/mithril-* (every skill, tutor included) belongs to the first home only.
  if [[ "$home" == "$first_home" ]]; then
    mkdir -p "$home/skills"
    prune_stale "$home/skills" skill
    for f in "$root"/skills/*.md; do
      ln -sfn "$f" "$home/skills/mithril-$(basename "$f" .md)"
    done
  fi
  for f in "$root"/skills/*.md; do
    base="$(basename "$f")"
    [[ "$base" == "tutor.md" ]] && continue
    ln -sfn "$f" "$home/agents/mithril-$base"
  done
  tmpcmd="$(mktemp "$home/commands/.mithril.XXXXXX")"
  sed "s|\${CLAUDE_PLUGIN_ROOT}|$esc_root|g" "$root/claude/commands/mithril.md" > "$tmpcmd"
  chmod 644 "$tmpcmd"
  mv -f "$tmpcmd" "$home/commands/mithril.md"
  echo "mithril: linked agents and rendered command into $home from $root"
done
