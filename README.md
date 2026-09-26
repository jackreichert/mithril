# Mithril — Sources & Index

## What this is

This repo is a **code-quality framework** — the canonical CS literature distilled into agent-executable form — delivered through two layers:

- **Review-time (catch).** A set of specialized review agents — for code quality, architecture, refactoring, testing, security, delivery, distributed systems, design patterns, persistence, and process discipline — run against your current `git diff` and aggregate their findings into a severity-ranked verdict (`SHIP IT` / `NEEDS WORK` / `SIGNIFICANT ISSUES`). This layer runs first-class inside [Claude Code](https://docs.claude.com/claude-code) and [Grok Build](https://docs.x.ai) via the `/mithril` slash command (parallel subagent orchestration + tool execution).
- **Write-time (prevent).** The always-on [Constitution](CONSTITUTION.md) compiles the same canon into terse imperative rules an agent obeys *while writing*. It's plain markdown, so it's portable: point any tool's project-instructions file at `CONSTITUTION.md` (see [Multi-tool reach](#multi-tool-reach)).

Each agent is a focused lens. The orchestrator picks which lenses are relevant to the diff, runs them in parallel, re-checks every blocking finding against the code, deduplicates overlap, and returns one report.

**Prompts carry rules, not the canon.** The runtime prompts in `skills/` hold only what changes a capable model's behavior: thresholds, detection heuristics, tool invocations, anti-false-positive calibration, confidence and severity rules, and output formats. The books, principles, and tensions stay in `Resources/` and `THEMES.md` for the tutor and for humans. Restating the canon in a review prompt adds tokens and turns principle lists into checklists to satisfy, which produces false positives. Keep new rules to what the model would not do unprompted, and verify changes with `calibration/`.

## How it was created

The framework is a **distillation of the canonical CS literature** into agent-executable form. The pipeline:

1. **Source selection.** A reading list of 46 canonical books plus key articles and papers (Clean Code, Refactoring, A Philosophy of Software Design, Agile Software Development, Don't Make Me Think, Clean Architecture, GOOS, Designing Data-Intensive Applications, PEAA, Release It!, Continuous Delivery, GoF, the OWASP standards, etc.) — the full inventory lives in [`CS-Best-Practices-Resources.md`](CS-Best-Practices-Resources.md).
2. **Per-source summaries.** Each book/article was summarized into a structured note in [`Resources/`](Resources/) (Books, Articles, Papers, Standards, Originals). Book chapter entries contain at least three sentences so a reader can understand the idea, why it matters, and how to apply or qualify it without prior knowledge.
3. **Cross-source themes.** The summaries are synthesized into **20 concept guides** in [`Resources/Themes/`](Resources/Themes/) (plus the one-file horizontal cut, [`THEMES.md`](THEMES.md)) — a Tier 1→5 curriculum (foundations → construction → design at scale → verification → systems in production). Each theme walks how the idea builds across its sources, names the real tensions instead of papering over them, and ends with the operational checklist its skill encodes. The learning on-ramp, and the reasoning layer the skills cite.
4. **Synthesis into skills.** The themes and summaries were synthesized into concise, source-grounded runtime prompts in [`skills/`](skills/). These are both the executable specialists and the sole content source.
5. **Host compatibility.** The Claude Code and Grok plugin manifests load `skills/*.md` directly as subagents.
6. **Orchestration.** The `/mithril` slash command routes a diff to the relevant agents, runs them in parallel, normalizes severity, and aggregates the report.

The "Sources by Skill" section below shows exactly which book/article/chapter informed each part of each skill, so any finding the framework produces can be traced back to a primary source.

For the master inventory of every book and article that informed this work, see [`CS-Best-Practices-Resources.md`](CS-Best-Practices-Resources.md). For the lineage of individual sections within each skill, see "Sources by Skill" further down.

---

## Quick start

Install as a plugin — the standard mechanism for each tool. There's no clone-and-run installer; the plugin loads `skills/*.md` and `claude/commands/mithril.md` directly, so editing a skill takes effect immediately.

**Claude Code:**

```
/plugin marketplace add jackreichert/mithril
/plugin install mithril@mithril
```

**Grok Build:**

```bash
grok plugin install jackreichert/mithril --trust
grok plugin enable mithril
```

Then run `/mithril` from either tool in any git repo.

**GitHub Copilot, Codex, and other tools** don't have an equivalent plugin/subagent mechanism for the review agents, but the write-time [Constitution](CONSTITUTION.md) is plain markdown — point that tool's project-instructions file at `CONSTITUTION.md` (see [Multi-tool reach](#multi-tool-reach)). For Copilot specifically, see [`Copilot-Integration.md`](Copilot-Integration.md).

### Contributing

The framework keeps one canonical agent definition in `skills/`. See [`CONTRIBUTING.md`](CONTRIBUTING.md).

---

## Files in This Directory

### Current Skills

| File | Focus | Subagent type |
|------|-------|---------------|
| `skills/code-quality.md` | Size-as-prompt calibration, reuse and placement, names, errors, contracts, performance (load X → outcome Y), pattern misuse | `mithril-code-quality` |
| `skills/architecture.md` | Sonnet. New modules and layer-crossing imports only. Dependency direction, cycles, public-contract evolution, timeouts at integration points | `mithril-architecture` |
| `skills/refactor.md` | Opt-in. Mode 1 simplify (light) + Mode 2 named, test-first refactor plan with the WELC seam ranking, Branch by Abstraction & Strangler Fig | `mithril-refactor` |
| `skills/review.md` | Confidence-scored review (quick / full-PR / follow-up), per-commit review of sliced PRs, and the Look Here First human inspection brief | `mithril-review` |
| `skills/security-review.md` | Scanners, then a manual read. Tenant scoping, exact-match allowlists, fail-closed, exploit-or-downgrade. No empty-category report and no PHI policy | `mithril-security-review` |
| `skills/test-quality.md` | False confidence, behavior-vs-internals, determinism, failure edges. Acceptance scenarios only when the repo has them | `mithril-test-quality` |
| `skills/delivery.md` | Deploy/rollback safety: expand-contract, build-once, config and secrets, process hygiene, feature flags, lockfiles | `mithril-delivery` |
| `skills/distributed.md` | Waldo categories, timeouts and retries, idempotency, outbox/sagas, ordering, consistency, boundaries, trace context | `mithril-distributed` |
| `skills/concurrency.md` | The three hazards (atomicity, visibility, liveness) and a high-signal flag list, including async mutation across `await` | `mithril-concurrency` |
| `skills/persistence.md` | Lost updates, transactions, N+1, query cost (sargable, keyset), migration safety, connection handling | `mithril-persistence` |
| `skills/gates.md` | Opt-in tool floor. SKIPPED is never PASS. Coverage, CRAP, mutation, and function length are reported, not failed, unless the repo writes the threshold down | `mithril-gates` |
| `skills/observability.md` | Telemetry changes only. Golden signals, structured logs without secrets, trace propagation, jobs/consumers, alert hygiene | `mithril-observability` |
| `skills/accessibility.md` | WCAG 2.2 AA: semantic-first controls, keyboard, accessible names, dialogs and APG widgets, contrast | `mithril-accessibility` |
| `skills/usability.md` | Observed / Heuristic / Preference evidence rule; hierarchy, labels, orientation, feedback and error recovery | `mithril-usability` |
| `skills/flow.md` | Three questions on each changed entry point: does untrusted input reach a sink on this path, what does each helper return, what is left if the far side succeeds and this side fails | `mithril-flow` |
| `skills/tutor.md` | Grounded CS tutor — teaches a concept/theme from the library, or the principles at play in a PR/diff; cites sources, surfaces tensions, explains rather than reviews | — (inline via `/mithril tutor` \| `/mithril learn`) |

### Workflow & Supporting Docs

| File | Focus | Agent file |
|------|-------|-----------|
| `README.md` | Sources, lineage, exclusions, and update guide for this framework | — |
| `CS-Best-Practices-Resources.md` | Per-source index — every book, article, and paper that informed the framework, and which idea each one owns | — |
| `THEMES.md` | Cross-cutting synthesis of the `Resources/` library — the themes that recur across sources, where they converge, and the documented tensions (with a resolution map keyed to the skills) | — |
| `Resources/Themes/` | 20 cross-source concept guides (Tier 1→5 curriculum) — the synthesis layer between the per-source summaries and the skills; each theme names its tensions and the checklist its skill encodes | — |
| `CONSTITUTION.md` | Write-time prevention layer — the skills distilled into always-on imperative rules, a conflict-precedence order, numeric gate thresholds, and a Definition of Done. Loaded via a `CLAUDE.md` `@`-import. | — |
| `hooks/pre-commit` | Opt-in git hook that runs the fast gates (lint + complexity) on staged files and blocks the commit on a breach. See `hooks/README.md`. | — |

### Two modes: review-time and write-time

The framework now works at both ends of the change lifecycle:

- **Review-time (catch).** `/mithril` routes a diff to the relevant reading agents, which *judge* the code against the canon and report severity-ranked findings. This is the original framework.
- **Write-time (prevent).** [`CONSTITUTION.md`](CONSTITUTION.md) compiles the same canon into terse always-on rules an agent obeys *while writing* — so issues are designed out, not just flagged. Import it into a project's `CLAUDE.md` with `@/path/to/Mithril/CONSTITUTION.md`.
- **Enforcement (block).** `/mithril gates` and the [`hooks/pre-commit`](hooks/) hook turn the qualitative rules into objective, tool-measured pass/fail gates (lint, complexity, duplication, coverage, mutation) — the floor beneath the reading agents. The agents opine; the gates measure.

This mirrors the lesson of [unclebob/swarm-forge](https://github.com/unclebob/swarm-forge): the same distilled discipline should run as a *constitution* up front and as *enforced gates*, not only as post-hoc review.

### Lineage Notes

| Current file | Lineage |
|--------------|---------|
| `skills/review.md` | Started from the `code-reviewer` agent and absorbed the old `review-pr` orchestrator workflow |
| `skills/refactor.md` | Synthesized from Fowler/Feathers and absorbed the old `code-simplifier` behavior-preserving cleanup mode |
| `skills/delivery.md` | Synthesized fresh from Continuous Delivery + Trunk-Based Development + 12-Factor + Feature Toggles (Hodgson) — no prior agent ancestor |
| `skills/distributed.md` | Synthesized fresh from DDIA + Waldo's "A Note on Distributed Computing" + Microservices/CQRS/Event Sourcing — no prior agent ancestor |
| `skills/concurrency.md` | Synthesized fresh from Effective Java ch.11 (items 78–84) + DDIA ch.7 + Clean Code ch.13 + SICP ch.3 + Release It! (Blocked Threads) + Out of the Tar Pit — the in-process counterpart to `distributed.md`; no prior agent ancestor |
| `skills/persistence.md` | Synthesized fresh from PEAA pattern catalog + DDIA storage chapters + Effective Java resource-management items + DDD Repository — no prior agent ancestor |
| `skills/security-review.md` | Adapted from the `security-auditor` agent and extended with explicit security standards references |

### Orchestration

| Path | Purpose |
|------|---------|
| `claude/commands/mithril.md` | The `/mithril [aspects]` command — routes to agents, aggregates findings. Loaded directly by the Claude Code and Grok plugins. |
| `skills/*.md` | Canonical agent content, loaded directly by the plugin manifests. |

### Multi-tool reach

The **review framework** (`/mithril` — parallel agents, diff-routing, severity aggregation, tool-backed SAST/SCA) is first-class on **Claude Code and Grok Build** via their plugin systems. Copilot and Codex do not offer equivalent subagent orchestration, so they get the write-time Constitution only.

The **write-time [Constitution](CONSTITUTION.md)** is plain markdown — point each tool at it the standard way for that tool:

| Tool | Where to put it | `/mithril` review agents? |
|------|-----------------|---------------------------|
| **Claude Code** | `@import` it from `~/.claude/CLAUDE.md` or the repo's `CLAUDE.md` | ✅ full (via the plugin) |
| **Grok Build** | point `~/.grok/AGENTS.md` (or the repo's) at it | ✅ full (via the plugin) |
| **Codex** | point `~/.codex/AGENTS.md` at it, or inline it if Codex can't reference an external file | ❌ |
| **Copilot** (VS Code / IntelliJ / github.com) | Copilot can't `@import` — inline the Constitution's content into your instructions file. See [`Copilot-Integration.md`](Copilot-Integration.md). | ❌ |
| **Any other agentic tool** — Cursor, Continue, Windsurf, Cline, Aider, Zed, Gemini CLI, … | point the tool's project-instructions file at `CONSTITUTION.md` | ❌ |

The lingua franca is the [**`AGENTS.md`**](https://agents.md) open standard: drop a repo-root `AGENTS.md` (or point it at `CONSTITUTION.md`) and Codex, Cursor, Zed, Gemini CLI, Jules, and a growing list of agents pick it up.

| Tool | Where to put it |
|------|-----------------|
| **Cursor** | `.cursor/rules/*.mdc`, or a repo-root `AGENTS.md` |
| **Continue** | a rule in `.continue/rules/` (or `rules:` in `config.yaml`) |
| **Windsurf** | `.windsurf/rules/`, or `AGENTS.md` |
| **Cline** | `.clinerules/` |
| **Aider** | a conventions file referenced from `.aider.conf.yml`, or `AGENTS.md` |
| **Zed / Gemini CLI** | `.rules` / `GEMINI.md`, both of which also honor `AGENTS.md` |

Check the tool's current docs for the exact filename — these conventions move fast. Either way the principle holds: **one canonical `CONSTITUTION.md`, every tool pointed at it.**

> **Company HIPAA lives *inline* in each tool's instructions** (Claude's `CLAUDE.md`; the self-contained file for Codex/Copilot) — never delegated to the imported Constitution — so the mandate survives even where `@import` doesn't resolve.

---

## Sources by Skill

Below: the books, articles, and chapters that drove each skill's content. Section names refer to the fuller pre-2026-09 prompts; the canon still informs the rules, but the runtime prompts no longer restate it (see [Prompts carry rules, not the canon](#what-this-is)).

### `skills/code-quality.md`

**Books**
- **Clean Code** — Robert C. Martin (2008)
  - ch.2 Meaningful Names → Naming section
  - ch.3 Functions → Function Design section
  - ch.4 Comments → Comments section
  - ch.5 Formatting → Formatting section
  - ch.7 Error Handling → Error Handling section
  - ch.12 Emergence → Beck's Four Rules of Simple Design
  - ch.17 Smells and Heuristics → Code Smells section (cross-checked with Fowler)
- **A Philosophy of Software Design** — John Ousterhout (2018/2021)
  - ch.2 Nature of Complexity → Complexity section
  - ch.4-5 Modules should be deep, Information hiding → Function Design / Complexity sections
  - ch.10 Define Errors Out of Existence → Error Handling section
  - ch.12-15 Comments → Tensions & Comments sections (counterpoint to Clean Code ch.4)
  - ch.13-14 Comments, Choosing Names → Comments / Naming sections
- **Clean Architecture** — Robert C. Martin (2017)
  - ch.6 Functional Programming → FP section (the three-paradigm framing)
  - ch.21 Screaming Architecture → Reuse & Placement section (where general-purpose code belongs)
- **Refactoring 2nd ed.** — Martin Fowler (2018)
  - ch.3 Bad Smells in Code → Code Smells categories (Bloaters, OO Abusers, Change Preventers, Dispensables, Couplers)
- **Code Complete 2nd ed.** — Steve McConnell (2004)
  - ch.5-7 Construction practices → Function Design / Naming
  - ch.25 Code-Tuning Strategies → Performance section
  - ch.31 Layout and Style → Formatting section
- **The Art of Readable Code** — Boswell & Foucher (2011) → Naming section surface clarity
- **The Pragmatic Programmer** — Hunt & Thomas (1999/2019)
  - DRY (knowledge, not text), fail fast → Code Smells / Error Handling / Reuse & Placement
  - ch.4 Design by Contract → Structure & Contracts section

**Articles & Papers**
- **Out of the Tar Pit** — Moseley & Marks (2006) — essential vs. accidental complexity, FP+relational core → Complexity / FP sections
- **Extreme Programming Explained** — Kent Beck — Four Rules of Simple Design (cited via Clean Code ch.12)

**Note:** Release It! stability patterns moved to `skills/architecture.md` (resilience is an architectural decision, not code-quality polish). Code-quality surfaces the symptoms; architecture prescribes the patterns.

---

### `skills/architecture.md`

**Books**
- **Clean Architecture** — Robert C. Martin (2017)
  - Part III chs.7-11 SOLID Principles → SOLID section
  - Part IV chs.13-14 Component Principles → Component Principles section (REP, CCP, CRP, ADP, SDP, SAP)
  - Part V ch.22 The Clean Architecture → Dependency Architecture section (the layered diagram)
- **Agile Software Development** — Robert C. Martin (2002)
  - Part II chs.8-12 → worked SOLID reasoning
  - Part IV ch.20 → original package cohesion/coupling principles
  - Payroll case study → abstractions and package boundaries responding to observed change pressure
- **Domain-Driven Design** — Eric Evans (2003)
  - Part II Building Blocks → DDD Patterns section (aggregates, repositories, domain services)
  - Part III Refactoring Toward Deeper Insight → Ubiquitous Language
  - Part IV Strategic Design → Bounded Contexts, Anti-Corruption Layer
- **Patterns of Enterprise Application Architecture** — Martin Fowler (2002)
  - ch.1 Layering → Layering Violations section
- **Software Engineering at Google** — Winters, Manshreck, Wright (2020)
  - ch.1 Hyrum's Law → Hyrum's Law subsection (API stability lens)
  - ch.3 Knowledge Sharing, dependency management chapters → Coupling & Cohesion section
- **Release It! 2nd ed.** — Michael T. Nygard (2018)
  - ch.4 Stability Antipatterns → Resilience & Stability Patterns section (antipatterns to flag)
  - ch.5 Stability Patterns → Resilience & Stability Patterns section (Timeout, Circuit Breaker, Bulkhead, Steady State, Fail Fast, Backpressure, Shed Load)
- **Domain-Driven Design** (Evans 2003)
  - Part IV ch.15 Distillation → Strategic DDD subsection (Core / Generic / Supporting subdomains)
- **Clean Architecture** — Robert C. Martin (2017)
  - ch.21 Screaming Architecture → Screaming Architecture subsection
  - ch.27 Services: Great and Small → Boundaries Are Not Services subsection
- **A Philosophy of Software Design** — John Ousterhout (2018/2021)
  - ch.4-5 Deep modules, Information hiding → Module Depth subsection (interface-as-cost vs. implementation-as-value; the deep-vs-small-functions tension, resolved to `code-quality.md` §0.5)

**Articles & Papers**
- **"On the Criteria to Be Used in Decomposing Systems into Modules"** — D.L. Parnas (1972) → Information Hiding section
- **The Principles of OOD** (SOLID articles) — Robert C. Martin (blog.cleancoder.com) → SOLID section
- **Hexagonal Architecture (Ports and Adapters)** — Alistair Cockburn (alistair.cockburn.us) → Hexagonal Architecture subsection (sibling of Clean Architecture)
- **"How Do Committees Invent?"** — Melvin Conway (1968) → Conway's Law subsection
- **Team Topologies** — Matthew Skelton & Manuel Pais (2019) → Conway's Law subsection (Inverse Conway Maneuver)

---

### `skills/refactor.md`

**Books**
- **Refactoring: Improving the Design of Existing Code 2nd ed.** — Martin Fowler (2018)
  - ch.3 Bad Smells → Smell → Refactoring Map
  - ch.6-10 Composing Methods, Encapsulation, Moving Features, Organizing Data, Simplifying Conditional Logic → Smell→Move tables
  - ch.11 Refactoring APIs → Refactoring APIs section (Separate Query from Modifier, Parameterize Function, Remove Flag Argument, Preserve Whole Object, Replace Constructor with Factory Function, Replace Function with Command)
  - ch.8 Replace Loop with Pipeline → Refactoring APIs section
  - ch.12 Dealing with Inheritance → Inheritance Smell→Move table
- **Working Effectively with Legacy Code** — Michael Feathers (2004)
  - Seams (Object/Parameter/Interface) → Legacy Code Strategy section
  - Characterization tests → Legacy Code Strategy section
  - Sprout Method, Wrap Method → Legacy Code Strategy section
  - **ch.25 Dependency-Breaking Techniques** → Dependency-Breaking Techniques catalog (24 named techniques: Subclass and Override Method, Extract and Override Call/Factory/Getter, Parameterize Method/Constructor, Adapt Parameter, Extract Interface/Implementer, Encapsulate Global Reference, Introduce Static Setter, Pull Up Feature, Push Down Dependency, Supersede Instance Variable, Introduce Instance Delegator, Break Out Method Object, Link Substitution, Definition Completion, Template/Text Redefinition, Replace Function with Function Pointer, ranked by invasiveness)
- **Clean Code** — Robert C. Martin (2008) — ch.17 Smells (cross-references Fowler's catalog)

**Articles**
- **BranchByAbstraction** — Fowler / Hammant (martinfowler.com bliki) → Large-Scale Refactor Strategies (in-process replacement)
- **Strangler Fig Application** — Fowler (martinfowler.com bliki) → Large-Scale Refactor Strategies (system-level replacement)
- **Things You Should Never Do, Part I** — Joel Spolsky → motivation for Strangler Fig over big-bang rewrites

**Lineage**
- Mode 1 ("simplify") is the successor to the old `code-simplifier` agent pattern: behavior-preserving cleanup on recently touched code
- Mode 2 ("full-refactor") is the deeper Fowler/Feathers refactoring path

---

### `skills/test-quality.md`

**Books**
- **Growing Object-Oriented Software, Guided by Tests** — Freeman & Pryce (2009)
  - **ch.18 Listening to the Tests → Listen to the Tests section (organizing principle of the whole skill)**
  - Mock roles, not objects → Test Doubles section
  - Outside-in TDD, Walking Skeleton → TDD Indicators section
- **Test-Driven Development: By Example** — Kent Beck (2002)
  - Red-Green-Refactor cycle, baby steps, Three Laws of TDD → TDD Indicators section
- **Agile Software Development** — Robert C. Martin (2002)
  - ch.4 programmer tests vs. customer acceptance tests → Two Test Layers section
  - ch.6 bowling episode → test-first design in a worked example
- **The Art of Unit Testing 3rd ed.** — Roy Osherove (2023)
  - F.I.R.S.T. principles → F.I.R.S.T. section
  - AAA pattern → Structure section
  - Test double taxonomy (Stub, Mock, Spy, Fake, Dummy) → Test Doubles section
- **xUnit Test Patterns: Refactoring Test Code** — Gerard Meszaros (2007)
  - Test smell catalog → Test Smells section (Obscure, Eager, Mystery Guest, Fragile, Slow, Flaky, Hard-Coded Test Data, Irrelevant Information, Shared Fixture)
  - Database Sandbox / Transaction Rollback Teardown → Test Doubles section (DB isolation strategy)
- **Unit Testing Principles, Practices, and Patterns** — Vladimir Khorikov (2020)
  - ch.2 The two schools of unit testing → Test Doubles section (Classical/Detroit vs. London/mockist; framework default is classical)
  - ch.8-10 Integration testing → Test Doubles section (real-DB integration tests; clean-up-between-tests vs. transaction-rollback isolation)
- **Software Engineering at Google** — Winters et al. (2020)
  - ch.11 The Beyoncé Rule → Beyoncé Rule subsection ("if you liked it, then you shoulda put a test on it")
  - chs.11-14 Testing → Coverage Analysis + Test Pyramid sections
- **Clean Code** — Robert C. Martin (2008) — ch.9 Unit Tests → F.I.R.S.T. section (overlap with Osherove)
- **Growing Object-Oriented Software, Guided by Tests** — Freeman & Pryce (2009)
  - **ch.19 Coverage** → Mutation Testing subsection (test quality, not just coverage)
- **The Pragmatic Programmer** — Hunt & Thomas (1999/2019)
  - ch.7 (QuickCheck lineage referenced) → Property-Based Testing §6.6 (expanded: domains, generators, shrinking, tooling matrix)

**Articles & Concepts**
- **Test Pyramid** — Mike Cohn, *Succeeding with Agile* (2009) → Test Pyramid subsection
- **Testing Trophy** — Kent C. Dodds (kentcdodds.com) → Testing Trophy variant (frontend-heavy contexts)
- **Mocks Aren't Stubs** — Martin Fowler (martinfowler.com) → Test Doubles section (classical vs. mockist framing)
- **QuickCheck** (Claessen & Hughes) + **Hypothesis** / **fast-check** / **jqwik** / **proptest** docs → PBT tooling table in §6.6

---

### `skills/delivery.md`

**Books**
- **Continuous Delivery** — Humble & Farley (2010)
  - ch.5 Anatomy of the Deployment Pipeline → Build Discipline + Deployment Strategy sections
  - ch.6 Build and Deployment Scripting → Build Discipline section
  - ch.10 Deploying and Releasing → Deployment Strategy section
  - ch.12 Managing Data → Database Migrations (Expand-Contract) section
  - ch.13 Managing Components and Dependencies → Dependencies & Supply Chain section
  - ch.14 Advanced Version Control → Trunk-Based Development Hygiene section
- **Accelerate: The Science of Lean Software and DevOps** — Forsgren, Humble, Kim (2018)
  - DORA research → DORA Four Key Metrics subsection (deploy frequency, lead time, change failure rate, MTTR)
- **Software Engineering at Google** — Winters et al. (2020)
  - chs.16, 22-24 (Version Control, LSCs, CI, CD) → Trunk-Based Development + Build Discipline + Deployment Strategy
- **Release It! 2nd ed.** — Nygard (2018) ch.13 (Design for Deployment) → Deployment Strategy section
- **Growing Object-Oriented Software, Guided by Tests** — Freeman & Pryce (2009)
  - ch.4 Walking Skeleton → Walking Skeleton (§ 0) section
- **The Pragmatic Programmer** — Hunt & Thomas (1999/2019)
  - ch.2 Tracer Bullets → Walking Skeleton (§ 0) section

**Articles & Standards**
- **Trunk Based Development** — Fowler / Hammant → Trunk-Based Development Hygiene section
- **The Twelve-Factor App** — Heroku/Wiggins → Configuration & Environment + Process Hygiene + Logs & Telemetry sections
- **Feature Toggles** — Pete Hodgson on Fowler's site → Feature Flags section (the four-category taxonomy: release / experiment / ops / permission)
- **DORA State of DevOps Reports** (annual, dora.dev) → DORA Four Key Metrics subsection (elite/high/medium/low tiers)

### `skills/distributed.md`

**Books**
- **Designing Data-Intensive Applications** — Martin Kleppmann (2017)
  - ch.5 Replication → Replication & Consistency section
  - ch.6 Partitioning → Partitioning section
  - ch.7 Transactions → Transactions & Isolation section
  - ch.8 The Trouble with Distributed Systems → Network Reliability + Time/Clocks/Ordering sections
  - ch.9 Consistency and Consensus → Replication & Consistency section
  - ch.11 Stream Processing → Idempotency and Exactly-Once + CQRS / Event Sourcing sections
- **Release It! 2nd ed.** — Nygard (2018) → Stability Patterns at Distributed Scale (cross-ref skills/architecture.md § 5)
- **Software Engineering at Google** — Winters et al. (2020) ch.14 → Observability for Distributed Systems

**Articles & Papers**
- **A Note on Distributed Computing** — Waldo, Wyant, Wollrath, Kendall (1994) → § 0 Waldo's Four Differences (organizing principle)
- **Microservices** — Fowler & Lewis (martinfowler.com) → Microservice Boundaries section
- **CQRS** — Fowler (martinfowler.com) → CQRS / Event Sourcing section
- **Event Sourcing** — Fowler (martinfowler.com) → CQRS / Event Sourcing section

### `skills/concurrency.md`

**Books**
- **Effective Java 3rd ed.** — Bloch (2018) ch.11 (Concurrency)
  - item 78 (synchronize access to shared mutable state) → § 0 Three Hazards + § 1 Shared Mutable State + § 2 Atomicity + § 3 Visibility
  - item 79 (avoid excessive synchronization — no alien calls under a lock) → § 4 Locking Discipline
  - items 80–81 (executors/tasks over threads; concurrency utilities over `wait`/`notify`) → § 6 Prefer High-Level Concurrency Utilities
  - items 82–84 (document thread safety; lazy init; don't depend on the scheduler) → § 2 lazy init, § 5 Liveness, § 8 Thread-Safety Contracts
- **Designing Data-Intensive Applications** — Kleppmann (2017) ch.7 → § 2 Atomicity (lost updates, the in-memory analog of weak isolation)
- **Clean Code** — Martin (2008) ch.13 (Concurrency) → § 0 organizing rule ("race/deadlock/update problems are due to mutable variables") + § 1
- **SICP** — Abelson & Sussman (1996) ch.3 → § 1 the cost of assignment/state (why confinement & immutability win)
- **Release It! 2nd ed.** — Nygard (2018) → § 5 Liveness Hazards (Blocked Threads, thread-pool exhaustion; cross-ref distributed § 10, architecture § 5)

**Articles & Papers**
- **Out of the Tar Pit** — Moseley & Marks (2006) → § 1 state as the great complexity multiplier (minimize shared mutable state first)
- **FP Basics** — Robert C. Martin → § 0/§ 1 "no assignment → no race conditions"
- **Eradicating Non-Determinism in Tests** — Fowler (martinfowler.com) → § 9 Testing Concurrent Code (flaky-test discipline)
- **Java Concurrency in Practice** — Goetz et al. (informal reference) → locking discipline, safe publication, and the memory-model framing throughout

### Patterns (retired — pattern misuse folded into `code-quality`)

**Books**
- **Design Patterns: Elements of Reusable Object-Oriented Software** — Gamma, Helm, Johnson, Vlissides / GoF (1994)
  - The 23 patterns by category → § 2 The 23 GoF Patterns + § 1 Pattern Recognition by Smell
  - Foundational principles (program-to-interface, composition-over-inheritance) → § 0 The Pattern Mindset
- **Head First Design Patterns 2nd ed.** — Freeman & Robson (2020)
  - ch.12 Compound Patterns → § 2.5 MVC = Strategy + Composite + Observer (and MVP/MVVM/Flux variants)
  - Modern OO framing throughout, anti-pattern warnings
- **Patterns of Enterprise Application Architecture** — Fowler (2002)
  - Web Presentation Patterns chapter → § 2.6 Web Presentation Patterns (Page/Front Controller, Template/Transform/Two-Step View, Application Controller)
- **Refactoring 2nd ed.** — Fowler (2018) → Smell→Pattern mapping (Replace Conditional with Polymorphism = Strategy/State)
- **Effective Java 3rd ed.** — Bloch (2018) → Modern OO refinements (item 17 immutability, item 18 composition-over-inheritance)
- **A Philosophy of Software Design** — Ousterhout (2018/2021) ch.19 → § 5 When NOT to Apply a Pattern (counterweight on over-patterning)
- **Agile Software Development** — Martin (2002) chs.6, 13-30 → patterns emerging from tested, observed design pressure; remove patterns whose force disappears

### `skills/persistence.md`

**Books**
- **Patterns of Enterprise Application Architecture** — Martin Fowler (2002)
  - ch.2 Organizing Domain Logic → Domain Logic Pattern section (Transaction Script vs Domain Model vs Table Module)
  - ch.3, 10-11 Mapping to Relational + ORM Behavioral patterns → Active Record vs Data Mapper, Unit of Work, Identity Map, Lazy Load sections
  - ch.5 Concurrency → Transactions and Boundaries section
  - **Offline Concurrency Patterns chapter** → § 6.5 Offline Concurrency Patterns (Optimistic / Pessimistic Offline Lock, Coarse-Grained Lock, Implicit Lock)
  - PEAA inheritance mapping (STI / CTI / Concrete Table) → Inheritance Mapping section
  - PEAA Repository, Query Object → Repository Pattern section
- **Designing Data-Intensive Applications** — Kleppmann (2017)
  - ch.2 Data Models and Query Languages → cross-ref for relational vs document
  - ch.3 Storage and Retrieval → Query Patterns and SQL Hygiene section
  - ch.7 Transactions → Transactions and Boundaries section
- **Effective Java 3rd ed.** — Bloch (2018) items 7-9 → Connection & Resource Management section
- **Domain-Driven Design** — Evans (2003) → Repository pattern grounding

### Process (retired — failure-edge coverage folded into `test-quality`)

**Books**
- **Code Complete 2nd ed.** — Steve McConnell (2004)
  - ch.3 Measure Twice, Cut Once → Pre-Flight checks 1, 5
  - ch.5 Design in Construction → Pre-Flight check 2
  - ch.8 Defensive Programming → Pre-Flight check 3 (edge cases)
  - ch.25-26 Code-Tuning → Post-Validation check 8 (Big-O)
- **The Pragmatic Programmer** — Hunt & Thomas (1999/2019)
  - ch.2 Tracer Bullets → Pre-Flight check 1
  - ch.4 Pragmatic Paranoia, Design by Contract → Pre-Flight check 3 + Post-Validation check 9
  - ch.5 Decoupling → Pre-Flight check 4 (blast radius)
- **The Clean Coder** — Robert C. Martin (2011)
  - **chs.2-3 Saying No / Saying Yes** → Commitment Discipline section (specific objections vs. silent overcommitment; "I will + date" vs. "soon")
  - ch.7 Acceptance Testing → Post-Validation check 6
  - ch.10 Estimation → Pre-Flight check 5
- **The Mythical Man-Month** — Fred Brooks (1975/1995)
  - ch.2 Brooks's Law → Principles Behind These Checks
  - ch.7 Why Did the Tower of Babel Fail → Pre-Flight check 4 (dependencies/communication)
  - ch.16 No Silver Bullet → Principles (essence vs. accident)
- **A Philosophy of Software Design** — John Ousterhout (2018/2021)
  - ch.11 Design It Twice → Pre-Flight checks 2, 5
- **Agile Software Development** — Robert C. Martin (2002)
  - ch.3 measured velocity and revisable iteration plans → forecast discipline and replanning
  - ch.4 customer acceptance tests → story-completion evidence in post-validation

**Articles & Papers**
- **Painless Software Schedules** — Joel Spolsky → Pre-Flight check 5 (estimation discipline; weak signal in this skill but cited)
- **Out of the Tar Pit** — Moseley & Marks (2006) → Principles (essential vs. accidental complexity)

**Lineage:** Built from the maintainer's CLAUDE.md "Planning Process" section. The 9 checks (5 pre-flight + 4 post-validation) map directly to that source.

---

### `skills/review.md`

**Articles**
- **Code Review Developer Guide** — Google Engineering Practices (CC BY 3.0) → Review Priority Order section (design > functionality > complexity > tests > naming > comments > style)
- **The Standard of Code Review** — Google Engineering Practices → "net positive over current state, not perfection" framing
- **What to Look For in a Code Review** — Google Engineering Practices → ranked review dimensions
- **The CL Author's Guide / Small CLs** — Google Engineering Practices → CL-size guidance (≤200 sweet spot, >400 split, refactor + feature in separate CLs)

**Lineage**
- `code-reviewer` agent from `~/.claude/plugins/marketplaces/claude-plugins-official/plugins/pr-review-toolkit/agents/code-reviewer.md`
- `review-pr` orchestrator from `~/.claude/plugins/marketplaces/claude-plugins-official/plugins/pr-review-toolkit/commands/review-pr.md`

**Pattern:** Confidence-scored review (≥80 threshold), CLAUDE.md-driven, bug detection + general code quality, plus merged PR-review orchestration modes (`quick`, `full-pr`, `targeted-follow-up`).

**Agent files**: `mithril-review` and `mithril-security-review` were derived from these canonical skills (`skills/review.md`, `skills/security-review.md`).

---

### `skills/security-review.md`

**Source:** `security-auditor` agent from `~/.claude/plugins/marketplaces/claude-plugins-official/plugins/code-modernization/agents/security-auditor.md`

**Pattern:** Adversarial OWASP/CWE review with exploit scenarios. Backed today by:
- **OWASP Top 10:2021** (web application security risks)
  - A01 Broken Access Control, A02 Cryptographic Failures, A03 Injection, A05 Security Misconfiguration, A06 Vulnerable Components, A07 Identification/Auth Failures, A10 SSRF → existing systematic checklist
  - **A04 Insecure Design** → architectural threat-modeling subsection (trust boundaries, abuse cases, secure design patterns, no security-by-obscurity, defense in depth)
  - **A08 Software/Data Integrity Failures** → supply chain subsection (pinned deps + lockfile review, signed artifacts, CI/CD trust boundaries, SBOM)
  - **A09 Security Logging/Monitoring Failures** → detection subsection (auth events, sensitive ops, failed-access logging, log integrity, retention, alert routing)
- **Selected OWASP ASVS control families** for code-review-relevant checks (authentication, session management, access control, validation, crypto, configuration, logging)
- **CWE catalog** (Common Weakness Enumeration)
- **SAST**: Semgrep (OWASP Top 10 + secrets + security-audit rulesets), CodeQL for deep taint analysis, plus language-specific scanners (Bandit, ESLint-security, gosec, Brakeman, SpotBugs+find-sec-bugs)
- **SCA**: `npm audit`, `pip-audit`, `govulncheck`, `bundle audit`, OWASP Dependency-Check, Trivy
- **Secrets scanning**: gitleaks, trufflehog
- **IaC scanning**: checkov, tfsec, trivy config

**Tool stance:** tools are recommended, not required. Their absence is *not blocking* — the review proceeds via manual code reading. But missing/failed tools must be called out explicitly so the coverage profile is visible to the reader.

---

### `skills/gates.md`

**Pattern:** The objective, tool-measured floor beneath the reading agents — the enforceable form of judgments the other skills make qualitatively. Backed by:
- **Continuous Delivery** (Humble & Farley) — automated quality gates in the deployment pipeline
- **A Philosophy of Software Design** ch.19 (Ousterhout) — complexity as the thing to measure; **Clean Code** function-size/complexity heuristics
- **Software Engineering at Google** chs.11, 20 — coverage and static analysis at scale
- **GOOS** ch.19 — mutation testing as the test-quality oracle
- **CRAP** metric — Savoia & Evans (2007), `crap4j` (see `Resources/Originals/Citations/Articles.md`); the one gate sourced outside the book canon, included because it measures the complex-*and*-undertested interaction nothing else in the set catches
- Enforceable-gate framing adapted from the constitution/engineering model in [unclebob/swarm-forge](https://github.com/unclebob/swarm-forge)

### Specification (retired — acceptance scenarios folded into `test-quality`, the review contract into the router and `review`)

**Source:** Synthesized fresh — no prior agent ancestor. The layer upstream of `test-quality.md`: spec quality before code.
- **Specification by Example** (Adzic, 2011) — the seven process patterns, key-example discipline, living documentation (`Resources/Books/Testing/28-Specification-by-Example.md`)
- **Agile Software Development** (Martin, 2002) — user stories as revisable planning units and customer acceptance tests as the executable definition of story completion
- **BDD / Given-When-Then** (Dan North) + **The Cucumber Book** (Wynne & Hellesøy) — Gherkin structure
- **The Clean Coder** ch.8 + **Continuous Delivery** ch.8 — acceptance tests as executable specifications
- **Domain-Driven Design** (Evans) — ubiquitous language
- Acceptance-level (Gherkin) mutation adapted from `gherkin-mutator` in [unclebob/swarm-forge](https://github.com/unclebob/swarm-forge)

### Performance (retired — folded into `code-quality` and `persistence`)

**Source:** Synthesized 2026 audit — primary home for Theme 18's *speed/cost* half (was scattered across code-quality / persistence).
- **Systems Performance** (Gregg) — USE method (Utilization / Saturation / Errors); measure-then-change
- **SQL Performance Explained** (Winand) — indexes, `SELECT *`, sargable predicates, keyset vs OFFSET
- **Database Internals** (Petrov) — storage engines under the ORM
- **Designing Data-Intensive Applications** (Kleppmann) — latency percentiles, load
- **Code Complete** ch.25–26 + **APOSD** ch.20 + **Effective Java** item 67 — premature optimization discipline
- **Release It!** — pools, unbounded results; **PEAA** — Lazy Load / N+1 pathology

### `skills/observability.md`

**Source:** Synthesized 2026 audit — primary home for Theme 18's *debuggability* half (was thin inside delivery).
- **Site Reliability Engineering** (Beyer et al.) — golden signals, SLIs/SLOs, error budgets, practical alerting
- **Observability Engineering** (Majors, Fong-Jones, Miranda) — high-cardinality events, unknown-unknowns, trace context
- **Twelve-Factor App** XI — logs to stdout / structured telemetry
- **Release It!** — control plane / instrumentation
- OpenTelemetry conceptual model — correlated traces/metrics/logs

### `skills/accessibility.md`

**Source:** Synthesized 2026 audit — Theme 19; product UI floor.
- **WCAG 2.2** (W3C) — POUR; Level AA default (`Resources/Standards/09-WCAG.md`)
- **WAI-ARIA Authoring Practices (APG)** — keyboard/state contracts for custom widgets
- HTML living standard semantics — buttons, labels, landmarks, headings
- Inclusive design practice (GOV.UK / Inclusive Components patterns) — forms, dialogs, focus management

### `skills/usability.md`

**Source:** Synthesized 2026 usability expansion — Theme 20; task-centered UI review and direct-observation discipline.
- **Don't Make Me Think, Revisited** — scanning and satisficing, visual hierarchy, navigation and orientation, concise content, mobile usability, goodwill, and low-cost testing
- **Rocket Surgery Made Easy** — realistic tasks, representative-enough recruiting, neutral facilitation, shared observation, rapid debriefing, prioritized fixes, and retesting
- **Specification by Example** — goal-centered examples and observable outcomes as inputs to research tasks, without scripting the interface path
- **WCAG 2.2 / APG** — adjacent accessibility floor; usability review complements but never replaces it

---

## What's Deliberately Not Synthesized (vs absorbed)

The master resource list (`CS-Best-Practices-Resources.md`) is larger than the executable skill surface. Use this table as the honest absorption map.

### Context-only (principles filter through other sources)

| Source | Why not a standalone skill | Summary |
|--------|----------------------------|---------|
| **SICP** | Foundational/educational; filters through FP discipline, concurrency, patterns | [24-SICP.md](Resources/Books/Language-Specific/24-SICP.md) |
| **NASA's Power of 10 Rules** | Safety-critical C; overlaps code-quality / gates, not a full skill | [04-NASA-Power-of-10.md](Resources/Standards/04-NASA-Power-of-10.md) |
| **Effective Java** (full 90 items) | Language-specific; selected items in persistence/patterns/concurrency | [22-Effective-Java.md](Resources/Books/Language-Specific/22-Effective-Java.md) |

### Deeply absorbed into skills + Constitution (2024–2026)

| Source | Primary skill(s) |
|--------|------------------|
| Continuous Delivery, Trunk-Based Dev, 12-Factor, Feature Toggles | `delivery` |
| DDIA, Waldo, Microservices, CQRS/ES, EIP, Building Microservices | `distributed` (+ `persistence` for storage chapters) |
| GoF, Head First Design Patterns | `patterns` |
| PEAA catalog | `persistence` |
| JCiP + EJ ch.11 | `concurrency` |
| SRE, Systems Performance, SQL Performance Explained | `delivery` + `code-quality` + `persistence` + **Theme 18** |
| Threat Modeling (Shostack), Building Secure and Reliable Systems | `security-review` + Constitution Art. V |
| Tidy First? | `refactor` |
| Grokking Simplicity, Domain Modeling Made Functional | `code-quality` (FP) + `architecture` (illegal states / aggregates) |
| Observability Engineering, API Design Patterns, Supply-chain note | `observability` / `delivery` / `architecture` / `security-review` |
| Systems Performance, SQL Performance Explained, SRE (ops half) | `performance` + `observability` + Theme 18 |
| WCAG 2.2 / APG | `accessibility` + Theme 19 |
| Don't Make Me Think, Rocket Surgery Made Easy | `usability` + Theme 20 |
| Google Eng Practices | `review` |
| GOOS ch.18, Spec by Example | `test-quality` (acceptance scenarios) + the router's review contract |
| Release It! | `architecture` resilience + `distributed` |
| Mythical Man-Month, Joel schedules / never-rewrite | `process`, `refactor` |

### Runtime parity rule

When a named checklist is missing from a canonical runtime skill or the Constitution, that is a defect. Run `bash healthcheck.sh` for parity.

---

## How to Update

When extending or revising a skill:

1. **Edit the skill in `skills/`** — it is the sole source of truth and the runtime prompt
2. **Run `bash healthcheck.sh`**
3. **If adding a new source**, update both:
   - The skill's "Sources" line at the top of its file
   - This README's "Sources by Skill" section
4. **If adding a new aspect to the orchestrator**, update `claude/commands/mithril.md`'s aspect routing table and tips section

---

## Worked Example: A Full `/mithril` Session

A walkthrough so you (or future-you in 3 months) can re-orient.

### Scenario
You just finished a feature: added an `/api/users/:id/orders` endpoint that fetches a user's orders. Files changed:
- `src/routes/users.ts` (new endpoint handler)
- `src/services/orderService.ts` (new method `getOrdersForUser`)
- `src/services/orderService.test.ts` (one new test)

### Step 1 — Ready to commit, run the default
```
/mithril
```

The orchestrator:
1. Runs `git rev-parse --is-inside-work-tree` → confirms git repo
2. Runs `git diff` and `git diff --name-only` → identifies the three changed files
3. Establishes the Review Contract before judging the code:
  - Goal: an authenticated user can retrieve only that user's orders
  - Key examples: own orders returned; another user's ID denied; unknown user handled with the agreed error
  - If those outcomes are absent or contradictory, labels the contract ASSUMED, reviews against it, and lists the open questions at the top of the report
4. Shares that contract with every agent it spawns.
5. Auto-selects the remaining agents based on detectable signals:
   - `mithril-code-quality` (always, source files changed)
   - `mithril-architecture` (new function/endpoint adds structural surface)
   - `mithril-test-quality` (test file in diff)
   - `mithril-security-review` (file in `routes/` path)
   - `mithril-flow` (new route handler: traces request → service → DB)
6. Spawns the applicable agents in parallel via `Task`
7. Each returns findings tagged Critical / Important / Minor
8. Orchestrator re-reads every Critical/Important finding against the code, demotes any without a concrete failure scenario, deduplicates, and aggregates

### Step 2 — Read the report

Hypothetical output:
```
## Critical — Fix Before Committing
- [mithril-security-review] src/routes/users.ts:18 — IDOR: no ownership check;
  user A can fetch user B's orders by changing the path param

## Important — Fix Before PR
- [mithril-test-quality] orderService.test.ts:42 — only happy path tested;
  missing test for non-existent userId
- [mithril-architecture] orderService.ts:15 — direct DB import in service
  layer; should go through repository

## Minor — Worth Doing
- [mithril-code-quality] orderService.ts:23 — variable `data` is vague;
  rename to `userOrders`

Counts: Critical: 1 | Important: 2 | Minor: 1
Verdict: SIGNIFICANT ISSUES
```

### Step 3 — Fix Critical, re-run

Add the ownership check, re-run `/mithril`. If now `NEEDS WORK`, fix the Importants and re-run. When `SHIP IT`, commit.

### Step 4 — Optional: targeted follow-ups

Want named refactoring moves for the architecture finding?
```
/mithril refactor
```

Mode 2 returns specific Fowler moves (e.g., "Extract Repository — mechanics: ...").

---

## Smoke Test Recipe

Before relying on `/mithril` for anything important, run it once on a low-stakes diff to confirm everything wires up.

```bash
# In any git repo with some uncommitted changes:
cd ~/some-test-repo

# Make a trivial change — anything that produces a diff:
echo "// test comment" >> src/some-file.ts

# Run the framework:
# (in Claude Code or Grok session)
/mithril
```

**Expected:**
- Orchestrator detects the change
- Agents spawn (you'll see "◆ Spawning agents in parallel...")
- Each returns a report
- Aggregated output with verdict appears
- Verdict on a trivial comment-only change should be `SHIP IT` or maybe one Minor finding

**If it doesn't work:**
- Agent fails to spawn → check the `mithril` plugin is installed and enabled
- Orchestrator says "no diff found" but you have changes → check `git status`
- Output format looks broken → see Troubleshooting below

---

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|-------------|-----|
| `/mithril` not recognized | Plugin not installed or not enabled | `/plugin` (Claude Code) or `grok plugin enable mithril` (Grok) |
| Orchestrator asks for files instead of using diff | Not a git repo OR no changes | `git status` — confirm you're in a repo with uncommitted work |
| Agent returns nothing useful | Diff is empty or trivial | Verify `git diff` shows substantive changes |
| Agent times out | Diff too large | Run targeted aspect on subset: `/mithril code` on specific file |
| Severity counts don't match findings | Some agent didn't tag severity inline | Check that agent file has the `[CRITICAL]/[IMPORTANT]/[MINOR]` tagging instruction |
| An agent reports `PASS`, `High`, or another off-vocabulary word | That agent's output format drifted from the shared vocabulary | Every agent uses `[CRITICAL]/[IMPORTANT]/[MINOR]` and `SHIP IT / NEEDS WORK / SIGNIFICANT ISSUES`; `bash healthcheck.sh` asserts it |
| Output is severity-grouped but I want category-grouped | Default is severity-grouped (orchestrator); per-agent reports are category-grouped | Run agents directly via `Task` (Claude) or `spawn_subagent` (Grok) for per-agent category view |
| Agents disagree about a finding | Expected — different lenses | Orchestrator preserves the most severe rating during deduplication |
| Grok can't find `mithril-*` agents | Plugin not installed or disabled | `grok plugin install jackreichert/mithril --trust` then `grok plugin enable mithril` |

If output is consistently broken, smoke-test a single agent directly via `Task` (Claude Code) or `spawn_subagent` (Grok) to isolate whether the bug is in the orchestrator or the agent.

---

*Created 2026-05-01. Update whenever the framework grows.*
