---
description: "Code quality framework — runs targeted quality agents against your current git diff or full project. Usage: /mithril [aspects] | /mithril project [path] [aspects] | /mithril deep [path] (file→method→flow pass)"
argument-hint: "[project [path]] [deep] [code] [arch] [refactor] [tests] [security] [simplify] [process] [delivery] [distributed] [concurrency] [patterns] [persistence] [perf] [observability] [a11y] [gates] [spec] — or omit for all"
allowed-tools: ["Bash", "Glob", "Grep", "Read", "Task"]
---

# Quality Framework

Run quality agents against the current git diff or the full project. Spawn relevant agents in parallel, then aggregate findings into a prioritized action plan.

**Requested aspects:** "$ARGUMENTS"

**Host-agnostic spawning.** This orchestrator runs first-class on **Claude Code** and **Grok Build**. When examples say `Task(...)`, use the host's subagent spawn tool:
- **Claude Code** → `Task` tool (`subagent_type`, `prompt`, `description`)
- **Grok** → `spawn_subagent` tool (same fields: `subagent_type`, `prompt`, `description`; set `background: true` when launching several in parallel)

Agent type names (`mithril-code-quality`, `mithril-architecture`, …) are identical on both hosts. Read/Grep/Glob/Bash in agent prompts mean the host's equivalent read/search/list/shell tools.

---

## Step 1 — Get the Diff (or Project Files)

**Check for project mode first.** If `project` appears anywhere in `$ARGUMENTS`, skip the diff and jump to **Case C** below.

**Check for deep mode too.** If `deep` (or its alias `trace`) appears anywhere in `$ARGUMENTS`, resolve the scope using Cases A–C exactly as below (diff / feature-branch / project), then follow the **Deep Mode** section instead of Steps 2–5. `deep` and `project` combine — `/mithril deep project src/` does a deep traversal scoped to a subtree. `deep`/`trace` are mode keywords, not aspects, so Step 2 ignores them.

Otherwise, check we're in a git repo:
```bash
git rev-parse --is-inside-work-tree 2>/dev/null
```

**If not a git repo:** ask the user which files or directories to review explicitly. Skip the diff steps and pass file paths directly to agents.

**If in a git repo:** detect the current branch and pick the right diff scope.

```bash
git rev-parse --abbrev-ref HEAD
```

### Case A — On `main`, `staging`, or `develop` (long-lived branches)

Review what's about to be committed. In priority order:

```bash
git diff --cached                    # staged
git diff --cached --name-only
```

If empty, fall back to working tree:
```bash
git diff
git diff --name-only
git status --short
```

If still empty, ask the user which files to review.

### Case B — On a feature branch (anything else)

Review the entire branch's work since it forked, plus any uncommitted changes on top.

**Find the true base branch.** Don't just take the first long-lived branch that exists — that picks `develop` even when the branch actually forked from `main`, over-including unrelated commits. Instead, resolve each candidate to a ref, compute its `merge-base` with HEAD, and choose the branch whose fork point is **closest to HEAD** (the fewest commits between the fork and HEAD). That is, by definition, the branch this one diverged from most recently. Prefer the remote ref (`origin/<branch>`) since the local copy may be stale; fall back to the local ref. The priority order `develop` → `staging` → `main` is only the **tie-breaker** when two candidates fork at the same commit.

```bash
# Resolve each candidate to a usable ref (prefer origin), then pick the closest fork.
parent=""; fork=""; best=-1
for base in develop staging main; do
  ref=""
  if git rev-parse --verify --quiet "origin/$base" >/dev/null; then ref="origin/$base"
  elif git rev-parse --verify --quiet "$base"        >/dev/null; then ref="$base"
  fi
  [ -z "$ref" ] && continue
  [ "$ref" = "$(git rev-parse --abbrev-ref HEAD)" ] && continue   # skip self
  mb=$(git merge-base HEAD "$ref") || continue
  ahead=$(git rev-list --count "$mb"..HEAD)                       # commits HEAD is ahead of the fork
  # Closest fork = smallest "ahead". First candidate in priority order wins ties.
  if [ "$best" -lt 0 ] || [ "$ahead" -lt "$best" ]; then
    best=$ahead; parent="$ref"; fork="$mb"
  fi
done
echo "Base branch: ${parent:-<none found>} (fork: ${fork:-?}, HEAD is $best commits ahead)"
```

**Build the diff** — all commits on the branch + uncommitted working-tree changes:

```bash
git diff "$fork"...HEAD              # branch commits since fork
git diff "$fork"...HEAD --name-only
git diff                             # uncommitted on top
git diff --name-only
git status --short
```

The combined file list (branch commits ∪ working tree) feeds Step 2's auto-selection. The combined diff content feeds Step 4's agents.

**If no parent candidate exists** (rare — fresh repo, detached HEAD, exotic setup): fall back to Case A's logic and warn the user that fork-point detection failed.

**Edge case — feature-on-feature branches.** The closest-fork rule only ranks the long-lived candidates (`develop`/`staging`/`main`), so a branch cut from another *feature* branch (`feature/x` off `feature/y`) still diffs against the nearest long-lived ancestor and includes `feature/y`'s commits. State the detected base in the Step 3 plan (`Base branch: …`) so the user can catch a wrong base; if it looks off, ask them to confirm or pass the intended base explicitly.

### Case C — Project mode (`project` in $ARGUMENTS)

Review all tracked source files in the repo, or a scoped subdirectory.

**Extract path scope:** scan `$ARGUMENTS` tokens for any that start with `.`, `/`, or contain `/` — that token is the path scope. If none found, default to repo root (`.`).

**Extract aspect keywords:** all remaining tokens (excluding `project` and the path) are the aspect filter for Step 2.

```bash
# List all git-tracked files under the scope
git ls-files <path>
```

**Filter the file list** — exclude the following before passing to agents:

| Exclude pattern | Reason |
|----------------|--------|
| `*.min.js`, `*.min.css` | Minified — unreadable |
| `*.lock`, `package-lock.json`, `yarn.lock`, `Pipfile.lock`, `poetry.lock` | Generated — no signal |
| `dist/`, `build/`, `out/`, `.next/`, `__pycache__/`, `.cache/` | Build output |
| `node_modules/`, `vendor/`, `.venv/`, `venv/` | Dependencies — not your code |
| `*.png`, `*.jpg`, `*.gif`, `*.webp`, `*.svg`, `*.ico`, `*.woff`, `*.woff2`, `*.ttf`, `*.pdf`, `*.zip` | Binary / assets |
| `*.map` | Source maps |

Warn the user if the filtered list exceeds 100 files, and offer to narrow by passing a subdirectory path.

**In project mode:** agents receive the filtered file list (not a diff). Agents use their own Read/Grep/Glob tools to inspect the files. In Step 4, pass `"mode: project-wide review — read the listed files in full"` instead of diff content.

**Diff-size guard (all diff-mode cases).** After building the diff, count its changed lines (`git diff --shortstat` insertions + deletions). If it exceeds **~1,500 changed lines**, warn the user that review quality degrades on oversized diffs and offer to (a) narrow to a subdirectory, (b) review per-directory in sequence, or (c) proceed anyway. Never silently truncate the diff.

---

## Step 1.5 — Establish Project Context (reuse surface)

Gather a small, **fresh** snapshot of the codebase so agents can judge whether a change *fits* — not just whether the changed lines read well in isolation. This closes the diff's two structural blind spots: **naming** (needs the surrounding domain) and **reuse / placement** (needs the rest of the repo). Computed every run; **never written to disk** — a stored map goes stale on exactly the untouched code where reuse lives, and becomes a confident liar.

Keep it cheap and bounded:

1. **Locate the reuse surface** — where shared / general-purpose code already lives:
   ```bash
   git ls-files | grep -iE '(^|/)(utils?|helpers?|shared|common|lib|core)(/|\.)' | head -50
   ```
   For the directories found, list their files so agents know where a reusable function *would* go.

2. **Sample naming conventions** — note the local style near the changed files (casing, suffixes, domain vocabulary). Agents do the deep read; here just capture the convention so "is this name generic?" has a baseline.

3. **Note the directory shape** — top-level layout (feature-oriented vs. framework-oriented), so "where should this live?" has an answer.

Assemble a compact **Project Context** block (a dozen lines, not an inventory). If the repo is large, cap the reuse-surface listing and say so. Pass this block into **every** agent prompt in Step 4.

> This is the **ephemeral reuse-surface scan**, not a persistent codebase map — gathered fresh each run and discarded. A stored map updated only on review passes goes stale on exactly the untouched code where reuse lives, and becomes a confident liar.

---

## Step 1.6 — Establish the Review Contract Before Judging Code

*Sources: Specification by Example (Adzic), BDD (North), The Cucumber Book, The Clean Coder ch.7, Code Complete ch.3.*

A reviewer cannot conclude that code is correct without first knowing the behavior it is meant to implement or preserve. Do this before selecting or spawning code-review agents.

1. **Classify the change.**
  - **Behavior-affecting:** adds or changes user-visible behavior, business rules, API contracts, persistence semantics, authorization, error outcomes, or operational behavior.
  - **Behavior-preserving:** refactor, rename, cleanup, internal reorganization, or mechanical migration whose contract is that observable behavior remains unchanged.
2. **Gather requirement evidence without inventing it.** Look in the provided request/context and changed or nearby tracked files for acceptance criteria, `.feature` files, stories, ADRs, behavior-named tests, API schemas, bug reproductions, or documented invariants. The implementation itself is not evidence of what the requirement should have been.
3. **Write a compact Review Contract.**
  - State the business/user goal or preserved invariant.
  - For behavior-affecting changes, list the minimal **key examples** that distinguish the rule and its boundaries: `Given` relevant state, `When` one event occurs, `Then` a definite observable outcome follows.
  - Include the important failure/boundary examples, not every combination. Keep scenarios declarative; do not encode clicks, selectors, internal calls, or implementation choices.
  - Gherkin is a useful shared grammar; a committed Cucumber suite is warranted when these examples should become executable living documentation. Do not require Cucumber for every branch or confuse tool adoption with collaborative requirements discovery.
4. **Validate before reviewing implementation.**
  - If the evidence is sufficient and internally consistent, label the contract `CONFIRMED FROM REPO/REQUEST` and cite its sources.
  - If key behavior is missing, contradictory, or requires a product decision, label it `UNCONFIRMED`, present the smallest set of clarifying questions or candidate scenarios, and **stop before issuing code-correctness findings or a ship verdict**. Ask the user/product owner to confirm; never reverse-engineer intended behavior from the diff.
  - You may still report requirement-independent facts (for example, an exposed secret or definite data race), but clearly state that functional correctness was not reviewable.
5. **Review the specification first when one exists.** Spawn `mithril-specification` before the code agents. If it reports a Critical ambiguity or untestable outcome, stop and clarify. Otherwise, include the confirmed Review Contract and specification findings in every Step-4 agent prompt so each reviewer judges the same intended behavior.
6. **Validate executable examples.** If the repository already has acceptance scenarios and a documented narrow command for them, run it before the final verdict. A feature file that is never executed is documentation, not a living specification.

This gate is intentionally proportional: a typo or behavior-preserving rename needs a one-line preserved-behavior contract; a new billing rule needs collaboratively validated key examples. The Three Amigos conversation (business, development, testing) is the source of truth. Gherkin records that conversation; it does not replace it.

---

## Step 2 — Determine Applicable Agents

Parse `$ARGUMENTS` for aspect keywords:
- `code` → mithril-code-quality
- `arch` or `architecture` → mithril-architecture
- `refactor` → mithril-refactor (Mode 2: full refactor plan)
- `simplify` → mithril-refactor (Mode 1: light simplify pass)
- `tests` or `test` → mithril-test-quality
- `security` → mithril-security-review
- `review` → mithril-review (confidence-scored review with PR lenses)
- `process` → mithril-process
- `delivery` or `deploy` → mithril-delivery
- `distributed` or `dist` → mithril-distributed
- `concurrency` or `concurrent` or `threads` or `async` → mithril-concurrency (in-process: races, locks, visibility, deadlock, async/event-loop)
- `patterns` or `pattern` → mithril-patterns
- `persistence` or `db` or `database` → mithril-persistence
- `perf` or `performance` or `latency` → mithril-performance (USE method, query cost, measure-then-change)
- `observability` or `o11y` or `telemetry` or `slo` → mithril-observability (golden signals, traces, SLOs, alert hygiene)
- `a11y` or `accessibility` or `wcag` → mithril-accessibility (WCAG 2.2 AA UI review)
- `usability` or `ux` → mithril-usability (task clarity, hierarchy, navigation, recovery, and user-testing evidence)
- `gates` → mithril-gates (runs tools — lint, complexity, duplication, coverage, mutation — for pass/fail vs thresholds)
- `spec` or `specification` → mithril-specification (acceptance-criteria / BDD feature-file quality)
- `flow` or `flows` → mithril-flow (trace control + data flow from entry points to sinks; taint, error propagation, resource/transaction lifecycle, N+1-across-chain)
- `tutor` or `learn` → **Tutor Mode** — teaches the CS principle/theme, or the principles at play in a diff. Does NOT spawn a review agent or aggregate findings; runs inline and conversational (see the Tutor Mode section). It explains; it does not review or fix.
- No arguments / `all` → run all applicable agents (see rules below)

**Note on simplify routing:** `mithril-refactor` now handles both modes. Mode is selected by the aspect keyword: `simplify` → Mode 1 (light), `refactor` → Mode 2 (full plan). The existing `code-simplifier` agent is no longer routed by this orchestrator.

**Auto-selection rules (when no arguments provided)**

In **diff mode**, these rules use signals detectable from `git diff --name-only` and the diff content itself.
In **project mode**, signals come from the filtered file list (extensions, directory names, file name patterns).

| Detectable signal | Agent to run |
|-------------------|-------------|
| Any source files present | mithril-code-quality (always) |
| New files added (`A` in `git status`) OR diff touches imports/dependencies OR adds/changes classes, constructors, fields, collaborators, or public methods — *project mode: any source files* | mithril-architecture |
| Test files in diff (`*.test.*`, `*.spec.*`, `*_test.*`, `test_*.py`) — *project mode: same patterns in file list* | mithril-test-quality |
| Files in auth/payment/api paths OR diff touches input handling, sessions, secrets — *project mode: same path patterns in file list* | mithril-security-review |
| Migration files (`migrations/`, `db/migrate/`, `alembic/`, `prisma/migrations/`) OR Dockerfiles, k8s manifests, CI/CD configs (`.github/workflows/`, `.gitlab-ci.yml`, `Jenkinsfile`) OR feature-flag config OR `.env*` template changes | mithril-delivery |
| Service-to-service HTTP/gRPC calls (`axios`, `fetch`, `http.Client`, `requests`, `RestTemplate`, `grpc`) OR message-queue imports (`kafka`, `rabbitmq`, `sqs`, `pubsub`, `nats`, `eventbridge`) OR files under `services/` crossing service boundaries | mithril-distributed |
| In-process concurrency primitives in the diff — `Thread`/`Runnable`/`ExecutorService`/`goroutine`/`go func`, `synchronized`/`Lock`/`Mutex`/`RLock`, `volatile`/`Atomic*`/`compare-and-set`, `async`/`await`/`Promise.all`/`asyncio`/coroutines, thread pools, or shared mutable statics/singletons/caches written from concurrent paths — *project mode: same primitives in file content* | mithril-concurrency |
| ORM imports (`hibernate`, `sqlalchemy`, `prisma`, `typeorm`, `sequelize`, `mongoose`, `ActiveRecord`, `EntityFramework`) OR `*.sql`, `*.prisma`, schema files OR repository / DAO files OR raw SQL in diff | mithril-persistence |
| Hot-path / cost signals — nested loops over collections, new caches/pools/queues, pagination, raw SQL/`EXPLAIN`, bulk processors, serializers on request path, `Promise.all` over lists — *project mode: same patterns* | mithril-performance |
| Telemetry / ops signals — metrics/logging/tracing libraries, dashboard/alert config, OpenTelemetry, SLO/SLI mentions, new HTTP route handlers or queue consumers (ship golden signals) | mithril-observability |
| UI signals — `*.tsx`/`*.jsx`/`*.vue`/`*.svelte`, `components/`, CSS modules for interactive UI, Storybook stories | mithril-accessibility + mithril-usability |
| Behavior-affecting branch/change OR executable specs / acceptance criteria (`*.feature`, `features/`, `*.story`, Gherkin `Given`/`When`/`Then` in diff) OR a requirements/acceptance-criteria doc | mithril-specification (run first per Step 1.6) |
| After other reviews complete (always last, on recently modified code) | mithril-refactor in Mode 1 (Simplify) |

**Opt-in only — never auto-spawned:**
- `mithril-refactor` in Mode 2 (full plan) — invoke via `/mithril refactor` when smells need named refactoring moves prescribed
- `mithril-process` — invoke via `/mithril process` when reviewing planning discipline of a significant change
- `mithril-patterns` — invoke via `/mithril patterns` for pattern recognition / anti-pattern audit (auto-detection of "this should be a Strategy" is unreliable; prefer explicit invocation, often after `mithril-code-quality` finds smells)
- `mithril-review` — invoke via `/mithril review` for the full PR-style review with confidence scoring and lenses; redundant with the auto-selection above for normal pre-commit use
- `mithril-flow` — invoke via `/mithril flow` to trace execution flows on demand, or it runs automatically as Phase 2 of `/mithril deep`. Not auto-spawned in normal diff review because whole-flow tracing is heavier than per-file review; reach for it when a bug spans methods/files, or on input→sink paths in security-sensitive code.
- `mithril-gates` — invoke via `/mithril gates` to run the objective tool-measured floor (lint, complexity, duplication, coverage, mutation). Not auto-spawned because it executes tools that may not be installed; run it explicitly, in CI, or via the pre-commit hook (`hooks/`). It complements the reading agents — they judge, it measures.
- Explicit aspect keywords still force `mithril-performance` / `mithril-observability` / `mithril-accessibility` / `mithril-usability` even when auto-signals are weak.

**Suggestion behavior:** When auto-spawning produces findings, suggest follow-up agents that aren't auto-spawned:
- If `mithril-code-quality` flags multiple smells (Switch on type code, Long Method with branches, etc.) → suggest `/mithril patterns` for prescribed pattern recognition AND `/mithril refactor` for Fowler moves
- If significant changes were made → suggest `/mithril process` for planning audit
- If `mithril-distributed` flags partial-failure issues → suggest `/mithril arch` for the underlying resilience patterns
- If `mithril-performance` flags missing saturation/latency signals → suggest `/mithril observability`
- If `mithril-code-quality` flags O(n²)/N+1 → ensure `mithril-performance` ran (or suggest `/mithril perf`)
- If UI components lack keyboard/labels → ensure `mithril-accessibility` ran
- If UI hierarchy, labels, navigation, feedback, or recovery obscure an important task → ensure `mithril-usability` ran
- If `mithril-code-quality` or `mithril-distributed` flags shared mutable state, a race, a lock, or async/threads → suggest `/mithril concurrency` for the in-process interleaving review (the shared-memory counterpart to `mithril-distributed`'s cross-process review)
- If `mithril-persistence` flags N+1 or migration issues → ensure `mithril-delivery` ran (or suggest it) for migration safety

When in doubt: run `mithril-code-quality` only.

---

## Step 3 — Display Plan

Before spawning, show the appropriate header:

**Diff mode:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 QUALITY ► REVIEWING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Base branch: [detected base + fork point, feature-branch (Case B) only]
Changed files: [list from git diff --name-only]

◆ Spawning agents in parallel...
  → [agent name] — [what it checks]
  → [agent name] — [what it checks]
  ...
```

**Project mode:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 QUALITY ► PROJECT SCAN  [scope: <path>]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Files in scope: [N files across M directories]
[list first 20 files, then "...and N more"]

◆ Spawning agents in parallel...
  → [agent name] — [what it checks]
  → [agent name] — [what it checks]
  ...
```

---

## Step 4 — Spawn Agents in Parallel

**Pass the Step 1.5 Project Context block into every agent prompt, in both modes.**

**Make every finding teach.** Append this to every agent prompt: *"For each finding, include a one-clause **why** — the principle it violates and the concrete consequence — and cite the canon source when apt (e.g. `Clean Code ch.2`, `APOSD ch.4`, `Law of Demeter`). Keep it to one line. Minor findings may omit the why. The reader should come away understanding the principle, not just the patch — but do not pad: one clause, no lecture."*

**Diff mode** — pass the full diff content, the file list, and the Project Context block.

Spawn via host tool (`Task` on Claude Code, `spawn_subagent` on Grok) — same arguments:

```
Task / spawn_subagent(
  prompt="Review the following git diff for code quality issues.

  Project context (reuse surface + conventions, from Step 1.5):
  [project context block]

  Changed files: [list]

  Diff:
  [full git diff output]

  IMPORTANT — the diff is your FOCUS, not your SCOPE. Before judging, Read each
  changed file in full for surrounding context, and Grep the repo (start from the
  reuse surface above) to check whether new logic is duplicated elsewhere or belongs
  in an existing shared module. Judge whether the change FITS the codebase, not just
  whether the changed lines read well in isolation.

  Focus on: naming (in domain context), function design, code smells, reuse & placement,
  complexity, comments. Use the checklist in your instructions.",
  subagent_type="mithril-code-quality",
  description="Code quality review"
)
```

**Project mode** — pass the file list and instruct the agent to read the files itself:

```
Task / spawn_subagent(
  prompt="Project-wide code quality review.

  Project context (reuse surface + conventions, from Step 1.5):
  [project context block]

  Mode: project-wide review — read and analyze the listed files in full using your Read, Grep, and Glob tools.

  Scope: [path]

  Files to review:
  [filtered file list, one per line]

  Focus on: naming (in domain context), function design, code smells, reuse & placement,
  complexity, comments. Grep across the listed files for duplicated logic and reusable
  code in the wrong place. Use the checklist in your instructions. Prioritize findings
  that appear in multiple files or indicate systemic issues.",
  subagent_type="mithril-code-quality",
  description="Code quality project scan"
)
```

Spawn all selected agents simultaneously (parallel, not sequential).

**Scope each agent's input to its signals.** Don't broadcast the full diff to every agent when the diff is large (>~500 changed lines): pass each specialist only the hunks for the files that matched its Step-2 signal (test files → mithril-test-quality; ORM/SQL files → mithril-persistence; migration/CI files → mithril-delivery; service-boundary files → mithril-distributed; auth/input files → mithril-security-review), plus the full changed-file list for context. `mithril-code-quality` and `mithril-architecture` always receive the full diff — their judgments are cross-cutting. On small diffs, just pass everything to everyone.

**Note on simplify:** Always spawn `mithril-refactor` (Mode 1) LAST, after other reviews complete, so it polishes rather than duplicates findings. Pass `mode=simplify` in the prompt so the agent picks the correct mode.

---

## Step 5 — Aggregate Results

After all agents complete, aggregate by severity (every agent now reports Critical/Important/Minor with consistent semantics):

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 QUALITY ► RESULTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Critical — Fix Before Committing
- [agent] file:line — what; why: principle + consequence (source) → fix

## Important — Fix Before PR
- [agent] file:line — what; why: principle + consequence (source) → fix

## Minor — Worth Doing
- [agent] file:line — what → fix   (why optional — keep Minor terse)

## Strengths
- [what's done well across agents]

─────────────────────────────────────────────────

Agents run: [list] | Issues: [X critical, Y important, Z minor]
Verdict: [SHIP IT / NEEDS WORK / SIGNIFICANT ISSUES]
```

**Aggregation rules:**
- **Adjudicate before printing (false-positive gate).** For every Critical and Important finding, re-read the relevant diff hunk (or file region) yourself and confirm the issue is really there — the code does what the finding claims, and the claimed consequence is plausible on this path. Drop findings that don't survive confirmation, and report the count dropped (`Adjudicated: N findings dropped on re-read`). Minor findings pass through unadjudicated.
- **Failure scenario required at Critical/Important.** Every surviving Critical/Important finding must state the concrete failure: *given what inputs/state → what wrong outcome*. A principle citation alone ("violates SRP", "not thread-safe") is not a scenario. If neither the agent nor your adjudication re-read can articulate one, **demote the finding to Minor** — it may still be worth doing, but it can't block.
- Deduplicate findings that multiple agents flagged for the same issue — same file within **±3 lines** and a similar description counts as a duplicate (exact line-number match is not required); keep the clearest description and credit both agents
- Preserve the most severe rating when agents disagree on severity
- **Severity normalization** — different agents use different scales; normalize to Critical/Important/Minor before aggregating:

  | Agent's native scale | Mapped to |
  |---------------------|-----------|
  | Critical (CVSS) → mithril-security-review | Critical |
  | High (CVSS) → mithril-security-review | Critical |
  | Medium (CVSS) → mithril-security-review | Important |
  | Low (CVSS) → mithril-security-review | Minor |
  | All other agents (already use Critical/Important/Minor) | passthrough |

  Security findings get elevated weight: a CVSS-High vulnerability is treated as Critical for aggregation since security issues block ship more readily than other categories.

- **Conflict precedence (tie-break)** — when two agents' recommendations pull in opposite directions (e.g. mithril-code-quality wants a function split for readability while mithril-architecture wants a deep module), resolve in this fixed order, *earlier wins*: **(1) correctness → (2) security & data safety → (3) readability for the next maintainer → (4) simplicity → (5) consistency with surrounding code → (6) performance.** This is Article I of [`CONSTITUTION.md`](../../CONSTITUTION.md); cite it when you override one finding in favor of another so the trade-off is explicit.

- **If `mithril-gates` ran:** a gate `FAIL` is a hard block regardless of the reading agents' severity counts — fold each failing gate in as a Critical finding. A gates verdict of `PARTIAL` (gates green but some skipped) is surfaced as a note, not a block.

- Final verdict from normalized severity counts (post-adjudication):
  - Any Critical (including any gate `FAIL`) → `SIGNIFICANT ISSUES`
  - No Critical, **≥2 Important** (or 1 Important that is security-sourced or correctness-affecting) → `NEEDS WORK`
  - Otherwise → `SHIP IT` (a single judgment-call Important is listed for the author to weigh, not a block — the standard is *net positive*, not perfection; see `skills/review.md`)

**Suggest next steps if applicable:**
- If `mithril-code-quality` flagged smells: suggest `/mithril refactor` for prescribed moves
- If significant changes were made: suggest `/mithril process` for planning audit
- If results were strong: confirm ready to commit

---

## Deep Mode (`/mithril deep` | alias `/mithril trace`)

A deep, sequential traversal for when parallel-aspect review isn't enough — onboarding a subsystem, auditing a critical path, or scrutinizing a large feature before merge. Default `/mithril` runs one agent per *aspect* across the whole scope; **deep mode walks the code by *unit*** — file → method — then follows the **flows** that connect them, then synthesizes a single top-level summary.

Deep mode reuses **Step 1**'s scope resolution (diff / feature-branch / project). It then replaces **Steps 2–5** with the three sequential phases below.

**Guardrails — resolve before Phase 1:**
- Deep mode is expensive (it spawns per-file agents). If the in-scope file list exceeds **40 files**, warn and require a narrower scope (a path, or `deep project <path>`) or explicit confirmation to proceed.
- Apply the same **Case C exclusion table** (minified, generated, build output, dependencies, binaries) to the file list regardless of diff/project mode.

### Phase 1 — File by file, method by method

Batch the in-scope files (≤ ~6 small files per batch; 1 agent per large or complex file). For each batch, spawn `mithril-code-quality` with a method-level instruction:

```
Task / spawn_subagent(
  prompt="Deep-mode per-file review. For EACH file below, walk it method by method, top to bottom.
  For every method report:
    • purpose (one line) and its parameter/return contract
    • findings keyed to `method:line` — naming, single-responsibility, complexity,
      error handling, FP/purity, performance, and security surface
      (unvalidated input, injection sinks, secret handling)
    • the inputs it consumes and the outputs/side-effects it produces
      (DB writes, network calls, mutations) — these seed flow tracing
  Use the checklist in your instructions. Report nothing for trivial getters/setters.

  Files:
  [batch file list]",
  subagent_type="mithril-code-quality",
  description="Deep: per-file methods"
)
```

For files matching **sensitive signals** (auth/payment/api paths, input handling, secrets) also spawn `mithril-security-review` on that file. For files with **ORM/SQL signals** also spawn `mithril-persistence`. For files with **in-process concurrency signals** (threads, executors, locks/`synchronized`, `volatile`/atomics, async/await/coroutines, shared mutable statics) also spawn `mithril-concurrency`. Batches and these add-on agents run in parallel.

Collect each agent's per-method findings **and** its per-method input/output notes — the I/O notes feed Phase 2.

### Phase 2 — Trace the flows

After **all** Phase 1 agents complete, spawn the dedicated flow tracer, `mithril-flow`. It traces sources → sinks and owns the flow-level checks (taint, error propagation, resource/transaction lifecycle, cross-boundary partial failure, N+1-across-chain). Pass it the Phase 1 per-method input/output notes — they seed the trace:

```
Task / spawn_subagent(
  prompt="Deep-mode flow analysis. Trace control + data flow from each entry point to its sinks,
  one entry point at a time, using the per-method input/output notes below plus your own
  Read/Grep/Glob. Produce a flow map per entry point and the flow-level findings in your checklist.
  Per-method I/O notes from Phase 1:
  [notes]

  Entry-point hints:
  [grep results for routes/handlers/main/consumers]",
  subagent_type="mithril-flow",
  description="Deep: flow analysis"
)
```

`mithril-flow` is the right agent here — `mithril-architecture` reviews *structure* (SOLID, layering, coupling), not execution flow. If the flow map exposes structural rot on a path (a dependency cycle, a layer violation, a god module), note it and suggest a follow-up `/mithril arch` rather than asking `mithril-flow` to judge structure.

### Phase 3 — Top-level summary

The orchestrator synthesizes this itself — **do not delegate it**:

- **Flow map** — entry points → key paths → sinks (from Phase 2).
- **Findings by severity** — Critical / Important / Minor, deduplicated, using **Step 5**'s aggregation, severity-normalization, and conflict-precedence rules. Tag each finding `file:method:line`.
- **Cross-cutting flow findings** — the Phase 2 issues that span files.
- **Verdict** — same thresholds as Step 5 (any Critical → `SIGNIFICANT ISSUES`; ≥2 Important, or 1 security/correctness Important → `NEEDS WORK`; else → `SHIP IT`), applied post-adjudication.

**Detail destination — ask the user.** Before printing, ask where the granular per-file/per-method detail should land (skip the prompt if the user passed `--report`, `--inline`, or `--summary`):

| Choice | Behavior |
|--------|----------|
| **Report file** (default) | Write full per-file/per-method/flow detail to `.mithril/deep-{timestamp}.md` (create the dir; suggest adding `.mithril/` to `.gitignore` if untracked); show only the flow map + top-level summary in chat. |
| **Inline** | Print full detail, then the summary, in chat. |
| **Summary only** | Discard granular detail; show the summary alone. |

Output header:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 QUALITY ► DEEP  [scope: <path or diff>]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Flow Map
  ▸ <entry point> → … → <sink>
  ...

## Critical — Fix Before Committing
- [agent] file:method:line — description
## Important — Fix Before PR
- ...
## Minor — Worth Doing
- ...

## Cross-Cutting (flow-level)
- ...

─────────────────────────────────────────────────
Files traced: N | Flows: M | Issues: [X critical, Y important, Z minor]
Detail: [report path | inline | summary-only]
Verdict: [SHIP IT / NEEDS WORK / SIGNIFICANT ISSUES]
```

---

## Tutor Mode (`/mithril tutor` | `/mithril learn`)

The framework's teaching leg: where the review agents *catch* and the Constitution *prevents*, the tutor *explains*. Use it to learn the CS principle or theme, or to understand the principles at play in a diff.

**This mode does not spawn a sub-agent and does not produce a findings report.** Teaching is conversational — run it **inline in the main thread** so the learner can ask follow-ups. Read the teaching reference at `${CLAUDE_PLUGIN_ROOT}/skills/tutor.md` and follow its contract.

**The canon lives under `${CLAUDE_PLUGIN_ROOT}`, not the user's project.** You are running in the user's repo, but the library you teach from is the installed framework. Read `${CLAUDE_PLUGIN_ROOT}/THEMES.md`, `${CLAUDE_PLUGIN_ROOT}/Resources/`, `${CLAUDE_PLUGIN_ROOT}/skills/`, and `${CLAUDE_PLUGIN_ROOT}/CONSTITUTION.md` by that absolute path — the relative links inside `tutor.md` are repo-internal and resolve under `${CLAUDE_PLUGIN_ROOT}`.

**Resolve which sub-mode from `$ARGUMENTS`:**

- **Concept mode** — a topic/term/theme is given (`/mithril tutor deep modules`, `/mithril learn "classical vs london"`, `/mithril tutor N+1`). No diff needed. Locate it in the library — `THEMES.md` for cross-cutting themes and tensions, `skills/*.md` for a single area's depth, `Resources/` for the primary source + chapter, `CONSTITUTION.md` for the rule — and teach it.
- **PR / diff mode** — no topic, or the learner points at code / a prior `/mithril` finding (`/mithril tutor` on the current diff, `/mithril tutor src/orders.py`). Resolve scope with **Step 1** (diff / branch / path), Read the code, then teach the principle(s) it exemplifies using their actual lines as the worked example.

**Rules (from `skills/tutor.md`):**
- Ground every claim in the curated library and **cite the source** (file + book/chapter). Don't freelance from memory; if it isn't in the library, say so.
- **Explain, don't review or fix.** No severity, no verdict, no edits. If the learner wants the code judged or changed, point them to `/mithril code` / `/mithril refactor` and return to teaching the why.
- Surface the documented tension when one exists (`THEMES.md §XI`) — teach both sides and how the framework resolves it.
- Keep each lesson tight (short answer → why it matters → example → tension if any → source → read-next → a check question), and stay available for follow-up.

---

## Usage Examples

```
# — Diff mode (default) —
/mithril                              # Run all applicable agents on git diff (auto-routed)
/mithril code                         # Naming, functions, smells only
/mithril arch                         # SOLID, dependencies, coupling, resilience
/mithril refactor                     # Smell catalog, safe refactoring plan (Mode 2)
/mithril simplify                     # Light behavior-preserving cleanup (Mode 1)
/mithril tests                        # Test suite quality audit
/mithril security                     # OWASP/CWE adversarial scan + SAST/SCA tools
/mithril review                       # Confidence-scored PR-style review with lenses
/mithril process                      # Planning discipline — edge cases, deps, Big-O
/mithril delivery                     # CD pipeline readiness, 12-Factor, migrations
/mithril distributed                  # Service boundaries, idempotency, replication
/mithril patterns                     # GoF pattern recognition + anti-pattern audit
/mithril persistence                  # ORM patterns, N+1, transactions, migrations
/mithril gates                        # Objective tool-measured floor: lint, complexity, dup, coverage, mutation
/mithril spec                         # Acceptance-criteria / BDD feature-file quality
/mithril flow                         # Trace control + data flow from entry points to sinks
/mithril tutor deep modules           # Learn a concept/theme from the library (cited)
/mithril learn "classical vs london"  # Same — teaches both sides of a documented tension
/mithril tutor                        # Teach the CS principles at play in the current diff
/mithril code arch                    # Code quality + architecture
/mithril code arch refactor           # Three-way review
/mithril persistence delivery         # DB layer + deploy/migration audit (common pair)
/mithril distributed arch             # Distributed concerns + structural review

# — Project mode —
/mithril project                      # All applicable agents on all tracked source files
/mithril project src/                 # Narrow scan to a subdirectory
/mithril project code                 # Code quality only across full project
/mithril project arch                 # Architecture-only project scan
/mithril project security             # Security scan across full project
/mithril project src/ code arch       # Subdirectory + specific aspects
/mithril project code arch tests      # Full project, three aspects

# — Deep mode (file → method → flow → summary) —
/mithril deep                         # Deep traversal of the diff / branch changes
/mithril deep src/services            # Deep traversal scoped to a path (still git-diff scope unless 'project')
/mithril deep project src/services    # Deep traversal of all tracked files under a subtree
/mithril deep --report                # Skip the prompt: write detail to a report file
/mithril deep --inline                # Skip the prompt: print full detail in chat
/mithril deep --summary               # Skip the prompt: summary only
```

---

## Tips

- **Project mode vs. diff mode.** Use `/mithril` (diff) as a fast pre-commit/pre-PR gate. Use `/mithril project` for onboarding a new codebase, a periodic health check, or when the diff-based approach misses systemic issues across files that weren't recently changed.
- **Narrow project scans.** On large repos, `/mithril project src/services` is far more actionable than scanning everything. Start small and expand.
- **Scope depends on the branch.** On `main`/`staging`/`develop`, `/mithril` reviews staged (or working-tree) changes — a pre-commit gate. On a feature branch, it reviews the entire branch since it forked from `develop`/`staging`/`main` (whichever is its parent), plus uncommitted changes on top — a pre-PR gate.
- **Requirements before conclusions.** Before reviewing a behavior-changing branch, `/mithril` establishes a confirmed Review Contract from the request/specification: goal plus declarative key examples for the main rule, boundaries, and failures. Missing or contradictory requirements pause the functional verdict for clarification. Gherkin is encouraged as a shared grammar; Cucumber is added only when the scenarios warrant executable living documentation.
- **Run before committing on long-lived branches, before opening a PR on feature branches.** Critical issues block the commit/PR.
- **`/mithril`** — default; runs always-on agents based on what changed.
- **`/mithril code`** — fast, focused. Naming, smells, FP, error handling, performance, structure.
- **`/mithril arch`** — before large features. Catches structural problems + resilience-pattern gaps before they're baked in.
- **`/mithril refactor`** — before adding to messy code. Make the change easy, then make the easy change.
- **`/mithril tests`** — when tests feel brittle. Find the smells before a refactor breaks them.
- **`/mithril security`** — before any code touching auth, payments, user input, or external API surface goes live.
- **`/mithril review`** — full PR-style review with the Google design-first priority order; ideal before opening a PR.
- **`/mithril process`** — for significant features. Audits whether edge cases, dependencies, alternatives, and Big-O were considered.
- **`/mithril simplify`** — final polish pass. Run it last, after other reviews pass.
- **`/mithril delivery`** — when touching schema migrations, deployment config, feature flags, or anything that affects the deploy pipeline. Catches deploy-coupled changes that break rolling deploys.
- **`/mithril distributed`** — when crossing service boundaries (HTTP, gRPC, queues) or touching replication, partitioning, distributed transactions. Reduces every distributed bug to one of Waldo's four categories.
- **`/mithril concurrency`** — the in-process counterpart to `distributed`. When the diff has threads, locks, atomics, `volatile`, async/await, coroutines, thread pools, or shared mutable state. Reduces every interleaving bug to one of three hazards — atomicity, visibility, liveness — and catches the races, deadlocks, and event-loop blocks that single-threaded tests never see.
- **`/mithril patterns`** — after `/mithril code` finds smells. Names the GoF pattern that prescribes the fix, OR flags pattern misuse (Singleton-as-global, Visitor abuse). Often invoked alongside `refactor`.
- **`/mithril persistence`** — when ORM, repositories, queries, or migrations are in the diff. Catches N+1, deploy-coupled migrations, missing transaction boundaries, persistence leaking into domain.
- **`/mithril gates`** — the objective floor. Runs real tools (lint, cyclomatic complexity, duplication, coverage, mutation) and reports pass/fail against thresholds rather than opinions. Run it in CI or via the pre-commit hook (`hooks/`) to *block* breaches, not just flag them. The reading agents judge; gates measure. See [`CONSTITUTION.md`](../../CONSTITUTION.md) Article VII for the thresholds and `hooks/` for the git hook.
- **`/mithril flow`** — trace execution, not structure. Follows control + data flow from each entry point (route, handler, `main`, consumer) to its sinks, catching bugs that live in the path between methods: untrusted input reaching a sink, errors swallowed mid-flow, leaked resources/locks, a transaction that doesn't wrap the unit of work, N+1 visible only across the call chain, partial failure across a boundary. Runs automatically as Phase 2 of `/mithril deep`; invoke alone when chasing a cross-method/cross-file bug. Complements `/mithril arch` (structure) — not a substitute for it.
- **`/mithril deep`** — the deep traversal. Where default `/mithril` runs one agent per aspect in parallel, deep mode walks file → method, then traces flows from entry point to sink, then synthesizes one summary. Use it to onboard a subsystem, audit a critical path, or scrutinize a large feature before merge. Expensive — scope it to a path (`/mithril deep src/services` or `/mithril deep project src/`). Defaults to writing detail to a report file and showing only the summary; override with `--inline` / `--summary`.
- **`/mithril spec`** — upstream of code. Reviews acceptance criteria and BDD/Gherkin feature files for the qualities that make a spec a reliable single source of truth: concrete key examples, declarative (not UI-scripted) phrasing, ubiquitous language, and executable/living specs. Run it before building a feature, or when `.feature` files are in the diff. Behavior-affecting branch reviews run it first; a Critical ambiguity blocks the functional-correctness verdict. Where `/mithril tests` checks the tests verify the code, `/mithril spec` checks the spec expresses the right behavior.
- **`/mithril tutor`** (alias `/mithril learn`) — the teaching leg. Where the review agents *catch* and the Constitution *prevents*, the tutor *explains* — grounded in the curated library and citing its sources. Name a concept or theme to learn it (`/mithril tutor deep modules`), or run it on a diff/finding to learn the principles at play in your actual code. It explains rather than reviews (no findings, no fixes — those are the other agents), surfaces documented tensions (both sides + how the framework resolves them), and stays conversational for follow-ups.

### Common multi-aspect combinations

- `/mithril persistence delivery` — DB code + migration safety. Run together when touching schema.
- `/mithril distributed arch` — service-to-service work + the resilience patterns underneath.
- `/mithril concurrency code` — multi-threaded or async code: interleaving hazards + the naming/structure/error-handling underneath.
- `/mithril code patterns refactor` — when reviewing structural code: smells + pattern recognition + prescribed moves.
- `/mithril security review` — pre-PR pass on any user-facing or auth code.
