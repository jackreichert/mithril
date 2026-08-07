---
title: Agile Software Development — Principles, Patterns, and Practices
authors: Robert C. Martin
year: 2002
category: Engineering Culture & Process
focus: Agile and XP practices, SOLID principles, package design, and design patterns through case studies
---

<!-- markdownlint-disable MD025 -->

# Agile Software Development — Robert C. Martin (2002)

This book connects three layers that are often taught separately: an iterative development process, object-oriented design principles, and concrete design patterns. Martin begins with the practices of Extreme Programming (XP), derives SOLID and package-level principles as ways to keep change affordable, and then demonstrates those ideas in extended payroll, weather-station, and embedded-system case studies. The examples use Java and C++, but the enduring contribution is the reasoning process: write a test, make a small change, notice a design pressure, and introduce only the abstraction that the pressure justifies.

## Part I — Agile Development

### Ch 1 — Agile Practices

The opening chapter introduces the Agile Manifesto as a response to heavyweight processes that try to eliminate uncertainty through extensive up-front planning. It explains that agile development does not reject plans, documentation, contracts, or tools; it values working software, collaboration, and adaptation more when the two sides conflict. The practical lesson is to shorten the feedback loop so the team can learn from executable results instead of defending assumptions made months earlier.

### Ch 2 — Overview of Extreme Programming

Extreme Programming turns short feedback loops into a concrete team discipline through user stories, small releases, acceptance tests, pair programming, test-first development, refactoring, continuous integration, and collective ownership. The practices reinforce one another: tests make refactoring safer, continuous integration exposes conflicts quickly, and small releases keep planning grounded in evidence. Removing one practice can therefore weaken the others, so XP should be understood as a system rather than a menu of unrelated techniques.

### Ch 3 — Planning

Planning begins with user stories that describe valuable behavior without pretending to be complete technical specifications. Business participants prioritize stories by value while developers estimate their relative cost, and measured delivery velocity determines how much work fits into the next iteration. The plan is deliberately revisable: estimates, priorities, and scope change as the team learns, while the iteration deadline remains a stable cadence for making trade-offs visible.

### Ch 4 — Testing

The chapter separates programmer tests, which guide and verify small design decisions, from customer acceptance tests, which define whether a story is complete. Writing tests first forces the programmer to decide how the code should be used before deciding how it should be implemented, often producing simpler interfaces and less coupling. A continuously running test suite becomes both a regression net and an executable account of the system's expected behavior, but it remains valuable only when failures are treated as urgent information.

### Ch 5 — Refactoring

Refactoring changes the structure of code without changing its observable behavior, allowing design to evolve after the team has learned more about the problem. The safety comes from taking small steps and running tests after each one, not from attempting a large cleanup under the same label. Martin frames refactoring as routine design work: remove duplication, clarify intent, and improve dependency structure continuously so later features do not have to pay accumulated complexity first.

### Ch 6 — A Programming Episode

This worked episode shows two programmers developing a bowling-score calculator through tiny test-first increments. The design is not predicted in full; it emerges as examples expose missing concepts, duplication suggests abstractions, and refactoring keeps the implementation understandable. The episode demonstrates the book's core method in miniature: prefer executable feedback and reversible steps to speculative generality, while still applying judgment about when the design has become clear enough.

## Part II — Agile Design

### Ch 7 — What Is Agile Design?

An agile design is not a design produced by avoiding architecture; it is a design kept responsive to change through continuous attention. Martin identifies rigidity, fragility, immobility, viscosity, needless complexity, needless repetition, and opacity as symptoms of dependency structures that make change expensive. The remedy is to remove these smells incrementally with tests and principles, introducing abstractions when actual changes demand them rather than forecasting every possible future requirement.

### Ch 8 — The Single-Responsibility Principle

The Single-Responsibility Principle states that a class or module should have only one reason to change, where a reason corresponds to a responsibility owned by a particular actor or policy. Code that mixes independent responsibilities couples their rates of change, so a request from one stakeholder can break behavior belonging to another. Applying SRP therefore requires understanding the domain and its change pressures; mechanically making every class or function small does not establish a coherent responsibility.

### Ch 9 — The Open-Closed Principle

The Open-Closed Principle says software entities should be open for extension but closed for modification, so a new variation can often be added without editing stable behavior. Abstraction and polymorphism can create that protected axis, but every abstraction closes the design against some changes while leaving it exposed to others. The practical rule is to wait for evidence of the variation, then isolate it; trying to close the system against every imaginable change produces needless complexity.

### Ch 10 — The Liskov Substitution Principle

The Liskov Substitution Principle requires a subtype to preserve the behavioral promises of its base type, not merely share its method signatures. A subtype that strengthens preconditions, weakens postconditions, changes invariants, or surprises callers forces clients to know its concrete type and breaks substitutability. The familiar rectangle-square example shows that a mathematically valid "is-a" relationship may be an invalid software subtype when mutability and client expectations differ.

### Ch 11 — The Dependency-Inversion Principle

The Dependency-Inversion Principle says high-level policy should not depend directly on low-level mechanism; both should depend on abstractions shaped by the policy's needs. This reverses the conventional dependency direction in which business rules import database, device, or framework details and become difficult to test or reuse. Stable abstractions, ownership of interfaces by their clients, and construction at the system edge let mechanisms vary without dragging policy with them.

### Ch 12 — The Interface-Segregation Principle

The Interface-Segregation Principle says clients should not be forced to depend on methods they do not use. A broad interface couples unrelated clients because changing one responsibility can require recompiling, redeploying, or reconsidering all consumers of the interface. Splitting the contract into role-specific views keeps dependencies narrow, though the goal is meaningful client boundaries rather than the maximum possible number of tiny interfaces.

## Part III — The Payroll Case Study

### Ch 13 — Command and Active Object

The Command pattern turns a request into an object, allowing callers to queue, schedule, log, or undo work without knowing how the work is performed. The chapter combines commands with an Active Object design in which a scheduler executes queued commands while preserving a controlled concurrency model. The broader lesson is that patterns become useful when a real force, such as deferred execution or decoupled scheduling, appears; the pattern is not valuable merely because its class diagram can be reproduced.

### Ch 14 — Template Method and Strategy: Inheritance versus Delegation

Template Method places an algorithm's stable skeleton in a base class and lets subclasses override selected steps, which is concise but binds variation to inheritance. Strategy moves the varying algorithm behind a collaborating object, adding delegation while allowing runtime substitution and avoiding a rigid class hierarchy. The comparison teaches a recurring design choice: inheritance can be appropriate for a genuine, stable subtype relationship, but composition is usually safer when the primary goal is interchangeable behavior.

### Ch 15 — Facade and Mediator

Facade presents a simpler interface over a complex subsystem so most clients need not understand its internal relationships. Mediator centralizes coordination among peers that would otherwise depend directly on one another, reducing a web of pairwise coupling. Both patterns reduce knowledge, but in different directions: a facade simplifies access from outside a boundary, while a mediator manages interactions inside a collaboration and can itself become overly powerful if given unrelated policy.

### Ch 16 — Singleton and Monostate

Singleton enforces one instance and exposes it globally, while Monostate permits multiple instances that share the same static state. Martin compares their mechanics and trade-offs, including creation control, inheritance, transparency, and destruction behavior. Modern readers should add a stronger warning: both forms create hidden global coupling and shared mutable state, so explicit ownership and dependency injection are generally preferable unless process-wide uniqueness is a demonstrated invariant.

### Ch 17 — Null Object

Null Object replaces repeated absence checks with an object that implements the expected interface using neutral behavior. This can simplify clients because they invoke a stable protocol instead of branching every time a collaborator might be missing. The object must represent a legitimate domain meaning for "do nothing" or "no result"; using it to hide configuration errors or exceptional absence makes failures harder to detect.

### Ch 18 — The Payroll Case Study: Iteration 1 Begins

The payroll case study starts from user stories and use cases for adding, deleting, and modifying employees rather than from a comprehensive class model. Transactions provide the application boundary, while entities and classifications emerge from the behavior required by the first iteration. The chapter shows how agile analysis stays concrete: choose a thin set of valuable stories, model only what those stories require, and leave room for later evidence to reshape the design.

### Ch 19 — The Payroll Case Study: Implementation

Implementation proceeds story by story with tests driving transaction objects, employee records, payment classifications, schedules, and methods. Patterns such as Command, Strategy, and Factory appear because the cases need replaceable behavior and controlled construction, not because the project began with a pattern inventory. The result demonstrates evolutionary design at a larger scale while also exposing the cost of persistence and global-database choices that later designs should keep at the boundary.

## Part IV — Packaging the Payroll System

### Ch 20 — Principles of Package Design

Martin scales responsibility and dependency reasoning from classes to deployable packages through six principles. REP, CCP, and CRP govern cohesion by balancing what should be released, changed, and reused together; ADP, SDP, and SAP govern coupling by preventing cycles and directing dependencies toward stable abstractions. These principles describe competing forces rather than a permanent ideal, so package boundaries should change as a system moves from active development toward broader reuse and stability.

### Ch 21 — Factory

Factory patterns separate object creation from the code that uses the resulting abstractions. This is especially useful when construction selects among families of implementations or requires low-level details that high-level policy should not import. A factory earns its indirection only when creation actually varies or crosses a dependency boundary; wrapping a single obvious constructor in layers of factories makes the design shallower rather than more flexible.

### Ch 22 — The Payroll Case Study: Iteration 2

The second iteration adds more payroll behavior and uses package principles to reorganize the growing design around cohesive responsibilities and stable dependency directions. New requirements test whether the abstractions discovered in the first iteration accept extension cleanly or reveal misplaced responsibilities. The chapter makes architecture empirical: package structure is revised in response to actual change, and the quality of the prior design is judged by the cost and locality of that change.

## Part V — The Weather Station Case Study

### Ch 23 — Composite

Composite gives individual objects and groups of objects a common interface so clients can treat tree structures uniformly. The pattern is useful for structures such as graphical figures, organizational hierarchies, or expression trees where operations naturally recurse over parts and wholes. Uniformity can obscure differences between leaves and containers, so the interface should include only operations that make behavioral sense for both.

### Ch 24 — Observer: Backing into a Pattern

Observer defines a one-to-many relationship in which subjects notify interested observers when state changes. The chapter deliberately arrives at the pattern by refactoring a concrete dependency problem, showing how duplicated update logic and unwanted knowledge motivate the abstraction. Observer reduces direct coupling but introduces temporal behavior, ordering questions, lifecycle management, and possible update cascades, all of which must be made explicit in production code.

### Ch 25 — Abstract Server, Adapter, and Bridge

Abstract Server applies dependency inversion by placing an interface between a client and the service it uses, letting the client own the contract it needs. Adapter translates an existing or third-party interface into that contract, while Bridge separates an abstraction from its implementation so both can vary independently. Together they show three related but distinct moves: invert a dependency, reconcile an interface mismatch, and decouple two dimensions of change.

### Ch 26 — Proxy and Stairway to Heaven: Managing Third-Party APIs

Proxy stands in for another object and controls access for concerns such as remoting, laziness, security, or instrumentation while preserving the same apparent interface. The "Stairway to Heaven" technique builds an application-owned abstraction above a third-party API so vendor details do not spread through business code. Both approaches protect a boundary, but they must not pretend remote or failure-prone behavior is local and harmless; latency, partial failure, and semantic differences still belong in the contract.

### Ch 27 — The Weather Station Case Study

The weather-station example integrates the preceding patterns to isolate sensors, communications, domain calculations, and presentation concerns. Its value is not the final diagram but the sequence of decisions that assigns each dependency to a boundary and keeps domain policy independent of hardware and vendor APIs. The case study also illustrates restraint: each pattern answers a specific force, and removing that force should make the extra abstraction unnecessary.

## Part VI — The ETS Case Study

### Ch 28 — Visitor

Visitor separates operations from a stable object structure by using double dispatch, making it easier to add new operations without modifying every element class. The trade-off is symmetrical: adding a new element type becomes expensive because every visitor must learn about it, and the visitor may need broad access to element details. Visitor therefore fits structures whose variants are stable and whose operations change frequently; in languages with algebraic data types and exhaustive pattern matching, a simpler native form may express the same trade-off.

### Ch 29 — State

State represents each mode of an object's finite-state behavior as a separate object and delegates mode-specific behavior to the current state. This replaces sprawling conditionals with explicit transitions and lets each state's rules remain cohesive. The pattern is most useful when states have substantial distinct behavior; for a small and stable transition table, an enum plus a clear transition function may be easier to understand.

### Ch 30 — The ETS Framework

The final case study develops an embedded training-system framework by combining State, Strategy, Template Method, and other principles from the book. It demonstrates how tests and dependency inversion can isolate hardware-facing code so most behavior remains executable in a normal development environment. The framework closes the book's argument: agile practice supplies feedback, principles diagnose dependency problems, and patterns provide tested shapes for resolving only the problems the evolving system actually exhibits.

## Enduring contribution and cautions

The book's strongest contribution is its explicit bridge from development process to design structure: rapid feedback is sustainable only when dependencies permit inexpensive change. Its SOLID chapters and worked case studies remain foundational, while some mechanics reflect early-2000s Java/C++ and should be translated into current language features and deployment realities. In particular, modern use should temper Singleton, transparent remote proxies, inheritance-heavy Template Method, and interface proliferation with explicit dependency injection, failure-aware contracts, composition, and the deep-module test.

## Why it belongs in Mithril

- **Process:** connects short iterations, customer tests, test-first development, refactoring, and continuous integration as one feedback system.
- **Architecture:** provides the clearest worked introduction to SOLID and the package cohesion/coupling principles.
- **Patterns:** demonstrates patterns as responses to observed design pressure through extended case studies rather than as a catalog to install up front.
- **Tension handling:** supplies useful historical guidance that Mithril can retain while applying modern cautions around global state, distributed transparency, and needless abstraction.
