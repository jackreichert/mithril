---
title: Out of the Tar Pit
authors: Ben Moseley, Peter Marks
year: 2006
category: Paper
focus: Complexity theory, functional-relational programming
---

# Out of the Tar Pit — Moseley & Marks (2006)

A long-form essay (~60 pages) on managing software complexity. Diagnoses the *causes* of complexity and proposes **Functional-Relational Programming (FRP)** as a way to minimize accidental complexity.

## Part I — Diagnosis

### Essential vs. accidental complexity (Brooks)
Following Brooks's *No Silver Bullet*:
- **Essential** complexity: inherent in the problem.
- **Accidental** complexity: introduced by our tools and approaches.

Moseley & Marks's claim: most complexity is accidental, and we can radically reduce it.

### The two main culprits
1. **State** — variables and assignment make programs hard to reason about. Each piece of mutable state multiplies the state space.
2. **Control** — explicit ordering of operations adds dependencies that don't reflect the problem.

### Categories of complexity
- State-derived complexity.
- Control-derived complexity.
- Code-volume complexity (a consequence of the first two).

### Existing approaches and their limits
- **OO** — encapsulates state but doesn't reduce it. Inheritance adds complexity.
- **FP** — eliminates state but doesn't address shared data.
- **Logic programming** — declarative but limited in scope.
- **Pure relational** — declarative for data but not programs.

## Part II — Solution

### Functional-Relational Programming (FRP)
A proposed architecture:
- **Essential state** stored declaratively in a relational form.
- **Accidental state** (caches, intermediate computations) generated functionally from essential state — no mutable storage.
- **Logic** expressed as pure functions of relational data.
- **Performance hints** (indices, caches) separated from the logic, declared metadata.

### Architecture in three layers
1. **Essential state** (relational; persistent).
2. **Essential logic** (pure functions over the state).
3. **Accidental** layer: feeders/observers (I/O, performance, integration with the messy outside world).

### Why this matters even if you don't build FRP
The diagnosis holds even when the solution doesn't fit. Recognize:
- State you don't need.
- Control you don't need.
- Volume you don't need.
And remove them.

## Influence

- **Datomic** (Rich Hickey's database) — explicitly inspired by FRP.
- **Datalog systems** — fit the model.
- **Event sourcing + CQRS** — closely related.
- **APOSD's deep modules** — variation on "minimize accidental complexity."

## Pairs with
- **No Silver Bullet** (Brooks) — the essential/accidental distinction.
- **Designing Data-Intensive Applications** — modern systems-level view of state management.
- Rich Hickey's "Simple Made Easy" talk — same instincts in talk form.
