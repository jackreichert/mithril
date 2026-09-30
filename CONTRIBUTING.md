# Contributing

## Project layout

The framework keeps **one canonical definition** for every runtime specialist: `skills/*.md`.

```text
skills/code-quality.md ──── Claude/Grok plugin manifests (direct path)

claude/commands/mithril.md ──── the `/mithril` orchestrator, loaded by the plugin
```

| Layer | Location | Purpose |
| --- | --- | --- |
| Canonical | `skills/*.md` | Source-grounded runtime prompt and sole content source. |
| Orchestrator | `claude/commands/mithril.md` | Routes specialists and remains a separate command artifact. |

Install via the plugin marketplace (`.claude-plugin/plugin.json`, `.grok-plugin/plugin.json`) — the standard mechanism for each tool. There is no separate deploy step; the plugin loads `skills/*.md` and `claude/commands/mithril.md` directly.

When adding or renaming a skill, update both plugin manifests' `agents` lists by hand — there is no longer an automated parity check.

## Workflows

### Editing skill content (canonical `.md` files)

Prompts carry load-bearing rules only (thresholds, heuristics, tool steps, confidence/severity, output format), not restated canon. Every agent uses the shared vocabulary — `[CRITICAL]/[IMPORTANT]/[MINOR]` and `Verdict: SHIP IT / NEEDS WORK / SIGNIFICANT ISSUES` — which `healthcheck.sh` enforces.

1. Edit the canonical file, for example `skills/code-quality.md`.
2. Run `bash healthcheck.sh`.
3. The plugin loads `skills/*.md` directly, so the edit is live on next invocation — no redeploy step.

### Editing the orchestrator

Edit `claude/commands/mithril.md` directly. The plugin loads it live; no redeploy step.

## Drift caution

`healthcheck.sh` fails when routing or contracts drift from canonical skills.

## Adding a new agent

1. Add the canonical runtime `.md` under `skills/`, including agent frontmatter.
2. Add `./skills/<name>.md` to both plugin manifests.
3. Update `claude/commands/mithril.md` to route the new aspect.
4. Update `README.md` (skills table) and `Copilot-Integration.md` (file layout).
5. If a Copilot prompt is wanted, add `copilot/prompts/mithril-accessibility.prompt.md` mirroring an existing one.

## CI

Every PR runs `.github/workflows/ci.yml`:

- **shellcheck** on `healthcheck.sh` and the other repo shell scripts.

Keep them shellcheck-clean. If you add a new shell script, add it to the workflow.

## Coding conventions for the scripts

- Bash only (no zsh-isms). Both macOS bash 3.2 and modern bash 5.x must work.
- Use `set -euo pipefail` at the top.
- Use `|` as the sed delimiter to avoid escaping `/` in paths.
- Idempotent: re-running with no underlying changes must produce zero writes.
