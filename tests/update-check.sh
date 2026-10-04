#!/usr/bin/env bash
# Tests for scripts/update-check.sh against throwaway repos in a temp dir.
set -u
here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script="$here/scripts/update-check.sh"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@example.com GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@example.com
export HOME="$tmp/home" XDG_CONFIG_HOME="$tmp/home/.config"; mkdir -p "$HOME"
unset MITHRIL_AUTO_PULL
fails=0

setup() { # fresh origin + clone; origin gets $1 extra commits after the clone
  rm -rf "$tmp/origin" "$tmp/work" "$tmp/pusher"
  git init -q --bare -b main "$tmp/origin"
  git clone -q "$tmp/origin" "$tmp/work" 2>/dev/null
  git -C "$tmp/work" commit -q --allow-empty -m base
  git -C "$tmp/work" push -q origin main 2>/dev/null
  git -C "$tmp/work" branch -q --set-upstream-to=origin/main main
  git clone -q "$tmp/origin" "$tmp/pusher" 2>/dev/null
  for ((i = 0; i < $1; i++)); do git -C "$tmp/pusher" commit -q --allow-empty -m up; done
  git -C "$tmp/pusher" push -q origin main 2>/dev/null
}
run() { MITHRIL_REPO="$tmp/work" bash "$script"; }
check() { # name expected-substring actual
  if { [ -z "$2" ] && [ -z "$3" ]; } || { [ -n "$2" ] && [[ "$3" == *"$2"* ]]; }; then echo "ok   $1"; else echo "FAIL $1: want '$2' got '$3'"; fails=$((fails+1)); fi
}

setup 0; check "current is silent" "" "$(run)"
setup 3; check "behind reported, auto_pull off" "3 behind origin/main; auto_pull is off" "$(run)"
check "off leaves HEAD alone" "base" "$(git -C "$tmp/work" log -1 --format=%s)"
out="$(MITHRIL_AUTO_PULL=on run)"; check "on fast-forwards" "fast-forwarded 3" "$out"
check "ff moved HEAD" "up" "$(git -C "$tmp/work" log -1 --format=%s)"
setup 2; echo x > "$tmp/work/f"; git -C "$tmp/work" add f; git -C "$tmp/work" commit -q -m local
out="$(MITHRIL_AUTO_PULL=on run)"; check "diverged reported, not pulled" "diverged: 1 ahead, 2 behind" "$out"
check "diverged leaves HEAD" "local" "$(git -C "$tmp/work" log -1 --format=%s)"
setup 1; echo z > "$tmp/work/g"; git -C "$tmp/work" add g
out="$(MITHRIL_AUTO_PULL=on run)"; check "dirty and behind is reported, not pulled" "1 behind origin/main,dirty (1 file(s))" "$out"
setup 1; mkdir -p "$XDG_CONFIG_HOME/mithril"; echo 'auto_pull=on' > "$XDG_CONFIG_HOME/mithril/config"
check "config file turns it on" "fast-forwarded 1" "$(run)"
rm -rf "$XDG_CONFIG_HOME"
mkdir -p "$tmp/plain"; check "non-git dir is silent" "" "$(MITHRIL_REPO="$tmp/plain" bash "$script")"
exit $((fails > 0))
