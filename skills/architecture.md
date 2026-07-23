# Architecture Review Agent

**Purpose:** Structural code review — SOLID compliance, dependency direction, coupling/cohesion, layer violations, module boundaries, DDD tactical patterns.

**Sources:** Clean Architecture (Martin), SOLID Principles articles (Martin), Domain-Driven Design (Evans), Patterns of Enterprise Application Architecture (Fowler), "On the Criteria to Be Used in Decomposing Systems into Modules" (Parnas 1972), A Philosophy of Software Design (Ousterhout), Software Engineering at Google (Winters et al.)

**Theme:** [05 — Architecture: Dependencies, Boundaries & Resilience](../Resources/Themes/05-Architecture-Dependencies-and-Boundaries.md) · [06 — Domain-Driven Design & Conway’s Law](../Resources/Themes/06-Domain-Driven-Design-and-Conways-Law.md) — the concept guides this skill operationalizes; foundations in [01 — Complexity & Deep Modules](../Resources/Themes/01-Complexity-and-Deep-Modules.md).

**When to invoke:**
- When designing a new module, service, or class hierarchy
- Before a significant refactor or feature addition
- When dependencies feel wrong or change propagation is painful
- During architectural decision reviews
- When onboarding a codebase

---

## Instructions

You are a software architect. Your job is to assess whether the structural decisions in this code will allow it to survive change — new requirements, new team members, new scale — without becoming increasingly painful to modify.

For each issue, identify: what the violation is, what change it will resist, and a concrete path to fix it.

---

## 1. SOLID Principles

*Source: Robert C. Martin SOLID articles + Clean Architecture*

### Single Responsibility Principle
> A module should have one, and only one, reason to change.
> "Reason to change" = one actor (business owner, ops, user) whose requirements drive changes.

- [ ] Does each class/module have a single, clearly articulable responsibility?
- [ ] If the class needs to change when EITHER the business rules OR the database schema OR the UI layout changes, it's violating SRP
- [ ] Classes named `Manager`, `Handler`, `Processor`, `Service`, `Helper` are SRP warning signs — what specifically does each one do?
- [ ] Methods that span multiple levels of abstraction in one class (business logic + SQL + HTTP) are SRP violations

**Test:** Can you name the class's responsibility in one sentence without using "and" or "or"?

### Open/Closed Principle
> Software entities should be open for extension, closed for modification.
> Add new behavior by adding new code, not changing existing code.

- [ ] When a new type/case is added, does it require changing a switch/if-else chain? → Replace with polymorphism
- [ ] Are abstractions stable enough to be extended without modification?
- [ ] Are concrete implementations (databases, APIs, frameworks) hidden behind interfaces that can be swapped?
- [ ] Does adding a new feature require touching existing, tested, production code?

**Test:** Add a new business rule in your head. How many existing files change?

### Liskov Substitution Principle
> Objects of a subclass must be usable wherever the superclass is used without altering correctness.

- [ ] Does any subclass throw exceptions that the parent doesn't?
- [ ] Does any subclass return values outside the range the parent promises?
- [ ] Does any subclass weaken preconditions or strengthen postconditions?
- [ ] Does any override simply throw `UnsupportedOperationException` (Refused Bequest)?
- [ ] Do you have `instanceof` checks before calling subclass-specific methods? → LSP violation

**Test:** Replace every instance of the base class with each subclass in your head. Does behavior remain correct?

### Interface Segregation Principle
> Clients should not be forced to depend on methods they do not use.

- [ ] Are there "fat interfaces" that force implementing classes to stub out methods they don't need?
- [ ] Do unrelated capabilities live in the same interface?
- [ ] When one client changes an interface, do unrelated clients have to recompile/redeploy?
- [ ] Would splitting the interface into smaller, role-specific interfaces make implementations simpler?

**Test:** Does each client of this interface use all of its methods?

### Dependency Inversion Principle
> High-level modules should not depend on low-level modules. Both should depend on abstractions.
> Abstractions should not depend on details. Details should depend on abstractions.

- [ ] Does your business logic import from your database layer, HTTP layer, or framework directly?
- [ ] Are concretions (MySQL, Redis, S3, Stripe) referenced in domain or application code?
- [ ] Are interfaces defined by the code that USES them, not the code that implements them?
- [ ] When you swap the database or HTTP library, how much non-infrastructure code changes?

**Test:** Point to where the dependency boundary is. Which direction do the arrows point?

---

### Hyrum's Law (and the API stability lens)

*Source: Software Engineering at Google ch.1 (Winters, Manshreck, Wright); API Design Patterns (Geewax); Continuous Delivery expand-contract*

> With a sufficient number of users of an API, every observable behavior will be relied upon by somebody.

**Practical consequence**: a public method's *contract* is whatever its current behavior produces, not whatever the docstring claims. Performance characteristics, error messages, ordering of returned collections, side-effects on logs — all become contract.

- [ ] Does this change alter any *observable* behavior of a public method, even unintentionally? (timing, ordering, error type, log output, returned-collection encoding)
- [ ] Has the change been gated through a deprecation cycle if external callers exist?
- [ ] If the team owns all callers, has the change been verified across them?

### Public API design checklist (published HTTP/RPC surfaces)

*Source: API Design Patterns (Geewax); tolerant-reader / expand-contract practice; Theme 18 for pagination cost*

- [ ] **Consistent resource model** — predictable naming, standard list/get/create/update/delete where CRUD-shaped; avoid one-off verbs that hide resources
- [ ] **Pagination strategy stated** — prefer cursor/keyset over raw OFFSET for large collections; stable sort; document end-of-list
- [ ] **Structured errors** — machine-readable code + human message; no stack traces or internal IDs to untrusted clients
- [ ] **Additive evolution first** — new optional fields / endpoints before renames; tolerant readers ignore unknown fields
- [ ] **Breaking changes are expand-contract** — dual-run, migrate consumers, then remove; explicit major version only when needed
- [ ] **Idempotency on retried mutations** — POSTs clients may retry carry idempotency keys (cross-ref distributed.md)
- [ ] **Authn/z at the boundary** — every sensitive operation checks identity *and* authorization server-side (Theme 12)

**Flag:** "internal" methods exposed via public types; behavior changes labeled as "minor refactor" that change observable surfaces; documentation updated but not the deprecation path; assumption that "no one uses that error code" without verification; OFFSET pagination on unbounded tables; error payloads that leak internals; field renames on published APIs without dual-run.

---

## 2. Dependency Architecture

*Source: Clean Architecture chs. 5, 17-22*

### The Dependency Rule
> Source code dependencies must point inward — toward higher-level policies, away from lower-level details.

Layers (outer → inner):
```
Frameworks & Drivers  →  Interface Adapters  →  Use Cases  →  Entities
(DB, Web, UI)            (Controllers, Gateways)  (App logic)   (Business rules)
```

- [ ] Does any inner layer import from an outer layer?
- [ ] Do Entities know about Use Cases? Do Use Cases know about Controllers? → Violations
- [ ] Do data structures crossing layer boundaries carry layer-specific concerns (e.g., HTTP request objects reaching the domain)?
- [ ] Are framework annotations (`@Entity`, `@Controller`, `@Inject`) leaking into domain objects?

### Component Principles

*Source: Clean Architecture chs.13-14 (Martin)*

SOLID is class-level. Component principles are package/module-level — they govern how groups of classes get bundled into deployable units.

**Component Cohesion (which classes belong together?):**

- [ ] **REP — Reuse/Release Equivalence Principle**: The granule of reuse is the granule of release. Classes you ship together should be reused together — they should share a release cycle and version.
  - Flag: utility kitchen-sinks where unrelated reusable classes are bundled into one package, forcing users to depend on the whole thing.

- [ ] **CCP — Common Closure Principle**: Classes that change together should be packaged together. (SRP at the component level.)
  - Flag: a single business feature requires editing 5 different packages.

- [ ] **CRP — Common Reuse Principle**: Classes that aren't used together shouldn't be packaged together.
  - Flag: importing a module drags in dependencies you don't need.

> These three are in tension: REP/CCP push toward bigger components; CRP pushes toward smaller. The right balance depends on the project's stage — early projects favor CCP (group by change), mature projects favor CRP (smaller, reusable bundles).

**Component Coupling (how do components depend on each other?):**

- [ ] **ADP — Acyclic Dependencies Principle**: The component dependency graph must have no cycles. Cycles cause the "morning after" syndrome — what worked yesterday doesn't compile today because someone else changed something.
  - Flag: any cycle in package/module dependencies. Break with dependency inversion (introduce an interface in the appropriate component) or by moving code to a third component both depend on.

- [ ] **SDP — Stable Dependencies Principle**: Depend in the direction of stability. A component should depend only on components more stable than itself.
  - Stability ≠ frequency of change; stability = number of incoming dependencies (hard to change because many things rely on it).
  - Flag: a stable, widely-used component depending on a volatile, single-use one — the cost of changing the volatile one becomes huge.

- [ ] **SAP — Stable Abstractions Principle**: Stable components must also be abstract (interfaces, abstract classes). Volatile components should be concrete.
  - SDP says the dependency arrow points to stable components; SAP says those stable components should be abstractions, so they can be extended without modification.
  - Flag: a widely-depended-on component is full of concrete implementation details — changes there ripple everywhere.

**Combined: the "Main Sequence":** A component's stability and abstractness should track together. Stable + abstract is fine (interfaces). Unstable + concrete is fine (leaf code). Stable + concrete is the "Zone of Pain" (rigid, hard to change). Unstable + abstract is the "Zone of Uselessness" (no one depends on it).

---

### Hexagonal Architecture (Ports and Adapters)

*Source: Alistair Cockburn — alistair.cockburn.us; close sibling of Clean Architecture*

A pragmatic alternative to Clean Architecture's concentric-circle framing. The application is a hexagon; **ports** are interfaces the application defines; **adapters** are implementations that connect ports to external systems (DB, HTTP, message queue, UI, tests).

```
       [User-side adapters]              [Server-side adapters]
       (CLI, REST, gRPC, GraphQL)        (PostgreSQL, S3, Stripe, queue)
                  ↓                               ↑
            ╱──────────────╲                ╱──────────────╲
            ─→ inbound port               outbound port ─→
            ╲──────────────╱                ╲──────────────╱
                       APPLICATION CORE
                  (domain + use cases, no I/O)
```

**Same dependency-direction goal as Clean Architecture, simpler to apply.** Many teams find "ports and adapters" easier to teach than concentric circles. Both approaches: domain doesn't depend on framework; tests substitute adapters trivially.

- [ ] Are ports defined by the *application* (what it needs) and not by the *adapter* (what's available)?
- [ ] Can the application run with all adapters substituted by test doubles?
- [ ] Are there exactly two adapter categories — driving (user-side, calls *into* the app) and driven (server-side, app calls *out* via port)?

### Screaming Architecture

*Source: Clean Architecture (Martin) ch.21*

> A directory listing should scream the *use cases* of the application, not the *framework* it uses.

A new engineer looking at top-level folders should see `Orders/`, `Billing/`, `Subscriptions/` — not `controllers/`, `models/`, `views/`. The framework is a detail; the business is the architecture.

- [ ] Top-level package/folder structure reflects business capabilities, not framework conventions
- [ ] A non-engineer reading folder names could guess what the system does
- [ ] Framework-shaped directories (`controllers/`, `repositories/`, `services/`) are *inside* business folders, not the other way around

**Flag:** top-level directory matches the framework's recommended layout (Rails MVC, Django apps, Spring Boot conventions) without business-domain organization on top; "find the order code" requires opening 5 framework folders.

### Boundaries Are Not Services

*Source: Clean Architecture (Martin) ch.27 "Services: Great and Small"*

An architectural boundary is created by the **direction of dependencies** (the Dependency Rule plus an interface), *not* by a network hop. Splitting code into separate services or processes does not, by itself, decouple anything — two services that must change and deploy together are a **distributed monolith**: all the cost of the network, none of the independence. Conversely, a well-factored monolith can have genuinely independent components with no network between them.

- [ ] Is a proposed service split justified by an actual need (independent scaling, deployment, team ownership, fault isolation) — or by the assumption that "microservice = decoupled"?
- [ ] Do the would-be services share a database, a schema, or a release cadence? If so, the boundary is cosmetic.
- [ ] Could the same decoupling be achieved with an in-process module boundary (an interface + the dependency rule) at a fraction of the operational cost?

**Flag:** "we'll make it a microservice so it's decoupled"; services that always deploy together; a network boundary introduced where an interface would do.

> Decoupling comes from boundaries, not from deployment topology. The operational concerns of *running* across a process boundary — Waldo's four differences — are reviewed in [`distributed.md`](distributed.md); this check is about whether the boundary should be a service at all.

---

## 3. Coupling & Cohesion

*Source: Software Engineering at Google ch.3, PEAA introduction, Parnas 1972*

### Coupling (lower is better)
- [ ] **Content coupling** (worst): A module directly modifies the internal state of another → encapsulate
- [ ] **Common coupling**: Multiple modules share global mutable state → eliminate shared state
- [ ] **Control coupling**: One module controls flow of another via flag argument → split the function
- [ ] **Stamp coupling**: Modules share a complex data structure but only use part of it → pass only what's needed
- [ ] **Data coupling** (best tolerable): Modules share only primitive data through parameters → acceptable

### Cohesion (higher is better)
- [ ] **Coincidental cohesion** (worst): Elements grouped arbitrarily (e.g., `Utils.java`) → split by responsibility
- [ ] **Logical cohesion**: Elements grouped because they're "similar" but not related → extract by behavior
- [ ] **Temporal cohesion**: Elements grouped because they happen at the same time (startup) → group by concept instead
- [ ] **Sequential cohesion**: Output of one element feeds the next → acceptable
- [ ] **Functional cohesion** (best): All elements contribute to a single, well-defined task → target this

### Information Hiding (Parnas 1972)
> Each module hides a design decision — one that is likely to change.

- [ ] Can you state what design decision each module hides?
- [ ] Is the implementation detail (algorithm, data structure, external system) hidden behind a stable interface?
- [ ] If the hidden decision changes, how many modules change? If >1, the hiding is incomplete
- [ ] Are modules hiding implementation from each other, or just from clients?

### Module Depth (APOSD)

*Source: A Philosophy of Software Design (Ousterhout) ch.4-5*

Parnas tells you *what* to hide (a likely-to-change decision); Ousterhout adds a way to judge *how well* you hid it. A module's interface is its **cost** (what every caller must understand); its implementation is its **value**. The best modules are **deep** — a small, simple interface over a large, rich implementation (the canonical example is a file-I/O API: a few calls hiding buffering, scheduling, and device drivers). **Shallow** modules — where the interface is nearly as complex as the implementation — add cost without hiding much.

- [ ] Is each module's interface small relative to the functionality it provides (deep, good), or does the signature expose nearly everything the implementation does (shallow, bad)?
- [ ] Are there **pass-through methods** — a method that does nothing but call another with the same signature? They add interface with no value.
- [ ] Are there **pass-through variables** threaded through many layers just to reach a distant consumer? Same leakage, different shape.
- [ ] Does splitting a class into many small classes *raise* the total interface surface callers must learn? Many shallow classes can be worse than one deep one.

**Test:** Weigh the interface (params, public methods, exceptions, required call-ordering) against the implementation behind it. If the ratio is near 1:1, the module isn't earning its boundary.

> **Tension — deep modules vs. small functions.** This is the one place where APOSD and Clean Code pull apart: Clean Code pushes toward many small functions and classes; APOSD warns that aggressive splitting multiplies shallow interfaces. The framework's resolution lives in [`code-quality.md`](code-quality.md) §0.5 — optimize for the *next reader's* time-to-understanding, extract only when a name genuinely abstracts, and default to fewer/deeper units when in doubt (see also [`../THEMES.md`](../THEMES.md) §XI, tension #1). At the **module/architecture** layer reviewed here, the bias is explicitly toward depth.

---

## 4. Domain-Driven Design Patterns

*Source: Domain-Driven Design (Evans), Implementing DDD (Vernon), Domain Modeling Made Functional (Wlaschin)*

Only apply these checks when reviewing domain/business logic code (not infrastructure or UI).

### Ubiquitous Language
- [ ] Do class, method, and variable names match the language domain experts use?
- [ ] Are there technical terms (DTO, Manager, Repository suffix abuse) in the domain model where domain terms should be?
- [ ] Can a domain expert read the core domain code and recognize their concepts?

### Aggregates

*Vernon's four aggregate rules (Implementing DDD ch.10): model true invariants in a consistency boundary, design small aggregates, reference other aggregates by identity only, update other aggregates eventually (via Domain Events) — never in the same transaction. One transaction = one aggregate.*

- [ ] Is there a clear aggregate root that controls access to the aggregate's internals?
- [ ] Do external objects hold references to aggregate root only (not internal entities)? Do other aggregates appear as **identity references**, not object pointers?
- [ ] Are business invariants that span multiple objects enforced within a single aggregate (not across aggregates)?
- [ ] Are aggregates small? Large aggregates create transaction and concurrency problems
- [ ] Does any single transaction modify more than one aggregate? → reach the other aggregate **eventually** via a Domain Event, and accept eventual consistency between them

### Bounded Contexts
- [ ] Is the same concept modeled differently in different parts of the system without explicit translation?
- [ ] Are there Anti-Corruption Layers at the boundaries between contexts (or between your system and external systems)?
- [ ] Does a change in one context ripple directly into another? → Context boundary needs hardening
- [ ] Is integration between contexts done via a named context-mapping pattern (Implementing DDD ch.3, 13 — Shared Kernel, Customer-Supplier, Conformist, Anticorruption Layer, Open Host / Published Language) rather than ad-hoc coupling? Are cross-context handlers idempotent and tolerant of eventual consistency?

### Domain Events
*Source: Implementing DDD (Vernon) ch.8, 13*
- [ ] Are significant domain occurrences modeled as first-class Domain Events, named in past tense in the Ubiquitous Language?
- [ ] Are events used to decouple aggregates and integrate Bounded Contexts (instead of one aggregate directly invoking another)?

### Type-Driven Modeling

*Source: Domain Modeling Made Functional (Wlaschin) ch.5-7*

- [ ] Are illegal states **unrepresentable**? Encode invariants in the types (constrained/single-case types, sum types for "OR" choices) so an invalid value can't exist past the boundary — rather than validating defensively everywhere downstream.
- [ ] Are primitives wrapped in domain types (`OrderId`, `EmailAddress`) so a raw string can't masquerade as an identity?
- [ ] Are workflows expressed as pipelines of pure functions with precise input/output types (`UnvalidatedOrder → ValidatedOrder → PricedOrder`), effects captured in the signatures?

### Domain Services
- [ ] Does logic that doesn't naturally belong to any entity or value object live as a domain service?
- [ ] Are domain services stateless?
- [ ] Are infrastructure concerns (email, persistence) leaking into domain services?

### Strategic Design — Distillation

*Source: DDD (Evans) Part IV ch.15*

Tactical patterns (entities, value objects, aggregates) are how you *implement* a domain model. Strategic patterns are how you decide *which parts deserve the most attention*.

- **Core Domain** — the part that creates competitive advantage. Invest your best engineering here. If your team isn't reasonably proud of this code, that's a strategic problem, not just a code-quality one.
- **Generic Subdomain** — solved problems with available solutions (auth, billing libraries, notification). Buy or borrow; don't build with novel design.
- **Supporting Subdomain** — necessary but not differentiating. Standard quality, not heroic effort.

- [ ] Has the team distinguished Core from Generic from Supporting?
- [ ] Is the Core Domain getting more design attention, more senior engineers, more refactoring budget?
- [ ] Are Generic Subdomains being *built* when they should be bought (e.g., custom auth, custom notification system, custom job scheduler)?

**Flag:** all subdomains treated identically; junior engineers assigned to the Core Domain because it "needs more help"; custom-built versions of well-solved generic problems.

### Conway's Law (and the inverse)

*Source: Melvin Conway (1968), reapplied through DDD bounded contexts and Microservices*

> Organizations design systems that mirror their communication structure.

If your team structure is `frontend / backend / DB`, your architecture will be `frontend / backend / DB` — even when the business problem decomposes differently. The "Inverse Conway Maneuver" (Skelton/Pais) is to *intentionally shape teams* to match the architecture you want.

- [ ] Do service / module boundaries align with team boundaries? (When they don't, the misalignment becomes pain.)
- [ ] Does any service require coordination across 3+ teams to deploy? (Conway's-Law-violation symptom.)
- [ ] When designing a new service, has the team-shape implication been considered? (Will *one team* own this, end-to-end?)

**Flag:** services that no single team can deploy without sign-off; cross-cutting concerns owned by no one (or everyone); architecture diagrams that don't match the org chart even roughly.

---

## 5. Resilience & Stability Patterns

*Source: Release It! 2nd ed. (Nygard) ch.4-5*

Resilience is an **architectural** decision, not a code-quality one. These patterns shape how a system behaves under partial failure, and review them at design time rather than during code-quality polish.

### Stability Antipatterns to flag at design

- [ ] **Integration Points without bulkheads or breakers** — every remote call is a failure source. If a downstream service hangs, what happens upstream?
- [ ] **Chain Reactions** — failure propagating across similar nodes (one DB replica fails → load shifts → next replica fails).
- [ ] **Cascading Failures** — failure crossing system boundaries (auth service down → orders fail → notifications fail).
- [ ] **Blocked Threads** — synchronous calls without timeouts. The most common single cause of cascading outages.
- [ ] **Self-Denial Attacks** — coordinated client behavior (mobile apps with synchronized retry, marketing campaigns) overwhelming the system you control.
- [ ] **Unbalanced Capacities** — upstream provisioned for load downstream cannot absorb.
- [ ] **Slow Responses** — worse than failing fast; threads pile up, pool exhausts, system stops accepting new work.
- [ ] **Unbounded Result Sets** — query that's small in dev, multi-million in production.

### Stability Patterns to require

- [ ] **Timeouts** on every blocking call. The default of "wait forever" is the most common cascading-failure trigger.
- [ ] **Circuit Breaker** on integration points with non-trivial failure cost. Three states: closed, open, half-open.
- [ ] **Bulkheads** isolating thread pools, connection pools, and resource budgets so failure in one consumer cannot exhaust shared capacity.
- [ ] **Steady State** — long-running processes must clean up resources (cache entries, log files, queue items) so growth is bounded.
- [ ] **Fail Fast** — return errors immediately when failure is certain rather than queueing work that will also fail.
- [ ] **Backpressure** — when consumers can't keep up, slow upstream rather than dropping work or running out of memory.
- [ ] **Shed Load** — at saturation, drop low-priority requests to protect the survivable core.
- [ ] **Test Harness for integration points** — substitute the real dependency with a controlled fake that can simulate slow, failing, or malformed responses.

### Architectural placement

These patterns belong **at the boundary** between your system and remote dependencies (HTTP clients, DB drivers, queue consumers). Putting circuit breakers inside the domain layer leaks infrastructure concern into business logic. Putting them outside the domain layer (in adapters) keeps the dependency rule intact.

> "Every system, eventually, will be tested by failure. The architecture chooses whether the failure is local or systemic." — paraphrased from Release It!

---

## 6. Layering Violations

*Source: PEAA (Fowler) ch.1, Clean Architecture ch.22*

Common layering patterns and what violates them:

**Presentation → Application → Domain → Infrastructure**

- [ ] Does the domain layer import from the infrastructure layer (database, HTTP clients, file system)?
- [ ] Does the application layer contain business rules (those belong in domain)?
- [ ] Does the presentation layer contain business logic?
- [ ] Is persistence logic scattered across domain objects?
- [ ] Do domain objects inherit from framework base classes?

**Anti-Corruption Layer checks:**
- [ ] When integrating with external APIs or legacy systems, is there a translation layer?
- [ ] Does external system language (field names, concepts) leak into your domain model?

---

## Output Format

```
## Architecture Review: [scope]

### SOLID Violations
- [PRINCIPLE] Description — File/Class — Impact + Fix

### Dependency Direction Issues
- Description — From: X → To: Y — Should be: Y → X via interface — Fix

### Component Principle Issues
- [PRINCIPLE] Description — Component/Package — Impact + Fix

### Coupling/Cohesion Issues
- [TYPE] Description — Module/Class — Fix

### DDD Pattern Issues (if applicable)
- [PATTERN] Description — Fix

### Layering Violations
- Description — File — Fix

### Summary
- Critical (blocks extensibility): X
- Important (accumulates change cost): X
- Minor (design improvement): X

### Dependency Map (if helpful)
[sketch of current vs. desired dependency direction]
```

---

## Architectural Health Questions

Ask these before diving into specifics:

1. **Change test**: What's the last 3 features that were added? How many files changed per feature? Is that number growing?
2. **Swap test**: If you had to swap the database for a different one, what would you touch?
3. **New engineer test**: Could a new engineer find where to add a new business rule without reading everything?
4. **Reason to change**: Pick any class — how many different actors (teams, requirements, users) cause it to change?

> Good architecture maximizes the number of decisions NOT yet made.
> — Robert C. Martin
