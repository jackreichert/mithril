# Contributing

## Project layout

The framework keeps **one canonical definition** for every runtime specialist: `skills/*.md`.

```text
skills/code-quality.md ──┬── Claude/Grok plugin manifests (direct path)
                         ├── ~/.claude/agents/mithril-code-quality.md (symlink)
                         └── ~/.grok/agents/mithril-code-quality.md (symlink)

claude/commands/mithril.md ──── ~/.claude/commands/ and ~/.grok/commands/
```

| Layer | Location | Purpose |
| --- | --- | --- |
| Canonical | `skills/*.md` | Source-grounded runtime prompt and sole content source. |
| Deployed | `~/.claude/agents/`, `~/.grok/agents/` | Direct links to `skills/` by default, or frozen copies with `--copy-agents`. |
| Orchestrator | `claude/commands/mithril.md` | Routes specialists and remains a separate command artifact. |

## The two scripts

- **`install.sh`** deploys canonical skills under host-compatible `mithril-*` names. Live links are the default; use `--copy-agents` for a frozen install.
- **`bundle.sh`** is a legacy-named parity check that verifies both plugin manifests list every canonical runtime skill.

## Workflows

### Editing skill content (canonical `.md` files)

1. Edit the canonical file, for example `skills/code-quality.md`.
2. Run `bash bundle.sh --check` and `bash healthcheck.sh`.
3. Symlink installs update immediately. Re-run `bash install.sh --copy-agents` for frozen installs.

Do not edit deployed `~/.claude/agents/` / `~/.grok/agents/` files. They point to or copy canonical skills.

### Editing the orchestrator

Edit `claude/commands/mithril.md` directly, then run `bash install.sh` to redeploy it.

## Drift caution

`healthcheck.sh` and `bundle.sh --check` fail when routing, contracts, or plugin manifests drift from canonical skills. Copy installs can still become stale; redeploy after canonical changes.

## Adding a new agent

1. Add the canonical runtime `.md` under `skills/`, including agent frontmatter.
2. Add `./skills/<name>.md` to both plugin manifests.
3. Update `claude/commands/mithril.md` to route the new aspect.
4. Run `bash install.sh` to deploy.
5. Update `README.md` (skills table) and `Copilot-Integration.md` (file layout).
6. If a Copilot prompt is wanted, add `copilot/prompts/mithril-accessibility.prompt.md` mirroring an existing one.

## CI

Every PR runs `.github/workflows/ci.yml`:

- **shellcheck** on `install.sh` and `bundle.sh`
- **install smoke test** — tests copy and symlink installs in temporary Claude/Grok homes

Keep both scripts shellcheck-clean. If you add a new shell script, add it to the workflow.

## Coding conventions for the scripts

- Bash only (no zsh-isms). Both macOS bash 3.2 and modern bash 5.x must work.
- Use `set -euo pipefail` at the top.
- Use `|` as the sed delimiter to avoid escaping `/` in paths.
- All install mutations honor dry-run; compatibility links are idempotent.
- Idempotent: re-running with no underlying changes must produce zero writes.
