---
title: The Art of Unit Testing (3rd ed.)
author: Roy Osherove
year: 2023
category: Testing
focus: Isolation, stubs, mocks, maintainable tests
---

# The Art of Unit Testing (3rd ed.) — Roy Osherove (2023)

A practical guide focused on **what makes tests maintainable** in a long-running codebase. The 3rd edition switches to JavaScript/TypeScript with Jest. ~14 chapters.

## Per-chapter summary

### Part 1 — Getting Started

**Ch 1 — The Basics of Unit Testing**
Definition: a test that runs a small unit of code, in memory, fast, repeatable, with a single clear failure reason. Differentiates from integration tests. The three test categories (unit, integration, acceptance/E2E).

**Ch 2 — A First Unit Test**
Write a real test in Jest: arrange-act-assert structure. Why naming matters: `MethodName_Scenario_ExpectedBehavior` (or descriptive sentence form).

### Part 2 — Core Techniques

**Ch 3 — Breaking Dependencies with Stubs**
Stubs are non-asserting fakes that *return* canned data. Used to break dependencies on external systems (filesystem, time, network). Signs you need a stub: slow tests, flaky results.

**Ch 4 — Interaction Testing using Mock Objects**
Mocks *assert* on interactions. Used when the *call* is the behavior under test (e.g., logging, sending notifications). Classic distinction: stubs answer questions; mocks expect calls.

**Ch 5 — Isolation Frameworks**
Jest mocks, Sinon, jest.fn. Auto-mocking vs hand-rolled. The "framework dependency" trade-off — too much magic harms readability.

### Part 3 — The Test Code

**Ch 6 — Unit Testing Asynchronous Code**
Promises, async/await, fake timers, polling vs. signal-based completion.

**Ch 7 — Trustworthy Tests**
A trustworthy test:
- Fails when production breaks.
- Passes when production works.
- Has one good reason to fail.
- Is named so the failure is comprehensible.
- Is deterministic.
Untrustworthy tests = worse than no tests.

**Ch 8 — Maintainable Tests**
The big anti-patterns: over-specification, brittle assertions, magic strings, duplicated setup, tests that read like Rube Goldberg machines. Refactor tests like production code.

**Ch 9 — Readable Tests**
Naming, factory methods, builders, helper methods, AAA visual structure, no logic in tests.

### Part 4 — Design and Process

**Ch 10 — Test-Driven Development**
TDD basics, when it helps, when it doesn't, the rhythm. Why dev teams adopt and abandon TDD.

**Ch 11 — Working with Existing Code**
Characterization tests. Seam-finding. Add a test before you change anything in legacy code.

**Ch 12 — Working in a Team**
Standards, code review of tests, ownership. Why "the QA writes the tests" is an antipattern.

**Ch 13 — Working with Different Test Types**
The pyramid: heavy unit, fewer integration, fewest E2E. The "trophy" alternative for frontend-heavy codebases.

**Ch 14 — Other Resources / Where to Go Next**
Pointers to xUnit Test Patterns, GOOS, etc.

## Why it pairs well with GOOS
GOOS is opinionated about *style* (London-school, outside-in). Osherove is opinionated about *maintainability* in the long term. Reading both gives you both halves of test design.

## Why it's deeply integrated into `/quality test-quality`
The "trustworthy + maintainable + readable" trio is the test-quality agent's primary scoring rubric.
