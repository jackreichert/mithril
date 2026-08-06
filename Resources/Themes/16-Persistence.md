# 16 — Persistence: The Data Layer

> **Tier 5 · Systems in production.** The pattern catalog between domain and database: which domain-logic style to build on, how objects and rows map without lying to each other, where transactions begin and end, and the resource discipline underneath it all. **Skill:** [`skills/persistence.md`](../../skills/persistence.md) · agent `mithril-persistence` (lifecycle tracing: `mithril-flow`).

## The idea in one paragraph

Most "ORM problems" are pattern mismatches: a team picks a mapping technology before choosing a domain-logic pattern, and then fights the consequences forever. Fowler's PEAA lays out the decision in order. First, domain logic: **Transaction Script** (procedural, honest, right for simple logic), **Domain Model** (rich objects, right when business rules are complex — and the only one that pays DDD's rent, Theme 06), or **Table Module** (one instance per table, a middle path). *Then* the mapping follows: **Active Record** (object = row + save/load methods; simple, couples domain to schema — correct for CRUD, a trap when logic grows) versus **Data Mapper** (a separate layer moves data both ways; the domain model stays persistence-ignorant — the pattern behind Hibernate/EF cores). Around the mapping sit the behavioral trio every serious ORM implements — **Unit of Work** (track changes, commit as one transaction), **Identity Map** (one in-memory instance per row per session), and **Lazy Load**, whose signature failure is the **N+1 query** (one query for the list, one per element — invisible at 10 rows in dev, a fire at 10,000 in production). **Repository** (PEAA + Evans) gives the domain a collection-shaped seam that keeps query construction out of business logic. Kleppmann supplies the transactional floor — what isolation levels actually promise (dirty/non-repeatable/phantom reads; write skew at snapshot isolation) — PEAA's offline-concurrency patterns extend correctness across user think-time where database transactions can't reach, and Bloch's items 7–9 cover the unglamorous foundation: connections and cursors are resources, and resources leak unless closed deterministically.

## The arc (how the ideas build)

- **Domain logic first, mapping second** (PEAA ch. 2) — Transaction Script vs. Domain Model vs. Table Module is the load-bearing choice; each has an honest domain. Complex invariants in Transaction Scripts duplicate across scripts (Shotgun Surgery at the data layer); a Domain Model for three CRUD tables is ceremony. The anemic domain model — Domain Model shapes, Transaction Script soul, logic drained into "service" classes — is the classic mismatch finding.
- **Active Record vs. Data Mapper** (PEAA ch. 10) — AR is fast to build and welds domain to schema (schema change = domain change; testing needs a database). Data Mapper buys persistence ignorance at mapping-layer cost. The choice keys to the domain-logic choice — AR fits Transaction Script/simple domains, Mapper fits rich Domain Models — not to fashion.
- **The behavioral trio** (PEAA ch. 11) — **Unit of Work**: business logic mutates objects; one commit flushes the net change atomically (scattered mid-logic saves defeat both atomicity and batching). **Identity Map**: two objects for one row is a lost-update generator inside a single session. **Lazy Load**: four flavors (lazy init, virtual proxy, value holder, ghost), one signature failure —
- **— N+1, the emblematic finding** — a loop touching a lazy association issues a query per iteration. The fix is deliberate fetch strategy at the *query* level (eager join/fetch for known access patterns, projection for read-only shapes), and the review rule is blunt: any query inside a loop, explicit or ORM-implicit, must justify itself.
- **Repository & Query Object** (PEAA; Evans) — the domain sees a collection (`orders.overdueFor(customer)`); query construction lives behind the seam. Criteria/SQL leaking into domain services couples business logic to the store (Theme 05's layering violation at the data edge); repositories returning half-hydrated objects leak the mapping instead.
- **Transactions: short, deliberate, isolation-aware** (PEAA ch. 5; DDIA ch. 7) — the transaction boundary is a *use case*, not a method that happens to touch the DB (and one aggregate, in Theme 06 terms). Isolation levels are a menu of permitted anomalies: read committed (non-repeatable reads allowed), snapshot/repeatable read (write skew allowed — the on-call-doctors bug), serializable (correct, contended). The finding pattern: code assuming serializable behavior while the connection defaults to read committed.
- **Concurrency across think-time** (PEAA offline-concurrency) — a user edit spanning minutes can't hold a DB transaction. **Optimistic Offline Lock** (version column, conflict on stale write — the default), **Pessimistic Offline Lock** (reserve first — when conflicts are common and merges are painful), **Coarse-Grained Lock** (one version for an aggregate). Missing version checks on read-modify-write over user think-time = silent lost updates.
- **Resources leak by default** (Bloch items 7–9) — connections, statements, cursors are non-memory resources; GC finalization is not a strategy. try-with-resources/`using`/context-manager idioms make release deterministic; a connection acquired outside such a scope is a leak the load test will find in production.
- **Schema evolves by expand–contract** (CD ch. 12; Theme 14) — the data layer's deployment contract: migrations versioned in the repo, backward-compatible one release each way, destructive steps deferred a release.

## Key concepts & frameworks

- **Transaction Script / Domain Model / Table Module** — the first decision; the anemic model as its classic failure.
- **Active Record ⇄ Data Mapper** — coupling vs. mapping cost, keyed to domain complexity.
- **Unit of Work · Identity Map · Lazy Load** — the ORM's behavioral core, and what each protects against.
- **N+1** — the query-in-a-loop family; fetch strategy as a deliberate, per-use-case choice.
- **Repository + Query Object** — collection semantics as the domain-facing seam.
- **Isolation levels as permitted anomalies** — read committed → serializable; write skew as the subtle one.
- **Optimistic / Pessimistic / Coarse-Grained Offline Locks** — correctness across user think-time.
- **Deterministic resource release** — try-with-resources discipline for connections and cursors.

## The sources

- ★ [**Patterns of Enterprise Application Architecture** — Fowler](../Books/Domain-Systems-Design/11-Patterns-of-Enterprise-Application-Architecture.md) — chs. 2–3, 5, 10–11 + offline concurrency and inheritance mapping (STI/CTI/concrete-table): the catalog this theme walks.
- [**Designing Data-Intensive Applications** — Kleppmann](../Books/Domain-Systems-Design/12-Designing-Data-Intensive-Applications.md) — chs. 2–3, 7: data models, storage engines, what transactions really guarantee.
- [**Domain-Driven Design** — Evans](../Books/Domain-Systems-Design/10-Domain-Driven-Design.md) — repositories and aggregate-shaped consistency.
- [**Effective Java** — Bloch](../Books/Language-Specific/22-Effective-Java.md) — items 7–9: resource lifecycle discipline.
- [**Continuous Delivery** — Humble & Farley](../Books/Engineering-Culture-Process/19-Continuous-Delivery.md) — ch. 12: managing data (expand–contract).

## What the skill encodes (operational checklist)

- [ ] Name the domain-logic pattern in play and flag mismatches (anemic domain model; complex invariants duplicated across transaction scripts).
- [ ] Queries inside loops — explicit or ORM-lazy — are N+1 findings; prescribe the fetch strategy, not just "eager load."
- [ ] Transaction boundaries = use cases: scattered saves mid-logic, or transactions spanning user interaction, are findings.
- [ ] Isolation assumptions audited against the connection's actual level; write-skew-shaped logic (check-then-act on two rows) called out at snapshot isolation.
- [ ] Read-modify-write across think-time requires a version check (optimistic offline lock) — its absence is a silent-lost-update finding.
- [ ] Query construction (criteria, SQL fragments) in domain code → repository/query-object seam finding.
- [ ] Every connection/statement/cursor acquired in a deterministic-release scope; leaks are Critical in request paths.
- [ ] Migrations reviewed under Theme 14's expand–contract rules; ORM-generated schema drift flagged.

## Connects to

[06 — DDD & Conway's Law](06-Domain-Driven-Design-and-Conways-Law.md) (aggregates and repositories are the domain half of this contract) · [15 — Distributed Systems](15-Distributed-Systems.md) (what happens to these guarantees across partitions) · [14 — Delivery](14-Delivery.md) (expand–contract as the schema's release process) · [05 — Architecture](05-Architecture-Dependencies-and-Boundaries.md) (the data source layer, kept in its layer).
