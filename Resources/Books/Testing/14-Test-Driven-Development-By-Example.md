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
Start with a concrete failing test (`5 USD * 2 = 10 USD`). Make a list of tests to write.

### Ch 2 — Degenerate Objects
Write the simplest implementation that could pass — even if it's a constant.

### Ch 3 — Equality for All
`equals()` and `hashCode()` driven by tests for behavior, not framework expectations.

### Ch 4 — Privacy
Encapsulation comes from tests pressing against the API.

### Ch 5 — Franc-ly Speaking
Add `Franc`. Notice duplication.

### Ch 6 — Equality for All, Redux
Refactor `equals()` to share via inheritance.

### Ch 7 — Apples and Oranges
Tests forbid `Franc.equals(Dollar)`. Code reflects test intent.

### Ch 8 — Makin' Objects
Replace constructors with factory methods.

### Ch 9 — Times We're Livin' In
Generalize `times()` operation.

### Ch 10 — Interesting Times
Generalize across both currencies.

### Ch 11 — The Root of All Evil
Inheritance is overused. Replace with composition.

### Ch 12 — Addition, Finally
`Money.plus(Money)`. Discover the *expression* abstraction.

### Ch 13 — Make It
Implement `Sum` as an `Expression`.

### Ch 14 — Change
Reduce expressions in a context (`Bank`).

### Ch 15 — Mixed Currencies
Currency conversion via `Bank.reduce()`.

### Ch 16 — Abstraction, Finally
Dollar/Franc collapse into one Money class.

### Ch 17 — The Money Example, Retrospective
What was learned about design from following the tests.

## Part II — The xUnit Example (Python)

Build a test framework with itself. The "self-bootstrapping" demo of TDD's power.

### Ch 18–24
Write `TestCase`. Make `setUp()`, `tearDown()`, test discovery, suites — each driven by tests.

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
