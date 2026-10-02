---
description: "Code quality framework — runs targeted quality agents against your current git diff or full project. Usage: /mithril [aspects] | /mithril project [path] [aspects] | /mithril deep [path] (file→method→flow pass) | /mithril tutor [topic]"
argument-hint: "[project [path]] [deep] [code] [smells] [fix] [arch] [refactor] [simplify] [tests] [security] [review] [flow] [delivery] [distributed] [concurrency] [persistence] [perf] [observability] [a11y] [usability] [gates] [tutor [topic]] — or omit for auto-selection"
allowed-tools: ["Bash", "Glob", "Grep", "Read", "Write", "Task"]
---

# Quality Framework

Run quality agents against the current git diff or the full project, in parallel, then adjudicate and aggregate their findings into one prioritized report.

**Requested aspects:** "$ARGUMENTS"

**Host-agnostic spawning.** Runs on **Claude Code** and **Grok Build**. Where this says `Task(...)`, use the host's subagent tool:
- **Claude Code** → `Task` (`subagent_type`, `prompt`, `description`)
- **Grok** → `spawn_subagent` (same fields; set `background: true` when launching several in parallel)

Agent names (`mithril-code-quality`, …) are identical on both hosts.

---

## Step 1 — Scope

`project` anywhere in `$ARGUMENTS` → **Case C**. `deep` (alias `trace`) → resolve scope with Cases A–C, then follow **Deep Mode** instead of Steps 2–5 (`deep` and `project` combine). `tutor`/`learn` → **Tutor Mode**.

Not a git repo (`git rev-parse --is-inside-work-tree` fails) → ask which files to review.

### Case A — On `main`, `staging`, or `develop`

Review `git diff --cached`; if empty, `git diff` + `git status --short`; if still empty, ask.

### Case B — On a feature branch

Review every commit since the fork **plus** uncommitted changes. Pick the base whose fork point is **closest to HEAD** (prefer `origin/<base>`); `develop` → `staging` → `main` is only the tie-breaker:

```bash
parent=""; fork=""; best=-1
for base in develop staging main; do
  ref=""
  if git rev-parse --verify --quiet "origin/$base" >/dev/null; then ref="origin/$base"
  elif git rev-parse --verify --quiet "$base" >/dev/null; then ref="$base"
  fi
  [ -z "$ref" ] && continue
  [ "$ref" = "$(git rev-parse --abbrev-ref HEAD)" ] && continue
  mb=$(git merge-base HEAD "$ref") || continue
  ahead=$(git rev-list --count "$mb"..HEAD)
  if [ "$best" -lt 0 ] || [ "$ahead" -lt "$best" ]; then best=$ahead; parent="$ref"; fork="$mb"; fi
done
echo "Base branch: ${parent:-<none found>} (fork: ${fork:-?}, HEAD is $best commits ahead)"
git diff "$fork"...HEAD; git diff "$fork"...HEAD --name-only
git diff; git diff --name-only; git status --short
```

No candidate found → fall back to Case A and warn. A feature-on-feature branch diffs against the nearest long-lived ancestor — always print `Base branch:` in the Step 3 plan so the user can catch a wrong base.

### Case C — Project mode

Path scope = any token starting with `.` or `/` or containing `/` (default `.`); remaining tokens are aspects. `git ls-files <path>`, then exclude: minified (`*.min.*`), lockfiles, build output (`dist/ build/ out/ .next/ __pycache__/ .cache/`), dependencies (`node_modules/ vendor/ .venv/ venv/`), binaries/assets, `*.map`. Warn above 100 files and offer to narrow. Agents get the file list and read files themselves.

**Diff-size guard.** Above ~1,500 changed lines (`git diff --shortstat`), warn that quality degrades and offer: narrow to a path, review per directory, or proceed. Never silently truncate.

---

## Step 1.5 — Project Context (ephemeral)

Build a ~12-line block, fresh each run and never written to disk:
1. Reuse surface: `git ls-files | grep -iE '(^|/)(utils?|helpers?|shared|common|lib|core)(/|\.)' | head -50`, with those directories' files.
2. Local naming conventions near the changed files.
3. Top-level directory shape.

Pass it into **every** agent prompt.

---

## Step 1.6 — Establish the Review Contract Before Judging Code

A reviewer cannot call code correct without knowing the behavior it must implement or preserve.

1. **Classify:** behavior-affecting (user-visible behavior, business rules, API contracts, persistence semantics, authorization, error outcomes) or behavior-preserving (refactor, rename, mechanical migration).
2. **Gather evidence, don't invent it:** the request and conversation, the ticket, acceptance criteria, `.feature` files, behavior-named tests, API schemas, bug reproductions. **Never infer intended behavior from the implementation under review.**
3. **Write the contract:** the goal or preserved invariant, plus the few key examples that pin the rule and its boundary/failure cases (`Given` state, `When` event, `Then` observable outcome). A rename needs one line; a new billing rule needs real examples.
4. **Label it and proceed.** `CONFIRMED` (cite sources) or `ASSUMED` (say what you assumed and why). Do not halt on an assumed contract: review against it, tag findings that depend on it `[depends on assumed contract]`, and list the open questions at the top of the report so the user can correct the premise.
5. **Share it** with every Step-4 agent. If the repo documents a narrow command for its acceptance scenarios, run it before the verdict.

---

## Step 2 — Select Agents

**Aspect keywords:**
- `code` → mithril-code-quality · `perf`/`performance`/`latency` → mithril-code-quality (+ mithril-persistence when queries are involved) · `patterns` → mithril-code-quality
- `smells`/`smell`/`lint` → mithril-smells (report-only) · `fix` → mithril-lint-fix (Step 6)
- `arch`/`architecture` → mithril-architecture
- `refactor` → mithril-refactor (Mode 2: plan) · `simplify` → mithril-refactor (Mode 1: light)
- `tests`/`test`/`spec`/`specification` → mithril-test-quality
- `security` → mithril-security-review
- `review` → mithril-review (confidence-scored PR review with Look Here First)
- `flow`/`flows` → mithril-flow
- `delivery`/`deploy` → mithril-delivery
- `distributed`/`dist` → mithril-distributed
- `concurrency`/`concurrent`/`threads`/`async` → mithril-concurrency
- `persistence`/`db`/`database` → mithril-persistence
- `observability`/`o11y`/`telemetry`/`slo` → mithril-observability
- `a11y`/`accessibility`/`wcag` → mithril-accessibility
- `usability`/`ux` → mithril-usability
- `gates` → mithril-gates
- `tutor`/`learn` → Tutor Mode (inline; no agent)

**Auto-selection (no aspects).** Diff mode reads signals from `git diff --name-only` and the diff; project mode from the file list.

| Signal | Agent |
|---|---|
| Any source files | mithril-code-quality + mithril-smells (always, in diff, project and deep runs) |
| A new module, or a new import that crosses a layer (domain importing DB, HTTP, or a framework). Not a class, constructor, field, or public-method edit inside an existing module | mithril-architecture |
| Test files (`*.test.*`, `*.spec.*`, `*_test.*`, `test_*.py`) or executable specs (`*.feature`, Given/When/Then) | mithril-test-quality |
| Auth/payment/api paths, input handling, sessions, secrets, tenant/agency scoping, logging of request or patient data | mithril-security-review |
| New or changed route handlers, controllers, queue consumers, or jobs | mithril-flow |
| Migrations (`migrations/`, `db/migrate/`, `alembic/`, `prisma/migrations/`), Dockerfiles, k8s, CI/CD config, feature-flag config, `.env*` templates | mithril-delivery |
| Service-to-service HTTP/gRPC calls or queue clients (`kafka`, `rabbitmq`, `sqs`, `pubsub`, `nats`, `eventbridge`) | mithril-distributed |
| A lock, atomic, shared mutable static or cache, or a write to shared state across an `await`. Not the mere presence of `async`/`await` | mithril-concurrency |
| ORM imports, `*.sql`, schema files, repositories/DAOs, raw SQL | mithril-persistence |
| A new or changed metric, log, trace, or alert. Not every new route handler or consumer | mithril-observability |
| `*.tsx`/`*.jsx`/`*.vue`/`*.svelte`, `components/`, interactive CSS | mithril-accessibility + mithril-usability |

The table is an exact match, not a keyword search. A weak or partial signal does not select the agent.

**Opt-in only:** mithril-refactor (both modes — `/mithril simplify` or `/mithril refactor`), mithril-review (overlaps the auto-selected set; use for a PR-style pass), mithril-gates (executes tools that may not be installed; also runs from `hooks/pre-commit` and CI). Explicit keywords always force an agent even when signals are weak.

When in doubt: mithril-code-quality + mithril-smells only. That line wins over a weak row in the table.

---

## Step 3 — Show the Plan

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 QUALITY ► REVIEWING   (or: PROJECT SCAN [scope: <path>])
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Base branch: [Case B only]
Review contract: [CONFIRMED | ASSUMED] — one line
Changed files / Files in scope: [list, first 20 then "...and N more"]
◆ Spawning agents in parallel...
  → [agent] — [what it checks]
```

---

## Step 4 — Spawn Agents in Parallel

Every prompt carries: the Project Context block, the Review Contract, the changed-file list, and either the diff (diff mode) or `mode: project-wide review — read the listed files in full` plus the file list (project mode). Add this instruction to every prompt:

> The diff is your FOCUS, not your SCOPE. Read each changed file in full and Grep the repo (start from the reuse surface) before judging. Every Critical/Important finding must state a concrete failure: given what input/state → what wrong outcome.

```
Task(
  subagent_type="mithril-code-quality",
  description="Code quality review",
  prompt="[project context] [review contract] Changed files: [list] Diff: [diff] [instruction above]"
)
```

Spawn all selected agents at once. On diffs over ~500 changed lines, give each specialist only the hunks matching its Step-2 signal plus the full file list; code-quality, smells and architecture always get the full diff.

---

## Step 5 — Adjudicate and Aggregate

**Rules:**
- **Adjudicate before printing (false-positive gate).** For every Critical and Important finding, re-read the relevant diff hunk and any helper it calls. Drop the finding only if the claimed fact is false or the consequence cannot happen on this path. Minor findings pass through. Two cases:
  - **Invented claim — drop.** The agent says a line does something and the line does not, or the named consequence cannot occur here. Example: "this query interpolates user input" when the query is parameterized.
  - **Absence claim — keep unless disproved.** The agent says a control is missing: an uncalled validator, a missing tenant or entity predicate, or a helper that returns a different id than the caller asked for. Not seeing the bug in the hunk is what a correct absence finding looks like. Drop it only when the re-read finds that control on the path. Confirm a helper-return mismatch by reading the helper, not by looking for the bad value at the call site.
  Report `Adjudicated: N findings dropped on re-read`, and count only invented or implausible findings. Do not count an absence the re-read could not disprove. This rule is not satisfied by deleting every finding that is not a visible bad line.
- **Failure scenario required at Critical/Important.** Each must state *given what inputs/state → what wrong outcome*. A principle alone ("violates SRP", "not thread-safe") is not a scenario. If neither the agent nor your re-read can articulate one, **demote to Minor**.
- **Deduplicate:** `mithril-smells` and `mithril-code-quality` overlap on Mysterious Name, Duplicated Code, Long Function and Large Class; treat those as one finding. Same file within ±3 lines and a similar description is one finding; keep the clearest wording, credit both agents, keep the higher severity.
- **Shared vocabulary:** every agent tags findings `[CRITICAL]`/`[IMPORTANT]`/`[MINOR]` and ends with `Verdict: SHIP IT / NEEDS WORK / SIGNIFICANT ISSUES`; no normalization is needed. Treat any other word as a defect in that agent.
- **Conflict precedence** when two findings pull opposite ways, earlier wins: **(1) correctness → (2) security & data safety → (3) consistency with the repository's established conventions → (4) readability for the next maintainer → (5) simplicity → (6) performance.** Say which finding you overrode and why.
- **mithril-gates:** a gate `FAIL` is a Critical finding. A number reported against a generic default, with no project threshold, is a note, not a FAIL and not a block. Skipped gates are a note, not a block.
- **Look Here First (required on feature-branch / PR-scope reviews).** After aggregating, write a human inspection brief — where residual risk and judgment live, not a second findings list. Rank 3–7 concrete `path:line` (or hunk) targets, each with a risk class and the question the human should answer there. Prefer behavior/contract/auth/money/PII/persistence, concurrency/retries/idempotency, migrations/public API/flags, dense logic that looks right, and new behavior whose tests don't prove it. Skip generated, lock, format-only, and mechanical files. Tiny and obvious change → `Look Here: none — mechanical / fully covered`. The first 3 items are the 10-minute pass. Don't repeat Critical/Important issues unless a judgment call remains that the agents cannot close. When mithril-review ran, prefer its list and add only targets other agents uniquely justified.
- **Verdict** (post-adjudication): any Critical → `SIGNIFICANT ISSUES`; no Critical but ≥2 Important, or 1 Important that is security- or correctness-sourced → `NEEDS WORK`; otherwise `SHIP IT` (the bar is net improvement, not perfection).

**Output:**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 QUALITY ► RESULTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Review contract: [CONFIRMED | ASSUMED — open questions]

## Look Here First
If you only have 10 minutes, inspect these in order:
1. path:line — [risk class] — question to answer
   Why human: one sentence
2. ...
Skip: [noise / generated / mechanical files]
Deeper pass (if more time): [remaining targets, or none]

## Critical — Fix Before Committing
- [agent] file:line — what → failure scenario → fix

## Important — Fix Before PR
- [agent] file:line — what → failure scenario → fix

## Minor — Worth Doing
- [agent] file:line — what → fix

─────────────────────────────────────────────────
Agents run: [list] | Adjudicated: N dropped | Issues: X critical, Y important, Z minor
Verdict: [SHIP IT / NEEDS WORK / SIGNIFICANT ISSUES]
```

Suggest follow-ups only when earned: smells needing a step-by-step plan → `/mithril refactor`; a new pool/queue/cache without saturation signals → `/mithril observability`; shared mutable state or async hazards flagged by another agent → `/mithril concurrency`; a bug that spans files → `/mithril flow`.

---

## Step 6 — Lint Fix (opt-in: the `fix` keyword only)

Everything above is read-only; this is the only step that edits files, and only `mithril-lint-fix` has the `Edit` tool. Run it only when `fix` is in `$ARGUMENTS` and the scope is diff mode (Cases A/B). With `deep` or `project`, print `fix skipped: diff mode only` and run nothing. After Step 5 completes (one writer, nothing else running), spawn `mithril-lint-fix` alone with the diff's changed-file list. Print what it fixed and left, and remind the caller to commit it separately from behavior changes (`style(lint): ... (no behaviour change)`). Without `fix`, the `[LINT]` findings from `mithril-smells` are reported and nothing is changed.

---

## Deep Mode (`/mithril deep` | `/mithril trace`)

A flow pass on a critical path, plus the specialists Step 2 would select for those files. Expensive: if the in-scope list (after the Case C exclusions) exceeds **40 files**, require a narrower path or explicit confirmation. Do not walk every method for inputs and outputs. Flow greps its own entry points.

Spawn in parallel: `mithril-flow` on the in-scope entry points, and the Step 2 specialists whose signals match (mithril-smells on any source file; security on auth, tenant scope, or secrets; persistence on SQL; concurrency on a lock or a mutation across `await`). Not a method-by-method code-quality dump, and not architecture unless the diff adds a module or a layer-crossing import.

**Summary (do not delegate).** Flow map (entry → key paths → sinks), findings by severity tagged `file:method:line` under Step 5's rules, verdict. Structural notes from flow are suggestions, not findings.

**Detail destination** — ask unless `--report`, `--inline`, or `--summary` was passed: **Report file** (default) writes full detail to `.mithril/deep-{timestamp}.md` with the Write tool (create the dir; suggest adding `.mithril/` to `.gitignore`) and shows only the summary; **Inline** prints everything; **Summary** discards the detail.

---

## Tutor Mode (`/mithril tutor` | `/mithril learn`)

Teaching, not review: runs **inline in the main thread** (no agent, no findings, no verdict, no edits). Read `${CLAUDE_PLUGIN_ROOT}/skills/tutor.md` and follow its contract. The library lives under `${CLAUDE_PLUGIN_ROOT}` (`THEMES.md`, `Resources/`, `skills/`, `CONSTITUTION.md`), not the user's repo — read it by that absolute path.

- **Concept mode** — a topic is given (`/mithril tutor deep modules`): locate it in the library and teach it.
- **Diff mode** — no topic, or a file/finding is named: resolve scope with Step 1, read the code, and teach the principle it exemplifies using its own lines.

---

## Usage

```
/mithril                         # auto-selected agents on the diff / branch
/mithril code arch               # specific aspects (code-quality and smells run on every source diff anyway)
/mithril security flow           # auth or input-handling change: exploitability + entry→sink paths
/mithril persistence delivery    # schema change: queries + migration safety
/mithril review                  # PR-style confidence-scored review with Look Here First
/mithril simplify                # light behavior-preserving cleanup (opt-in)
/mithril refactor                # named, test-first refactor plan (opt-in)
/mithril fix                     # review, then fix lint findings on the changed files (opt-in, edits files)
/mithril gates                   # tool-measured lint/complexity/duplication/coverage/mutation
/mithril project src/ code       # project scan of a subtree
/mithril deep src/services       # flow on that path, plus the specialists the files would select
/mithril deep --summary          # skip the detail-destination prompt
/mithril tutor N+1               # learn a concept from the library
```
