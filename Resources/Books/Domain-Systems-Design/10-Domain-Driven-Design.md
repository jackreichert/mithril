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
Models are negotiated artifacts between developers and domain experts. The model evolves through conversation and experimentation. Insight comes from "knowledge crunching," the repeated process of testing language and assumptions until the team reaches a more useful understanding of the business.

### Ch 2 — Communication and the Use of Language
**Ubiquitous Language** is one shared language used by developers, domain experts, code, and conversation. Translation between dev-speak and biz-speak creates friction, so the team should eliminate it. When the language changes as understanding improves, the model and implementation must change with it.

### Ch 3 — Binding Model and Implementation
In **Model-Driven Design**, the model and the code reflect each other. If the model can't be implemented, change the model — don't fork it. This binding lets insights discovered in code inform domain discussions and keeps the software from drifting away from the business concepts it represents.

## Part II — The Building Blocks of a Model-Driven Design

### Ch 4 — Isolating the Domain (Layered Architecture)
Layered Architecture separates a system into four layers: Presentation, Application, Domain, and Infrastructure. The Domain layer is the heart and must not depend on the others. Isolating domain rules from user-interface and persistence concerns keeps the model understandable and allows technical details to change independently.

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
A worked cargo-shipping example shows how the building blocks compose into a model. The example follows the team as it turns domain conversations into entities, value objects, services, aggregates, factories, and repositories. Its purpose is to demonstrate that the patterns reinforce one another when they are expressed through a consistent Ubiquitous Language.

## Part III — Refactoring Toward Deeper Insight

### Ch 8 — Breakthrough
Domain insight often comes in jumps rather than through steady refinement. A breakthrough exposes a simpler or more expressive way to represent the business. Be ready to *replace* a model when a better one appears, even when doing so disrupts the current design.

### Ch 9 — Making Implicit Concepts Explicit
Constraints, processes, and specifications often hide as inline conditions. Extract them as first-class objects. Naming these concepts in the model makes important business rules visible, discussable, and reusable instead of leaving them buried in procedural code.

### Ch 10 — Supple Design
Supple Design produces pliable, intention-revealing code that developers can safely reshape as domain knowledge grows. Its patterns reduce mental overhead by making operations predictable and keeping concepts close to their natural boundaries. The goal is not cleverness, but a model whose code communicates what it does and avoids surprising side effects. Patterns:
- **Intention-Revealing Interfaces**
- **Side-Effect-Free Functions**
- **Assertions**
- **Conceptual Contours**
- **Standalone Classes**
- **Closure of Operations** (operations whose result type matches input type)
- **Specification** (predicate as object)

### Ch 11 — Applying Analysis Patterns
Analysis patterns capture modeling ideas that recur across different business domains. Reusing this established vocabulary, including patterns described by Fowler, can accelerate knowledge crunching and expose questions a team might otherwise miss. These patterns are starting points that must be adapted to the current domain rather than copied mechanically.

### Ch 12 — Relating Design Patterns to the Model
General software design patterns from the Gang of Four gain domain meaning when applied with model-driven thinking. A pattern should clarify a domain concept or relationship rather than impose a technical structure for its own sake. The model determines how the pattern is named and shaped, keeping the implementation connected to the Ubiquitous Language.

### Ch 13 — Refactoring Toward Deeper Insight
Deep models often appear after refactoring eliminates accidental complexity. Refactoring should pursue new domain insight, not merely rearrange code. Welcome the disruption when a clearer model replaces assumptions that the existing design had concealed.

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
Large systems need an organizing structure that helps teams understand how major parts relate without freezing the model in place. The structure should be minimal, conceptually coherent, and capable of evolving as domain knowledge changes. The chapter presents several ways to provide that system-wide orientation:
- **Evolving Order**, **System Metaphor**, **Responsibility Layers**, **Knowledge Level**, **Pluggable Component Framework**.

### Ch 17 — Bringing the Strategy Together
Strategic design is a continuous practice rather than a one-time project phase. Teams must combine context boundaries, distillation, and large-scale structure as the system and organization evolve. Negotiate boundaries with the org chart because model ownership and team relationships directly affect whether the strategy can work.

## Why it endures
DDD-lite (entities, value objects, aggregates, repositories) is now table stakes. Strategic patterns (bounded contexts, context maps) became the vocabulary of microservices.

## Pairs with
- **Implementing Domain-Driven Design** (Vaughn Vernon, "Red Book") — more pragmatic, tactical examples.
- **Domain-Driven Design Distilled** (Vernon) — short intro.
