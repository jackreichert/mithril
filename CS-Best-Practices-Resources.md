# CS Best Practices: Canonical Resources

Foundation reading for clean-code skill synthesis. This file is the **per-resource index** ("which book owns which idea"); for the **cross-cutting synthesis** — themes that recur across many sources, where they converge, and where the canon disagrees with itself — see [`THEMES.md`](THEMES.md).

> **Coverage note:** Not every book listed here drove the `/mithril` framework's synthesis. About 10 of the original core were deeply integrated into the agents (Clean Code, Refactoring, APOSD, Clean Architecture, GOOS, Art of Unit Testing, xUnit Test Patterns, Working Effectively with Legacy Code, DDD, Release It!). The remainder are listed for context, future reference, or because their concepts already filter through other primary sources. For the honest "what's actually synthesized vs. what's just listed" breakdown, see [`README.md`](README.md#whats-deliberately-not-synthesized).
>
> **2026-06 expansion:** 13 books (#29–41) were added to close named gaps — concurrency (JCiP), performance & query hygiene (SQL Performance Explained, Database Internals, Systems Performance), reliability/ops (SRE), functional discipline (Grokking Simplicity, Domain Modeling Made Functional), security-by-design (Building Secure and Reliable Systems, Threat Modeling), distributed/integration (Building Microservices, Enterprise Integration Patterns), change-economics (Tidy First?), and DDD how-to (Implementing DDD). Chapter summaries and THEMES.md are updated; skill integration follows.

---

## Books

### The Canon

| # | Title | Author(s) | Year | Focus |
|---|-------|-----------|------|-------|
| 1 | **Clean Code** | Robert C. Martin | 2008 | Naming, functions, comments, formatting, objects, error handling, TDD |
| 2 | **Code Complete** (2nd ed.) | Steve McConnell | 2004 | Construction fundamentals — the encyclopedia |
| 3 | **The Pragmatic Programmer** (20th anniv.) | Andrew Hunt, David Thomas | 1999/2019 | Mindset, habits, tool mastery, orthogonality |
| 4 | **Design Patterns** (GoF) | Gamma, Helm, Johnson, Vlissides | 1994 | Creational, structural, behavioral patterns |
| 5 | **Refactoring** (2nd ed.) | Martin Fowler | 1999/2018 | Smell catalog, refactoring mechanics, when/how to change code |
| 6 | **A Philosophy of Software Design** | John Ousterhout | 2018/2021 | Complexity theory, deep modules, information hiding |
| 7 | **Working Effectively with Legacy Code** | Michael Feathers | 2004 | Seams, test harnesses, safe change in untested systems |
| 34 | **Tidy First?** | Kent Beck | 2023 | Tidyings catalog, structure-vs-behavior, coupling/cohesion, design economics |

### Clean Architecture Trilogy (Uncle Bob)

| # | Title | Author | Year | Focus |
|---|-------|--------|------|-------|
| 8 | **Clean Architecture** | Robert C. Martin | 2017 | Dependencies, layers, boundaries, SOLID at scale |
| 9 | **The Clean Coder** | Robert C. Martin | 2011 | Professionalism, TDD discipline, estimates, pressure |

### Domain & Systems Design

| # | Title | Author(s) | Year | Focus |
|---|-------|-----------|------|-------|
| 10 | **Domain-Driven Design** | Eric Evans | 2003 | Ubiquitous language, bounded contexts, aggregates, repositories |
| 11 | **Patterns of Enterprise Application Architecture** | Martin Fowler | 2002 | Layering, ORMs, concurrency, session state |
| 12 | **Designing Data-Intensive Applications** | Martin Kleppmann | 2017 | Storage, replication, transactions, distributed systems |
| 13 | **Release It!** (2nd ed.) | Michael T. Nygard | 2018 | Stability patterns, circuit breakers, bulkheads, production-readiness |
| 37 | **Building Microservices** (2nd ed.) | Sam Newman | 2021 | Service decomposition, information hiding, communication, resilience, observability |
| 38 | **Enterprise Integration Patterns** | Gregor Hohpe, Bobby Woolf | 2003 | 65 async-messaging patterns — channels, routing, transformation, endpoints |
| 41 | **Implementing Domain-Driven Design** | Vaughn Vernon | 2013 | Tactical + strategic DDD how-to — aggregates, domain events, context mapping |

### Testing

| # | Title | Author(s) | Year | Focus |
|---|-------|-----------|------|-------|
| 14 | **Test-Driven Development: By Example** | Kent Beck | 2002 | TDD mechanics, baby steps, red-green-refactor |
| 15 | **Growing Object-Oriented Software, Guided by Tests** | Freeman, Pryce | 2009 | Outside-in TDD, mock roles not objects |
| 16 | **The Art of Unit Testing** (3rd ed.) | Roy Osherove | 2023 | Isolation, stubs, mocks, maintainable tests |
| 17 | **xUnit Test Patterns** | Gerard Meszaros | 2007 | Test smell catalog, pattern library |
| 27 | **Unit Testing: Principles, Practices, and Patterns** | Vladimir Khorikov | 2020 | Four Pillars, Classical vs. London school, integration testing, anti-patterns |
| 28 | **Specification by Example** | Gojko Adzic | 2011 | Key examples, living documentation, Three Amigos, executable specs |

### Engineering Culture & Process

| # | Title | Author(s) | Year | Focus |
|---|-------|-----------|------|-------|
| 18 | **Software Engineering at Google** | Winters, Manshreck, Wright | 2020 | Scale, code review, testing culture, documentation |
| 19 | **Continuous Delivery** | Jez Humble, David Farley | 2010 | Deployment pipelines, trunk-based dev, feature flags |
| 20 | **The Mythical Man-Month** | Fred Brooks | 1975/1995 | Complexity, estimation, team coordination |
| 21 | **Head First Design Patterns** (2nd ed.) | Freeman, Robson | 2020 | Approachable GoF with OO design principles |
| 25 | **Accelerate** | Forsgren, Humble, Kim | 2018 | DORA empirics: four key metrics, capabilities that drive elite delivery performance |
| 26 | **Team Topologies** | Skelton, Pais | 2019 | Four team types, three interaction modes, Inverse Conway Maneuver, cognitive load |

### Language-Specific (High Signal)

| # | Title | Author | Year | Focus |
|---|-------|--------|------|-------|
| 22 | **Effective Java** (3rd ed.) | Joshua Bloch | 2018 | Idiomatic Java; principles transfer to all OO languages |
| 23 | **The Art of Readable Code** | Boswell, Foucher | 2011 | Surface-level clarity — names, loops, conditionals |
| 24 | **SICP** | Abelson, Sussman | 1996 | Abstraction, recursion, interpreters — foundational |

### Concurrency

| # | Title | Author(s) | Year | Focus |
|---|-------|-----------|------|-------|
| 29 | **Java Concurrency in Practice** | Brian Goetz et al. | 2006 | Threads, locks, the memory model, safe publication, atomicity/visibility/liveness |

### Performance & Reliability

| # | Title | Author(s) | Year | Focus |
|---|-------|-----------|------|-------|
| 30 | **SQL Performance Explained** | Markus Winand | 2012 | Index anatomy, query performance, `SELECT *`/over-fetch, joins, sorting, pagination |
| 31 | **Database Internals** | Alex Petrov | 2019 | Storage engines (B-tree/LSM), WAL, distributed consensus & replication |
| 32 | **Systems Performance** (2nd ed.) | Brendan Gregg | 2020 | Performance methodology — USE method, latency analysis, profiling, observability |
| 33 | **Site Reliability Engineering** | Beyer, Jones, Petoff, Murphy (eds.) | 2016 | SLIs/SLOs, error budgets, toil, four golden signals, incident response |

### Functional

| # | Title | Author(s) | Year | Focus |
|---|-------|-----------|------|-------|
| 35 | **Grokking Simplicity** | Eric Normand | 2021 | Actions/calculations/data, immutability, first-class functions, onion architecture |
| 36 | **Domain Modeling Made Functional** | Scott Wlaschin | 2018 | DDD + FP, algebraic types, illegal states unrepresentable, railway-oriented errors |

### Security

| # | Title | Author(s) | Year | Focus |
|---|-------|-----------|------|-------|
| 39 | **Building Secure and Reliable Systems** | Adkins et al. (Google) | 2020 | Security & reliability as design properties, least privilege, design for recovery |
| 40 | **Threat Modeling: Designing for Security** | Adam Shostack | 2014 | STRIDE, the four-question framework, data-flow diagrams, attack trees, mitigation |
| 42 | **Observability Engineering** | Majors, Fong-Jones, Miranda | 2022 | High-cardinality events, debugging production, structured telemetry |
| 43 | **API Design Patterns** | JJ Geewax | 2021 | Resource-oriented APIs, pagination, errors, versioning, compatibility |

### Supply chain & accessibility (standards notes)

| # | Resource | Focus |
|---|----------|-------|
| — | **Software Supply Chain Security** (SLSA / SBOM / signed artifacts) | Provenance, lockfiles, CI trust, SCA — [`08-Supply-Chain-Security.md`](Resources/Standards/08-Supply-Chain-Security.md) |
| — | **WCAG 2.2** | POUR / Level AA product floor — [`09-WCAG.md`](Resources/Standards/09-WCAG.md) · Theme 19 · `skills/accessibility.md` |

---

## Articles & Online Resources

### Martin Fowler (martinfowler.com)

| Resource | Key Concept |
|----------|-------------|
| **Refactoring Catalog** (refactoring.com) | 68 named refactoring moves with mechanics |
| **Code Smells** | Bloaters, OO abusers, change preventers, dispensables, couplers |
| **Technical Debt** | Debt quadrant — reckless/prudent × deliberate/inadvertent |
| **Is Design Dead?** | XP, emergent design, planned vs. evolutionary architecture |
| **Beck's Design Rules** | Simple design: passes tests, reveals intent, no duplication, fewest elements |
| **CQRS** | Command-query responsibility segregation |
| **Event Sourcing** | Append-only logs as system of record |
| **Strangler Fig Pattern** | Safe legacy migration strategy |
| **Microservices** (with James Lewis) | Service boundaries, independent deployability |
| **BranchByAbstraction** | Feature flag alternative for large refactors |
| **Trunk Based Development** | Short-lived branches, continuous integration |
| **Hexagonal Architecture (Ports and Adapters)** — Alistair Cockburn (alistair.cockburn.us) | Application as hexagon; ports defined by app, adapters connect external systems |
| **Mocks Aren't Stubs** | Test double taxonomy (dummy/fake/stub/spy/mock); Classical vs. Mockist TDD; state vs. behavior verification |
| **UnitTest** (bliki) | Definitional clarity; solitary vs. sociable distinction; compile suite vs. commit suite |
| **Test Pyramid** (bliki) + **Practical Test Pyramid** (Ham Vocke) | Distribution strategy; unit/subcutaneous/E2E layers; ice-cream cone anti-pattern; CDC/Contract tests |
| **Eradicating Non-Determinism in Tests** | Flaky test root causes (isolation, async, time, remote services, resource leaks); quarantine strategy |
| **On the Diverse And Fantastical Shapes of Testing** | Pyramid vs. honeycomb vs. trophy; semantic root of the debate; test quality over proportions |

### Robert C. Martin — blog.cleancoder.com

| Resource | Key Concept |
|----------|-------------|
| **The Principles of OOD** | Original SOLID articles (SRP, OCP, LSP, ISP, DIP) |
| **Clean Code series** | Application of Clean Code principles |
| **Test Driven Development** | Why TDD is a professional discipline |
| **The Three Laws of TDD** | Red, green, refactor mechanics |
| **FP Basics series** | OO vs FP, immutability, side-effect isolation |

### Joel Spolsky — joelonsoftware.com

| Resource | Key Concept |
|----------|-------------|
| **The Joel Test** | 12-question dev environment health check |
| **Things You Should Never Do, Part I** | Never rewrite from scratch |
| **Painless Software Schedules** | Evidence-based estimation |
| **The Law of Leaky Abstractions** | All non-trivial abstractions leak |

### Google Engineering Practices

| Resource | URL |
|----------|-----|
| **Code Review Developer Guide** | google.github.io/eng-practices |
| **What to look for in a code review** | Includes: design, functionality, complexity, tests, naming, comments, style |
| **The CL Author's Guide** | How to write reviewable code |

### Standards & Principles

| Resource | What It Covers |
|----------|----------------|
| **OWASP Top 10** | Web application security risks |
| **OWASP ASVS** | Application Security Verification Standard |
| **The Twelve-Factor App** (12factor.net) | SaaS application methodology |
| **NASA's Power of 10 Rules** | Safety-critical C coding rules |
| **Google Style Guides** | Python, Java, C++, Go, JS style standards |
| **Airbnb JavaScript Style Guide** | Most-starred JS style guide |
| **PEP 8** (Python) | Python style standard |

### Key Papers

| Paper | Author(s) | What It Introduced |
|-------|-----------|-------------------|
| **On the Criteria to Be Used in Decomposing Systems into Modules** | D.L. Parnas (1972) | Information hiding, interface/implementation split |
| **A Note on Distributed Computing** | Waldo et al. (1994) | Why distributed objects ≠ local objects |
| **Out of the Tar Pit** | Moseley, Marks (2006) | Complexity theory, functional-relational programming |
| **No Silver Bullet** | Fred Brooks (1987) | Essential vs. accidental complexity |

---

## Summary: Concept Coverage

| Concept | Primary Source(s) |
|---------|-------------------|
| Naming | Clean Code ch.2, APOSD, Art of Readable Code |
| Function design | Clean Code ch.3, Code Complete |
| SOLID | Uncle Bob articles + Clean Architecture |
| Design patterns | GoF, Head First Design Patterns |
| Refactoring | Fowler Refactoring 2nd ed., Working Effectively with Legacy Code, Tidy First? |
| Testing / TDD | TDD by Example, GOOS, Art of Unit Testing, xUnit Test Patterns, Khorikov |
| Test doubles | Mocks Aren't Stubs (Fowler), Art of Unit Testing, xUnit Test Patterns ch.11 |
| Test strategy / distribution | Test Pyramid (Fowler/Vocke), Diverse Fantastical Shapes (Fowler) |
| Test quality / pillars | Khorikov Four Pillars, GOOS ch.18, Art of Unit Testing ch.7–9 |
| Flaky tests | Eradicating Non-Determinism (Fowler) |
| Architecture | Clean Architecture, PEAA, DDD, Implementing DDD |
| Error handling | Clean Code ch.7, Release It!, Domain Modeling Made Functional (Result/railway) |
| Concurrency | Java Concurrency in Practice, Clean Code ch.13, Effective Java ch.11 |
| Functional programming | Grokking Simplicity, Domain Modeling Made Functional, SICP, Uncle Bob FP Basics |
| Performance | SQL Performance Explained, Systems Performance, Database Internals, Code Complete, DDIA, Theme 18 |
| Distributed / integration | Waldo, DDIA, Building Microservices, Enterprise Integration Patterns, Release It! |
| Reliability / operability | Site Reliability Engineering, Release It!, 12-Factor, Accelerate, Observability Engineering |
| API / contracts | API Design Patterns, Hyrum's Law (SE@G), expand-contract (CD / DDIA) |
| Supply chain | SLSA/SBOM note, OWASP A08, delivery + security skills |
| Security | OWASP Top 10, ASVS, Threat Modeling, Building Secure and Reliable Systems |
| Code review | Software Eng @ Google, Google Eng Practices |
| Complexity management | APOSD, Out of the Tar Pit, No Silver Bullet |

---

*Created: 2026-05-01 — foundation for clean-code skill synthesis*
