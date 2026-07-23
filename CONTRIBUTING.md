# Contributing

## Project layout

The framework keeps **three copies** of every agent definition. Each copy serves a different purpose and they are kept in sync by two scripts.

```
canonical (skills/)              tokenized bundle (repo)         deployed (user machine)
─────────────────────────        ─────────────────────────       ─────────────────────────
skills/code-quality.md                                           ~/.claude/agents/  AND
skills/architecture.md           claude/agents/                    ~/.grok/agents/
skills/refactor.md   ───────►      quality-code-quality.md ──►     quality-code-quality.md
skills/review.md                   quality-architecture.md          ...
... 18 total                       ... 18 total
                                 claude/commands/                 ~/.claude/commands/  AND
                                   quality.md             ──►       ~/.grok/commands/quality.md
```

| Layer | Location | Purpose | Path placeholder |
|---|---|---|---|
| Canonical | `skills/*.md` | Human-readable source of truth for skill content. Cite-friendly, source-grounded. Read by humans and by agents (referenced from each agent's prompt). | n/a |
| Bundle | `claude/agents/quality-*.md`, `claude/commands/quality.md` | What `install.sh` ships (and what Claude/Grok plugins load via `.claude-plugin/` / `.grok-plugin/`). Identical to deployed except every reference to the canonical dir is the literal token `${CLAUDE_PLUGIN_ROOT}` (resolved by Claude Code and Grok when installed as a plugin; Grok also exposes `GROK_PLUGIN_ROOT`). | `${CLAUDE_PLUGIN_ROOT}` |
| Deployed | `~/.claude/agents|commands/` and `~/.grok/agents|commands/` | What Claude Code and Grok load in classic-install mode. Token replaced with the absolute path to wherever the user cloned the repo. | `/Users/.../code-quality-agents` |

## The two scripts

- **`install.sh`** — bundle → deployed. Substitutes `${CLAUDE_PLUGIN_ROOT}` with the absolute path. Runs idempotently (skips files already up to date). See `bash install.sh --help`.
- **`bundle.sh`** — deployed → bundle. The inverse: substitutes the absolute path back to `${CLAUDE_PLUGIN_ROOT}` and writes into `claude/`. Run this after editing an agent in place under `~/.claude/`. See `bash bundle.sh --help`.

## Workflows

### Editing skill content (canonical `.md` files)

1. Edit the canonical file (e.g. `skills/code-quality.md`).
2. If the change affects the agent prompt itself (not just reference material), mirror the change into the matching `claude/agents/quality-*.md` file. The bundle is the agent prompt; the canonical file is the citation-rich human reference. They overlap in spirit but are not literally identical.
3. Run `bash install.sh` to redeploy.

### Editing an agent in place (live, under `~/.claude/agents/`)

1. Edit `~/.claude/agents/quality-foo.md` directly — fastest path while iterating.
2. Run `bash bundle.sh` to capture the change in the repo bundle.
3. Review with `git diff claude/`.
4. Commit.

### Editing the orchestrator

The orchestrator (`claude/commands/quality.md`) has few `${CLAUDE_PLUGIN_ROOT}` references but the same flow applies — edit live, run `bundle.sh` to capture, commit.

## Drift caution

If you edit only one of the three layers and skip the sync step, the others diverge silently. The CI smoke test catches *deployment* drift (does install.sh still produce a working `~/.claude/`?) but not *content* drift (do the canonical and bundled agent prompts agree?). Always run `bundle.sh` or `install.sh` after a hand edit, and skim the resulting `git diff` before committing.

## Adding a new agent

1. Add the canonical `.md` under `skills/` (e.g. `skills/accessibility.md`).
2. Create `claude/agents/quality-accessibility.md` with the agent frontmatter and prompt body. Reference the canonical file via `${CLAUDE_PLUGIN_ROOT}/skills/accessibility.md`.
3. Update `claude/commands/quality.md` to route the new aspect.
4. Run `bash install.sh` to deploy.
5. Update `README.md` (skills table) and `Copilot-Integration.md` (file layout).
6. If a Copilot prompt is wanted, add `copilot/prompts/quality-accessibility.prompt.md` mirroring an existing one.

## CI

Every PR runs `.github/workflows/ci.yml`:

- **shellcheck** on `install.sh` and `bundle.sh`
- **install smoke test** — runs `install.sh --dry-run` then a real install into temp `--claude-home` and `--grok-home`, asserts the agents and the orchestrator land on both hosts and that `${CLAUDE_PLUGIN_ROOT}` got substituted

Keep both scripts shellcheck-clean. If you add a new shell script, add it to the workflow.

## Coding conventions for the scripts

- Bash only (no zsh-isms). Both macOS bash 3.2 and modern bash 5.x must work.
- Use `set -euo pipefail` at the top.
- Use `|` as the sed delimiter to avoid escaping `/` in paths.
- All file mutations route through `install_file` / `bundle_file` so dry-run is honored uniformly.
- Idempotent: re-running with no underlying changes must produce zero writes.
