# 05 — Architecture: Dependencies, Boundaries & Resilience

> **Tier 3 · Design at scale.** The same war as Theme 01, fought between components instead of inside them: which way dependencies point, where boundaries sit, and whether the system stays up when its neighbors don't. **Skill:** [`skills/architecture.md`](../../skills/architecture.md) · agent `quality-architecture`.

## The idea in one paragraph

Architecture is dependency management. SOLID gives the class-level grammar — single reason to change, open for extension, substitutable subtypes, client-specific interfaces, and above all **dependency inversion**: depend on abstractions, and make the abstractions belong to the policy, not the mechanism. Scaled up, the same rule becomes the layered discipline of Clean Architecture and Cockburn's Hexagonal Architecture (two drawings of one idea): **dependencies point inward** toward business rules; databases, frameworks, and delivery mechanisms are plugins behind ports; a use case must be testable with no web server and no database running. Martin's component principles then govern the boundaries themselves — what to group (REP/CCP/CRP: group what changes together) and how component graphs must hang together (ADP: no cycles; SDP: depend toward stability; SAP: stable things should be abstract). Hyrum's Law adds the sobering observation that with enough users, every observable behavior of an interface becomes a contract someone depends on — so boundary hygiene is not optional. And Nygard extends architecture to its production fate: every out-of-process call is an **integration point** that will eventually hang, flood, or lie, and the stability patterns — Timeout, Circuit Breaker, Bulkhead, Fail Fast, Steady State, Backpressure — are the difference between a component failure and a cascading outage.

## The arc (how the ideas build)

- **SOLID as dependency grammar** (Martin, *The Principles of OOD*; Clean Architecture ch. 7–11) — SRP (one reason to change — one *actor*), OCP (add behavior by adding code, not editing it), LSP (subtypes keep promises), ISP (no client forced to depend on what it doesn't use), DIP (both high- and low-level code depend on abstractions). DIP is the load-bearing one: it's what makes the inward-pointing arrow possible at every scale.
- **Dependencies point inward** (Clean Architecture ch. 22; Cockburn, Hexagonal) — entities ← use cases ← interface adapters ← frameworks/drivers; nothing in an inner circle knows an outer circle exists. Hexagonal says the same with ports (defined by the application) and adapters (implementing them for Postgres, HTTP, the message bus). The acid test in both: business rules compile and test without the delivery mechanism.
- **Boundaries scream the domain** (Clean Architecture ch. 21) — a codebase's top-level structure should announce *what the system does* (accounting, orders, payroll), not *what framework it uses* (controllers, models, views). Framework-first layout is a dependency arrow pointing the wrong way at the level of the directory tree.
- **Component cohesion and coupling** (Clean Architecture ch. 13–14) — cohesion: REP (release together), CCP (group what changes together — SRP for components), CRP (don't force reuse of what isn't used together). Coupling: ADP (the dependency graph is acyclic, or builds and reasoning both break), SDP (depend in the direction of stability), SAP (the stable core should be abstract so it can still evolve). CCP and CRP pull opposite directions; the balance shifts over a project's life.
- **Layering discipline** (Fowler, PEAA ch. 1) — presentation / domain / data source, and the rule that makes it real: domain logic that leaks into presentation or SQL is the most common architectural finding in working codebases.
- **Interfaces harden into contracts** (Hyrum's Law, *Software Engineering at Google* ch. 1) — with enough consumers, someone depends on your timing, your error strings, your iteration order. Corollaries: keep interfaces minimal (every exposed detail is future debt), and treat observable-behavior changes as breaking changes.
- **Production is part of the architecture** (Nygard, *Release It!* ch. 4–5) — the stability *antipatterns* (integration points, chain reactions, cascading failures, unbounded result sets, slow responses) and the *patterns* that answer them (Timeout on every remote call, Circuit Breaker to stop hammering a sick dependency, Bulkhead to contain the blast, Fail Fast over slow failure, Steady State, Shed Load / Backpressure). Resilience is decided at design time; a retrofit is a rewrite.

## Key concepts & frameworks

- **SOLID** — with SRP read as "one actor," not "does one thing," and DIP as the keystone.
- **The Dependency Rule** — source-code dependencies point only inward; frameworks are plugins.
- **Ports & adapters** — the application defines the port; the adapter implements it; swap adapters, not business rules.
- **Screaming architecture** — top-level structure names the domain, not the toolkit.
- **REP / CCP / CRP + ADP / SDP / SAP** — component grouping and graph discipline; no cycles, depend toward stability.
- **Hyrum's Law** — every observable behavior will be depended on; minimal interfaces age best.
- **Stability patterns & antipatterns** (Release It!) — Timeout, Circuit Breaker, Bulkhead, Fail Fast, Steady State, Backpressure vs. integration points, cascades, unbounded results.

## The sources

- ★ [**Clean Architecture** — Martin](../Books/Clean-Architecture-Trilogy/08-Clean-Architecture.md) — SOLID at scale, component principles, the Dependency Rule, screaming architecture.
- [**The Principles of OOD** — Martin](../Articles/Robert-Martin/01-The-Principles-of-OOD.md) — the original SOLID articles.
- [**Hexagonal Architecture** — Cockburn](../Articles/Martin-Fowler/12-Hexagonal-Architecture.md) — ports and adapters; the sibling drawing.
- [**Patterns of Enterprise Application Architecture** — Fowler](../Books/Domain-Systems-Design/11-Patterns-of-Enterprise-Application-Architecture.md) — ch. 1 layering.
- [**Release It!** — Nygard](../Books/Domain-Systems-Design/13-Release-It.md) — ch. 4–5 stability antipatterns and patterns.
- [**Software Engineering at Google** — Winters et al.](../Books/Engineering-Culture-Process/18-Software-Engineering-at-Google.md) — ch. 1 Hyrum's Law.
- [**On the Criteria…** — Parnas](../Papers/01-On-the-Criteria-to-Be-Used-in-Decomposing-Systems-into-Modules.md) — the 1972 root of every boundary argument here.

## What the skill encodes (operational checklist)

- [ ] Trace the arrows: any source-code dependency from business rules outward (to framework, DB, transport) is a finding.
- [ ] Business logic in controllers/adapters/SQL → name the layering violation and the move inward.
- [ ] New abstractions belong to the consumer/policy side (DIP), not to the implementation they wrap.
- [ ] Flag dependency cycles between components (ADP) and depend-on-less-stable edges (SDP).
- [ ] Every integration point (remote call, queue, DB) has a timeout; repeated-failure paths have a circuit breaker; shared resources are bulkheaded.
- [ ] Unbounded queries/result sets and missing backpressure on ingest paths are stability findings, not perf nits.
- [ ] Interface additions reviewed against Hyrum's Law: is this observable behavior something we're willing to support forever?

## Connects to

[01 — Complexity & Deep Modules](01-Complexity-and-Deep-Modules.md) (deep modules are this theme at module scale) · [06 — DDD & Conway's Law](06-Domain-Driven-Design-and-Conways-Law.md) (what the boundaries should *mean*) · [15 — Distributed Systems](15-Distributed-Systems.md) (the stability patterns' home turf) · [16 — Persistence](16-Persistence.md) (the data-source layer's own pattern catalog).
