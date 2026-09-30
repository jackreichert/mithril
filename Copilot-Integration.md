# Copilot Integration

How to use the `/mithril` framework with GitHub Copilot, in addition to (or instead of) Claude Code.

## What works the same

The **canonical content** of every skill is in the markdown files under `skills/` (`skills/code-quality.md`, `skills/architecture.md`, `skills/delivery.md`, etc.). These are the source of truth for both Claude Code and Copilot integrations.

## What works differently

Claude Code and Copilot have fundamentally different mechanics:

| Feature | Claude Code | GitHub Copilot |
|---------|-------------|----------------|
| Slash commands | `/mithril` orchestrator | `/mithril-code`, `/mithril-arch`, etc. (per-skill prompts; no orchestrator) |
| Auto-routing by diff signal | Yes — orchestrator inspects `git diff` and spawns relevant agents | No — user picks the prompt |
| Parallel agent execution | Yes — agents run simultaneously, results aggregated | No — one prompt at a time |
| Custom agents (per-tool) | `~/.claude/agents/mithril-*.md` | Custom prompt files (`.prompt.md`) |
| Personal global instructions | `~/.claude/CLAUDE.md` | github.com personal instructions + VS Code user settings |
| Repo-level instructions | `CLAUDE.md` in repo root | `.github/copilot-instructions.md` or `AGENTS.md` |

The Copilot side has **less workflow automation** but the **same review content**. The trade-off: in Copilot you choose which lens to apply; in Claude Code the orchestrator chooses for you based on diff signals.

## File layout

```
mithril/
├── skills/                            # Canonical skills (source of truth)
│   └── *.md                           # 18 skill files (+ tutor.md)
├── README.md                          # Framework overview
├── .claude-plugin/ + .grok-plugin/    # manifests load skills/*.md directly
├── claude/commands/mithril.md         # /mithril orchestrator
├── copilot/
│   ├── prompts/                       # Per-skill Copilot prompts (subset may lag agents)
│   │   ├── mithril-code.prompt.md
│   │   ├── mithril-arch.prompt.md
│   │   ├── mithril-tests.prompt.md
│   │   ├── mithril-refactor.prompt.md
│   │   ├── mithril-simplify.prompt.md
│   │   ├── mithril-review.prompt.md
│   │   ├── mithril-security.prompt.md
│   │   ├── mithril-delivery.prompt.md
│   │   ├── mithril-distributed.prompt.md
│   │   └── mithril-persistence.prompt.md
│   │   # TODO: mithril-observability / accessibility / concurrency prompts
│   ├── global-instructions.md         # Paste-ready ~2.5K char snippet
│   └── AGENTS.md                      # Repo-drop-in cross-tool template
└── Copilot-Integration.md             # This file
```

**Skill inventory (canonical):** `code-quality`, `architecture`, `refactor`, `review`, `security-review`, `test-quality`, `delivery`, `distributed`, `concurrency`, `persistence`, `gates`, `observability`, `accessibility`, `usability`, `flow`, plus `tutor` (inline teaching, not a subagent).

## Setup — three layers

### Layer 1 — Personal global instructions (apply everywhere)

Two places to paste the condensed framework summary from `copilot/global-instructions.md`:

**A. github.com personal custom instructions**
1. Visit github.com → Settings → Copilot → Personal custom instructions
2. Paste the contents of the "Paste-ready text" block in `copilot/global-instructions.md`
3. Save. Now applies in github.com Copilot Chat across all repos.

**B. VS Code user settings**
1. Cmd+Shift+P → "Preferences: Open User Settings (JSON)"
2. Add the snippet from `copilot/global-instructions.md` (the "VS Code settings.json snippet" block)
3. Reload VS Code. Now applies in VS Code Copilot Chat across all workspaces.

### Layer 2 — Per-skill prompt files (selective deep review)

Make the 12 prompt files available globally in VS Code:

```json
// In user settings.json
{
  "chat.promptFiles": true,
  "chat.promptFilesLocations": {
    "<path-to-this-repo>/copilot/prompts": true
  }
}
```

Then in any VS Code workspace, in Copilot Chat, type:
- `/mithril-code` — naming, smells, FP, error handling
- `/mithril-arch` — SOLID, dependency direction, resilience patterns
- `/mithril-tests` — F.I.R.S.T., mutation, property-based
- `/mithril-refactor` — Fowler moves + WELC dependency-breaking
- `/mithril-simplify` — light behavior-preserving cleanup
- `/mithril-review` — confidence-scored review (Google priority order)
- `/mithril-security` — OWASP Top 10:2021 systematic
- `/mithril-delivery` — CD pipeline + 12-Factor + DORA
- `/mithril-distributed` — Waldo's four differences + microservices
- `/mithril-persistence` — PEAA + N+1 + transactions + migrations

### Layer 3 — Per-repo AGENTS.md (cross-tool consistency)

Drop `copilot/AGENTS.md` into a repo's root (rename per the repo's needs). Tools that read it (Claude Code, Cursor, Continue, recent Copilot versions) will use it as repo-level context.

If a tool reads only its own format:
- Claude Code: `cp AGENTS.md CLAUDE.md`
- Copilot: `cp AGENTS.md .github/copilot-instructions.md`

A symlink works if the repo allows.

## Verifying the setup

**Claude Code:**
```bash
/plugin
# confirm mithril is installed and enabled, then in a repo: /mithril
```

**Copilot (VS Code):**
```bash
ls <path-to-this-repo>/copilot/prompts/  # 12 .prompt.md files
# In VS Code Chat: type "/" — should see /mithril-code, /mithril-arch, etc.
```

**Copilot (github.com):**
- Open any PR in github.com
- Click "Files changed" → "..." → "Review with Copilot"
- The review should reflect the framework's priority order

## Workflow recommendations

**For Claude Code (preferred when available):**
- Default: `/mithril` before each commit. Auto-routing covers the common case.
- Targeted: `/mithril persistence delivery` when touching schema. `/mithril distributed arch` when touching service-to-service code.

**For Copilot (when working in VS Code without Claude Code, or in github.com PR review):**
- Default: rely on Layer 1 global instructions for ambient guidance during code generation and review.
- Targeted: invoke a specific prompt (`/mithril-code`, `/mithril-arch`) when you want a focused audit on the open file or selection.
- For a full review: walk through the prompts you'd combine in Claude Code (e.g., for a schema change, run `/mithril-persistence` then `/mithril-delivery` separately).

**For github.com Copilot PR review:**
- Layer 1 global instructions apply automatically. The PR review will reflect the framework priorities.
- For deeper review on specific files, switch to local VS Code with the prompt files configured.

## Limitations honest about

- **No parallel orchestration in Copilot.** Claude Code's `/mithril` runs 5+ agents in parallel and aggregates; Copilot runs one prompt at a time. Reviewing a complex change is more manual.
- **No git-diff awareness in Copilot Chat by default.** Prompts work on the current file or selection. To review a diff, paste it into chat or use the Source Control view's Copilot integration.
- **Tool augmentation is unavailable in Copilot prompts.** Where a Claude Code agent could run `semgrep`, `bandit`, `npm audit`, etc., Copilot Chat can only suggest the user run them. The security prompt handles this by calling out which scanners would augment its findings.
- **No model-of-modes routing in Copilot.** Claude Code's `/mithril refactor` (Mode 2) vs `/mithril simplify` (Mode 1) is split into two distinct prompt files.

These are inherent to Copilot's architecture, not gaps in this framework.

## Maintenance

When canonical skills (`skills/code-quality.md`, `skills/architecture.md`, etc.) are updated:
1. The Claude/Grok plugin installs load `skills/` directly, so the edit is live on next invocation.
2. Mirror relevant changes to the corresponding Copilot prompt file (`copilot/prompts/mithril-*.prompt.md`).
3. If the change affects high-level priorities or stance, update `copilot/global-instructions.md` and `copilot/AGENTS.md`.

Claude and Grok plugin manifests load canonical skills directly; there is no second agent-content directory.
