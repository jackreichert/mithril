# 18 — Performance & Operability

> **Tier 5 · Systems in production.** Measure before you change: USE-method resource hygiene, latency percentiles, query cost models, SLOs/error budgets, and the telemetry that makes failure visible. **Primary skills:** [`skills/performance.md`](../../skills/performance.md) · [`skills/observability.md`](../../skills/observability.md) · agents `quality-performance`, `quality-observability`. Supporting: [`skills/persistence.md`](../../skills/persistence.md), [`skills/delivery.md`](../../skills/delivery.md), [`skills/code-quality.md`](../../skills/code-quality.md). Flow tracing (source→sink cost) is owned by `quality-flow`.

## The idea in one paragraph

Performance work fails when it is fashion rather than measurement. *Systems Performance* gives the discipline: find the bottleneck with a method (the **USE** method — Utilization, Saturation, Errors on every saturable resource), then change the bottleneck, not the code that looks slow. Latency is a **distribution** — averages lie; p95/p99 and the tail matter for users (*DDIA*, SRE). At the data layer, *SQL Performance Explained* makes the cost model concrete: indexes match `WHERE`/`ORDER BY`, `SELECT *` over-fetches and breaks-on-add, keyset beats OFFSET pagination, and N+1 is the classic ORM pathology (*PEAA* / Theme 16). Operability is the other half of the same coin: *Site Reliability Engineering* treats reliability as a dial with an **error budget** (1 − SLO), instruments the **four golden signals** (latency, traffic, errors, **saturation**), and refuses 100% as a target. Observability practice adds high-cardinality events and trace context so you can ask new questions of production without redeploying dashboards. The theme is Tier 5 because none of this is style — it is whether the system stays fast and diagnosable under load.

## The arc (how the ideas build)

- **Clarity first, then measure** (Code Complete 25–26; APOSD ch.20; Effective Java 67) — premature optimization is still wrong; correct algorithms and data structures first; micro-optimizations only against a profiled hotspot.
- **USE method** (Gregg, *Systems Performance*) — for each resource (CPU, memory, disk, network, thread pool, connection pool, queue): utilization (how busy), saturation (how much work is waiting), errors. Missing saturation signals are the silent killers (pool exhaustion, unbounded queues).
- **Percentiles, not averages** (DDIA; SRE) — a mean latency of 50ms with p99 of 3s is a broken experience for 1% of users. Instrument and SLO on the tail.
- **The database cost model** (Winand, *SQL Performance Explained*; Petrov, *Database Internals*) — B-tree/LSM engines, sargable predicates, covering indexes, why `SELECT *` and OFFSET pagination hurt; N+1 as the ORM face of the same blindness.
- **SLOs and error budgets** (SRE ch.3–4) — pick a few meaningful SLIs, set objectives, spend the budget on velocity, freeze risk when exhausted. Reliability is a feature with a cost, not an absolute.
- **Golden signals + observability** (SRE ch.6; Observability Engineering practice) — latency, traffic, errors, saturation on every user-facing path; structured logs and traces with enough cardinality to debug *this* request, without logging PII.
- **Flow-level cost** (quality-flow) — N+1 across a call chain, resource lifecycle (open without close), and partial-failure retry storms show up only when you walk entry→sink, not when you lint one file.

## Key concepts & frameworks

- **USE method** — Utilization / Saturation / Errors per resource.
- **Latency percentiles** — p50 / p95 / p99; averages as a red flag when used alone.
- **Query cost model** — index to the query; explicit columns; bounded results; keyset pagination.
- **N+1** — one query per element of a collection; the classic persistence/performance smell.
- **Four golden signals** — latency, traffic, errors, saturation.
- **SLI / SLO / error budget** — measure user-visible reliability; spend or freeze deliberately.
- **High-cardinality telemetry** — ask new questions without shipping new dashboards (within PII bounds).

## The sources

- ★ [**Systems Performance** — Gregg](../Books/Performance-Reliability/32-Systems-Performance.md) — USE method, latency analysis, profiling discipline.
- ★ [**Site Reliability Engineering** — Beyer et al.](../Books/Performance-Reliability/33-Site-Reliability-Engineering.md) — SLOs, error budgets, golden signals.
- ★ [**SQL Performance Explained** — Winand](../Books/Performance-Reliability/30-SQL-Performance-Explained.md) — indexes and query shape.
- [**Database Internals** — Petrov](../Books/Performance-Reliability/31-Database-Internals.md) — storage engines under the ORM.
- [**Designing Data-Intensive Applications** — Kleppmann](../Books/Domain-Systems-Design/12-Designing-Data-Intensive-Applications.md) — percentiles, load, data systems.
- [**Release It!** — Nygard](../Books/Domain-Systems-Design/13-Release-It.md) — stability under load; pool antipatterns.
- [**Observability Engineering** (summary)](../Books/Performance-Reliability/42-Observability-Engineering.md) — high-cardinality events, debugging production.
- [**PEAA** — Fowler](../Books/Domain-Systems-Design/11-Patterns-of-Enterprise-Application-Architecture.md) — Lazy Load / N+1 pathology.

## What the skills encode (operational checklist)

- [ ] New pools, queues, and rate limiters expose utilization **and** saturation (and errors).
- [ ] Nested loops / O(n²) over realistic `n` flagged; data structure choice justified.
- [ ] N+1 and `SELECT *` / missing indexes flagged at the persistence boundary.
- [ ] Latency claims and SLOs use percentiles, not averages alone.
- [ ] New endpoints ship golden signals; alerts page on symptoms, not internal counters.
- [ ] Error budget / SLO defined for user-facing flows when the service is production-shaped.
- [ ] Optimizations without a measured bottleneck → finding (premature optimization).
- [ ] Cross-method resource/N+1 issues deferred to `quality-flow` with the hand-off named.

## Connects to

[01 — Complexity](01-Complexity-and-Deep-Modules.md) (accidental complexity is often unmeasured work) · [03 — Readable Code](03-Readable-Code.md) (clarity before micro-opt) · [14 — Delivery](14-Delivery.md) (SLOs, golden signals, DORA) · [15 — Distributed](15-Distributed-Systems.md) (partial failure, timeouts under load) · [16 — Persistence](16-Persistence.md) (query cost, N+1) · [17 — Concurrency](17-Concurrency.md) (pool saturation, blocked threads) · [12 — Security](12-Security-Review.md) (DoS as a performance + security boundary).
