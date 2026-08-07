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
### Ch 1 — What Is Design and Architecture?
Design and architecture describe the same activity at different scales. Their goal is to *minimize the lifetime cost of the system*, not merely to ship the first version quickly. A sound structure keeps future changes affordable by preserving options and resisting accidental coupling.

**Ch 2 — A Tale of Two Values**
Software provides both behavior, which determines what the system does now, and structure, which determines how readily it can change later. Behavioral requests often feel urgent, while architectural quality remains important even when its consequences are delayed. When the two compete, professionals must protect structure because a system that cannot change eventually loses its ability to deliver new behavior.

### Part II — Programming Paradigms
### Ch 3 — Paradigm Overview
The three major programming paradigms are presented as disciplines that remove capabilities from programmers. Structured programming removes unrestricted `goto`, object-oriented programming removes direct function-pointer manipulation, and functional programming removes assignment. By constraining control, dependency, or state changes, each paradigm makes some classes of behavior easier to reason about.

### Ch 4 — Structured Programming
Structured programming removes unrestricted direct transfers of control. Programs are instead composed from predictable structures such as sequence, selection, and iteration. Those structures enable larger problems to be decomposed into units whose behavior can be reasoned about and tested independently.

### Ch 5 — Object-Oriented Programming
Polymorphism is presented as the *key* contribution of object-oriented programming because it lets source-code dependencies be *inverted*. Encapsulation and inheritance are treated as weaker contributions because non-object-oriented languages already offered comparable mechanisms. With polymorphism, high-level policy can define an interface that lower-level details implement, reversing the direction of dependency.

### Ch 6 — Functional Programming
Functional programming restricts assignment and therefore reduces mutable state. Without shared mutation, race conditions and many concurrency bugs cannot arise in the same form. Event sourcing is presented as a real-world architecture that preserves state changes as an append-only history rather than overwriting data in place.

### Part III — Design Principles (SOLID)
### Ch 7 — SRP
A module should have one reason to change. In the Single Responsibility Principle, a *reason* means a stakeholder or actor rather than a generic function performed by the code. Behavior serving different actors belongs in different modules so changes requested by one do not endanger the others.

### Ch 8 — OCP
The Open-Closed Principle says software should be open for extension but closed for modification. Dependency inversion and plugin architectures let new variants attach through stable interfaces. This arrangement allows behavior to grow without repeatedly editing and risking the policy that already works.

### Ch 9 — LSP
The Liskov Substitution Principle requires subtypes to be usable wherever their parent abstractions are expected. A subtype that weakens the parent's contract forces callers to detect its concrete type or handle surprising behavior. Those special cases leak the abstraction and make the hierarchy less useful.

### Ch 10 — ISP
The Interface Segregation Principle favors focused interfaces over one large interface containing unrelated operations. A client should depend only on the methods it actually needs. Even unused methods create harmful source-code dependencies because changes to them can force unrelated clients to recompile, redeploy, or change.

### Ch 11 — DIP
The Dependency Inversion Principle says source code should depend on abstractions rather than volatile concrete implementations. Stable interfaces express policy, while replaceable implementations handle changing details. Arranging boundaries this way keeps high-level decisions from importing frameworks, devices, or other mechanisms likely to change.

### Part IV — Component Principles
### Ch 12 — Components
Components are independently linkable units of software. Their boundaries determine which source-code dependencies are allowed to cross between larger pieces of the system. Choosing those boundaries also establishes practical units for release, reuse, and deployment.

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
### Ch 15–16 — What Is Architecture? / Independence
Architecture keeps important options open for as long as responsible decisions can be deferred. Use cases and business rules should remain independent of frameworks, user interfaces, and databases. That independence lets delivery mechanisms and deployment choices change without rewriting the system's purpose.

### Ch 17 — Boundaries
A boundary is a place where source-code dependencies *invert*. The plug-in architecture model places stable policy on one side and replaceable details on the other. Interfaces at the boundary allow control to cross outward while source dependencies continue pointing inward.

### Ch 18 — Boundary Anatomy
Boundary mechanics differ among function calls in one process, independently deployed services, and modules inside a monolith. Crossing a process boundary adds latency and failure modes that a local call does not have. Regardless of mechanism, the architectural principle remains that lower-level details depend on higher-level policy.

### Ch 19 — Policy and Level
Higher-level policy is *farther* from concrete input and output. It describes enduring rules about what the system should accomplish rather than the devices or protocols used to accomplish it. Lower-level mechanisms should therefore depend on that policy, not force the policy to import their details.

### Ch 20 — Business Rules
Entities contain enterprise-wide business rules, while Use Cases contain application-specific rules that coordinate them. Together they occupy the *innermost* circles of the architecture. Inputs, outputs, databases, and user interfaces must adapt to these rules rather than define them.

### Ch 21 — Screaming Architecture
A directory listing should communicate the system's *use cases*, not merely name its framework. The top-level organization ought to reveal what the application does to a reader who has not opened the implementation. Framework packages remain details beneath that business-oriented structure.

**Ch 22 — The Clean Architecture** ⭐ — The famous concentric-circles diagram. Outermost: frameworks/drivers. Next: interface adapters (controllers, presenters, gateways). Next: application business rules (use cases). Innermost: enterprise business rules (entities). The dependency rule: source code dependencies point inward only.

### Ch 23 — Presenters and Humble Objects
The Humble Object pattern pushes behavior that is difficult to test, such as direct UI or database interaction, into thin boundary objects. Presenters and similar collaborators translate between those details and plain data used by the application. Keeping the humble object simple leaves the important decision-making core deterministic and easy to test.

### Ch 24 — Partial Boundaries
A full runtime and deployment boundary may cost more than a system currently needs. Facades, dependency inversion without separate deployment, and reciprocal interfaces provide partial alternatives. These approaches preserve some separation and a path to a stronger boundary while avoiding unnecessary packaging and operational overhead.

### Ch 25 — Layers and Boundaries
Real systems often need multiple layers whose boundaries cross both horizontal technical concerns and vertical use-case concerns. The useful boundary is determined by rates of change and dependency direction rather than by a standard diagram alone. Deliberate placement prevents convenient shortcuts from coupling business policy to unrelated details.

### Ch 26 — The Main Component
`main` is the dirtiest module because it knows which concrete implementations compose the running application. It constructs objects, supplies configuration, and injects dependencies into cleaner modules. Keeping this knowledge in one composition root prevents the rest of the system from depending on startup and wiring details.

### Ch 27 — Services: Great and Small
Splitting software into services does not by itself create a sound architecture. Decoupling comes from boundaries and dependency rules, not from deployment topology. Services can still form a distributed monolith when they share policy, data, or coordinated release requirements.

### Ch 28 — The Test Boundary
Tests are architectural components and should follow the dependency rule as well. Tests tied directly to a volatile user interface become fragile when presentation details change. Exercising use cases through stable interfaces protects important behavior while allowing outer mechanisms to evolve.

### Ch 29 — Clean Embedded Architecture
Embedded software can apply the same architectural layers as server or desktop systems. Target-hardware access belongs behind interfaces rather than inside software policy. This separation makes core behavior testable on ordinary development machines and easier to port when hardware changes.

### Part VI — Details
### Ch 30 — The Database Is a Detail
The data schema expresses policy, but the particular database engine is a detail. Business rules should not depend directly on an engine's API or storage model. Gateways and adapters isolate that mechanism so it can change without pulling the use cases with it.

### Ch 31 — The Web Is a Detail
Web technology is a delivery mechanism rather than the application's architecture. User-interface frameworks are interchangeable, while the use cases should survive their replacement. Controllers and presenters adapt web requests and responses at the outer boundary.

### Ch 32 — Frameworks Are Details
Frameworks are tools chosen to serve the application, not owners of its business rules. Domain code should not be married to framework base classes, annotations, or lifecycle hooks. Isolating those APIs in adapters preserves the option to upgrade or replace the framework.

### Ch 33 — Case Study: Video Sales
The chapter provides a worked example based on a video-sales system. It applies use-case boundaries and dependency direction to a concrete application rather than another abstract diagram. The example demonstrates how entities, application rules, and delivery details can be separated in an implementation.

### Ch 34 — The Missing Chapter (Simon Brown, guest)
This guest chapter by Simon Brown examines how source-code packaging makes architecture visible and enforceable. It argues that package-by-feature often protects use-case boundaries better than package-by-layer. Practical access controls and package organization must support the intended dependency rules or the architectural diagrams have little force.

## Why it's deeply integrated into `/mithril architecture`
Dependency-rule violations and layer mixing are primary findings.

## Critique
Some readers find the book repetitive (variations on dependency inversion). The diagrams are the high-value artifacts.
