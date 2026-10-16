#!/usr/bin/env bash
# Session-start update check: is this mithril checkout behind its origin?
# Prints one line when it is not current; prints nothing when current,
# when this is not a git checkout (plugin cache), or when the fetch fails.
# Config key auto_pull (default off): env MITHRIL_AUTO_PULL, else the line
# `auto_pull=on` in ${XDG_CONFIG_HOME:-~/.config}/mithril/config.
# When on, a clean checkout that is purely behind is fast-forwarded with
# `merge --ff-only`; anything else is only reported. Never rebases or resets.
set -u

repo="${MITHRIL_REPO:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
# Only act when $repo is itself a checkout root, never a copy nested in another repo.
top="$(git -C "$repo" rev-parse --show-toplevel 2>/dev/null)" || exit 0
[ "$(cd "$top" && pwd -P)" = "$(cd "$repo" && pwd -P)" ] || exit 0

auto_pull_enabled() {
  local v="${MITHRIL_AUTO_PULL:-}"
  if [ -z "$v" ]; then
    local cfg="${XDG_CONFIG_HOME:-$HOME/.config}/mithril/config"
    [ -r "$cfg" ] && v="$(sed -n 's/^auto_pull=//p' "$cfg" | tail -1)"
  fi
  case "$v" in on | true | 1 | yes) return 0 ;; *) return 1 ;; esac
}

upstream="$(git -C "$repo" rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null)" || exit 0
branch="$(git -C "$repo" rev-parse --abbrev-ref HEAD)"
remote="$(git -C "$repo" config "branch.$branch.remote")" || exit 0

# Bound the fetch: a hard timeout when available, plus transport-level limits.
fetch=(git -C "$repo" -c http.lowSpeedLimit=1 -c http.lowSpeedTime=20 fetch --quiet "$remote")
for t in timeout gtimeout; do
  if command -v "$t" >/dev/null 2>&1; then fetch=("$t" 20 "${fetch[@]}"); break; fi
done
GIT_TERMINAL_PROMPT=0 GIT_SSH_COMMAND="ssh -o BatchMode=yes -o ConnectTimeout=10" "${fetch[@]}" >/dev/null 2>&1 || exit 0

counts="$(git -C "$repo" rev-list --left-right --count "HEAD...$upstream" 2>/dev/null)" || exit 0
read -r ahead behind <<<"$counts"
dirty="$(git -C "$repo" status --porcelain --untracked-files=no | wc -l | tr -d ' ')"

[ "$ahead" -eq 0 ] && [ "$behind" -eq 0 ] && [ "$dirty" -eq 0 ] && exit 0

if [ "$behind" -gt 0 ] && [ "$ahead" -eq 0 ] && [ "$dirty" -eq 0 ] && auto_pull_enabled; then
  if git -C "$repo" merge --ff-only --quiet "$upstream" >/dev/null 2>&1; then
    echo "mithril: fast-forwarded $behind commit(s) from $upstream"
  else
    echo "mithril: $behind behind $upstream; fast-forward failed, update by hand"
  fi
  exit 0
fi

state=()
[ "$ahead" -gt 0 ] && [ "$behind" -gt 0 ] && state+=("diverged: $ahead ahead, $behind behind $upstream")
[ "$ahead" -gt 0 ] && [ "$behind" -eq 0 ] && state+=("$ahead ahead of $upstream")
[ "$ahead" -eq 0 ] && [ "$behind" -gt 0 ] && state+=("$behind behind $upstream")
[ "$dirty" -gt 0 ] && state+=("dirty ($dirty file(s))")
hint=""
[ "$behind" -gt 0 ] && ! auto_pull_enabled && hint="; auto_pull is off"
line="${state[0]}"
for part in "${state[@]:1}"; do line="$line, $part"; done
echo "mithril: $line$hint"
