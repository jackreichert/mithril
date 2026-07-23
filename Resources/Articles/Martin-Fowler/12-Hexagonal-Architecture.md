---
title: Hexagonal Architecture (Ports and Adapters)
author: Alistair Cockburn
url: alistair.cockburn.us/hexagonal-architecture/
category: Article — Architecture (Cockburn, indexed alongside Fowler bliki)
focus: Application as hexagon; ports defined by app, adapters connect external systems
---

# Hexagonal Architecture / Ports and Adapters — Cockburn

> Allow an application to equally be driven by users, programs, automated test or batch scripts, and to be developed and tested in isolation from its eventual run-time devices and databases.

Cockburn's framing of dependency-inversion at the application level. Predates Uncle Bob's "Clean Architecture" and is its conceptual sibling. Many teams find Hexagonal easier to teach.

## The shape

```
       [User-side adapters]              [Server-side adapters]
       (CLI, REST, gRPC, GraphQL)        (PostgreSQL, S3, Stripe, queue)
                  ↓                               ↑
            ╱──────────────╲                ╱──────────────╲
            ─→ inbound port               outbound port ─→
            ╲──────────────╱                ╲──────────────╱
                       APPLICATION CORE
                  (domain + use cases, no I/O)
```

The hexagon shape itself isn't load-bearing — it's a metaphor for "many sides, no privileged top/bottom." Six sides happens to be a convenient drawing convention.

## Three roles

- **Application core** — the use cases and domain model. Knows nothing about HTTP, DB, queues, files. All I/O is abstracted.
- **Ports** — *interfaces defined by the application* describing what it needs from the outside. Two flavors:
  - **Driving / inbound / primary** ports — interfaces external actors call *into* the application (e.g., a `PlaceOrder` use-case interface). UI and tests are drivers.
  - **Driven / outbound / secondary** ports — interfaces the application calls *out* through (e.g., `OrderRepository`, `PaymentGateway`). DB and external services live behind these.
- **Adapters** — concrete implementations connecting ports to specific technologies. Two flavors mirroring the ports:
  - **Driving adapters** — REST controller, CLI parser, message-queue consumer. Translate inbound calls into core invocations.
  - **Driven adapters** — Postgres-backed `OrderRepository`, Stripe-backed `PaymentGateway`. Implement outbound port interfaces.

## Why it works

- **Test substitutes are just adapters.** No special test-only abstractions; production and test share the port definition. The "fake" payment gateway implements the same interface as the Stripe adapter.
- **Technology choices stay reversible.** Swapping Postgres → DynamoDB is a new outbound adapter; the core doesn't know.
- **Dependency direction is enforced.** The core never imports from adapters; adapters import the core's port interfaces.

## Compared to Clean Architecture

Same goal, different vocabulary:
- Clean Architecture: concentric circles, dependency rule "inward only."
- Hexagonal: hexagon, ports defined by core, adapters connect outward.

Most teams adopt one or the other; the underlying discipline is identical. Hexagonal is often easier to apply because the hexagon shape doesn't imply a strict layer count, only a separation between *core* and *everything else*.

## Common implementation pitfalls

- **Anaemic ports** — port interfaces that mirror DB columns rather than expressing application needs. Symptom: changing the DB requires changing port shapes.
- **Adapters with logic** — business rules creeping into a REST controller or repository implementation. The core gets thin; adapters get fat.
- **Over-abstraction at small scale** — a 200-line CLI tool doesn't need ports and adapters; the abstraction tax exceeds the flexibility benefit.

## When to apply

- Application code expected to live for years
- Multiple driving channels (web + mobile + admin + batch + tests)
- Multiple driven implementations possible (DB swap, third-party service swap, fake-for-tests)
- Domain logic complex enough to warrant isolation from I/O

## Pairs with
- **Clean Architecture** (Martin) — equivalent dependency-direction discipline at the same scope.
- **DDD** — the application core in Hexagonal often is the DDD bounded context.
- **APOSD's "Deep Modules"** — the application core is the deepest module; adapters are shallower.
