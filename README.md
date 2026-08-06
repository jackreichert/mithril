# Mithril — Sources & Index

## What this is

This repo is a **code-quality framework** — the canonical CS literature distilled into agent-executable form — delivered through two layers:

- **Review-time (catch).** A set of specialized review agents — for code quality, architecture, refactoring, testing, security, delivery, distributed systems, design patterns, persistence, and process discipline — run against your current `git diff` and aggregate their findings into a severity-ranked verdict (`SHIP IT` / `NEEDS WORK` / `SIGNIFICANT ISSUES`). This layer runs first-class inside [Claude Code](https://docs.claude.com/claude-code) and [Grok Build](https://docs.x.ai) via the `/mithril` slash command (parallel subagent orchestration + tool execution).
- **Write-time (prevent).** The always-on [Constitution](CONSTITUTION.md) compiles the same canon into terse imperative rules an agent obeys *while writing*. It's plain markdown, so it's portable: Claude Code, Grok, GitHub Copilot, and Codex are wired natively by `install.sh --link`, and any other agentic tool (Cursor, Continue, Windsurf, Cline, Aider, Zed, …) adopts it through that tool's project-instructions file (see [Multi-tool reach](#multi-tool-reach)).

Each agent is a focused lens. The orchestrator picks which lenses are relevant to the diff, runs them in parallel, deduplicates overlap, and returns one report.

## How it was created

The framework is a **distillation of the canonical CS literature** into agent-executable form. The pipeline:

1. **Source selection.** A reading list of ~24 canonical books plus key articles and papers (Clean Code, Refactoring, A Philosophy of Software Design, Clean Architecture, GOOS, Designing Data-Intensive Applications, PEAA, Release It!, Continuous Delivery, GoF, the OWASP standards, etc.) — the full inventory lives in [`CS-Best-Practices-Resources.md`](CS-Best-Practices-Resources.md).
2. **Per-source summaries.** Each book/article was summarized into a structured note in [`Resources/`](Resources/) (Books, Articles, Papers, Standards, Originals). These summaries capture the principles, smell catalogs, patterns, and counterpoints from each source — not full reproductions, but enough to drive synthesis.
3. **Cross-source themes.** The summaries are synthesized into **19 concept guides** in [`Resources/Themes/`](Resources/Themes/) (plus the one-file horizontal cut, [`THEMES.md`](THEMES.md)) — a Tier 1→5 curriculum (foundations → construction → design at scale → verification → systems in production). Each theme walks how the idea builds across its sources, names the real tensions instead of papering over them, and ends with the operational checklist its skill encodes. The learning on-ramp, and the reasoning layer the skills cite.
4. **Synthesis into skills.** The themes and summaries were synthesized into concise, source-grounded runtime prompts in [`skills/`](skills/). These are both the executable specialists and the sole content source.
5. **Host compatibility.** Plugin manifests load `skills/*.md` directly; classic installs expose the same files under `~/.claude/agents/` and `~/.grok/agents/`.
6. **Orchestration.** The `/mithril` slash command routes a diff to the relevant agents, runs them in parallel, normalizes severity, and aggregates the report.

The "Sources by Skill" section below shows exactly which book/article/chapter informed each part of each skill, so any finding the framework produces can be traced back to a primary source.

For the master inventory of every book and article that informed this work, see [`CS-Best-Practices-Resources.md`](CS-Best-Practices-Resources.md). For the lineage of individual sections within each skill, see "Sources by Skill" further down.

---

## Quick start

Install into [Claude Code](https://docs.claude.com/claude-code) and/or [Grok Build](https://docs.x.ai) — both get the full `/mithril` review framework.

### Grok (plugin — recommended)

```bash
# from a clone, or use the GitHub shorthand once published
grok plugin install /path/to/mithril --trust
grok plugin enable mithril
```

Or classic install (also deploys Claude paths by default):

```bash
git clone https://github.com/jackreichert/mithril.git
cd mithril
bash install.sh --grok-only          # Grok only
# bash install.sh                    # Claude + Grok
```

Then in any git repo, run `/mithril` from Grok. Grok loads agents from `~/.grok/agents/` (and, via Claude compatibility, `~/.claude/agents/` if you installed both).

### Claude Code

**As a plugin** (recommended — no file copies, updates with the repo):

```
/plugin marketplace add jackreichert/mithril
/plugin install mithril@mithril
```

**Classic install** (links to the canonical skills for live updates by default):

```bash
git clone https://github.com/jackreichert/mithril.git
cd mithril
bash install.sh
```

Then run `/mithril` from Claude Code or Grok. Plugin and classic paths load the same canonical skill content. Use one installation path per host.

### What it does

`install.sh` deploys (Claude and Grok by default):

- 18 agent files into `~/.claude/agents/mithril-*.md` and `~/.grok/agents/mithril-*.md`
- The `/mithril` orchestrator into `~/.claude/commands/mithril.md` and `~/.grok/commands/mithril.md`

By default the installer links both host installations directly to `skills/`, so one edit updates every linked host. `--copy-agents` creates a frozen install instead. Re-running is idempotent.

### Useful flags

```bash
bash install.sh --dry-run             # show what would happen
bash install.sh --force               # overwrite without backups
bash install.sh --symlink-agents      # link Claude/Grok agents directly to canonical skills
bash install.sh --copy-agents         # install frozen copies instead of live links
bash install.sh --link                # link CONSTITUTION.md into Claude/Grok/Codex/Copilot (one source, no copies)
bash install.sh --name "Your Name"    # set the Constitution greeting name (with --link; asked if omitted)
bash install.sh --copilot             # (re)generate the self-contained Copilot file [--copilot-prefix F] [--copilot-out F]
bash install.sh --uninstall           # remove deployed files (incl. links)
bash install.sh --skills-dir /path    # canonical docs live elsewhere
bash install.sh --claude-home /path   # non-standard ~/.claude location
bash install.sh --grok-home /path     # non-standard ~/.grok location
bash install.sh --claude-only         # deploy Claude Code paths only
bash install.sh --grok-only           # deploy Grok paths only
bash install.sh --help
```

### One source, every tool — `--link`

`install.sh --link` wires the write-time [`CONSTITUTION.md`](CONSTITUTION.md) into the assistants from a **single canonical file, with no content copies**:

- **Claude Code** — appends a native `@import` line to `~/.claude/CLAUDE.md` (idempotent).
- **Grok** — symlinks `~/.grok/AGENTS.md` → Constitution (or the self-contained file if you also ran `--copilot`).
- **Codex** — symlinks `~/.codex/AGENTS.md` → `CONSTITUTION.md` (an existing real file is backed up first).
- **Copilot (VS Code)** — creates `instructions/CONSTITUTION.instructions.md` (a symlink) and prints the `chat.instructionsFilesLocations` settings snippet to register the folder.

Edit the Constitution once; every tool sees the change. `--uninstall` removes the symlinks and the import line. The one context this can't reach is **github.com's web Copilot**, which only reads in-repo files — commit a copy there if you need it. See [`CONSTITUTION.md`](CONSTITUTION.md) for the rules and `hooks/` for the enforcement hook.

**Personalizing the greeting.** The Constitution's communication-style article carries a `Hey {name}` / `Cheers {name}!` greeting. `--link` asks for the name (or pass `--name "Your Name"`) and writes it in. Re-running preserves the current choice.

**Copilot can't `@import`** — so for Copilot the Constitution has to be *inlined*, not referenced. `--copilot` (re)generates a self-contained Copilot instructions file (your personal prefix via `--copilot-prefix`, then the Constitution inlined) at `instructions/copilot-instructions.md` (gitignored). Re-run it whenever `CONSTITUTION.md` changes to keep Copilot in sync; symlink your IntelliJ/global Copilot file and point VS Code's `github.copilot.chat.codeGeneration.instructions` at it so the refresh propagates. github.com web Copilot still needs a manual re-paste.

### GitHub Copilot & Codex

`install.sh` installs the full review agents for Claude Code and Grok. To also give Copilot and Codex the write-time Constitution, run `install.sh --link --copilot --copilot-prefix <your-prefix>` — it generates a self-contained instructions file (your personal prefix + the Constitution inlined) and points Codex's `~/.codex/AGENTS.md` and Grok's `~/.grok/AGENTS.md` at it. The installer prints the per-surface wiring (VS Code settings ref, IntelliJ symlink, github.com paste) at the end of a run. See [Multi-tool reach](#multi-tool-reach).

### Contributing

The framework keeps one canonical agent definition in `skills/`. See [`CONTRIBUTING.md`](CONTRIBUTING.md); `bundle.sh --check` verifies plugin manifest parity.

---

## Files in This Directory

### Current Skills

| File | Focus | Agent file |
|------|-------|-----------|
| `skills/code-quality.md` | Naming, functions, smells, comments, complexity, FP, error handling, performance, structure, formatting | `~/.claude/agents/mithril-code-quality.md` |
| `skills/architecture.md` | SOLID, dependency direction, component principles, coupling/cohesion, info hiding, DDD, resilience patterns | `~/.claude/agents/mithril-architecture.md` |
| `skills/refactor.md` | Dual-mode: Mode 1 simplify (light) + Mode 2 full Fowler-catalog refactor plan, plus Branch by Abstraction & Strangler Fig | `~/.claude/agents/mithril-refactor.md` |
| `skills/review.md` | Confidence-scored code review with quick, full-PR, and targeted-follow-up modes; Google design-first priority | `~/.claude/agents/mithril-review.md` |
| `skills/security-review.md` | Adversarial security review using OWASP Top 10, CWE, and selected OWASP ASVS control families | `~/.claude/agents/mithril-security-review.md` |
| `skills/test-quality.md` | F.I.R.S.T., AAA, naming, test doubles, xUnit Pattern smells, coverage; GOOS Listen-to-the-Tests as organizing principle | `~/.claude/agents/mithril-test-quality.md` |
| `skills/delivery.md` | CD pipeline readiness, trunk-based dev, 12-Factor compliance, feature flags, expand-contract migrations, observability prereqs | `~/.claude/agents/mithril-delivery.md` |
| `skills/distributed.md` | Waldo's four differences, replication/consistency, idempotency, partitioning, microservice boundaries, CQRS/ES tradeoffs | `~/.claude/agents/mithril-distributed.md` |
| `skills/concurrency.md` | In-process concurrency: the three hazards (atomicity, visibility, liveness), shared mutable state, races, locking discipline & deadlock, high-level utilities, async/event-loop, thread-safety contracts, testing concurrent code | `~/.claude/agents/mithril-concurrency.md` |
| `skills/patterns.md` | GoF + HFDP pattern recognition vocabulary, anti-patterns (Singleton/Visitor abuse), modern alternatives | `~/.claude/agents/mithril-patterns.md` |
| `skills/persistence.md` | PEAA pattern catalog: Active Record vs Data Mapper, Unit of Work, Repository, Lazy Load + N+1, transactions, migrations | `~/.claude/agents/mithril-persistence.md` |
| `skills/gates.md` | Objective tool-measured floor: lint, cyclomatic complexity, function length, duplication, coverage, mutation score, CRAP — runs tools and reports pass/fail vs explicit thresholds | `~/.claude/agents/mithril-gates.md` |
| `skills/specification.md` | Acceptance-criteria / BDD feature-file quality: key examples, declarative phrasing, ubiquitous language, executable & living specs, acceptance-level mutation | `~/.claude/agents/mithril-specification.md` |
| `skills/performance.md` | Measure-then-change, USE method, latency percentiles, N+1/query cost, caches, bounded fan-out — Theme 18 | `~/.claude/agents/mithril-performance.md` |
| `skills/observability.md` | Golden signals (incl. saturation), structured logs, traces, SLIs/SLOs/error budgets, alert hygiene — Theme 18 | `~/.claude/agents/mithril-observability.md` |
| `skills/accessibility.md` | WCAG 2.2 AA UI review: keyboard, names/roles/values, labels/errors, contrast, APG widgets — Theme 19 | `~/.claude/agents/mithril-accessibility.md` |
| _cross-cutting: `security-review` + `distributed` + `persistence` + `code-quality` + `performance`_ | Flow tracing — control + data flow from entry points to sinks: taint (source→sink), error propagation, resource/transaction lifecycle, N+1-across-chain, cross-boundary partial failure. Runs as Phase 2 of `/mithril deep`; standalone via `/mithril flow` | `~/.claude/agents/mithril-flow.md` |
| `skills/tutor.md` | Grounded CS tutor — teaches a concept/theme from the library, or the principles at play in a PR/diff; cites sources, surfaces tensions, explains rather than reviews | — (inline via `/mithril tutor` \| `/mithril learn`) |

### Workflow & Supporting Docs

| File | Focus | Agent file |
|------|-------|-----------|
| `README.md` | Sources, lineage, exclusions, and update guide for this framework | — |
| `CS-Best-Practices-Resources.md` | Per-source index — every book, article, and paper that informed the framework, and which idea each one owns | — |
| `THEMES.md` | Cross-cutting synthesis of the `Resources/` library — the themes that recur across sources, where they converge, and the documented tensions (with a resolution map keyed to the skills) | — |
| `Resources/Themes/` | 19 cross-source concept guides (Tier 1→5 curriculum) — the synthesis layer between the per-source summaries and the skills; each theme names its tensions and the checklist its skill encodes | — |
| `skills/process.md` | Planning discipline: pre-flight (edge cases, deps, alternatives) + post-validation (Big-O, requirements, assumptions) | `~/.claude/agents/mithril-process.md` |
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
| `skills/process.md` | Built from the maintainer's CLAUDE.md "Planning Process" section, grounded in Code Complete + Pragmatic Programmer + Clean Coder + MMM + APOSD |
| `skills/delivery.md` | Synthesized fresh from Continuous Delivery + Trunk-Based Development + 12-Factor + Feature Toggles (Hodgson) — no prior agent ancestor |
| `skills/distributed.md` | Synthesized fresh from DDIA + Waldo's "A Note on Distributed Computing" + Microservices/CQRS/Event Sourcing — no prior agent ancestor |
| `skills/concurrency.md` | Synthesized fresh from Effective Java ch.11 (items 78–84) + DDIA ch.7 + Clean Code ch.13 + SICP ch.3 + Release It! (Blocked Threads) + Out of the Tar Pit — the in-process counterpart to `distributed.md`; no prior agent ancestor |
| `skills/patterns.md` | Synthesized fresh from GoF + Head First Design Patterns + Effective Java refinements + APOSD ch.19 counterweight — no prior agent ancestor |
| `skills/persistence.md` | Synthesized fresh from PEAA pattern catalog + DDIA storage chapters + Effective Java resource-management items + DDD Repository — no prior agent ancestor |
| `skills/security-review.md` | Adapted from the `security-auditor` agent and extended with explicit security standards references |

### Orchestration

| Path | Purpose |
|------|---------|
| `~/.claude/commands/mithril.md` · `~/.grok/commands/mithril.md` | The `/mithril [aspects]` command — routes to agents, aggregates findings (Claude Code + Grok) |
| `~/.claude/agents/mithril-*.md` · `~/.grok/agents/mithril-*.md` | Canonical skills exposed under host-compatible names |
| `instructions/` (generated, gitignored) | Self-contained inlined instructions (vendor prefix + Constitution) for tools that can't `@import` — Codex & Copilot, via `install.sh --copilot` |
| `install.sh --link` / `--copilot` | Wires the Constitution into Claude (import), Grok (`~/.grok/AGENTS.md`), Codex (symlink), and Copilot (inlined file) from one source |

### Multi-tool reach

The **review framework** (`/mithril` — parallel agents, diff-routing, severity aggregation, tool-backed SAST/SCA) is first-class on **Claude Code and Grok Build**. Copilot and Codex do not offer equivalent subagent orchestration, so they get the write-time Constitution only.

The **write-time [Constitution](CONSTITUTION.md)** reaches every wired assistant from a single source (`install.sh --link`):

| Tool | How it gets the Constitution | Wired by installer? | `/mithril` review agents? |
|------|------------------------------|---------------------|---------------------------|
| **Claude Code** | native `@import` in `~/.claude/CLAUDE.md` — live | ✅ `--link` | ✅ full |
| **Grok Build** | `~/.grok/AGENTS.md` → Constitution (or self-contained file) | ✅ `--link` | ✅ full |
| **Codex** | `~/.codex/AGENTS.md` → self-contained inlined file (vendor HIPAA + Constitution) | ✅ `--link --copilot` | ❌ |
| **Copilot** (VS Code / IntelliJ / github.com) | self-contained inlined file via settings ref / symlink / paste | ✅ `--copilot` | ❌ |
| **Any other agentic tool** — Cursor, Continue, Windsurf, Cline, Aider, Zed, Gemini CLI, … | point the tool's project-instructions file at `CONSTITUTION.md` | ➖ manual (one line) | ❌ |

Claude resolves `@import` live, so editing `CONSTITUTION.md` updates it instantly. Grok, Codex, and Copilot typically want a file path or symlink; `install.sh --link` points Grok and Codex at the effective Constitution (or the self-contained file when `--copilot` has been run). github.com web Copilot can't reach external files at all, so it takes a manual paste.

**Beyond the three the installer wires.** The Constitution is just a markdown document, so *any* assistant that reads a project-level instructions file can adopt it — the installer simply doesn't automate the wiring yet. The lingua franca is the [**`AGENTS.md`**](https://agents.md) open standard: drop a repo-root `AGENTS.md` (or symlink it to `CONSTITUTION.md`) and Codex, Cursor, Zed, Gemini CLI, Jules, and a growing list of agents pick it up. Tools that use a native file instead read the same content from their own path:

| Tool | Where to put it |
|------|-----------------|
| **Cursor** | `.cursor/rules/*.mdc`, or a repo-root `AGENTS.md` |
| **Continue** | a rule in `.continue/rules/` (or `rules:` in `config.yaml`) |
| **Windsurf** | `.windsurf/rules/`, or `AGENTS.md` |
| **Cline** | `.clinerules/` |
| **Aider** | a conventions file referenced from `.aider.conf.yml`, or `AGENTS.md` |
| **Zed / Gemini CLI** | `.rules` / `GEMINI.md`, both of which also honor `AGENTS.md` |

Two caveats. (1) Like Copilot, tools that can't reference an *external* file want the **inlined** copy — generate it once with `install.sh --copilot` and point them at `instructions/copilot-instructions.md` (re-run on change). (2) Check the tool's current docs for the exact filename — these conventions move fast. Either way the principle holds: **one canonical `CONSTITUTION.md`, every tool pointed at it.**

> **Company HIPAA lives *inline* in each tool's instructions** (Claude's `CLAUDE.md`; the self-contained file for Codex/Copilot) — never delegated to the imported Constitution — so the mandate survives even where `@import` doesn't resolve.

---

## Sources by Skill

Below: the books, articles, and chapters that drove each skill's content. Citations also appear inline next to the specific sections they informed.

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

### `skills/patterns.md`

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

### `skills/process.md`

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

**Agent files**: `mithril-review.md` and `mithril-security-review.md` were derived from these canonical skills and now exist at `~/.claude/agents/`.

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

### `skills/specification.md`

**Source:** Synthesized fresh — no prior agent ancestor. The layer upstream of `test-quality.md`: spec quality before code.
- **Specification by Example** (Adzic, 2011) — the seven process patterns, key-example discipline, living documentation (`Resources/Books/Testing/28-Specification-by-Example.md`)
- **BDD / Given-When-Then** (Dan North) + **The Cucumber Book** (Wynne & Hellesøy) — Gherkin structure
- **The Clean Coder** ch.8 + **Continuous Delivery** ch.8 — acceptance tests as executable specifications
- **Domain-Driven Design** (Evans) — ubiquitous language
- Acceptance-level (Gherkin) mutation adapted from `gherkin-mutator` in [unclebob/swarm-forge](https://github.com/unclebob/swarm-forge)

### `skills/performance.md`

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
| Google Eng Practices | `review` |
| GOOS ch.18, Spec by Example | `test-quality`, `specification` |
| Release It! | `architecture` resilience + `distributed` |
| Mythical Man-Month, Joel schedules / never-rewrite | `process`, `refactor` |

### Runtime parity rule

When a named checklist is missing from a canonical runtime skill or the Constitution, that is a defect. Run `bash healthcheck.sh` for parity and redeploy copy installs after skill edits.

---

## How to Update

When extending or revising a skill:

1. **Edit the skill in `skills/`** — it is the sole source of truth and the runtime prompt
2. **Run `bash bundle.sh --check` and `bash healthcheck.sh`**
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
  - If those outcomes are absent or contradictory in the request/spec, asks for confirmation before issuing a functional verdict
4. Runs `mithril-specification` first for this behavior-affecting change. Given/When/Then is the shared format; a Cucumber suite is required only if the team chooses to keep these as executable living documentation.
5. Auto-selects the remaining agents based on detectable signals:
   - `mithril-code-quality` (always, source files changed)
   - `mithril-architecture` (new function/endpoint adds structural surface)
   - `mithril-test-quality` (test file in diff)
   - `security-auditor` (file in `routes/` path)
   - `mithril-refactor` Mode 1 (last, polish pass)
6. Passes the confirmed Review Contract to the code agents and spawns the applicable agents in parallel via `Task`
7. Each returns severity-tagged findings
8. Orchestrator deduplicates, normalizes severity, aggregates

### Step 2 — Read the report

Hypothetical output:
```
## Critical — Fix Before Committing
- [security-auditor] src/routes/users.ts:18 — IDOR: no ownership check;
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
- Agent fails to spawn → check `~/.claude/agents/mithril-*.md` and/or `~/.grok/agents/mithril-*.md` exist
- Orchestrator says "no diff found" but you have changes → check `git status`
- Output format looks broken → see Troubleshooting below

---

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|-------------|-----|
| `/mithril` not recognized | Command file missing or permission issue | `ls ~/.claude/commands/mithril.md` and `ls ~/.grok/commands/mithril.md` — re-run `install.sh` or enable the `mithril` plugin |
| Orchestrator asks for files instead of using diff | Not a git repo OR no changes | `git status` — confirm you're in a repo with uncommitted work |
| Agent returns nothing useful | Diff is empty or trivial | Verify `git diff` shows substantive changes |
| Agent times out | Diff too large | Run targeted aspect on subset: `/mithril code` on specific file |
| Severity counts don't match findings | Some agent didn't tag severity inline | Check that agent file has the `[CRITICAL]/[IMPORTANT]/[MINOR]` tagging instruction |
| Security findings get swallowed | CVSS not normalizing correctly | Check the orchestrator's severity-normalization table — `~/.claude/commands/mithril.md` or `~/.grok/commands/mithril.md` |
| Output is severity-grouped but I want category-grouped | Default is severity-grouped (orchestrator); per-agent reports are category-grouped | Run agents directly via `Task` (Claude) or `spawn_subagent` (Grok) for per-agent category view |
| Agents disagree about a finding | Expected — different lenses | Orchestrator preserves the most severe rating during deduplication |
| Grok can't find `mithril-*` agents | Classic install skipped Grok, or plugin disabled | `bash install.sh --grok-only` or `grok plugin enable mithril` |

If output is consistently broken, smoke-test a single agent directly via `Task` (Claude Code) or `spawn_subagent` (Grok) to isolate whether the bug is in the orchestrator or the agent.

---

*Created 2026-05-01. Update whenever the framework grows.*
