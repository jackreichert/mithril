---
title: Clean Architecture
author: Robert C. Martin
year: 2017
category: Clean Architecture Trilogy
focus: Dependencies, layers, boundaries, SOLID at scale
---

# Clean Architecture — Robert C. Martin (2017)

A condensed restatement of decades of Uncle Bob's architecture writing. Centered on **dependency rules**: source-code dependencies must point only inward toward higher-level policy.

## Per-part / per-chapter summary

### Part I — Introduction
**Ch 1 — What Is Design and Architecture?**
Same thing at different scales. The goal of architecture is to *minimize the lifetime cost of the system*, not to ship fast.

**Ch 2 — A Tale of Two Values**
Behavior (what the system does) vs. structure (its ability to change). Behavior is urgent, structure is important — Eisenhower box puts structure first when both can't have priority.

### Part II — Programming Paradigms
**Ch 3 — Paradigm Overview** — Three paradigms remove capability: structured (no goto), object-oriented (no function pointers), functional (no assignment).

**Ch 4 — Structured Programming** — Removes direct transfer of control → enables decomposition into provable units.

**Ch 5 — Object-Oriented Programming** — Polymorphism is the *key* OO contribution: it lets dependencies be *inverted*. (Encapsulation and inheritance are weaker than non-OO equivalents.)

**Ch 6 — Functional Programming** — Removes assignment → no race conditions, no concurrency bugs. Event sourcing as a real-world functional architecture.

### Part III — Design Principles (SOLID)
**Ch 7 — SRP** — A module should have one reason to change. *Reason* = stakeholder, not "function." Different actors → different modules.

**Ch 8 — OCP** — Open for extension, closed for modification. Achieved via dependency-inversion + plugin architectures.

**Ch 9 — LSP** — Subtypes substitutable for parents. Violations leak abstraction.

**Ch 10 — ISP** — Many small interfaces > one fat interface. Source-code dependencies on unused things still hurt.

**Ch 11 — DIP** — Depend on abstractions, not concretions. Stable abstractions, volatile implementations.

### Part IV — Component Principles
**Ch 12 — Components** — Linkable units. Their boundaries determine dependency direction.

**Ch 13 — Component Cohesion** — Three rules in tension:
- **REP** (Reuse-Release Equivalence): the unit of reuse is the unit of release.
- **CCP** (Common Closure): things that change for the same reason go together.
- **CRP** (Common Reuse): things used together go together.
*Tension diagram* — you can't optimize all three; choose your trade-offs.

**Ch 14 — Component Coupling** —
- **Acyclic Dependencies Principle** (no cycles).
- **Stable Dependencies Principle** (depend on stable components).
- **Stable Abstractions Principle** (stable = abstract; volatile = concrete).
Each has a measurable metric.

### Part V — Architecture
**Ch 15–16 — What Is Architecture? / Independence** — Keep options open. Use cases + business rules independent of frameworks, UI, DB.

**Ch 17 — Boundaries** — A boundary is a place where dependencies *invert*. The "Plug-in Architecture" idea.

**Ch 18 — Boundary Anatomy** — Local processes, services, monolith — boundary mechanics differ but principle holds.

**Ch 19 — Policy and Level** — Higher-level policy is *farther* from input/output.

**Ch 20 — Business Rules** — Entities (enterprise-wide rules) and Use Cases (application-specific). The *innermost* circle.

**Ch 21 — Screaming Architecture** — A directory listing should scream the *use cases*, not the *framework*.

**Ch 22 — The Clean Architecture** ⭐ — The famous concentric-circles diagram. Outermost: frameworks/drivers. Next: interface adapters (controllers, presenters, gateways). Next: application business rules (use cases). Innermost: enterprise business rules (entities). The dependency rule: source code dependencies point inward only.

**Ch 23 — Presenters and Humble Objects** — Push untestable behavior (UI, DB) into thin "humble" objects so the testable core remains pure.

**Ch 24 — Partial Boundaries** — When full plugin separation is overkill: facades, dependency-inversion only, reciprocal interfaces.

**Ch 25 — Layers and Boundaries** — Multi-layer systems where boundaries cross horizontal and vertical concerns.

**Ch 26 — The Main Component** — `main` is the dirtiest module: it composes all the rest.

**Ch 27 — Services: Great and Small** — Services don't make architecture. Decoupling comes from boundaries, not deployment topology.

**Ch 28 — The Test Boundary** — Tests follow the dependency rule too. Don't write tests against volatile UI; test the use cases.

**Ch 29 — Clean Embedded Architecture** — Even firmware can have these layers — separate target-hardware concerns from software policy.

### Part VI — Details
**Ch 30 — The Database Is a Detail** — Schema is policy; the engine is a detail.

**Ch 31 — The Web Is a Detail** — UI tech is interchangeable; use cases survive.

**Ch 32 — Frameworks Are Details** — Don't marry your domain code to a framework.

**Ch 33 — Case Study: Video Sales** — Worked example.

**Ch 34 — The Missing Chapter** (Simon Brown, guest) — Practical package structure: package-by-feature beats package-by-layer.

## Why it's deeply integrated into `/quality architecture`
Dependency-rule violations and layer mixing are primary findings.

## Critique
Some readers find the book repetitive (variations on dependency inversion). The diagrams are the high-value artifacts.
