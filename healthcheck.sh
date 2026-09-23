#!/usr/bin/env bash
#
# Mithril — health check
#
# Guards the canonical-skill architecture (skills/ → deployed ~/.claude/ and
# ~/.grok/) plus doc integrity:
#   1. AGENT INTEGRITY   — every runtime skill has valid frontmatter and its
#                          ${CLAUDE_PLUGIN_ROOT} skill references point at real files
#   2. ROUTING           — every subagent_type the orchestrator routes to has a
#                          matching runtime skill (and no skill is orphaned)
#   3. COUNT CLAIMS      — "N agent" figures in README.md / install.sh match reality
#   4. SUMMARY DEPTH     — every chapter summary has at least three sentences
#   5. DEPLOYED SYNC     — ~/.claude and ~/.grok agents match canonical skills
#   6. DOC LINKS         — relative .md links AND plain-text ../ paths resolve
#
# Exit 0 = healthy, 1 = problems found.
#
#   bash healthcheck.sh            # full check
#   bash healthcheck.sh --quiet    # only failures + verdict

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
GROK_HOME="${GROK_HOME:-$HOME/.grok}"
AGENTS_SRC="$SCRIPT_DIR/skills"
CMD_SRC="$SCRIPT_DIR/claude/commands/mithril.md"
QUIET=0
[[ "${1:-}" == "--quiet" ]] && QUIET=1

if [[ -t 1 ]]; then GRN=$'\033[32m'; YLW=$'\033[33m'; RED=$'\033[31m'; BOLD=$'\033[1m'; RST=$'\033[0m'
else GRN=""; YLW=""; RED=""; BOLD=""; RST=""; fi
FAILS=0; WARNS=0
ok()   { (( QUIET )) || printf '%s✓%s %s\n' "$GRN" "$RST" "$*"; }
warn() { printf '%s!%s %s\n' "$YLW" "$RST" "$*" >&2; WARNS=$((WARNS+1)); }
bad()  { printf '%s✗%s %s\n' "$RED" "$RST" "$*" >&2; FAILS=$((FAILS+1)); }
hdr()  { (( QUIET )) || printf '\n%s%s%s\n' "$BOLD" "$*" "$RST"; }

# ---- 1. agent integrity --------------------------------------------------------
hdr "Canonical skill integrity"
n_agents=0
for f in "$AGENTS_SRC"/*.md; do
  [[ -f "$f" ]] || continue
  [[ "$(basename "$f")" == "tutor.md" ]] && continue
  name="mithril-$(basename "$f" .md)"; n_agents=$((n_agents+1)); agent_ok=1
  [[ "$(head -1 "$f")" == "---" ]] || { bad "$name — missing frontmatter fence"; agent_ok=0; }
  fm="$(awk 'NR>1 && /^---/{exit} {print}' "$f")"
  for key in name: description: model: tools:; do
    printf '%s\n' "$fm" | grep -q "^$key" || { bad "$name — frontmatter missing '$key'"; agent_ok=0; }
  done
  printf '%s\n' "$fm" | grep -qE "^name:[[:space:]]*$name([[:space:]]|$)" \
    || { bad "$name — frontmatter name does not match filename"; agent_ok=0; }
  (( agent_ok )) && ok "$name (frontmatter valid)"
done
(( n_agents > 0 )) || bad "no agents found under $AGENTS_SRC"

# ---- 2. orchestrator routing ---------------------------------------------------
hdr "Orchestrator routing"
if [[ -f "$CMD_SRC" ]]; then
  routed=0; routing_ok=1
  while IFS= read -r target; do
    [[ -z "$target" ]] && continue
    routed=$((routed+1))
    [[ -f "$AGENTS_SRC/${target#mithril-}.md" ]] \
      || { bad "orchestrator routes to '$target' but skills/${target#mithril-}.md does not exist"; routing_ok=0; }
  done < <(grep -ohE '(subagent_type="|→ )mithril-[a-z0-9_-]+' "$CMD_SRC" | sed -E 's/^(subagent_type="|→ )//' | sort -u)
  (( routing_ok )) && ok "all $routed routed agent targets exist as canonical skills"
  # Orphan check: every runtime skill should be reachable from the orchestrator.
  for f in "$AGENTS_SRC"/*.md; do
    [[ "$(basename "$f")" == "tutor.md" ]] && continue
    name="mithril-$(basename "$f" .md)"
    grep -q "$name" "$CMD_SRC" || warn "$name is never referenced by the orchestrator"
  done
else
  bad "claude/commands/mithril.md missing"
fi

# ---- 2b. plugin manifests (Claude + Grok) --------------------------------------
hdr "Plugin manifests"
check_plugin_manifest() {
  local plugin_json="$1" label="$2"
  if [[ ! -f "$plugin_json" ]]; then
    warn "$label missing (plugin install path unavailable)"
    return
  fi
  local manifest_ok=1
  for f in "$AGENTS_SRC"/*.md; do
    [[ "$(basename "$f")" == "tutor.md" ]] && continue
    local rel
    rel="./skills/$(basename "$f")"
    grep -qF "\"$rel\"" "$plugin_json" || { bad "$label missing agent entry: $rel"; manifest_ok=0; }
  done
  while IFS= read -r rel; do
    [[ -f "$SCRIPT_DIR/${rel#./}" ]] || { bad "$label lists missing file: $rel"; manifest_ok=0; }
  done < <(grep -oE '"\./(claude|skills)/[A-Za-z0-9/._-]+\.md"' "$plugin_json" | tr -d '"')
  (( manifest_ok )) && ok "$label agent/command entries match canonical files"
}
check_plugin_manifest "$SCRIPT_DIR/.claude-plugin/plugin.json" ".claude-plugin/plugin.json"
check_plugin_manifest "$SCRIPT_DIR/.grok-plugin/plugin.json"   ".grok-plugin/plugin.json"

# ---- 2c. skill → agent checklist parity (2026-06+ lag guard) --------------------
hdr "Skill → agent checklist parity"
# Named checklists that must survive agent compression (not full skill prose).
parity_ok=1
require_in_agent() {
  local agent="$1" phrase="$2" label="$3"
  local f="$AGENTS_SRC/${agent#mithril-}.md"
  if [[ ! -f "$f" ]]; then bad "missing agent $agent"; parity_ok=0; return; fi
  if grep -qiE "$phrase" "$f"; then
    ok "$agent carries $label"
  else
    bad "$agent missing '$label' (pattern: $phrase) — skill→agent lag"
    parity_ok=0
  fi
}
require_in_agent mithril-security-review 'STRIDE' 'STRIDE threat enum'
require_in_agent mithril-security-review 'Shostack|four questions' 'Shostack four questions'
require_in_agent mithril-delivery 'expand-contract' 'expand-contract deploy/rollback safety'
require_in_agent mithril-code-quality 'Size is a prompt, not a finding' 'anti-dogma size calibration'
require_in_agent mithril-code-quality 'independent reasons to change' 'class decomposition decision test'
require_in_agent mithril-code-quality 'load X → outcome Y' 'performance failure-scenario format'
require_in_agent mithril-architecture 'illegal states|one transaction = one aggregate' 'domain integrity / aggregates'
require_in_agent mithril-architecture 'Hyrum|expand-contract' 'API contract evolution'
require_in_agent mithril-architecture 'Class decomposition test|disjoint method/field clusters' 'class decomposition counterweight'
require_in_agent mithril-test-quality 'Property-based|property-based|PBT' 'property-based testing'
require_in_agent mithril-test-quality 'shrink|Hypothesis|fast-check' 'PBT tooling / shrinking'
require_in_agent mithril-test-quality 'Two test layers|acceptance-level evidence' 'customer/programmer test layers'
require_in_agent mithril-test-quality 'Confidence and Severity' 'confidence threshold'
require_in_agent mithril-persistence 'sargable' 'sargable predicates'
require_in_agent mithril-review 'Review Contract Precondition|Never infer intended behavior' 'requirements-first review contract'
require_in_agent mithril-review 'Look Here First' 'human PR inspection brief'
require_in_agent mithril-observability 'USE method' 'USE method on pools/queues'
require_in_agent mithril-concurrency 'atomic|visibility|liveness' 'three concurrency hazards'
require_in_agent mithril-observability 'golden signals|saturation' 'golden signals (observability skill)'
require_in_agent mithril-accessibility 'WCAG|keyboard|accessible name' 'WCAG / keyboard a11y'
require_in_agent mithril-usability 'Observed.*Heuristic|Heuristic.*Observed' 'observed vs heuristic usability evidence'
require_in_agent mithril-usability 'hierarchy|information scent|error recovery' 'task-centered usability checks'
if grep -qE 'UI usability clear.*discoverable.*feedback and recovery' "$SCRIPT_DIR/CONSTITUTION.md"; then
  ok "Constitution carries the UI usability gate"
else
  bad "Constitution missing UI usability Definition-of-Done gate"
  parity_ok=0
fi
if grep -qE 'adds/changes classes, constructors, fields, collaborators, or public methods' "$CMD_SRC"; then
  ok "quality orchestrator routes existing class-structure changes to architecture"
else
  bad "quality orchestrator missing existing class-structure routing signal"
  parity_ok=0
fi
if grep -qE 'Establish the Review Contract Before Judging Code' "$CMD_SRC"; then
  ok "quality orchestrator establishes requirements before code review"
else
  bad "quality orchestrator missing requirements-first review gate"
  parity_ok=0
fi
if grep -qE 'Look Here First' "$CMD_SRC"; then
  ok "quality orchestrator includes Look Here First human inspection brief"
else
  bad "quality orchestrator missing Look Here First section"
  parity_ok=0
fi
(( parity_ok )) && ok "all required skill checklists present in agents"

# ---- 3. count claims -----------------------------------------------------------
hdr "Count claims"
claims_ok=1
for doc in README.md install.sh; do
  while IFS= read -r n; do
    [[ -z "$n" ]] && continue
    [[ "$n" -eq "$n_agents" ]] \
      || { bad "$doc claims $n agents; $n_agents canonical runtime skills exist (stale count)"; claims_ok=0; }
  done < <(grep -ohE '[0-9]+ agent' "$SCRIPT_DIR/$doc" 2>/dev/null | grep -oE '^[0-9]+' | sort -u)
done
(( claims_ok )) && ok "README/install agent counts match reality ($n_agents)"
# Theme count: Themes/README claims N guides
n_themes=$(find "$SCRIPT_DIR/Resources/Themes" -maxdepth 1 -name '[0-9]*.md' | wc -l | tr -d ' ')
if grep -qE "${n_themes} cross-source|${n_themes} concept|\\*\\*${n_themes}\\*\\* per-theme|${n_themes} per-theme" \
  "$SCRIPT_DIR/Resources/Themes/README.md" "$SCRIPT_DIR/THEMES.md" 2>/dev/null; then
  ok "theme count docs mention $n_themes"
else
  warn "theme count may be stale (found $n_themes theme files) — check Themes/README + THEMES.md"
fi

# ---- 4. chapter-summary depth --------------------------------------------------
hdr "Chapter summary depth"
summary_failures="$({
  # shellcheck disable=SC2016 # awk owns these variables; Bash must not expand them.
  find "$SCRIPT_DIR/Resources/Books" -type f -name '*.md' -print0 \
    | xargs -0 awk '
      function count_sentences(text, copy, count) {
        copy = text
        gsub(/([Ee]\.[Gg]|[Ii]\.[Ee])\./, "", copy)
        gsub(/(^|[[:space:]])(vs|etc|[Mm]r|[Mm]rs|[Mm]s|[Dd]r|[Pp]rof|[Ss]r|[Jj]r)\./, " ", copy)
        gsub(/[[:upper:]]\.[[:upper:]]\./, "", copy)
        gsub(/[[:digit:]]+\.[[:digit:]]+/, "", copy)
        count = gsub(/[.!?]["*)_]*([[:space:]]|$)/, "", copy)
        return count
      }
      function flush() {
        if (chapter != "" && count_sentences(body) < 3) {
          print FILENAME ": " chapter " (" count_sentences(body) " sentences)"
        }
        chapter = ""
        body = ""
      }
      FNR == 1 { flush() }
      /^### Ch / || /^\*\*Ch [0-9]/ {
        flush()
        chapter = $0
        body = (/^\*\*Ch [0-9]/ ? $0 : "")
        next
      }
      chapter != "" && (/^### Part / || /^## /) { flush(); next }
      chapter != "" { body = body " " $0 }
      END { flush() }
    '
} 2>/dev/null)"
if [[ -n "$summary_failures" ]]; then
  while IFS= read -r failure; do bad "chapter summary below three sentences — ${failure#"$SCRIPT_DIR"/}"; done <<< "$summary_failures"
else
  n_chapters=$(grep -RhE '^(### Ch |\*\*Ch [0-9])' "$SCRIPT_DIR/Resources/Books" | wc -l | tr -d ' ')
  ok "all $n_chapters chapter summaries contain at least three sentences"
fi

# ---- 5. deployed sync ----------------------------------------------------------
check_deployed_sync() {
  local home="$1" label="$2"
  hdr "Deployed sync ($home — $label)"
  local deployed_any=0
  local f name dst
  for f in "$AGENTS_SRC"/*.md; do
    name="$(basename "$f")"
    [[ "$name" == "tutor.md" ]] && continue
    dst="$home/agents/mithril-$name"
    if [[ -f "$dst" ]]; then
      deployed_any=1
      if diff -q "$f" "$dst" >/dev/null 2>&1; then
        ok "$label: mithril-$name deployed & in sync"
      else
        warn "$label: mithril-$name deployed but DRIFTED from its canonical skill (edit skills/, then re-run install.sh for copy installs)"
      fi
    fi
  done
  if [[ -f "$home/commands/mithril.md" ]]; then
    deployed_any=1
    local expected_command
    expected_command="$(mktemp "${TMPDIR:-/tmp}/mithril-healthcheck.XXXXXX")"
    sed "s|\${CLAUDE_PLUGIN_ROOT}|$SCRIPT_DIR|g" "$CMD_SRC" > "$expected_command"
    if diff -q "$expected_command" "$home/commands/mithril.md" >/dev/null 2>&1; then
      ok "$label: mithril.md command deployed & in sync"
    else
      warn "$label: mithril.md command deployed but DRIFTED from canonical command"
    fi
    rm -f "$expected_command"
  fi
  (( deployed_any )) || warn "nothing deployed to $home — run install.sh (repository checks passed)"
}
check_deployed_sync "$CLAUDE_HOME" "Claude"
check_deployed_sync "$GROK_HOME"   "Grok"

# ---- 6. doc links --------------------------------------------------------------
hdr "Doc links"
brk=0; checked=0
while IFS= read -r f; do
  fdir="$(dirname "$f")"
  # markdown links + plain-text relative paths, both checked
  while IFS= read -r p; do
    [[ -z "$p" ]] && continue
    checked=$((checked+1))
    [[ -f "$fdir/$p" || -d "$fdir/$p" ]] || { bad "broken relative path in ${f#"$SCRIPT_DIR"/}: $p"; brk=1; }
  done < <(grep -ohE '\]\((\.{1,2}/)?[A-Za-z0-9][A-Za-z0-9/._-]*\.md|(^|[[:space:]`(])(\.\./)+[A-Za-z0-9][A-Za-z0-9/._-]*\.md' "$f" 2>/dev/null \
           | sed -E 's/^\]\(//; s/^[[:space:]`(]+//' | grep -v 'CLAUDE_PLUGIN_ROOT' | sort -u)
done < <(find "$SCRIPT_DIR" -name '*.md' \
  -not -path "$SCRIPT_DIR/.git/*" \
  -not -path "$SCRIPT_DIR/node_modules/*" \
  -not -path "$SCRIPT_DIR/instructions/*")
[[ "$brk" -eq 0 ]] && ok "all $checked relative doc paths resolve"

# ---- verdict -------------------------------------------------------------------
hdr "Verdict"
if [[ "$FAILS" -eq 0 ]]; then
  printf '%s✓ healthy%s (%d warning(s))\n' "$GRN" "$RST" "$WARNS"; exit 0
else
  printf '%s✗ %d problem(s)%s, %d warning(s)\n' "$RED" "$FAILS" "$RST" "$WARNS"; exit 1
fi
