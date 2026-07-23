---
title: Domain-Driven Design — Tackling Complexity in the Heart of Software
author: Eric Evans
year: 2003
category: Domain & Systems Design
focus: Ubiquitous language, bounded contexts, aggregates, repositories
---

# Domain-Driven Design — Eric Evans (2003)

The "Blue Book." Foundational text on aligning code with the business domain. Long, dense, full of patterns that have become standard vocabulary (entity, value object, aggregate, repository, bounded context).

## Part I — Putting the Domain Model to Work

### Ch 1 — Crunching Knowledge
Models are negotiated artifacts between developers and domain experts. The model evolves through conversation and experimentation. Insight comes from "knowledge crunching."

### Ch 2 — Communication and the Use of Language
**Ubiquitous Language**: one language used by developers, domain experts, code, and conversation. Translation between dev-speak and biz-speak is friction; eliminate it.

### Ch 3 — Binding Model and Implementation
**Model-Driven Design**: the model and the code reflect each other. If the model can't be implemented, change the model — don't fork it.

## Part II — The Building Blocks of a Model-Driven Design

### Ch 4 — Isolating the Domain (Layered Architecture)
Four layers: Presentation, Application, Domain, Infrastructure. Domain layer is the heart and must not depend on the others.

### Ch 5 — A Model Expressed in Software
- **Entities** — identity matters across time and state changes.
- **Value Objects** — defined by attributes; immutable; no identity.
- **Services** — operations that don't naturally belong on entities.
- **Modules** — high-cohesion packages.

### Ch 6 — The Life Cycle of a Domain Object
- **Aggregates** — clusters of entities/values with one root; transactional consistency boundary.
- **Factories** — encapsulate complex creation.
- **Repositories** — collection-like access to aggregates; hide persistence.

### Ch 7 — Using the Language: An Extended Example
A worked cargo-shipping example showing how the building blocks compose into a model.

## Part III — Refactoring Toward Deeper Insight

### Ch 8 — Breakthrough
Domain insight comes in jumps. Be ready to *replace* a model when a better one appears.

### Ch 9 — Making Implicit Concepts Explicit
Constraints, processes, and specifications often hide as inline conditions. Extract them as first-class objects.

### Ch 10 — Supple Design
Pliable, intention-revealing code. Patterns:
- **Intention-Revealing Interfaces**
- **Side-Effect-Free Functions**
- **Assertions**
- **Conceptual Contours**
- **Standalone Classes**
- **Closure of Operations** (operations whose result type matches input type)
- **Specification** (predicate as object)

### Ch 11 — Applying Analysis Patterns
Reuse vocabulary from cross-domain analysis (Fowler).

### Ch 12 — Relating Design Patterns to the Model
GoF patterns get domain-meaning when applied with model-driven thinking.

### Ch 13 — Refactoring Toward Deeper Insight
Deep models often appear after refactoring eliminates accidental complexity. Welcome the disruption.

## Part IV — Strategic Design

### Ch 14 — Maintaining Model Integrity (Bounded Contexts)
**Bounded Context**: an explicit boundary within which a model applies. Different contexts can have different models for the same concept (e.g., "Customer" in sales vs. support).
- **Continuous Integration** within a context.
- **Context Map** — diagram of relationships between contexts (Shared Kernel, Customer-Supplier, Conformist, Anticorruption Layer, Separate Ways, Open Host Service, Published Language).

### Ch 15 — Distillation
- **Core Domain** — the part that creates competitive advantage; invest here.
- **Generic Subdomain** — buy/borrow.
- **Domain Vision Statement**, **Highlighted Core**, **Cohesive Mechanisms**, **Segregated Core**, **Abstract Core**.

### Ch 16 — Large-Scale Structure
- **Evolving Order**, **System Metaphor**, **Responsibility Layers**, **Knowledge Level**, **Pluggable Component Framework**.

### Ch 17 — Bringing the Strategy Together
A continuous practice rather than a phase. Negotiate boundaries with the org chart.

## Why it endures
DDD-lite (entities, value objects, aggregates, repositories) is now table stakes. Strategic patterns (bounded contexts, context maps) became the vocabulary of microservices.

## Pairs with
- **Implementing Domain-Driven Design** (Vaughn Vernon, "Red Book") — more pragmatic, tactical examples.
- **Domain-Driven Design Distilled** (Vernon) — short intro.
