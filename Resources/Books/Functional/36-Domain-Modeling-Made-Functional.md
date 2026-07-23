---
title: Domain Modeling Made Functional
author: Scott Wlaschin
year: 2018
category: Functional
focus: DDD + FP, type-driven design, algebraic data types, making illegal states unrepresentable, railway-oriented programming
---

# Domain Modeling Made Functional — Scott Wlaschin (2018)

Fuses Domain-Driven Design with functional programming: the domain is modeled directly in the type system, illegal states are made unrepresentable, and workflows are expressed as composable pipelines of pure functions with errors carried on a `Result` track (railway-oriented programming). Feeds the **quality-architecture** and **quality-code-quality** agents — it reinforces the FP-discipline rule (Article II: pure functions, immutability, I/O at the boundaries) and the domain-modeling/SOLID rules (Article III: deep domain model independent of frameworks and persistence). Uses F#, but the algebraic-types-as-design ideas transfer to any language with sum/product types (Rust, TypeScript, Kotlin, Scala, Swift).

## Per-chapter summary

### Part 1 — Understanding the Domain

### Ch 1 — Introducing Domain-Driven Design
Build a shared mental model with domain experts before writing code. Discover the domain through business events (event storming), partition it into subdomains, draw bounded-context boundaries, and forge a ubiquitous language that the same words mean the same thing in code and in conversation.

### Ch 2 — Understanding the Domain
Capture the domain by interviewing the expert, not by jumping to a database schema or a class hierarchy. Resist database-driven and class-driven design; document the domain in plain text first. Model real complexity (optionality, constraints, alternative cases) instead of flattening it.

### Ch 3 — A Functional Architecture
Treat bounded contexts as autonomous components communicating via events and explicit contracts (commands in, events out). Model each workflow as a transformation inside its context, and let the onion/layered structure keep the pure domain at the center with I/O at the edges.

### Part 2 — Modeling the Domain

### Ch 4 — Understanding Types
Introduces algebraic data types as the modeling tool: product types (records/tuples = AND) and sum types (discriminated unions = OR). Types are composable and act as documentation; a function signature is a specification of the transformation.

### Ch 5 — Domain Modeling with Types
Translate the ubiquitous language directly into types — wrap primitives in single-case unions (`OrderId`, `EmailAddress`) so a string can't masquerade as an ID. Model choices with unions and workflows with functions, so the type definitions read as the domain itself.

### Ch 6 — Integrity and Consistency in the Domain
Make illegal states unrepresentable: encode validation into constructors (smart/private constructors), use constrained types so an invalid value cannot exist past the boundary. Keep integrity local to an aggregate, define consistency boundaries, and push validation to the edge so the core works only with already-valid data.

### Ch 7 — Modeling Workflows as Pipelines
Express a business workflow as a pipeline of steps (`UnvalidatedOrder → ValidatedOrder → PricedOrder → …`), each a function with a precise type. Capture effects (validation failure, async, dependencies) in the signatures, so the whole workflow is described by its types before any implementation exists.

### Part 3 — Implementing the Model

### Ch 8 — Understanding Functions
Functions are first-class values: pass them as parameters, return them, and compose them. Currying and partial application inject dependencies functionally; total functions and the type signature define the contract of each pipeline step.

### Ch 9 — Implementation: Composing a Pipeline
Assemble the workflow by composing the step functions, injecting dependencies via partial application rather than a DI container. The challenge — steps have mismatched shapes (some return `Result`, some are async) — motivates the next chapter.

### Ch 10 — Implementation: Working with Errors
Make errors explicit in the type system with `Result<Success, Error>` instead of exceptions for expected failures. Railway-oriented programming: `bind`/`map` chain functions on the success track and short-circuit to the error track on the first failure; model domain errors as a union and convert/adapt errors at boundaries.

### Ch 11 — Serialization
Separate the rich internal domain types from the simple, stable Data Transfer Objects used on the wire. Map domain → DTO → JSON/XML at the boundary (and back) so the domain model can evolve without breaking external contracts.

### Ch 12 — Persistence
Keep persistence at the edge: the pure domain emits commands/events and the infrastructure layer translates them to storage. Covers working with relational and document stores, transaction/consistency boundaries aligned to aggregates, and avoiding leaking ORM or query concerns into the domain.

### Ch 13 — Evolving a Design and Keeping It Clean
Show how the type-driven model absorbs new requirements with localized, compiler-guided change — adding a case, a field, or a new step. Demonstrates that the compiler flags every site needing attention, keeping the design clean as it evolves rather than rotting.

## Critiques worth knowing
- **F#-specific surface.** Examples lean on F# discriminated unions, `Result`, and partial application; readers in languages with weaker sum-type or pattern-matching support (Java pre-records, Go) must translate the ideas, and some elegance is lost.
- **Greenfield/CRUD-flavored.** The order-taking case study is a clean, mostly-linear workflow; the book is lighter on hard distributed-systems concerns (eventual consistency, sagas, sharing aggregates across contexts) and on retrofitting an existing tangled codebase.
- **DDD-lite.** It deliberately favors the tactical patterns (types, aggregates, bounded contexts) over deep strategic DDD; pair with Evans/Vernon for context mapping and large-org strategic design.
- **Errors-as-values discipline.** Railway-oriented programming is excellent for expected domain errors but is not a blanket replacement for exceptions; the line between recoverable `Result` errors and genuinely exceptional faults still requires judgment.
