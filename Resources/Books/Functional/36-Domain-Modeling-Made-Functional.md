---
title: Domain Modeling Made Functional
author: Scott Wlaschin
year: 2018
category: Functional
focus: DDD + FP, type-driven design, algebraic data types, making illegal states unrepresentable, railway-oriented programming
---

# Domain Modeling Made Functional — Scott Wlaschin (2018)

Fuses Domain-Driven Design with functional programming: the domain is modeled directly in the type system, illegal states are made unrepresentable, and workflows are expressed as composable pipelines of pure functions with errors carried on a `Result` track (railway-oriented programming). Feeds the **mithril-architecture** and **mithril-code-quality** agents — it reinforces the FP-discipline rule (Article II: pure functions, immutability, I/O at the boundaries) and the domain-modeling/SOLID rules (Article III: deep domain model independent of frameworks and persistence). Uses F#, but the algebraic-types-as-design ideas transfer to any language with sum/product types (Rust, TypeScript, Kotlin, Scala, Swift).

## Per-chapter summary

### Part 1 — Understanding the Domain

### Ch 1 — Introducing Domain-Driven Design
Developers and domain experts should build a shared mental model before code is written. Event storming uses business events to discover important behavior, after which the domain can be partitioned into subdomains and bounded contexts. A ubiquitous language then ensures that important words carry the same meaning in code and in conversation.

### Ch 2 — Understanding the Domain
Capture the domain by interviewing the expert, not by jumping to a database schema or a class hierarchy. Resist database-driven and class-driven design; document the domain in plain text first. Model real complexity (optionality, constraints, alternative cases) instead of flattening it.

### Ch 3 — A Functional Architecture
Bounded contexts should act as autonomous components that communicate through events and explicit contracts. Each workflow is modeled as a transformation within its own context, typically accepting commands and producing events. An onion or layered architecture keeps the pure domain at the center and moves input, output, and infrastructure to the edges.

### Part 2 — Modeling the Domain

### Ch 4 — Understanding Types
Algebraic data types provide the basic vocabulary for functional domain modeling. Product types such as records and tuples combine values with an "and," while sum types such as discriminated unions represent an "or" among alternatives. Because types compose and document allowed data, a function signature can serve as a precise specification of a transformation.

### Ch 5 — Domain Modeling with Types
The ubiquitous language should be translated directly into domain-specific types. Wrapping primitives in single-case unions such as `OrderId` and `EmailAddress` prevents an arbitrary string from masquerading as a meaningful value. Choices become union types and workflows become functions, allowing the type definitions to read like a description of the domain.

### Ch 6 — Integrity and Consistency in the Domain
Illegal states should be made unrepresentable so invalid values cannot circulate through the domain. Smart or private constructors enforce validation and create constrained types only when their invariants hold. Integrity stays local to an aggregate, consistency boundaries remain explicit, and the core receives data that has already been validated at the edge.

### Ch 7 — Modeling Workflows as Pipelines
A business workflow can be expressed as a pipeline of typed steps, such as `UnvalidatedOrder` to `ValidatedOrder` to `PricedOrder`. Each step is a function whose input and output types record the state transition it performs. Validation failures, asynchronous work, and dependencies also appear in signatures, allowing the complete workflow to be described before implementation.

### Part 3 — Implementing the Model

### Ch 8 — Understanding Functions
Functions are first-class values that can be passed as parameters, returned as results, and composed into larger behavior. Currying and partial application provide a functional way to supply dependencies without hiding them in mutable objects. Total functions and explicit type signatures define the contract for each pipeline step.

### Ch 9 — Implementation: Composing a Pipeline
The workflow is assembled by composing its step functions in domain order. Dependencies are supplied through partial application rather than resolved from a dependency-injection container. Composition becomes harder when steps have mismatched shapes, such as returning `Result` values or asynchronous work, which motivates the error-handling tools in the next chapter.

### Ch 10 — Implementation: Working with Errors
Expected failures should be explicit in the type system through `Result<Success, Error>` rather than hidden in exceptions. In railway-oriented programming, `bind` and `map` continue functions along the success track and short-circuit onto the error track at the first failure. Domain errors become a union of known cases, while boundary code converts or adapts them for external consumers.

### Ch 11 — Serialization
Rich internal domain types should remain separate from the simple, stable Data Transfer Objects used on the wire. Boundary code maps domain values to DTOs and then to JSON or XML, reversing the process for incoming data. This translation lets the internal model evolve without automatically breaking external contracts.

### Ch 12 — Persistence
Persistence belongs at the edge of the system rather than inside the pure domain. The domain emits commands or events, and infrastructure code translates those values into operations on relational or document stores. Transaction and consistency boundaries should align with aggregates, while ORM and query concerns remain outside domain logic.

### Ch 13 — Evolving a Design and Keeping It Clean
A type-driven model can absorb new requirements through localized changes such as adding a union case, record field, or workflow step. The compiler then identifies every location that must handle the changed type. This compiler-guided process helps the design evolve deliberately instead of allowing inconsistencies and obsolete assumptions to accumulate.

## Critiques worth knowing
- **F#-specific surface.** Examples lean on F# discriminated unions, `Result`, and partial application; readers in languages with weaker sum-type or pattern-matching support (Java pre-records, Go) must translate the ideas, and some elegance is lost.
- **Greenfield/CRUD-flavored.** The order-taking case study is a clean, mostly-linear workflow; the book is lighter on hard distributed-systems concerns (eventual consistency, sagas, sharing aggregates across contexts) and on retrofitting an existing tangled codebase.
- **DDD-lite.** It deliberately favors the tactical patterns (types, aggregates, bounded contexts) over deep strategic DDD; pair with Evans/Vernon for context mapping and large-org strategic design.
- **Errors-as-values discipline.** Railway-oriented programming is excellent for expected domain errors but is not a blanket replacement for exceptions; the line between recoverable `Result` errors and genuinely exceptional faults still requires judgment.
