---
title: CQRS — Command Query Responsibility Segregation
author: Martin Fowler (concept by Greg Young)
url: martinfowler.com/bliki/CQRS.html
category: Article — Martin Fowler
focus: Separate read and write models
---

# CQRS — Command Query Responsibility Segregation

Greg Young's idea, named and popularized by Fowler. The principle:
> Use a different model to update information than to read information.

## Origin
Bertrand Meyer's **Command-Query Separation (CQS)** says: a method should either be a command (mutate state, return nothing) or a query (return data, no side effects). CQRS scales CQS to the *architecture* level: separate the *whole model* for writes from the *whole model* for reads.

## Architecture sketch
```
Command side               Query side
-------------               -------------
Domain Model              ←  Read Models
       ↓                  ←  (denormalized, projected)
   Database (writes)
       ↓                       ↑
       └── events / sync ──────┘
```

- Writes go through the domain (validation, business rules).
- Reads go against denormalized projections optimized per query.
- Synchronization is async (events) or sync (reading directly from the same DB).

## Benefits
- Scales independently — most systems read >> write.
- Read models can be tailored per UI screen → no overfetching.
- Write model stays focused on invariants.
- Pairs naturally with **Event Sourcing**.

## Costs
- More moving parts.
- Eventual consistency between sides → UI must handle stale data.
- Doubled persistence shapes (write tables + read views).

## When to use
- Complex domains with many divergent read patterns.
- Significant read/write asymmetry.
- Needs for projection or replay (audit, analytics).

## When *not* to use
Most CRUD apps. Standard relational read/write is simpler and good enough.

## Related
- **Event Sourcing** — frequently combined with CQRS but independent.
- **Eventual Consistency** — necessary mental model.
- Reactive frameworks (Akka, Axon, EventStore).
