---
title: Clean Code
author: Robert C. Martin
year: 2008
category: Canon
focus: Naming, functions, comments, formatting, objects, error handling, TDD
---

# Clean Code — Robert C. Martin (2008)

The book that branded "clean code" as a discipline. Mixes opinionated essays with worked refactoring exercises in Java. Foundational for `/quality code-quality` agent.

## Per-chapter summary

### Ch 1 — Clean Code
Quotes from luminaries (Bjarne, Dave Thomas, Michael Feathers, Ron Jeffries, Ward Cunningham) on what clean code feels like. Establishes "the boy scout rule": leave the code cleaner than you found it.

### Ch 2 — Meaningful Names
Use intention-revealing names; avoid disinformation, noise words (`Data`, `Info`, `Manager`), and Hungarian notation. Class names are nouns, methods are verbs. One word per concept. Pick a domain or solution vocabulary and stick to it.

### Ch 3 — Functions
**Small** (under 20 lines, ideally under 10). Do **one thing** at one level of abstraction. Few arguments (0–3, ideally 0). No flag arguments. No side effects. Command-Query Separation. Prefer exceptions to return codes. DRY. Stepdown rule: read top-down.

### Ch 4 — Comments
Comments are a failure to express intent in code. Good: legal headers, intent explanations, warning of consequences, TODOs. Bad: redundant, mandated, journal-style, noise, commented-out code, attribution. *Don't* comment bad code — rewrite it.

### Ch 5 — Formatting
Vertical density and openness; related concepts close. Files ~200 lines, max ~500. Newspaper metaphor: high-level at top. Horizontal alignment is noise; respect 80–120 col width. Team rules win over personal preference.

### Ch 6 — Objects and Data Structures
Law of Demeter: "talk to friends, not strangers." Distinguish objects (hide data, expose behavior) from data structures (expose data, no behavior). Hybrid structures are the worst of both worlds. Train wrecks (`a.b().c().d()`) signal violations.

### Ch 7 — Error Handling
Use exceptions, not return codes. Write try-catch-finally first. Use unchecked exceptions. Wrap third-party APIs to control your boundary. Don't return null; don't pass null. The Special Case pattern beats null-checks.

### Ch 8 — Boundaries
Wrapping third-party code is how you keep it from leaking. Learning tests document third-party behavior and catch upgrade regressions. Define your own interface; let the boundary code adapt.

### Ch 9 — Unit Tests
**Three Laws of TDD**: don't write production code without a failing test; don't write more test than enough to fail; don't write more production code than enough to pass. Tests need clean code too. F.I.R.S.T.: Fast, Independent, Repeatable, Self-Validating, Timely. One assert (or one concept) per test.

### Ch 10 — Classes
Small (measured by responsibilities, not lines). Single Responsibility Principle. Cohesion: methods that share instance variables. High cohesion → many small classes. Open-Closed Principle: extend without modifying. Isolate from change via abstractions.

### Ch 11 — Systems
Separate construction (main) from use. Dependency Injection. Cross-cutting concerns via AOP. Architectures should let major decisions be deferred. Test-drive system architecture by keeping things modular and decision-light.

### Ch 12 — Emergence
Kent Beck's four rules of simple design, in priority: (1) runs all tests, (2) no duplication, (3) expresses programmer intent, (4) minimal classes/methods.

### Ch 13 — Concurrency
Concurrency is decoupling, not speedup. Single Responsibility for concurrency. Limit shared data scope. Use copies. Threads should be independent. Know your library (Executors, locks). Know execution models (producer-consumer, readers-writers, dining philosophers).

### Ch 14 — Successive Refinement
Long worked example (command-line argument parser). Watch a working-but-ugly module become clean through dozens of tiny refactorings.

### Ch 15 — JUnit Internals
Worked refactoring of JUnit's `ComparisonCompactor` — names, boolean expressions, structure. Real code from a respected codebase improved.

### Ch 16 — Refactoring SerialDate
Worked refactoring of JCommon's `SerialDate`. Tests pinned behavior; refactorings cleaned naming, structure, and bugs surfaced through reading.

### Ch 17 — Smells and Heuristics
Distilled catalog: Comments smells (C1–C5), Environment (E1–E2), Functions (F1–F4), General (G1–G36), Java (J1–J3), Names (N1–N7), Tests (T1–T9). The chapter that matters most for code review.

## Critiques worth knowing
Some advice is dogmatic ("functions should never have side effects"). The "small classes/methods" rule can fragment logic when applied without judgment. Pair with **APOSD** (Ousterhout), which argues *deep* modules over many small ones.
