#!/usr/bin/env bash
#
# Mithril installer
#
# Deploys the /mithril framework into Claude Code and Grok Build (first-class on both):
#   - 18 canonical skill files into ~/.claude/agents/ and ~/.grok/agents/,
#     linked by default or copied with --copy-agents
#   - 1 orchestrator command into ~/.claude/commands/ and ~/.grok/commands/ (mithril.md)
#
# Agent files are linked or copied directly from the canonical skills in this repo.
# The orchestrator command receives the absolute repo path in place of the
# plugin-standard ${CLAUDE_PLUGIN_ROOT} token used by plugin installations.
#
# Alternative install (Grok): `grok plugin install . --trust` (or the GitHub URL)
# uses .claude-plugin/plugin.json / .grok-plugin/plugin.json and needs no classic copy.
#
# --link wires CONSTITUTION.md into Claude Code, Grok, Codex, and Copilot from a
# single canonical source (no content copies): a Claude @import line, a
# ~/.grok/AGENTS.md symlink, a ~/.codex/AGENTS.md symlink, and an instructions/
# symlink + VS Code settings snippet for Copilot.
#
# --copilot (re)generates a self-contained Copilot instructions file (the
# Constitution inlined, since Copilot can't resolve @import). Re-run it
# whenever CONSTITUTION.md changes to keep Copilot in sync.
#
# Personalization never touches the git-tracked CONSTITUTION.md (it keeps the
# __USER_NAME__ placeholder). --name writes a personalized copy to the gitignored
# instructions/CONSTITUTION.local.md and points Claude/Grok/Codex/Copilot at THAT —
# so the repo stays shareable while every deployed artifact greets you by name.
#
# Usage:
#   bash install.sh                       # install into Claude + Grok with defaults
#   bash install.sh --dry-run             # show what would happen
#   bash install.sh --force               # overwrite without backups
#   bash install.sh --symlink-agents      # explicitly select the default linked mode
#   bash install.sh --copy-agents         # install frozen copies instead of live links
#   bash install.sh --link                # also link the Constitution into Claude/Grok/Codex/Copilot
#   bash install.sh --name "Your Name"    # greeting name baked into the DEPLOYED copy only (asked if omitted, with --link)
#   bash install.sh --poem                # enable the haiku/limerick sign-off (off by default; --no-poem to disable)
#   bash install.sh --copilot             # (re)generate self-contained Copilot file [--copilot-prefix F] [--copilot-out F]
#   bash install.sh --skills-dir /path    # canonical docs live elsewhere
#   bash install.sh --claude-home /path   # non-standard ~/.claude location
#   bash install.sh --grok-home /path     # non-standard ~/.grok location
#   bash install.sh --claude-only         # deploy only Claude Code paths
#   bash install.sh --grok-only           # deploy only Grok paths
#   bash install.sh --uninstall           # remove what was installed (incl. links)
#   bash install.sh --help

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SKILLS_DIR="${SKILLS_DIR:-$SCRIPT_DIR}"
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
GROK_HOME="${GROK_HOME:-$HOME/.grok}"
INSTALL_CLAUDE=1
INSTALL_GROK=1
FORCE=0
DRY_RUN=0
UNINSTALL=0
LINK=0
SYMLINK_AGENTS=1
USER_NAME=""
POEM=""
COPILOT=0
COPILOT_PREFIX=""
COPILOT_OUT=""

usage() {
  sed -n '2,45p' "$0" | sed 's/^# \{0,1\}//'
  exit "${1:-0}"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skills-dir)  SKILLS_DIR="$2"; shift 2;;
    --claude-home) CLAUDE_HOME="$2"; shift 2;;
    --grok-home)   GROK_HOME="$2"; shift 2;;
    --claude-only) INSTALL_CLAUDE=1; INSTALL_GROK=0; shift;;
    --grok-only)   INSTALL_CLAUDE=0; INSTALL_GROK=1; shift;;
    --force|-f)    FORCE=1; shift;;
    --dry-run|-n)  DRY_RUN=1; shift;;
    --symlink-agents) SYMLINK_AGENTS=1; shift;;
    --copy-agents) SYMLINK_AGENTS=0; shift;;
    --link)        LINK=1; shift;;
    --name)        USER_NAME="$2"; shift 2;;
    --poem)        POEM=1; shift;;
    --no-poem)     POEM=0; shift;;
    --copilot)         COPILOT=1; shift;;
    --copilot-prefix)  COPILOT_PREFIX="$2"; shift 2;;
    --copilot-out)     COPILOT_OUT="$2"; shift 2;;
    --uninstall)   UNINSTALL=1; shift;;
    --help|-h)     usage 0;;
    *) echo "Unknown option: $1" >&2; usage 1;;
  esac
done

SKILLS_DIR="$(cd "$SKILLS_DIR" 2>/dev/null && pwd || echo "$SKILLS_DIR")"

AGENTS_SRC="$SKILLS_DIR/skills"
COMMANDS_SRC="$SCRIPT_DIR/claude/commands"

log()  { printf '  %s\n' "$*"; }
note() { printf '\n[%s] %s\n' "$1" "$2"; }
die()  { printf 'error: %s\n' "$*" >&2; exit 1; }

run() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "dry-run: $*"
  else
    "$@"
  fi
}

make_temp() {
  mktemp "${TMPDIR:-/tmp}/mithril.XXXXXX"
}

# Remove pre-rename artifacts (the `quality-*` agents and `/quality` orchestrator
# deployed before this framework became Mithril). Prefers the legacy manifest so we
# only ever delete files we installed; falls back to the canonical agent list rather
# than globbing, to avoid touching a user's own `quality-*` agents.
remove_legacy_host() {
  local home="$1" label="$2"
  local agents_dest="$home/agents" commands_dest="$home/commands"
  local legacy_manifest="$agents_dest/.code-quality-skills-agents"
  local name target found=0
  if [[ -f "$legacy_manifest" ]]; then
    while IFS= read -r name; do
      [[ -n "$name" ]] || continue
      target="$agents_dest/$name"
      if [[ -f "$target" || -L "$target" ]]; then
        run rm -f "$target"
        log "removed legacy $target"
        found=1
      fi
    done < "$legacy_manifest"
    run rm -f "$legacy_manifest"
    log "removed legacy $legacy_manifest"
    found=1
  else
    for src in "$AGENTS_SRC"/*.md; do
      [[ -e "$src" ]] || continue
      name="$(basename "$src")"
      [[ "$name" == "tutor.md" ]] && continue
      target="$agents_dest/quality-$name"
      if [[ -f "$target" || -L "$target" ]]; then
        run rm -f "$target"
        log "removed legacy $target"
        found=1
      fi
    done
  fi
  if [[ -f "$commands_dest/quality.md" ]]; then
    run rm -f "$commands_dest/quality.md"
    log "removed legacy $commands_dest/quality.md"
    found=1
  fi
  (( found )) && note "MIGRATE" "cleaned up pre-Mithril /quality install in $home ($label)"
  return 0
}

# Remove Mithril agents + orchestrator from one host home (Claude or Grok).
uninstall_host() {
  local home="$1" label="$2"
  local agents_dest="$home/agents" commands_dest="$home/commands"
  local manifest="$agents_dest/.mithril-agents"
  note "UNINSTALL" "removing files from $home ($label)"
  remove_legacy_host "$home" "$label"
  local name target
  if [[ -f "$manifest" ]]; then
    while IFS= read -r name; do
      [[ -n "$name" ]] || continue
      target="$agents_dest/$name"
      if [[ -f "$target" || -L "$target" ]]; then
        run rm -f "$target"
        log "removed $target"
      fi
    done < "$manifest"
    run rm -f "$manifest"
    log "removed $manifest"
  else
    for src in "$AGENTS_SRC"/*.md; do
      [[ -e "$src" ]] || continue
      name="$(basename "$src")"
      [[ "$name" == "tutor.md" ]] && continue
      target="$agents_dest/mithril-$name"
      if [[ -f "$target" || -L "$target" ]]; then
        run rm -f "$target"
        log "removed $target"
      fi
    done
  fi
  if [[ -f "$commands_dest/mithril.md" ]]; then
    run rm -f "$commands_dest/mithril.md"
    log "removed $commands_dest/mithril.md"
  fi
}

# Remove a Constitution symlink if it points at one of our known targets.
unlink_if_ours() {
  local linkpath="$1" const="$2" const_personal="$3" selfcontained="$4"
  [[ -L "$linkpath" ]] || return 0
  local tgt; tgt="$(readlink "$linkpath")"
  if [[ "$tgt" == "$const" || "$tgt" == "$const_personal" || "$tgt" == "$selfcontained" ]]; then
    run rm -f "$linkpath"
    log "removed $linkpath"
  fi
}

if [[ "$UNINSTALL" -eq 1 ]]; then
  (( INSTALL_CLAUDE )) && uninstall_host "$CLAUDE_HOME" "Claude Code"
  (( INSTALL_GROK ))   && uninstall_host "$GROK_HOME"   "Grok"

  # Tear down anything --link / --copilot created (only our own symlinks / import line / generated copy).
  const="$SKILLS_DIR/CONSTITUTION.md"
  const_personal="$SKILLS_DIR/instructions/CONSTITUTION.local.md"
  selfcontained="${COPILOT_OUT:-$SKILLS_DIR/instructions/copilot-instructions.md}"
  unlink_if_ours "$HOME/.codex/AGENTS.md" "$const" "$const_personal" "$selfcontained"
  unlink_if_ours "$GROK_HOME/AGENTS.md"   "$const" "$const_personal" "$selfcontained"
  inst_link="$SKILLS_DIR/instructions/CONSTITUTION.instructions.md"
  if [[ -L "$inst_link" ]]; then
    run rm -f "$inst_link"
    log "removed $inst_link"
  fi
  if [[ -f "$const_personal" ]]; then
    run rm -f "$const_personal"
    log "removed $const_personal (personalized deployed copy)"
  fi
  claude_md="$CLAUDE_HOME/CLAUDE.md"
  if [[ -f "$claude_md" ]] && grep -qE '^@.*CONSTITUTION(\.local)?\.md$' "$claude_md"; then
    if [[ "$DRY_RUN" -eq 1 ]]; then
      log "dry-run: would remove Constitution import line(s) from $claude_md"
    else
      tmp="$(make_temp)"
      grep -Ev '^@.*CONSTITUTION(\.local)?\.md$' "$claude_md" > "$tmp" || true
      mv "$tmp" "$claude_md"
      log "removed Constitution import line(s) from $claude_md"
    fi
  fi

  note "DONE" "uninstall complete"
  exit 0
fi

[[ -d "$AGENTS_SRC" ]]   || die "missing $AGENTS_SRC — is this a clone of the repo?"
[[ -d "$COMMANDS_SRC" ]] || die "missing $COMMANDS_SRC"
[[ -f "$SKILLS_DIR/skills/code-quality.md" ]] || die "skills dir invalid: $SKILLS_DIR (no skills/code-quality.md found)"
(( INSTALL_CLAUDE || INSTALL_GROK )) || die "nothing to install — both --claude-only and --grok-only cancelled each other?"

note "PLAN" "installing /mithril framework"
log "skills dir:    $SKILLS_DIR"
(( INSTALL_CLAUDE )) && log "claude home:   $CLAUDE_HOME  (agents + commands)"
(( INSTALL_GROK ))   && log "grok home:     $GROK_HOME    (agents + commands)"
[[ "$DRY_RUN" -eq 1 ]] && log "mode:          DRY RUN"
[[ "$FORCE"   -eq 1 ]] && log "mode:          FORCE (no backups)"
[[ "$SYMLINK_AGENTS" -eq 1 ]] && log "agents:        SYMLINKED (canonical: $SKILLS_DIR/skills)"
[[ "$SYMLINK_AGENTS" -eq 0 ]] && log "agents:        COPIED (frozen install)"

if (( INSTALL_CLAUDE )) && [[ ! -d "$CLAUDE_HOME" ]]; then
  log "warning:       $CLAUDE_HOME does not exist — Claude Code may not be installed"
  log "               see https://docs.claude.com/claude-code (continuing anyway)"
fi
if (( INSTALL_GROK )) && [[ ! -d "$GROK_HOME" ]]; then
  log "warning:       $GROK_HOME does not exist — Grok may not be installed"
  log "               see https://docs.x.ai (continuing anyway)"
fi

backup_if_needed() {
  local target="$1"
  [[ -f "$target" ]] || return 0
  [[ "$FORCE" -eq 1 ]] && return 0
  local stamp; stamp="$(date +%Y%m%d-%H%M%S)"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "dry-run: would back up $(basename "$target") → $(basename "$target").bak.$stamp"
  else
    cp "$target" "$target.bak.$stamp"
    log "backed up existing → $(basename "$target").bak.$stamp"
  fi
}

install_file() {
  local src="$1" dest="$2"
  local tmp; tmp="$(make_temp)"
  sed "s|\${CLAUDE_PLUGIN_ROOT}|${SKILLS_DIR}|g" "$src" > "$tmp"
  if [[ -f "$dest" ]] && cmp -s "$tmp" "$dest"; then
    rm -f "$tmp"
    log "unchanged $(basename "$dest")"
    return 0
  fi
  backup_if_needed "$dest"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    rm -f "$tmp"
    log "dry-run: would install $dest"
  else
    mv "$tmp" "$dest"
    log "installed $dest"
  fi
}

copy_file() {
  local src="$1" dest="$2"
  if [[ -f "$dest" ]] && cmp -s "$src" "$dest"; then
    log "unchanged $(basename "$dest")"
    return 0
  fi
  backup_if_needed "$dest"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "dry-run: would install $dest"
  else
    cp "$src" "$dest"
    log "installed $dest"
  fi
}

# Point a symlink at a single canonical source — no content copy.
link_symlink() {
  local target="$1" linkpath="$2"
  if [[ -L "$linkpath" && "$(readlink "$linkpath")" == "$target" ]]; then
    [[ -e "$target" ]] || die "canonical symlink target is missing: $target"
    log "unchanged $linkpath → $target"
    return 0
  fi
  if [[ -e "$linkpath" || -L "$linkpath" ]]; then
    backup_if_needed "$linkpath"   # preserves an existing real file
    run rm -f "$linkpath"
  fi
  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "dry-run: would link $linkpath → $target"
  else
    ln -s "$target" "$linkpath"
    log "linked   $linkpath → $target"
  fi
}

# Read the greeting name baked into a Constitution file ("" if unset/placeholder/missing).
current_comms_name() {
  [[ -f "$1" ]] || { printf ''; return; }
  local n
  n="$(sed -n 's/.*Start every answer with "Hey \(.*\)" and end.*/\1/p' "$1" | head -1)"
  [[ "$n" == "__USER_NAME__" ]] && n=""
  printf '%s' "$n"
}

# Is the haiku/limerick sign-off currently enabled in a Constitution file? (1/0)
current_comms_poem() {
  [[ -f "$1" ]] || { printf '0'; return; }
  if sed -n '/BEGIN quality:communication-style/,/END quality:communication-style/p' "$1" | grep -q 'haiku or limerick'; then
    printf '1'
  else
    printf '0'
  fi
}

# Write a personalized copy of the Constitution from SRC to DEST: greeting name always,
# haiku/limerick only if poem=1. SRC (the canonical, git-tracked CONSTITUTION.md) is NEVER
# modified — the repo keeps __USER_NAME__, the deployed copy carries the name. DEST lives
# under instructions/ which is gitignored.
personalize_constitution() {
  local src="$1" dest="$2" name="$3" poem="$4"
  if ! grep -q "BEGIN quality:communication-style" "$src"; then
    log "communication-style: markers not found in $(basename "$src") — copying verbatim"
    run cp "$src" "$dest"
    return 0
  fi
  local pstate="off"; [[ "$poem" == "1" ]] && pstate="on"
  local tmp; tmp="$(make_temp)"
  awk -v name="$name" -v poem="$poem" '
    /<!-- BEGIN quality:communication-style -->/ {
      print
      print "- Start every answer with \"Hey " name "\" and end with \"Cheers " name "!\""
      if (poem == "1") {
        print "- End every answer with a properly formatted haiku or limerick:"
        print "  - Haiku: 5 / 7 / 5 syllables, each on its own line"
        print "  - Limerick: 5 lines, AABBA rhyme"
      }
      skip=1; next
    }
    /<!-- END quality:communication-style -->/ { skip=0; print; next }
    skip { next }
    { print }
  ' "$src" > "$tmp"
  if [[ -f "$dest" ]] && cmp -s "$tmp" "$dest"; then
    rm -f "$tmp"
    log "unchanged $(basename "$dest") (Hey $name, poem $pstate)"
  elif [[ "$DRY_RUN" -eq 1 ]]; then
    rm -f "$tmp"
    log "dry-run: would write $(basename "$dest") (Hey $name, poem $pstate)"
  else
    mkdir -p "$(dirname "$dest")"
    mv "$tmp" "$dest"
    log "personalized → $(basename "$dest") (Hey $name, poem $pstate)"
  fi
}

# Generate a self-contained Copilot instructions file: optional personal prefix
# (HIPAA/workflow, with its @import line dropped) + the Constitution inlined.
# Re-run after CONSTITUTION.md changes to keep Copilot in sync.
generate_copilot() {
  local out="$1" prefix="$2" const="$3" have_prefix=0
  if [[ -n "$prefix" && -f "$prefix" ]]; then
    have_prefix=1
  elif [[ -n "$prefix" ]]; then
    log "warning: --copilot-prefix $prefix not found — generating Constitution-only (no HIPAA prefix)"
  fi
  local tmp; tmp="$(make_temp)"
  {
    printf '<!-- GENERATED by install.sh --copilot. Self-contained for Copilot (which cannot\n'
    printf 'resolve @import): Constitution inlined below. Company HIPAA/safety rules inline and\n'
    printf 'first. Do not hand-edit — re-run: bash install.sh --copilot --copilot-prefix <file>. -->\n\n'
    if [[ "$have_prefix" -eq 1 ]]; then
      awk 'BEGIN{c=0} /<!--/{c=1} c{if(/-->/)c=0; next} {print}' "$prefix" | grep -Ev '^@.*CONSTITUTION(\.local)?\.md$' || true
      printf '\n---\n\n'
    fi
    cat "$const"
  } > "$tmp"
  if [[ -f "$out" ]] && cmp -s "$tmp" "$out"; then
    rm -f "$tmp"
    log "unchanged $out"
  elif [[ "$DRY_RUN" -eq 1 ]]; then
    rm -f "$tmp"
    log "dry-run: would generate $out"
  else
    backup_if_needed "$out"
    mv "$tmp" "$out"
    log "generated $out"
  fi
}

# Point a CLAUDE.md at exactly one Constitution @import: strip any prior canonical or
# personalized (CONSTITUTION.local.md) import, then append the chosen one. Keeps Claude
# from loading the Constitution twice when the deploy target changes.
set_constitution_import() {
  local file="$1" want="@$2"
  local re='^@.*CONSTITUTION(\.local)?\.md$'
  if [[ -f "$file" ]] && grep -qxF "$want" "$file" && [[ "$(grep -Ec "$re" "$file")" -eq 1 ]]; then
    log "unchanged $file (import present)"
    return 0
  fi
  backup_if_needed "$file"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "dry-run: would set Constitution import in $file → $want"
    return 0
  fi
  mkdir -p "$(dirname "$file")"
  local tmp; tmp="$(make_temp)"
  if [[ -f "$file" ]]; then
    grep -Ev "$re" "$file" > "$tmp" || true
  fi
  printf '\n%s\n' "$want" >> "$tmp"
  mv "$tmp" "$file"
  log "set Constitution import → $file ($want)"
}

# Deploy canonical skills + orchestrator into one host home.
deploy_host() {
  local home="$1" label="$2"
  local agents_dest="$home/agents" commands_dest="$home/commands"
  local manifest="$agents_dest/.mithril-agents"
  run mkdir -p "$agents_dest" "$commands_dest"
  remove_legacy_host "$home" "$label"

  note "AGENTS" "deploying agents → $agents_dest ($label)"
  local desired_manifest
  desired_manifest="$(make_temp)"
  local count=0 src name dest stale
  for src in "$AGENTS_SRC"/*.md; do
    [[ -e "$src" ]] || die "no agent files found in $AGENTS_SRC"
    name="$(basename "$src")"
    [[ "$name" == "tutor.md" ]] && continue
    dest="$agents_dest/mithril-$name"
    printf 'mithril-%s\n' "$name" >> "$desired_manifest"
    if [[ "$SYMLINK_AGENTS" -eq 1 ]]; then
      link_symlink "$src" "$dest"
    else
      copy_file "$src" "$dest"
    fi
    count=$((count + 1))
  done
  if [[ -f "$manifest" ]]; then
    while IFS= read -r stale; do
      [[ -n "$stale" ]] || continue
      if ! grep -qxF "$stale" "$desired_manifest"; then
        if [[ -f "$agents_dest/$stale" || -L "$agents_dest/$stale" ]]; then
          run rm -f "$agents_dest/$stale"
          log "removed stale $agents_dest/$stale"
        fi
      fi
    done < "$manifest"
  fi
  if [[ "$DRY_RUN" -eq 1 ]]; then
    rm -f "$desired_manifest"
    log "dry-run: would update $manifest"
  else
    mv "$desired_manifest" "$manifest"
  fi
  log "$count agent file(s) processed for $label"

  note "ORCHESTRATOR" "deploying /mithril command → $commands_dest ($label)"
  install_file "$COMMANDS_SRC/mithril.md" "$commands_dest/mithril.md"
}

(( INSTALL_CLAUDE )) && deploy_host "$CLAUDE_HOME" "Claude Code"
(( INSTALL_GROK ))   && deploy_host "$GROK_HOME"   "Grok"

# Resolve the greeting name + poem ONCE (needed by both --copilot and --link), and — when a
# name is set — write a personalized copy of the Constitution to instructions/CONSTITUTION.local.md
# (gitignored). The canonical, git-tracked CONSTITUTION.md is NEVER modified: the repo keeps the
# __USER_NAME__ placeholder while every deployed artifact carries the name. EFFECTIVE_CONST is the
# file all three tools point at — the personalized copy if it exists, else canonical.
CONST_CANONICAL="$SKILLS_DIR/CONSTITUTION.md"
CONST_PERSONAL="$SKILLS_DIR/instructions/CONSTITUTION.local.md"
EFFECTIVE_CONST="$CONST_CANONICAL"
if [[ "$LINK" -eq 1 || "$COPILOT" -eq 1 ]]; then
  [[ -f "$CONST_CANONICAL" ]] || die "no CONSTITUTION.md at $CONST_CANONICAL"
  name="$USER_NAME"
  if [[ -z "$name" ]]; then
    name="$(current_comms_name "$CONST_PERSONAL")"          # reuse a previously-installed name (idempotent)
    if [[ -z "$name" && "$LINK" -eq 1 && "$DRY_RUN" -eq 0 && -t 0 ]]; then
      printf '  Name for the Constitution greeting (Hey NAME / Cheers NAME!): '
      read -r name
    fi
  fi
  poem="$POEM"
  [[ -z "$poem" ]] && poem="$(current_comms_poem "$CONST_PERSONAL")"   # no flag → preserve current choice
  if [[ -n "$name" ]]; then
    note "PERSONALIZE" "writing deployed Constitution copy (canonical keeps __USER_NAME__)"
    run mkdir -p "$SKILLS_DIR/instructions"
    personalize_constitution "$CONST_CANONICAL" "$CONST_PERSONAL" "$name" "$poem"
    [[ "$DRY_RUN" -eq 1 ]] || EFFECTIVE_CONST="$CONST_PERSONAL"
  else
    log "communication-style: no name set — deploying canonical (Hey __USER_NAME__); re-run with --name \"Your Name\""
  fi
fi

# Generate the self-contained inlined file BEFORE --link, so Codex/Copilot can point at it.
if [[ "$COPILOT" -eq 1 ]]; then
  cp_out="${COPILOT_OUT:-$SKILLS_DIR/instructions/copilot-instructions.md}"
  note "COPILOT" "generating self-contained instructions (vendor prefix + Constitution inlined) — used by Codex & Copilot"
  run mkdir -p "$(dirname "$cp_out")"
  generate_copilot "$cp_out" "$COPILOT_PREFIX" "$EFFECTIVE_CONST"
  log "point at it — Codex: ~/.codex/AGENTS.md symlink (via --link); IntelliJ: symlink global file; VS Code: settings file ref; github.com: paste"
fi

if [[ "$LINK" -eq 1 ]]; then
  note "LINK" "wiring the Constitution into Claude / Grok / Codex / Copilot (deployed copy carries the name)"

  # Claude Code — native @import, pointed at the effective (personalized or canonical) copy.
  set_constitution_import "$CLAUDE_HOME/CLAUDE.md" "$EFFECTIVE_CONST"

  # Grok — global project-rules file under ~/.grok/ (AGENTS.md is the lingua franca).
  # Prefer the self-contained inlined file when present (same as Codex), else the effective Constitution.
  run mkdir -p "$GROK_HOME"
  link_target="$EFFECTIVE_CONST"
  sc="${COPILOT_OUT:-$SKILLS_DIR/instructions/copilot-instructions.md}"
  if [[ -f "$sc" ]]; then
    link_target="$sc"
  fi
  link_symlink "$link_target" "$GROK_HOME/AGENTS.md"
  if [[ "$link_target" == "$EFFECTIVE_CONST" ]]; then
    log "note: Grok AGENTS.md → Constitution only. Run --copilot --copilot-prefix <file> to include a vendor prefix."
  fi

  # Codex — point its global agents file at the self-contained inlined file (vendor HIPAA +
  # Constitution) when present, so HIPAA lives in AGENTS.md, not the Constitution. Else the
  # effective Constitution. ~/.codex lives elsewhere → absolute target.
  run mkdir -p "$HOME/.codex"
  if [[ -f "$sc" ]]; then
    link_symlink "$sc" "$HOME/.codex/AGENTS.md"
  else
    link_symlink "$EFFECTIVE_CONST" "$HOME/.codex/AGENTS.md"
    log "note: Codex AGENTS.md → Constitution only (no vendor HIPAA). Run --copilot --copilot-prefix <file> to generate the self-contained file, then re-link."
  fi

  # Copilot (VS Code) — a *.instructions.md symlink in a dedicated folder (relative target, repo-portable),
  # pointed at the effective copy (CONSTITUTION.local.md when personalized, else ../CONSTITUTION.md).
  run mkdir -p "$SKILLS_DIR/instructions"
  if [[ "$EFFECTIVE_CONST" == "$CONST_PERSONAL" ]]; then
    link_symlink "CONSTITUTION.local.md" "$SKILLS_DIR/instructions/CONSTITUTION.instructions.md"
  else
    link_symlink "../CONSTITUTION.md" "$SKILLS_DIR/instructions/CONSTITUTION.instructions.md"
  fi

  log "Copilot (VS Code): add to settings.json —"
  log "    \"chat.instructionsFilesLocations\": { \"$SKILLS_DIR/instructions\": true }"
  log "note: github.com web Copilot can't reference external files; commit a copy in-repo if you need it there."
fi

note "DONE" "install complete"
targets=""
(( INSTALL_CLAUDE )) && targets="Claude Code"
(( INSTALL_GROK )) && {
  if [[ -n "$targets" ]]; then targets="$targets + Grok"; else targets="Grok"; fi
}
log "deployed to: $targets"
log "try it:  open Claude Code or Grok in any git repo and run /mithril"
log "Grok plugin alternative:  grok plugin install $SCRIPT_DIR --trust && grok plugin enable code-quality"
[[ "$FORCE" -eq 0 && "$DRY_RUN" -eq 0 ]] && log "backups: any pre-existing files were saved as *.bak.<timestamp>"

cat <<EOF

────────────────────────────────────────────────────────────────────
Copilot & Codex — write-time Constitution (single source, no copies)
────────────────────────────────────────────────────────────────────

Generate the self-contained instructions (your personal prefix + the
Constitution inlined — used by Codex, Copilot, and optionally Grok via --link):

  bash install.sh --copilot --copilot-prefix <your-prefix.md>

Then wire it up (or just run --link, which points Grok + Codex at it):

  • Grok       ~/.grok/AGENTS.md → Constitution (or self-contained file if generated)
  • Codex      ~/.codex/AGENTS.md → $SKILLS_DIR/instructions/copilot-instructions.md
  • Copilot (VS Code)   settings.json:
      "github.copilot.chat.codeGeneration.instructions": [
        { "file": "$SKILLS_DIR/instructions/copilot-instructions.md" }
      ]
  • Copilot (IntelliJ)  symlink ~/.config/github-copilot/intellij/global-copilot-instructions.md → it
  • Copilot (github.com)  paste it into Settings → Copilot → personal custom instructions

Re-run --copilot whenever CONSTITUTION.md changes to keep Codex/Copilot in sync.
EOF
