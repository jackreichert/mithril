#!/usr/bin/env bash
#
# Code Quality Skills bundler — inverse of install.sh
#
# Reads the live agent files from ~/.claude/agents/quality-*.md and the
# orchestrator from ~/.claude/commands/quality.md, replaces the
# absolute SKILLS_DIR path with the ${CLAUDE_PLUGIN_ROOT} token, and writes
# the tokenized copies into claude/agents/ and claude/commands/ in
# this repo.
#
# Run this after editing an agent or the orchestrator in place under
# ~/.claude/, so the changes are captured in the repo bundle that
# install.sh ships.
#
# Usage:
#   bash bundle.sh                       # bundle with defaults
#   bash bundle.sh --dry-run             # show what would change
#   bash bundle.sh --skills-dir /path    # canonical docs live elsewhere
#   bash bundle.sh --claude-home /path   # non-standard ~/.claude location
#   bash bundle.sh --help

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SKILLS_DIR="${SKILLS_DIR:-$SCRIPT_DIR}"
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
DRY_RUN=0

usage() {
  sed -n '2,21p' "$0" | sed 's/^# \{0,1\}//'
  exit "${1:-0}"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skills-dir)  SKILLS_DIR="$2"; shift 2;;
    --claude-home) CLAUDE_HOME="$2"; shift 2;;
    --dry-run|-n)  DRY_RUN=1; shift;;
    --help|-h)     usage 0;;
    *) echo "Unknown option: $1" >&2; usage 1;;
  esac
done

SKILLS_DIR="$(cd "$SKILLS_DIR" 2>/dev/null && pwd || echo "$SKILLS_DIR")"

AGENTS_LIVE="$CLAUDE_HOME/agents"
COMMANDS_LIVE="$CLAUDE_HOME/commands"
AGENTS_BUNDLE="$SCRIPT_DIR/claude/agents"
COMMANDS_BUNDLE="$SCRIPT_DIR/claude/commands"

log()  { printf '  %s\n' "$*"; }
note() { printf '\n[%s] %s\n' "$1" "$2"; }
die()  { printf 'error: %s\n' "$*" >&2; exit 1; }

[[ -d "$AGENTS_LIVE"   ]] || die "missing $AGENTS_LIVE — nothing to bundle"
[[ -d "$COMMANDS_LIVE" ]] || die "missing $COMMANDS_LIVE — nothing to bundle"

note "PLAN" "bundling live agents → repo"
log "skills dir:      $SKILLS_DIR (will be tokenized to \${CLAUDE_PLUGIN_ROOT})"
log "agents source:   $AGENTS_LIVE"
log "commands source: $COMMANDS_LIVE"
log "agents dest:     $AGENTS_BUNDLE"
log "commands dest:   $COMMANDS_BUNDLE"
[[ "$DRY_RUN" -eq 1 ]] && log "mode:            DRY RUN"

mkdir -p "$AGENTS_BUNDLE" "$COMMANDS_BUNDLE"

bundle_file() {
  local src="$1" dest="$2"
  local tmp; tmp="$(mktemp)"
  sed "s|${SKILLS_DIR}|\${CLAUDE_PLUGIN_ROOT}|g" "$src" > "$tmp"
  if [[ -f "$dest" ]] && cmp -s "$tmp" "$dest"; then
    rm -f "$tmp"
    log "unchanged $(basename "$dest")"
    return 0
  fi
  if [[ "$DRY_RUN" -eq 1 ]]; then
    rm -f "$tmp"
    log "dry-run: would update $dest"
  else
    mv "$tmp" "$dest"
    log "bundled   $dest"
  fi
}

note "AGENTS" "tokenizing 14 agents"
count=0
shopt -s nullglob
for src in "$AGENTS_LIVE"/quality-*.md; do
  bundle_file "$src" "$AGENTS_BUNDLE/$(basename "$src")"
  count=$((count + 1))
done
shopt -u nullglob
[[ "$count" -eq 0 ]] && die "no quality-*.md files found in $AGENTS_LIVE"
log "$count agent file(s) processed"

note "ORCHESTRATOR" "bundling /quality command"
[[ -f "$COMMANDS_LIVE/quality.md" ]] || die "missing $COMMANDS_LIVE/quality.md"
bundle_file "$COMMANDS_LIVE/quality.md" "$COMMANDS_BUNDLE/quality.md"

note "DONE" "bundle complete — review and commit changes under claude/"
log "tip: git diff claude/  to see what changed"
