---
title: Java Concurrency in Practice
author: Brian Goetz et al.
year: 2006
category: Concurrency
focus: threads, locks, memory model, safe publication, concurrent collections
---

# Java Concurrency in Practice — Brian Goetz et al. (2006)

The definitive practitioner's guide to writing correct concurrent JVM code, feeding the **quality-concurrency** agent. The Constitution's Article II concurrency rules (atomic / visible / safe-publication / consistent lock ordering / no alien calls under a lock) derive almost verbatim from this book.

## Per-chapter summary

### Ch 1 — Introduction
Frames the **benefits vs. risks** of threads: throughput and responsiveness against **safety, liveness, and performance hazards**. Concurrency bugs are non-deterministic and rarely reproduce, so design for correctness up front rather than debug interleavings later.

### Part I — Fundamentals

### Ch 2 — Thread Safety
A class is **thread-safe** when it behaves correctly under concurrent access with no external synchronization. Guard all access to **shared mutable state** with the same lock; eliminate the sharing or the mutability and the problem disappears. **Atomicity** matters: read-modify-write and check-then-act must be **indivisible**, never two separate operations under a race.

### Ch 3 — Sharing Objects
Synchronization is about **visibility**, not just mutual exclusion — without it a thread may see **stale** values forever. Use `volatile` for simple flags, **confinement** (thread/stack/ownership) to dodge sharing, and **immutability** to make objects safe by construction. **Safe publication** means an object's reference and its state reach other threads correctly; improper publication leaks **partially constructed** objects.

### Ch 4 — Composing Objects
Build thread-safe classes deliberately: define the **synchronization policy**, identify the **invariants**, and document the locking. Prefer **instance confinement** (guard state with a private lock) and the **Java monitor pattern**. Compose via **delegation** to already-thread-safe components, and **client-side locking** or wrapper classes only when you must add atomic compound actions.

### Ch 5 — Building Blocks
Use the library: **concurrent collections** (`ConcurrentHashMap`, `CopyOnWriteArrayList`) over synchronized wrappers, **blocking queues** for producer-consumer, and **synchronizers** (`CountDownLatch`, `FutureTask`, `Semaphore`, `CyclicBarrier`) to coordinate threads. **Don't reinvent** these primitives — they encode hard-won correctness and scalability.

### Part II — Structuring Concurrent Applications

### Ch 6 — Task Execution
Structure work around **tasks**, not raw threads. Unbounded thread creation kills you under load; submit tasks to the **Executor framework** so thread lifecycle, queuing, and policy are decoupled from task logic. Choose a thread pool sized to the workload.

### Ch 7 — Cancellation and Shutdown
Java has no safe forced stop; use **cooperative cancellation** via **interruption**. Never swallow `InterruptedException` — propagate it or restore the interrupt flag. Shut executors down gracefully, handle the **poison pill** / shutdown-now boundary, and account for threads blocked in non-interruptible I/O.

### Ch 8 — Applying Thread Pools
**Size pools** to the task type (CPU-bound ≈ N+1, I/O-bound higher) and beware **thread-starvation deadlock** when pooled tasks wait on other pooled tasks. Tune queue type, **saturation/rejection policy**, and thread factory; tasks must be **independent** for the pool's assumptions to hold.

### Ch 9 — GUI Applications
GUI toolkits are **single-threaded** confinement models — touch UI state only on the **event dispatch thread**. Push long work off the EDT and marshal results back; this is confinement, not locking, applied to a whole subsystem.

### Part III — Liveness, Performance, and Testing

### Ch 10 — Avoiding Liveness Hazards
**Deadlock** comes from inconsistent **lock ordering** — impose a global order and hold it everywhere. Never call an **alien method** (overridable or callback) while holding a lock; prefer **open calls**. Use **timed/tryLock** to recover, and watch for **livelock** and starvation.

### Ch 11 — Performance and Scalability
**Measure, don't guess** — Amdahl's law bounds your speedup by the **serial fraction**. **Lock contention** is the main scalability enemy: narrow lock scope, **reduce lock granularity** (lock splitting/striping), shorten critical sections, and prefer concurrent collections. Context switching and memory synchronization have real costs.

### Ch 12 — Testing Concurrent Programs
Test both **safety** (nothing bad happens) and **liveness** (something good eventually happens). Use barriers to maximize **interleavings**, run on multiprocessors, and avoid tests that accidentally serialize. Static analysis and code review catch races that flaky tests miss.

### Part IV — Advanced Topics

### Ch 13 — Explicit Locks
`ReentrantLock` adds **timed, interruptible, and non-block-structured** locking and **fairness** options beyond `synchronized` — at the cost of a mandatory `finally` unlock. Use it only when you need those features; `ReadWriteLock` helps read-heavy data.

### Ch 14 — Building Custom Synchronizers
Implement **state-dependent** classes with the **condition-predicate / wait-notify** pattern: always wait in a loop, test the predicate, and prefer `notifyAll`. `Condition` objects and `AbstractQueuedSynchronizer` (AQS) underpin the library's synchronizers — build on them rather than from scratch.

### Ch 15 — Atomic Variables and Nonblocking Synchronization
**CAS** (compare-and-swap) enables **lock-free** algorithms via atomic classes (`AtomicInteger`, `AtomicReference`). Nonblocking algorithms avoid lock-related liveness hazards and scale better under contention, but are hard to get right — watch for the **ABA problem** and use them where the library hasn't already.

### Ch 16 — The Java Memory Model
The **JMM** defines the **happens-before** relation that makes writes visible across threads — the formal foundation under every prior chapter. **Synchronization, `volatile`, `Thread.start/join`, and final fields** all establish ordering edges. Properly constructed **immutable objects** are safe to share without synchronization because of final-field semantics.

## Critiques worth knowing
Java-and-2006-specific: predates `CompletableFuture`, `java.util.concurrent` reactive flows, virtual threads (Project Loom), and structured concurrency — the *principles* (happens-before, safe publication, confinement) are timeless, but several "use this primitive" recommendations have newer, better answers. The shared-memory threading model it teaches is also increasingly displaced by message-passing and async runtimes in other languages.
