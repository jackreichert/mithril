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
out="$(MITHRIL_AUTO_PULL=on run)"; check "dirty and behind is reported, not pulled" "1 behind origin/main, dirty (1 file(s))" "$out"
setup 1; mkdir -p "$XDG_CONFIG_HOME/mithril"; echo 'auto_pull=on' > "$XDG_CONFIG_HOME/mithril/config"
check "config file turns it on" "fast-forwarded 1" "$(run)"
rm -rf "$XDG_CONFIG_HOME"
setup 0; echo x > "$tmp/work/f"; git -C "$tmp/work" add f; git -C "$tmp/work" commit -q -m local
check "ahead only, auto_pull on, reported" "1 ahead of origin/main" "$(MITHRIL_AUTO_PULL=on run)"
setup 1; git -C "$tmp/work" remote set-url origin "$tmp/nonexistent"
check "failed fetch is silent" "" "$(MITHRIL_AUTO_PULL=on run)"
setup 1; mkdir -p "$tmp/work/sub"
check "nested subdir of a repo is silent" "" "$(MITHRIL_AUTO_PULL=on MITHRIL_REPO="$tmp/work/sub" bash "$script")"
check "nested subdir left HEAD alone" "base" "$(git -C "$tmp/work" log -1 --format=%s)"
mkdir -p "$tmp/plain"; check "non-git dir is silent" "" "$(MITHRIL_REPO="$tmp/plain" bash "$script")"
# --- auto-pull reinstalls the command copy and links (MITHRIL-022) ---
# Fixture: a clone of this repo's tree, installed into a temp HOME, then fast-forwarded.
reinstall_setup() { # $1 = shell snippet run in the pusher clone before it commits
  rm -rf "$tmp/origin" "$tmp/work" "$tmp/pusher" "$tmp/rhome"; mkdir -p "$tmp/rhome"
  git init -q --bare -b main "$tmp/origin"
  git clone -q "$tmp/origin" "$tmp/work" 2>/dev/null
  git -C "$here" archive HEAD | tar -x -C "$tmp/work"
  git -C "$tmp/work" add -A; git -C "$tmp/work" commit -q -m base
  git -C "$tmp/work" push -q origin main 2>/dev/null
  git -C "$tmp/work" branch -q --set-upstream-to=origin/main main
  git clone -q "$tmp/origin" "$tmp/pusher" 2>/dev/null
  (cd "$tmp/pusher" && eval "$1" && git add -A && git commit -q -m up && git push -q origin main 2>/dev/null)
  HOME="$tmp/rhome" bash "$tmp/work/scripts/install-local.sh" >/dev/null 2>&1
}
pull() { HOME="$tmp/rhome" MITHRIL_AUTO_PULL=on MITHRIL_REPO="$tmp/work" bash "$script" 2>&1; }
strict() { HOME="$tmp/rhome" bash "$tmp/work/healthcheck.sh" --strict 2>&1; }

reinstall_setup 'echo "<!-- v2 -->" >> claude/commands/mithril.md'
out="$(pull)"; rc=$?
check "reinstall: pull succeeds" "0" "$rc"
check "reinstall: command copy re-rendered" "yes" "$(grep -q 'v2 -->' "$tmp/rhome/.claude/commands/mithril.md" && echo yes || echo no)"
strict >/dev/null; check "reinstall: strict healthcheck exits 0 after update" "0" "$?"

reinstall_setup 'sed "s/mithril-review/mithril-zzextra/" skills/review.md > skills/zzextra.md'
pull >/dev/null
check "reinstall: new skill gets a skills link" "$tmp/work/skills/zzextra.md" "$(readlink "$tmp/rhome/.claude/skills/mithril-zzextra")"
check "reinstall: new skill gets an agent link" "$tmp/work/skills/zzextra.md" "$(readlink "$tmp/rhome/.claude/agents/mithril-zzextra.md")"

reinstall_setup 'printf "#!/usr/bin/env bash\nexit 1\n" > scripts/install-local.sh'
out="$(pull)"; rc=$?
check "reinstall failure exits non-zero" "1" "$rc"
check "reinstall failure says so" "reinstall failed" "$out"

reinstall_setup 'echo "<!-- v2 -->" >> claude/commands/mithril.md'
ln -s "$tmp/other/skills/retired.md" "$tmp/rhome/.claude/agents/mithril-retired.md"
out="$(pull)"; rc=$?
check "foreign link: pull still succeeds" "0" "$rc"
check "foreign link is kept" "$tmp/other/skills/retired.md" "$(readlink "$tmp/rhome/.claude/agents/mithril-retired.md")"
check "foreign link is warned about, remove by hand" "remove it by hand" "$out"
strict >/dev/null; check "foreign dangling link: strict healthcheck exits 1" "1" "$?"
rm -rf "$tmp/rhome"
exit $((fails > 0))
