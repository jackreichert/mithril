---
name: mithril
description: Code quality skillset for Codex. Use when asked to review a diff or project for correctness, maintainability, architecture, tests, security, delivery, persistence, concurrency, distributed-systems risks, patterns, refactoring, specification quality, numeric gates, or to tutor/explain the code-quality canon from this repository.
---

# Code Quality

Use this skill as the Codex-native entrypoint for the Mithril canon. Keep the canonical long-form guidance in the repository's `skills/*.md` files; load only the documents needed for the user's request.

## Workflow

1. Identify the user's mode:
   - **Review**: inspect a diff, staged changes, a branch, or specific files.
   - **Gates**: run lint, complexity, duplication, coverage, mutation, or related objective checks.
   - **Write-time guidance**: apply `CONSTITUTION.md` while implementing.
   - **Tutor**: explain a principle, trade-off, or source-backed theme.
2. Resolve the repository root before reading references. This skill is normally installed as a symlink from `~/.codex/skills/mithril` to `codex/skills/mithril`; if needed, use `readlink ~/.codex/skills/mithril` or `pwd -P` from the skill directory, then go three parents up to the repo root.
3. Gather fresh project context before reviewing: changed files, nearby conventions, reuse surfaces, tests, and dependency boundaries.
4. Report findings first, ordered by severity. Prefer high-confidence bugs and risks over broad style commentary.
5. For implementation tasks, apply the Constitution while writing and then verify with the narrowest meaningful tests and gates.

## Reference Routing

Read only what the task needs:

| Need | Reference |
|------|-----------|
| Always-on write discipline, conflict precedence, Definition of Done | `<repo>/CONSTITUTION.md` |
| General code readability, names, functions, complexity, error handling | `<repo>/skills/code-quality.md` |
| Review process, finding format, confidence scoring | `<repo>/skills/review.md` |
| Architecture, dependencies, SOLID, resilience, DDD | `<repo>/skills/architecture.md` |
| Behavior-preserving cleanup or Fowler-style refactor planning | `<repo>/skills/refactor.md` |
| Test design, test smells, coverage expectations | `<repo>/skills/test-quality.md` |
| Security, secrets, OWASP/CWE/ASVS checks | `<repo>/skills/security-review.md` |
| Delivery, CI/CD, migrations, feature flags, observability | `<repo>/skills/delivery.md` |
| Distributed boundaries, latency, idempotency, partial failure | `<repo>/skills/distributed.md` |
| Threads, async, races, visibility, deadlocks | `<repo>/skills/concurrency.md` |
| Design pattern fit and anti-patterns | `<repo>/skills/patterns.md` |
| ORM, repositories, transactions, N+1, migrations | `<repo>/skills/persistence.md` |
| Objective numeric gates and tool thresholds | `<repo>/skills/gates.md` |
| Acceptance criteria, Gherkin, Specification by Example | `<repo>/skills/specification.md` |
| Planning/process discipline | `<repo>/skills/process.md` |
| Teaching concepts from the canon | `<repo>/skills/tutor.md` |

For source-backed explanation or deeper nuance, follow links from the selected skill file into `<repo>/Resources/Themes/` or `<repo>/THEMES.md`.

## Review Scope

If the user does not specify files:

1. If in a git repo, prefer staged changes with `git diff --cached`; if empty, use `git diff`.
2. On a feature branch, compare against the closest available long-lived base (`develop`, `staging`, `main`) when a full branch review is requested.
3. If there is no diff, ask for the files or directories to review.

Exclude generated artifacts, lockfiles, build output, vendored dependencies, binaries, and minified assets unless the user explicitly asks about them.

## Output Standards

For reviews:

- Lead with findings, ordered by severity.
- Include file and line references.
- Explain the concrete risk and a targeted fix.
- State when no issues are found, plus any test or verification gaps.

For implementation:

- Keep changes small and behavior-preserving unless the user asked for behavior change.
- Add or update tests for relied-on behavior.
- Run relevant verification and summarize what passed or could not be run.
