# 17 — Concurrency: Shared Memory, Honestly

> **Tier 5 · Systems in production.** The in-process counterpart to Theme 15: what happens when threads, coroutines, and event loops share memory — the bugs that only exist under interleaving and never appear in a single-threaded test. **Skill:** [`skills/concurrency.md`](../../skills/concurrency.md) · agent `mithril-concurrency`.

## The idea in one paragraph

Concurrency bugs are Theme 01's warning made kinetic: *Out of the Tar Pit* named mutable state as the great multiplier of complexity, and concurrency is where the multiplication happens — every mutable field shared across threads multiplies the interleavings a reader must reason about, and no test suite enumerates them. Goetz's *Java Concurrency in Practice* (the anchoring text, and portable far beyond Java) organizes the whole field around three hazard families: **atomicity** (check-then-act and read-modify-write sequences that interleave mid-operation), **visibility** (writes one thread makes that another never sees, because without a happens-before edge the memory model promises nothing — the counterintuitive half nobody discovers by testing), and **liveness** (deadlock, starvation, thread-pool exhaustion). The strategy ladder is fixed and preference-ordered: **don't share** (confine state to one thread), **don't mutate** (immutable objects are free to share — SICP's cost-of-assignment argument and Uncle Bob's "no assignment → no race conditions" arrive at the same door), and only then **synchronize correctly** — one lock guarding *all* access to a variable, documented, held briefly. Async/event-loop code changes the vocabulary, not the physics: awaits are interleaving points, and blocking the loop is the single-threaded deadlock. The scope boundary matters: cross-process and cross-machine races belong to Theme 15; database-level isolation to Theme 16 — this theme is one process, shared memory.

## The arc (how the ideas build)

- **State is the multiplier** (Moseley & Marks; SICP ch. 3) — the theoretical ground: assignment introduces time into a program, and shared assignment introduces *orderings*. Every hazard below is downstream of shared mutable state; that's why minimizing it is step zero, not a style preference.
- **The three hazards** (JCiP — the organizing principle) — **atomicity**: `count++`, `containsKey`-then-`put`, `get`-then-`set` are multiple operations wearing one expression's clothes; **visibility**: without synchronization/`volatile`/atomics there is no guarantee another thread *ever* sees your write, or sees writes in order (the memory-model half that testing cannot reveal); **liveness**: two locks taken in different orders, a pool whose tasks submit to their own pool, a lock held across blocking I/O.
- **The strategy ladder** (JCiP; Bloch, *Effective Java* ch. 11) — in preference order: **thread confinement** (state owned by one thread needs no locks), **immutability** (safe to share by construction — Bloch item 17 doing concurrency work), **safe publication + correct synchronization** (every access path under the *same* lock; `@GuardedBy`-style documentation of which lock guards what). Bloch's refinements: prefer executors to raw threads, concurrency utilities to `wait`/`notify`, lazy initialization holders to double-checked locking.
- **The classic traps have names** (JCiP; Goetz) — unsynchronized lazy singletons; escaped `this` during construction; compound actions on concurrent collections (a `ConcurrentHashMap` makes each call atomic, not your two-call sequence); mutable statics written from request paths; caches grown without bounds or synchronization.
- **Async is concurrency with different spelling** (the skill's synthesis) — every `await` is a point where the world can change under you (check-then-act across an await is the same atomicity bug); un-awaited promises are swallowed failures (Theme 03's error discipline, interleaved); blocking calls on the event loop stall every request, not one.
- **Non-JVM models share the hazards** (skill § 0.1) — Go (channels / handoff ownership), Rust (`Send`/`Sync`, ownership), JS (event-loop + Workers), Python (asyncio / GIL limits) change the *tools*, not the three hazards. "It's Go so no races" is false when maps are shared without mutexes.
- **Pools and backpressure** (Nygard, *Release It!* — Blocked Threads antipattern) — thread pools are shared resources with the same physics as Theme 05's bulkheads: sized deliberately, never blocked on their own downstream, bounded queues so overload fails fast instead of accumulating.
- **The DB hand-off** (Kleppmann, DDIA ch. 7) — the same read-modify-write shape reappears against the database as lost updates and write skew; recognize it in-process here, route the isolation-level and offline-lock treatment to Theme 16.

## Key concepts & frameworks

- **Atomicity / visibility / liveness** — the three-hazard triage every finding sorts into.
- **Happens-before** — the memory model's only promise; no edge, no guarantee (visibility bugs are invisible to tests by nature).
- **The strategy ladder** — confine → immutabilize → synchronize; reaching for a lock first is a smell.
- **Safe publication** — an object must be *published* safely (final fields, volatile, lock) before other threads may see it.
- **One variable, one lock, documented** (`@GuardedBy`) — guarding *some* access paths is guarding none.
- **Compound actions on concurrent collections** — thread-safe pieces don't compose into thread-safe sequences.
- **Await = interleaving point; never block the loop** — the async translations of the classic hazards.
- **Bounded pools, bounded queues** — liveness at the resource level (Release It!).

## The sources

- ★ [**Java Concurrency in Practice** — Goetz et al.](../Books/Concurrency/29-Java-Concurrency-in-Practice.md) — the anchoring text: hazards, memory model, safe publication, the strategy ladder.
- [**Effective Java** — Bloch](../Books/Language-Specific/22-Effective-Java.md) — ch. 11 (items 78–84): the modern mechanics; immutability (item 17) as concurrency strategy.
- [**Out of the Tar Pit** — Moseley & Marks](../Papers/03-Out-of-the-Tar-Pit.md) and [**SICP** — Abelson & Sussman](../Books/Language-Specific/24-SICP.md) — ch. 3: why shared assignment is the root cost.
- [**Release It!** — Nygard](../Books/Domain-Systems-Design/13-Release-It.md) — Blocked Threads / pool antipatterns; liveness in production.
- [**Designing Data-Intensive Applications** — Kleppmann](../Books/Domain-Systems-Design/12-Designing-Data-Intensive-Applications.md) — ch. 7: the same races against the database.
- [**Clean Code** — Martin](../Books/Canon/01-Clean-Code.md) — ch. 13: keep concurrency-related code small and separate. [**FP Basics** — Martin](../Articles/Robert-Martin/05-FP-Basics-series.md) — "no assignment → no race conditions."

## What the skill encodes (operational checklist)

- [ ] New shared mutable state is the first finding, not the locking style — ask confine/immutabilize before reviewing the lock.
- [ ] Read-modify-write and check-then-act on shared state (`++`, `get`-then-`set`, `containsKey`-then-`put`) → atomicity finding, including across `await` points.
- [ ] Every shared variable's *complete* access set guarded by the *same* lock; partial guarding flagged as unguarded.
- [ ] Visibility: shared fields read without synchronization/volatile/atomic → finding even if "it works" — the memory model, not the test run, is the authority.
- [ ] Lazy initialization audited (holder idiom / `Lazy<T>` / once-primitives over hand-rolled double-checked locking).
- [ ] Lock ordering across multiple locks stated; locks never held across blocking I/O or awaits.
- [ ] Pools: bounded, sized deliberately, never submitting to themselves; event loops never blocked.
- [ ] Un-awaited async results and fire-and-forget tasks flagged as swallowed failures.
- [ ] Cross-process races deferred to `mithril-distributed`; DB-level isolation to `mithril-persistence` — with the hand-off named.

## Connects to

[01 — Complexity & Deep Modules](01-Complexity-and-Deep-Modules.md) (state as the root multiplier — this is its worst case) · [15 — Distributed Systems](15-Distributed-Systems.md) (the cross-process counterpart; same shapes, no shared memory) · [16 — Persistence](16-Persistence.md) (the same races replayed against the database) · [03 — Readable Code](03-Readable-Code.md) (immutability and side-effect isolation are concurrency tools first).
