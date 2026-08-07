---
title: Test-Driven Development: By Example
author: Kent Beck
year: 2002
category: Testing
focus: TDD mechanics, baby steps, red-green-refactor
---

# Test-Driven Development: By Example — Kent Beck (2002)

The book that codified TDD. Two long worked examples surrounded by a pattern language. Beck shows TDD by *doing it*, not by lecturing about it.

## Part I — The Money Example (Java)

A multi-currency money implementation built test-first. Each chapter is one small step.

### Ch 1 — Multi-Currency Money
Start with a concrete failing test: `5 USD * 2 = 10 USD`. The test turns a broad multi-currency requirement into one small, observable behavior. Beck also begins a list of tests to write so that new ideas are captured without interrupting the current step.

### Ch 2 — Degenerate Objects
Write the simplest implementation that could pass, even if it returns a constant. This deliberately incomplete solution gets the test suite back to green with minimal speculation. Later tests will force the implementation to become more general.

### Ch 3 — Equality for All
Tests drive the implementation of `equals()` and `hashCode()` through observable behavior rather than framework expectations. Two money values with the same amount should compare as equal. The example shows how a small test can introduce a necessary value-object contract.

### Ch 4 — Privacy
Tests press against the public API and reveal which implementation details can become private. Once multiplication behaves correctly, the test no longer needs direct access to the amount field. Encapsulation therefore emerges from demonstrated behavior instead of being imposed in advance.

### Ch 5 — Franc-ly Speaking
Add a `Franc` type to represent a second currency. Its implementation initially resembles `Dollar`, making duplication visible. That duplication becomes evidence for a later refactoring rather than a reason to design a hierarchy prematurely.

### Ch 6 — Equality for All, Redux
Refactor `equals()` so that `Dollar` and `Franc` share the behavior through inheritance. The existing tests protect equality while the structure changes. This step demonstrates that refactoring follows a green test suite.

### Ch 7 — Apples and Oranges
Add a test showing that a `Franc` must not equal a `Dollar`, even when their amounts match. The production code is then changed to reflect that distinction. The test clarifies that currency type is part of the value's identity at this stage of the design.

### Ch 8 — Makin' Objects
Replace direct constructors with factory methods such as `Money.dollar()` and `Money.franc()`. The factories hide the concrete classes from callers. This prepares the design for consolidating those classes without rewriting every test.

### Ch 9 — Times We're Livin' In
Generalize the `times()` operation behind the shared `Money` abstraction. Tests continue to describe multiplication in terms of currency values rather than concrete subclasses. The change moves duplicated behavior toward a common interface while preserving results.

### Ch 10 — Interesting Times
Apply the generalized multiplication behavior to both dollars and francs. Tests verify that each currency preserves its identity after multiplication. The remaining duplication becomes small enough to remove safely.

### Ch 11 — The Root of All Evil
The growing hierarchy shows that inheritance has been overused. Replace subclass-based currency distinctions with a currency field inside one `Money` representation. Composition removes duplicated classes while the tests preserve their externally visible behavior.

### Ch 12 — Addition, Finally
Introduce `Money.plus(Money)` through a failing addition test. The result cannot always be represented as a single money value, especially once currencies differ. This pressure reveals an *expression* abstraction that can represent unreduced arithmetic.

### Ch 13 — Make It
Implement `Sum` as an `Expression` containing an augend and an addend. The object records the addition without deciding immediately how to reduce it. Tests guide this new representation one observable property at a time.

### Ch 14 — Change
Introduce `Bank` as the context that reduces an expression to a requested currency. Reduction separates arithmetic structure from currency-specific interpretation. Tests show that a sum can now become a concrete `Money` value through the bank.

### Ch 15 — Mixed Currencies
Extend `Bank.reduce()` to handle expressions containing different currencies. Exchange rates provide the information needed to convert before combining values. Tests make mixed-currency addition concrete without embedding conversion rules in `Money` itself.

### Ch 16 — Abstraction, Finally
Collapse the separate `Dollar` and `Franc` implementations into one `Money` class. A currency attribute now carries the distinction that subclasses previously represented. The accumulated tests make this consolidation safe and confirm that the public behavior remains intact.

### Ch 17 — The Money Example, Retrospective
Review what the money example revealed about design emerging from tests. Small red-green-refactor steps exposed abstractions only when concrete behavior required them. The retrospective also makes the sequence of temporary duplication, generalization, and cleanup explicit.

## Part II — The xUnit Example (Python)

Build a test framework with itself. The "self-bootstrapping" demo of TDD's power.

### Ch 18 — First Steps to xUnit
Begin a minimal xUnit framework by creating `TestCase` and proving that it invokes a named test method. The emerging framework is used to test itself, making the example self-bootstrapping. This first step establishes the smallest behavior needed before richer test lifecycle features can be added.

### Ch 19 — Set the Table
Add `setUp()` so a test can prepare its fixture before the test method runs. Tests record the order of calls to prove that setup happens first. Centralizing preparation removes repeated fixture code from individual tests.

### Ch 20 — Cleaning Up After
Add `tearDown()` so a test can release resources after the test method runs. Tests verify the complete lifecycle from setup through execution to cleanup. The hook gives every test a consistent place for restoring its environment.

### Ch 21 — Counting
Introduce a result object that records how many tests have run. `TestCase.run()` reports execution through this object instead of leaving progress implicit. The result abstraction prepares the framework to summarize more than one test.

### Ch 22 — Dealing with Failure
Extend the result object to record test failures as well as successful runs. A failing test should be reported without terminating the entire suite. Tests define how exceptions become failure information that callers can inspect.

### Ch 23 — How Suite It Is
Create a test suite that groups multiple test cases. The suite runs each case into one shared result, accumulating the run and failure counts. This composite structure lets the framework handle collections without changing how individual tests behave.

### Ch 24 — xUnit Retrospective
Review the test framework that emerged from successive red-green-refactor steps. It now supports `TestCase`, `setUp()`, `tearDown()`, result recording, and suites without having been designed all at once. The retrospective shows that TDD can grow testing infrastructure through the same feedback process used for application code.

## Part III — Patterns for Test-Driven Development

A pattern language for the *mechanics* of TDD.

### Red Bar Patterns
- **Test List**: write down the tests you want to write before starting.
- **Test First**: write the test before the production code.
- **Assert First**: write the assertion before the rest of the test.
- **Test Data**: use data that makes the test obvious.
- **Evident Data**: use literal expected/actual values.
- **One-Step Test**: pick the simplest next step that teaches you something.
- **Starter Test**: pick the simplest possible first test.
- **Explanation Test**: write tests to *learn* unfamiliar code.
- **Learning Test**: tests for libraries you depend on.
- **Another Test**: when sidetracked, add a test to the list and continue.
- **Regression Test**: write a test the moment a defect is reported.

### Green Bar Patterns
- **Fake It (Till You Make It)**: return a constant; replace with logic later.
- **Triangulate**: only generalize when two tests force it.
- **Obvious Implementation**: when you know the answer, just write it.
- **One to Many**: handle a single first, then generalize.

### Refactoring Patterns
Reconcile differences, isolate change, migrate data, extract method, etc.

### Mastering TDD
Slowing down when stuck. Coverage. When *not* to use TDD. Reusing tests in different contexts. The "putting it all together" review.

## The fundamental discipline
1. Red — failing test.
2. Green — make it pass, fastest possible.
3. Refactor — remove duplication, improve names.

## Why it endures
Beck wrote this book by *doing* TDD on the page; you watch the discipline create design pressure. The cognitive shift is hard to describe and easy to feel through the example.
