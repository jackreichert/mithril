# 06 — Domain-Driven Design & Conway's Law

> **Tier 3 · Design at scale.** Where boundaries should *mean* something: model the business in its own language, split the system where the language splits, and expect the org chart to ship itself. **Skill:** [`skills/architecture.md`](../../skills/architecture.md) (DDD patterns + Conway sections) · agent `quality-architecture`.

## The idea in one paragraph

Theme 05 says dependencies must point inward; this theme says what they point *at*: a model of the business domain, expressed in a **ubiquitous language** shared verbatim by code, tests, and domain experts — when the expert says "policy lapses" and the code says `deactivateRecord`, every conversation pays a translation tax and every translation loses information. Evans's tactical building blocks give the model structure: **entities** (identity over time) vs. **value objects** (immutable, interchangeable), **aggregates** whose roots guard the invariants and define the transaction boundary, **repositories** that make persistence look like a collection, and **domain services** for operations that belong to no single object. Strategically, the hard-won insight is that one unified model for a whole company is a fantasy: large systems decompose into **bounded contexts**, each with an internally-consistent model, with explicit translation — an **anti-corruption layer** — where they meet, and **distillation** deciding where the modeling investment goes (the core domain that differentiates the business, not the generic billing module). Conway supplies the sociology: organizations ship their communication structures, like it or not — so Skelton & Pais's Team Topologies runs the law *forward* (the Inverse Conway Maneuver: shape teams to get the architecture you want) with **cognitive load** as the governing budget for how much system one team can own.

## The arc (how the ideas build)

- **One language, everywhere** (Evans, Part I) — the ubiquitous language is not documentation; it *is* the model. Class, method, and test names use the domain expert's words; a rename in conversation forces a rename in code. Divergence between the two is the earliest, cheapest-to-catch modeling failure.
- **Tactical blocks** (Evans, Part II) — entities carry identity; value objects are immutable and compared by value (most "primitive obsession" findings are missing value objects); **aggregates** cluster what must change together, and the root enforces the invariants — external references go to the root only, and one transaction touches one aggregate; repositories give the domain a collection-shaped view of persistence; domain services hold logic that spans objects without becoming a god class.
- **Refactoring toward deeper insight** (Evans, Part III) — models aren't designed once; breakthroughs come mid-project, when a key abstraction finally surfaces. Making implicit concepts explicit (a `Money` type, an `OverbookingPolicy`) is the DDD version of Theme 04's refactoring.
- **Bounded contexts** (Evans, Part IV) — the same word means different things in Sales and in Shipping ("customer," "order"), and forcing one model to serve both corrupts each. Draw the line where the language changes; keep each context's model internally consistent; map the relationships between contexts explicitly.
- **The anti-corruption layer** — when your clean context must talk to a legacy or foreign model, translate at the border instead of letting the foreign model's shape seep in. The ACL is Theme 05's adapter with a modeling job.
- **Distillation** (Evans, Part IV ch. 15) — core domain (differentiates the business — model it deeply, staff it best), supporting subdomains (necessary, not differentiating), generic subdomains (buy or adopt off-the-shelf). Modeling effort is a portfolio, not a uniform coat of paint.
- **The org chart ships** (Conway 1968, "How Do Committees Invent?") — a system's structure copies the communication structure of the organization that built it. Fighting it loses; the productive move is —
- **— run it forward** (Skelton & Pais, *Team Topologies*) — the Inverse Conway Maneuver: design team boundaries to induce the architecture you want. Four team types (stream-aligned by default; platform; enabling; complicated-subsystem) and three interaction modes (collaboration, X-as-a-service, facilitating), all governed by **cognitive load**: a team owns what fits in its collective head — which is also the honest sizing rule for a bounded context or a service.

## Key concepts & frameworks

- **Ubiquitous language** — code and conversation share one vocabulary; divergence is a finding.
- **Entity vs. value object** — identity vs. value semantics; immutable VOs kill a whole class of state bugs (Theme 01's state culprit).
- **Aggregate = consistency + transaction boundary** — invariants live at the root; cross-aggregate consistency is eventual by design.
- **Repository** — collection-semantics persistence seam (the domain-facing half of Theme 16).
- **Bounded context & context mapping** — one model per language region; explicit relationships between regions.
- **Anti-corruption layer** — translate at the border; never import a foreign model wholesale.
- **Core / supporting / generic distillation** — invest modeling depth where the business differentiates.
- **Conway's Law + Inverse Conway Maneuver** — architecture and org chart are one design problem; team cognitive load bounds context size.

## The sources

- ★ [**Domain-Driven Design** — Evans](../Books/Domain-Systems-Design/10-Domain-Driven-Design.md) — the whole arc: language, building blocks, contexts, distillation.
- [**Team Topologies** — Skelton & Pais](../Books/Engineering-Culture-Process/26-Team-Topologies.md) — the four team types, interaction modes, cognitive load, and the Inverse Conway Maneuver. (Conway's 1968 paper is the root; Team Topologies is this library's carrier for it.)
- [**Patterns of Enterprise Application Architecture** — Fowler](../Books/Domain-Systems-Design/11-Patterns-of-Enterprise-Application-Architecture.md) — ch. 2 domain-logic patterns: when a full Domain Model earns its cost vs. a Transaction Script (the honest low end).
- [**Clean Architecture** — Martin](../Books/Clean-Architecture-Trilogy/08-Clean-Architecture.md) — the Dependency Rule the domain model sits at the center of.

## What the skill encodes (operational checklist)

- [ ] Names in code that contradict the domain expert's vocabulary → ubiquitous-language finding (with the domain word as the fix).
- [ ] Domain concepts hiding in primitives (money as float, status as string) → introduce the value object.
- [ ] Transactions spanning multiple aggregates, or invariants enforced outside the root → aggregate-boundary finding.
- [ ] Foreign/legacy model types imported deep into a context → prescribe an anti-corruption layer at the border.
- [ ] One model straining to serve two languages ("customer" meaning different things) → propose the context split.
- [ ] Deep-modeling effort spent on generic subdomains (hand-rolled auth, bespoke billing) while the core is anemic → distillation finding.
- [ ] Service/module boundaries that no team can own within its cognitive load → Conway finding, stated as a design risk.

## Connects to

[05 — Architecture](05-Architecture-Dependencies-and-Boundaries.md) (the mechanics these boundaries run on) · [10 — Specification by Example](10-Specification-by-Example.md) (specs written in the ubiquitous language) · [15 — Distributed Systems](15-Distributed-Systems.md) (service boundaries = bounded contexts, or a distributed monolith results) · [16 — Persistence](16-Persistence.md) (repositories and aggregate-shaped transactions at the data layer).
