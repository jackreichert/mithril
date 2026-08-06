# 15 — Distributed Systems: Respecting the Network

> **Tier 5 · Systems in production.** Why a remote call is never just a slow local call, what the network actually promises (nothing), and the honest costs of the patterns that cope — replication, partitioning, idempotency, service boundaries, CQRS/ES. **Skill:** [`skills/distributed.md`](../../skills/distributed.md) · agent `mithril-distributed` (cross-boundary tracing: `mithril-flow`).

## The idea in one paragraph

In 1994, Waldo and colleagues ended the dream of transparent distribution with four differences that no framework can abstract away: **latency** (orders of magnitude, and variable), **memory access** (no shared address space — only copies passed by value), **partial failure** (a unique horror: parts fail while others proceed, *and you can't reliably tell which*), and **concurrency** (true simultaneity, not interleaving). Every RPC framework that promised to make remote calls look local has rediscovered these the hard way — a timeout is not knowledge; it means the request may have executed, failed, or still be running. Kleppmann builds the modern discipline on that foundation: networks drop, delay, and reorder; clocks skew and processes pause at arbitrary points (GC, VM migration), so ordering needs logical mechanisms, not timestamps; **replication** buys availability at the price of a consistency menu whose entries (read-your-writes, monotonic reads, linearizability) must be *chosen*, not assumed; **partitioning** buys scale at the price of hot keys, rebalancing, and the loss of cheap cross-partition joins and transactions. The operational keystone is **idempotency**: since at-least-once delivery is what the network actually offers, "exactly-once" is at-least-once plus deduplication designed by *you*. Fowler & Lewis's microservices essay and its aftermath supply the boundary wisdom — services split along bounded contexts (Theme 06) or you've built a distributed monolith, paying Waldo's four costs for zero autonomy — and CQRS/Event Sourcing round out the toolkit as powerful, sharp-edged instruments whose default answer is "not yet."

## The arc (how the ideas build)

- **Waldo's four differences** (*A Note on Distributed Computing*) — the organizing principle: latency, memory access, partial failure, concurrency. Any design that treats a network hop as a function call has a category error at its core; the seam *must* be visible in the programming model.
- **The network promises nothing** (DDIA ch. 8) — messages drop, duplicate, delay, and reorder; the only failure detector is a timeout, and a timeout is ambiguity, not evidence. Clocks are worse: wall clocks skew and step backwards, so last-write-wins by timestamp silently loses data; ordering claims need logical clocks or consensus, and any code comparing distributed timestamps for causality is a finding.
- **Replication's menu has prices** (DDIA ch. 5, 9) — single-leader (simple, failover risk: split brain), multi-leader (write conflicts are yours to resolve), leaderless (quorums and read repair). Asynchronous replication means **replication lag**, and lag means anomalies with names: a user who can't see their own write (read-your-writes violated), history that jumps backwards (monotonic reads violated). The review question is never "is it consistent?" but "*which* consistency does this read path actually need, and which does the store give it?"
- **Partitioning's fine print** (DDIA ch. 6) — hash vs. range partitioning trades scan-ability for skew resistance; hot keys defeat both; secondary indexes need scatter-gather or global index maintenance; rebalancing must not move more data than necessary. Cross-partition operations lose single-node atomicity — which is where the next point takes over.
- **Idempotency is the load-bearing wall** (DDIA ch. 11) — retries are mandatory (partial failure), so duplicates are inevitable; every externally-invoked mutation needs an idempotency key, a natural idempotent formulation, or a dedup ledger. "Exactly-once" in any vendor's brochure means at-least-once delivery + idempotent processing — the second half is application code.
- **Boundaries are bounded contexts or they're wrong** (Fowler & Lewis, *Microservices*) — services own their data, deploy independently, and communicate through published interfaces (smart endpoints, dumb pipes). Two services that must deploy together, share a database, or chat n times per request are a distributed monolith: all four Waldo costs, none of the autonomy benefits. The monolith-first corollary: you must understand the domain (Theme 06) before you can cut it.
- **CQRS and Event Sourcing, priced honestly** (Fowler's bliki) — CQRS splits read and write models where their shapes genuinely diverge; ES makes the append-only event log the system of record (perfect audit, temporal queries, replayability) at the cost of eventual-consistent projections, event versioning forever, and a steep model tax. Both are scalpel patterns: applied to a bounded context that needs them, transformative; applied by default, accidental complexity at architectural scale (Theme 07's counterweight, writ large).
- **Stability at scale** (Nygard; cross-ref Theme 05) — the integration-point patterns (timeout, circuit breaker, bulkhead, backpressure) stop one service's bad day from becoming everyone's; in a mesh of services they're not optional hardening, they're the difference between an incident and an outage.

## Key concepts & frameworks

- **The four differences** (Waldo) — latency · memory access · partial failure · concurrency; the seam must show.
- **Timeout = ambiguity** — the request may have happened; design every caller for all three outcomes.
- **Clocks lie** — no causality from wall-clock timestamps; logical ordering or consensus where order matters.
- **The consistency menu** — read-your-writes, monotonic reads, linearizability; chosen per read path, paid per choice.
- **Partitioning trade-offs** — hash vs. range, hot keys, scatter-gather indexes, rebalancing cost.
- **Idempotency keys & dedup** — exactly-once as an application-level construction over at-least-once delivery.
- **Bounded-context boundaries; distributed-monolith smell** — shared DBs, lockstep deploys, chatty synchronous chains.
- **CQRS / ES as scalpels** — default no; earn their complexity in the contexts that need them.

## The sources

- ★ [**A Note on Distributed Computing** — Waldo et al.](../Papers/02-A-Note-on-Distributed-Computing.md) — the four differences; the paper the whole theme hangs on.
- ★ [**Designing Data-Intensive Applications** — Kleppmann](../Books/Domain-Systems-Design/12-Designing-Data-Intensive-Applications.md) — chs. 5–9, 11: replication, partitioning, transactions, the troubles, consensus, streams.
- [**Microservices** — Fowler & Lewis](../Articles/Martin-Fowler/09-Microservices.md) — boundary characteristics and costs.
- [**CQRS**](../Articles/Martin-Fowler/06-CQRS.md) and [**Event Sourcing**](../Articles/Martin-Fowler/07-Event-Sourcing.md) — Fowler — the sharp tools, with their own warnings.
- [**Release It!** — Nygard](../Books/Domain-Systems-Design/13-Release-It.md) — stability patterns at integration points.

## What the skill encodes (operational checklist)

- [ ] Every remote call has a timeout, a retry policy, and an answer to "what if it executed anyway?" — missing any of the three is a finding.
- [ ] Retried mutations are idempotent (key, natural idempotency, or dedup); retry-without-idempotency is the theme's signature bug.
- [ ] Ordering or causality derived from wall-clock timestamps across nodes → finding (name the logical mechanism).
- [ ] Read paths audited against the consistency they assume vs. what the store provides under lag (read-your-writes after a write, especially).
- [ ] Cross-service transactions flagged; sagas/compensation or boundary redraw prescribed instead of distributed 2PC hope.
- [ ] Distributed-monolith smells: shared database, deploy coupling, synchronous call chains n-deep, chatty per-request conversations.
- [ ] CQRS/ES proposals must name the force (read/write shape divergence, audit/temporal requirement) — default is the simpler model.
- [ ] Integration points carry the Theme 05 stability kit; unbounded fan-out and missing backpressure are findings.

## Connects to

[05 — Architecture](05-Architecture-Dependencies-and-Boundaries.md) (stability patterns; boundaries as dependency discipline) · [06 — DDD & Conway's Law](06-Domain-Driven-Design-and-Conways-Law.md) (bounded contexts as the only sane service boundaries) · [16 — Persistence](16-Persistence.md) (transactions and isolation, single-node edition) · [12 — Security](12-Security-Review.md) (every hop is a trust boundary) · [01 — Complexity & Deep Modules](01-Complexity-and-Deep-Modules.md) (distribution is the most expensive complexity you can buy — spend it knowingly).
