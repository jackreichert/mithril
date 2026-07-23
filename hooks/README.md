# Git Hooks — enforce the gates, don't just advise

The `/quality` agents and the `/quality gates` runner are *invoked*. This hook makes a fast subset of the gates *automatic*: it runs on every `git commit` and **blocks the commit** when staged code breaches a threshold. It's the difference between catching problems and preventing them — the write-time enforcement the [Constitution](../CONSTITUTION.md) (Article VII) describes.

It is **opt-in**. Nothing here is installed by `install.sh`. You enable it per-repo, deliberately.

## What `pre-commit` checks

Only the *fast* gates — the ones cheap enough to run on every commit:

- **Lint** — zero errors, per detected language (eslint, ruff/flake8, golangci-lint, rubocop, clippy).
- **Cyclomatic complexity** — hard cap (default 15) via [`lizard`](https://github.com/terryyin/lizard), which covers every supported language with one tool.

Coverage and mutation are **deliberately excluded** — too slow for a commit hook. Run those via `/quality gates` or in CI.

A missing tool is **skipped with an install hint**, never a failure. The hook blocks only on a real violation reported by a tool that *is* installed — so it's safe to enable even in a repo where not every linter is set up yet.

## Install (per repo)

From the root of the repo you want to protect:

```bash
# Symlink (recommended — picks up future updates automatically)
ln -s /absolute/path/to/Code-Quality-Skills/hooks/pre-commit .git/hooks/pre-commit

# …or copy (frozen at install time)
cp /absolute/path/to/Code-Quality-Skills/hooks/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

> Replace `/absolute/path/to/Code-Quality-Skills` with wherever you cloned this repo.

### Using a hooks manager?

If the repo uses [`pre-commit`](https://pre-commit.com) (the framework) or Husky, add this script as a local hook entry instead of symlinking into `.git/hooks`, so it composes with the team's existing hooks.

## Escape hatches

```bash
git commit --no-verify                 # bypass ALL hooks (native git)
QUALITY_GATES_SKIP=1 git commit ...     # bypass just this gate
```

Use them sparingly — a bypassed gate is an undocumented exception, which the Constitution's Definition of Done (Article VIII) asks you to avoid.

## Tuning

| Env var | Default | Meaning |
|---------|---------|---------|
| `QG_COMPLEXITY_MAX` | `15` | Cyclomatic-complexity hard cap |
| `QUALITY_GATES_SKIP` | `0` | Set `1` to skip the gate for one commit |

For the full set of thresholds (including the slow gates) and per-project overrides via `quality-gates.toml`, see [`skills/gates.md`](../skills/gates.md).

## Recommended install hints

| Tool | Install |
|------|---------|
| lizard (complexity, all languages) | `pip install lizard` |
| eslint (JS/TS) | `npm i -D eslint` |
| ruff (Python) | `pip install ruff` |
| golangci-lint (Go) | `brew install golangci-lint` |
| rubocop (Ruby) | `gem install rubocop` |
| clippy (Rust) | `rustup component add clippy` |
