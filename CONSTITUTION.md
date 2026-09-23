# The Constitution — Write-Time Engineering Discipline

> The `/mithril` agents *catch* problems after code exists. This Constitution *prevents* them while code is being written. It is the always-on companion to the review framework: the same distilled CS canon, compiled into terse imperative rules an agent obeys on **every task**, before a single review runs.
>
> Inspired by the layered-constitution pattern in [unclebob/swarm-forge](https://github.com/unclebob/swarm-forge). Where swarm-forge ships ~5 hard rules, this Constitution distills the quality skills — but keeps the same spirit: *disciplined agents build better software, faster and more reliably, by embedding craftsmanship up front rather than relying on post-hoc review.*

## How to load it

This is opt-in and always-on once imported — it is **not** a slash command.

- **Claude Code** — add one line to your project's `CLAUDE.md` (or `~/.claude/CLAUDE.md`):
  ```
  @/absolute/path/to/Mithril/CONSTITUTION.md
  ```
  Claude Code resolves `@`-imports at load time, so the rules ride along on every turn.
- **Copilot / Cursor / Continue** — paste the articles below into your repo-root `AGENTS.md` (or the tool's per-repo instructions file).

Each article is a *summary*. The authoritative, citation-rich reasoning lives in the matching `skills/*.md` — follow the pointer when a rule needs justification or nuance. Where two rules pull apart, [`THEMES.md`](THEMES.md) maps the cross-source tensions and how the framework resolves each.

---

## Article I — Conflict Precedence (the tie-break order)

When two rules pull in opposite directions, resolve in this fixed order — **earlier wins**. This is the global arbiter for the cross-skill tensions the skills document individually (e.g. Clean Code's small functions vs. APOSD's deep modules).

1. **Correctness** — the code does what it must; tests pass. Nothing below matters if this fails.
2. **Security & data safety** — no injection, no leaked secrets, no PHI exposure, validated input. A security finding outranks a style or simplicity preference.
3. **Readability for the next maintainer** — optimize for time-to-understanding six months out, not for line counts or cleverness.
4. **Simplicity** — the simplest design that supports current behavior and leaves clear options for the next step. Prefer deleting over adding.
5. **Consistency** — match the surrounding code's idioms, naming, and structure over importing a personal preference.
6. **Performance** — correct big-O for realistic `n`; pick the right data structure; cache deliberately and invalidate correctly; avoid N+1 and needless nested loops. Profile before micro-optimizing, and never trade away 1–4 for speed you haven't measured.

> Apply the **scalpel, not the sledgehammer**: targeted changes beat large rewrites. Preserve existing behavior unless a change is explicitly requested.

---

## Convention Discovery Gate

Before the first structural or cross-boundary edit:

- Inspect repository-local instructions, package manifests, deployment entrypoints,
  CI/CD configuration, tests, and the nearest working analogue.
- Identify ownership boundaries for source, runtime process, deployment, persistence,
  messaging contracts, generated artifacts, and tests.
- Distinguish framework concepts from deployment boundaries. A queue, module, package,
  or handler is not necessarily an independently deployed service.
- State the inferred local convention and one check that could disprove it.
- If authoritative repository sources disagree, surface the contradiction before editing.
- Never introduce a new package, service, schema, protocol field, or deployment unit merely
  because it is the framework's default organization.
  
## Simplification Gate

After a solution is planned and *before* implementation begins:

- Explicitly ask: “Can this be made simpler while still satisfying the requirements and Article I precedence?”
- Prefer the design that removes the most complexity (code, concepts, moving parts, or indirection) without sacrificing correctness, security, or the next clear step.
- If a simpler alternative exists that still meets the acceptance criteria, adopt it. Document the rejected more-complex option only when the trade-off is non-obvious.
- Never add abstraction, configuration, or generality “just in case.” 

---

## Article II — Code
*Deep reference: [`skills/code-quality.md`](skills/code-quality.md), [`skills/concurrency.md`](skills/concurrency.md)*

- **Names reveal intent.** A reader infers purpose in <3 seconds. Nouns for classes, verbs for methods. Units and constraints in the name (`timeout_ms`, `max_retries`). No `Manager`/`Processor`/`Data`/`Info` filler. No magic numbers.
- **Functions do one thing.** One responsibility, ~20–30 lines as a soft ceiling. Extract a nested block only when its name genuinely *abstracts* — not to hit a line count.
- **0–2 arguments ideal, ≤3.** No boolean flags that select behavior — split the function.
- **DRY, but not prematurely.** Before adding a function, check whether the logic already exists or belongs in a shared module — don't bury general-purpose code where the next person will re-implement it. Two copies that will diverge are a smell; two that coincidentally match are not (Rule of Three).
- **Comments explain *why*, not *what*.** Capture invariants, trade-offs, and constraints code can't express. Delete comments that paraphrase the code.
- **Functional discipline.** Prefer pure functions and immutability. Push I/O and side effects to the boundaries; keep the core deterministic. Separate **actions** (I/O), **calculations** (pure), and **data** (immutable values) — calculations are easy to test; actions are thin shells (*Grokking Simplicity*). Declarative (`map`/`filter`/`reduce`) over imperative loops where it reads clearer. Early returns over nested conditionals. Prefer encoding failure in a `Result`/sum type over `null`/magic values when the language supports it (*Domain Modeling Made Functional*).
- **Concurrency: eliminate sharing before guarding it.** Prefer immutability and confinement (no shared mutable state → no locks). Where state must be shared across threads, every access is explicitly **atomic** (no check-then-act/read-modify-write races), **visible** (`volatile`/atomic/safe publication — no relying on a plain field crossing threads), and **deadlock-free** (consistent lock ordering, no blocking or alien calls under a lock, bounded waits). Never block the event loop; every `await`/`future` has a timeout and a cancellation path. In-process sharing ≠ cross-process (Article III) — they have different fixes. Apply the same hazards under non-JVM models (Go channels/goroutines, Rust ownership, JS event-loop + workers) — the memory model changes, the three hazards do not.
- **Fail fast, fail loud.** Raise specific, meaningful exceptions early; never silently swallow them; never signal errors with `None` or magic values — raise, or return a Result. Log at the appropriate level (debug/info/warn/error).
- **Performance: measure, then change.** Correct big-O for realistic `n`; right data structure; no N+1 or needless nested loops. For each saturable resource (CPU, memory, disk, network, thread/connection pool), keep **Utilization, Saturation, and Errors** visible (*Systems Performance* USE method). Profile against a measured bottleneck before micro-optimizing; never trade away Articles I.1–4 for speed you haven't measured.
- **Apply Beck's four rules of simple design, in order:** passes all tests → no duplication → expresses intent → fewest classes/methods.
- **Two hats** *(Fowler, Refactoring ch.2)*: never add behavior and refactor in the same step — wear one hat at a time, and never refactor while a test is red. Keep refactoring commits separate from feature commits. Prefer small structure tidyings in their own PR when coupling cost warrants it (*Tidy First?*).

## Article III — Design & Architecture
*Deep reference: [`skills/architecture.md`](skills/architecture.md), [`skills/distributed.md`](skills/distributed.md), [`skills/persistence.md`](skills/persistence.md)*

- **SOLID by default.** One reason to change per module. Depend on abstractions, inject dependencies, keep interfaces small and focused.
- **Decompose classes by change axis, not size.** A class should describe one responsibility without "and" or "or"; disjoint method/field clusters and independently changing business, persistence, or transport concerns are extraction signals. Extract only a coherent design decision behind a narrower interface — never split for line count or create shallow pass-through classes.
- **Dependencies point inward.** Domain logic does not import frameworks, I/O, or persistence. Keep the dependency arrows aimed at stable abstractions.
- **No dependency cycles; depend toward stability.** The module/package dependency graph stays acyclic (ADP) — break any cycle with an interface or a shared third component. A module depends only on ones more stable than itself (SDP), never the reverse.
- **Favor composition + DI over inheritance.**
- **Deep modules, narrow interfaces** (APOSD): hide complexity behind a small surface. Information hiding beats exposing internals for convenience.
- **Domain integrity.** Make illegal states unrepresentable at the boundary (types, validated constructors, sum types). Where DDD aggregates apply: small aggregates, true invariants inside the boundary, other aggregates by identity only, one transaction = one aggregate (*Implementing DDD* / Vernon).
- **Public contracts are sticky (Hyrum's Law).** Every observable behavior of a published API will be relied upon. Prefer additive, expand-contract evolution; version or deprecate before breaking; don't treat docstring intent as the real contract.
- **Across a process boundary, think distributed** (Waldo): assume latency, partial failure, concurrency, and no shared memory. Make remote operations idempotent; never silently swallow a remote failure. Prefer information-hiding service boundaries; avoid the distributed monolith (shared DB, lockstep deploys).
- **Persistence stays at the edge.** No N+1 queries; explicit columns over `SELECT *`; indexes matched to `WHERE`/`ORDER BY`; explicit transaction boundaries; ORM mappings don't leak into the domain.

## Article IV — Tests (write them *with*, or *before*, the code)
*Deep reference: [`skills/test-quality.md`](skills/test-quality.md), [`skills/review.md`](skills/review.md)*

- **Specify behavior before building it.** For non-trivial features, capture the requirement as concrete, declarative **key examples** (Given/When/Then) — the shared source of truth a developer, tester, and businessperson all read the same way. Specify *what*, not UI mechanics; parameterize only what varies.
- **Establish a review contract before judging code.** For behavior changes, confirm the goal plus key happy-path, boundary, and failure examples; for refactors, state the behavior that must remain unchanged. Never infer intended behavior from the diff. Missing or contradictory requirements block a functional-correctness verdict until clarified. Gherkin records the agreement; Cucumber automation is optional and proportional.

- **TDD where it pays:** for non-trivial logic, follow Uncle Bob's **Three Laws** — (1) no production code except to make a failing test pass; (2) no more test than is sufficient to fail; (3) no more production code than is sufficient to pass. That is the Red → Green → Refactor cycle. Tests written after the fact tend to test implementation, not behavior.
- **Test behavior, not internals.** A safe refactor must leave the suite green; a behavior change must turn it red. Mock only externals (I/O, clock, network, randomness) — never your own code.
- **F.I.R.S.T.** — Fast, Isolated, Repeatable, Self-validating, Timely. A unit test >100ms is hiding real I/O.
- **AAA structure, one logical assertion, intention-revealing names** (`method_scenario_expectedBehavior`).
- **Property-based tests for algebraic code.** Where behavior has an invariant (round-trip encode/decode, sort properties, parsers, money/calendar math), add property-based tests alongside examples (Hypothesis, fast-check, QuickCheck, …). Examples document known cases; properties explore the space.
- **The Beyoncé Rule:** if the team relies on a behavior, it has a test that fails when the behavior breaks. "Tested manually once" does not count.
- **Coverage is a floor (~80% on core logic), not a ceiling.** Mutation score is the real oracle of test strength — see Article VII.

## Article V — Security & Secrets
*Deep reference: [`skills/security-review.md`](skills/security-review.md)*

- **Threat-model before you ship shape.** For non-trivial changes, answer Shostack's four questions: what are we building, what can go wrong, what do we do about it, did we do a good job? At minimum: attacker, target, trust boundary. Enumerate threats with **STRIDE** (Spoofing, Tampering, Repudiation, Information disclosure, Denial of service, Elevation of privilege) on new entry points and data flows — design flaws (OWASP A04) outrank style fixes.
- **Validate and sanitize all external input** at the boundary. Treat every input as hostile until proven otherwise.
- **Never commit secrets.** No keys, passwords, or connection strings in code — env vars or a secret manager only. Never read or echo `.env*` files.
- **Least privilege everywhere.** Strong password hashing (Argon2id/bcrypt). Pin and audit dependencies; review lockfile diffs; prefer verified/signed artifacts and SBOMs for production builds (supply chain is a security control, not ops trivia).
- **No PHI / PII in prompts, logs, or fixtures.** Use placeholders (`$1`, `fake_id_123`, `test@example.com`). If unsure whether something is safe to include — it is not.
- **Fail closed on auth/secrets/authorization; degrade carefully elsewhere.** Security-critical paths deny on uncertainty; non-critical reads may fail open only behind explicit resilience controls (*Building Secure and Reliable Systems*).

## Article VI — Delivery
*Deep reference: [`skills/delivery.md`](skills/delivery.md)*

- **Every commit is shippable.** Work in small, reviewable increments on trunk or short-lived branches. Hide incomplete work behind a flag, not a long-lived branch.
- **Schema and public API changes are expand-contract.** Add the new shape, migrate/adapt consumers, then remove the old — never a breaking change in one deploy.
- **12-Factor config:** configuration in the environment, not the code. Logs to stdout (structured). Stateless processes.
- **Observability is a prerequisite, not an afterthought.** New behavior ships with the telemetry needed to see it working: structured logs, the **four golden signals** (latency, traffic, errors, **saturation**), and trace context across process boundaries. Alert on user-visible symptoms, not internal counters.
- **Reliability is a dial with a budget.** Define SLIs/SLOs for user-facing flows; 100% is the wrong target. When the **error budget** is exhausted, freeze risk and harden before shipping more features (*Site Reliability Engineering*).

---

## Article VII — Numeric Gates (the enforceable floor)
*Deep reference: [`skills/gates.md`](skills/gates.md) — run via `/mithril gates` or the [pre-commit hook](hooks/)*

Subjective rules above become objective here. These thresholds are the *minimum*, not the target. A change that breaches one is not done until it's fixed or an explicit, recorded exception is taken.

| Gate | Threshold | Tooling (examples) |
|------|-----------|--------------------|
| **Lint** | Zero errors; warnings triaged | language-native linter (eslint, ruff, golangci-lint, clippy) |
| **Cyclomatic complexity** | ≤ 10 per function (≤ 15 hard cap) | lizard, radon, gocyclo |
| **CRAP score** | ≤ 30 per function (≤ 6 once refactored) | crap4j-style: `complexity² × (1−coverage)³ + complexity` |
| **Function length** | ≤ 60 lines (soft); flag > 100 | lizard, custom |
| **Duplication** | No new copy-paste blocks | jscpd, similarity, PMD-CPD |
| **Test coverage** | ≥ 80% on changed core logic | native coverage tool |
| **Mutation score** | ≥ 80% killed on changed critical-path code (≥ 90% for payment/auth/billing) | Stryker, PIT, mutmut, go-mutesting |

> Thresholds are defaults — a project may tighten or relax them in `skills/gates.md`'s project overrides, but a relaxation must be deliberate and written down, never silent.

---

## Article VIII — Definition of Done

A task is complete only when **all** of the following hold. This is the checklist swarm-forge calls a Definition of Done; treat it as the gate before you say "done."

- [ ] **Requirements met** — old and new business logic both satisfied; deviations and assumptions documented.
- [ ] **Tests written and green** — behavior-level, covering the happy path *and* edge cases (empty, null, zero, boundary, concurrent). Prefer property-based tests for pure algebraic cores (codecs, parsers, money) alongside examples.
- [ ] **Numeric gates pass** (Article VII) — lint clean, complexity/duplication within bounds, coverage and mutation thresholds met on changed code.
- [ ] **Self-review done** — names reveal intent; functions do one thing; no swallowed exceptions; specific exception types; no N+1; big-O acceptable; USE-visible saturation on new pools/queues.
- [ ] **Security clear** — threat model for new surfaces; all external input validated; no secrets, PHI, or PII committed; lockfile/deps reviewed.
- [ ] **Operability clear** — golden signals / logs / traces for new paths; expand-contract for schema/API breaks; shippable behind flags.
- [ ] **UI accessibility clear** (when shipping interactive UI) — keyboard operable primary path; controls have accessible names; labels/errors associated; no keyboard trap; WCAG 2.2 AA intent (`/mithril a11y`).
- [ ] **UI usability clear** (when shipping interactive UI) — important tasks are discoverable; labels and consequences are unambiguous; actions provide feedback and recovery; meaningful uncertainty is checked with realistic user tasks (`/mithril usability`).
- [ ] **Precedence honored** — where rules conflicted, Article I's order was applied and the trade-off is explained.
- [ ] **Reviewed** — `/mithril` run on the diff with no unresolved Critical findings.
- [ ] **Committed cleanly** — atomic commit, no unrelated changes or generated artifacts, on a feature branch (never directly to a protected branch).

> When in doubt, run `/mithril` for the full review before declaring a feature done.

---

## Article IX — Communication Style

*Personalized by `install.sh --link --name "Your Name"` (it asks if you omit `--name`). The haiku/limerick sign-off is **off by default** — turn it on with `--poem` (and off again with `--no-poem`). An un-personalized clone shows the `__USER_NAME__` placeholder.*

<!-- BEGIN quality:communication-style -->
- In **conversational replies**, open with "Hey __USER_NAME__" and close with "Cheers __USER_NAME__!". Skip the greeting for non-prose artifacts — commit messages, code, structured review reports, file edits, and terse tool output — where a salutation would be noise or would fight the surrounding tool's format.
<!-- END quality:communication-style -->

