---
title: Event Sourcing
author: Martin Fowler
url: martinfowler.com/eaaDev/EventSourcing.html
category: Article — Martin Fowler
focus: Append-only logs as system of record
---

# Event Sourcing — Martin Fowler

> Capture all changes to application state as a sequence of events.

State at any time is a *fold* over the event log. The log, not a row in a table, is the system of record.

## Core idea
Instead of:
```
ACCOUNT(id=1, balance=950)
```
Store:
```
1. AccountOpened(id=1, balance=0)
2. Deposited(id=1, amount=1000)
3. Withdrawn(id=1, amount=50)
```

Current state = replay all events. Past state = replay up to event N.

## Benefits
- **Complete audit trail** — every state change preserved with cause.
- **Temporal queries** — "what did the user see on Tuesday?"
- **Bug recovery** — replay events with fixed code.
- **Event-driven integration** — events are first-class, easy to publish.
- **Natural CQRS pair** — events drive read-model projections.

## Costs
- **Schema evolution is painful** — events are persisted forever; old shapes must remain readable. Versioning, upcasters.
- **Snapshots required** for performance — fold over millions of events is slow.
- **Mental model shift** — engineers must think in events, not state.
- **Idempotency burden** — replays must be safe.
- **Tooling immaturity** vs. relational DBs.

## When to use
- Domains with strong audit needs (finance, healthcare records, logistics).
- Complex business processes that benefit from event timeline.
- High write throughput where appends > updates.

## When *not* to use
- CRUD apps with no audit needs.
- Domains where events are unstable (early product discovery).

## Related
- **CQRS** — natural pairing.
- **Event Storming** — discovery technique for event-sourced domains.
- *Event Sourcing in Practice* essays by Greg Young.
- Kafka, EventStore as common implementations.

## Caution
Fowler explicitly warns against doing event sourcing without a real reason. The complexity tax is significant; many teams adopt it for the *idea* and regret the *operation*.
