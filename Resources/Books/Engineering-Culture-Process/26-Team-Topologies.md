---
title: Team Topologies — Organizing Business and Technology Teams for Fast Flow
authors: Matthew Skelton, Manuel Pais
year: 2019
category: Engineering Culture & Process
focus: Four team types, three interaction modes, Inverse Conway Maneuver, cognitive load
---

# Team Topologies — Skelton & Pais (2019)

A pattern language for organizing software teams to optimize *flow of change*. Builds on Conway's Law and the modern microservices/cloud-native context. The book's contribution: a small, opinionated vocabulary for team types and how they should interact.

## Core thesis

Most software organizations evolve their team structure ad-hoc, then puzzle why services and teams don't align. Team Topologies offers an explicit model: four team types, three interaction modes, applied with **cognitive load** as the governing constraint.

## The four fundamental team types

### Stream-aligned team
The default team type. Aligned to a single, valuable stream of work — a product, service, or feature set. Owns it end to end. Most teams should be this type.

### Enabling team
Helps stream-aligned teams adopt new capabilities (e.g., a security-coaching team, a observability-coaching team). **Time-bounded engagement** with each stream-aligned team; they don't permanently embed.

### Complicated-subsystem team
Owns a part of the system that genuinely requires deep specialist knowledge (e.g., video codec, ML training pipeline, real-time engine). Few of these.

### Platform team
Provides internal services that multiple stream-aligned teams consume (CI/CD platform, observability platform, data platform). The internal product is consumed via well-defined APIs.

## The three interaction modes

How team-pairs interact at any moment. A team can interact differently with different teams.

### Collaboration
Two teams work together for a defined period to discover something. High communication cost; appropriate for early exploration. Time-bounded.

### X-as-a-Service
One team consumes another's offering through a stable interface (the platform team's CI/CD; the security team's audit-as-a-service). Low communication cost; appropriate when the interface is stable.

### Facilitating
An enabling team helps a stream-aligned team learn a new capability. Time-bounded; goal is the recipient becoming self-sufficient.

## Cognitive load as the governing constraint

A team can only own as much complexity as its members can hold. The book distinguishes:
- **Intrinsic** — fundamental to the domain (stays)
- **Extraneous** — accidental complexity from poor tooling, environment friction (eliminate)
- **Germane** — learning that builds expertise (cultivate)

If a team is overloaded, splitting the *work* before splitting the *team* leads to dysfunction. The book argues: split the *system* into well-bounded parts each within one team's cognitive limit.

## Inverse Conway Maneuver

Conway's Law (1968): organizations design systems mirroring their communication structure. **Inverse Conway**: deliberately shape teams to match the architecture you want. Don't let the org chart force a bad architecture.

Practical applications:
- Want microservices? Form small autonomous teams per service domain *first*, let them deliver the architecture as a consequence.
- Stuck with a monolith because of monolithic team? The team shape constrains the system shape.

## Why it matters for software-quality practices

- Service / module boundaries should align with team boundaries (cross-references DDD bounded contexts).
- The "service that requires 3+ teams to deploy" anti-pattern is a Team Topologies violation, not just a Conway's Law violation.
- Platform teams enable stream-aligned teams to focus on their stream; without one, every team builds bespoke infrastructure.

## Critique
- The patterns are descriptive vocabulary, not predictive. Knowing the team type doesn't predict outcomes; the *application* does.
- Some claim the four types are too narrow for some orgs (research labs, joint ventures, 2-pizza-team-but-different).
- Useful for naming what's already happening more than for greenfield design.

## Pairs with
- **Conway's "How Do Committees Invent?"** (1968) — the founding paper.
- **Microservices** (Fowler & Lewis) — service-level expression of similar thinking.
- **Software Engineering at Google** chs. 5–7 — large-scale team practices that fit some Team Topologies patterns and not others.
- **DDD bounded contexts** — the technical-decomposition counterpart.
