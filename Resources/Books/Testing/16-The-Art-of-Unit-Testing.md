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

### Ch 1 — The Basics of Unit Testing
A unit test exercises a small unit of code in memory, runs quickly and repeatably, and has one clear reason to fail. These properties distinguish unit tests from tests that integrate with external components. The chapter places unit, integration, and acceptance or end-to-end tests into three separate categories.

### Ch 2 — A First Unit Test
Write a real Jest test using the arrange-act-assert structure. A clear name explains the behavior and makes a failing result easier to understand. The chapter presents `MethodName_Scenario_ExpectedBehavior` and descriptive sentence form as two useful naming styles.

### Part 2 — Core Techniques

### Ch 3 — Breaking Dependencies with Stubs
Stubs are non-asserting fakes that *return* canned data to the system under test. They break dependencies on external systems such as the filesystem, clock, or network. Slow tests and flaky results are common signs that such a dependency needs to be replaced by a stub.

### Ch 4 — Interaction Testing using Mock Objects
Mocks *assert* that expected interactions occurred. They are useful when making a call is itself the behavior under test, such as logging an event or sending a notification. The classic distinction is that stubs answer questions, while mocks expect calls.

### Ch 5 — Isolation Frameworks
Jest mocks, `jest.fn`, and Sinon are isolation-framework tools for creating and inspecting test doubles. The chapter compares automatic mocking with hand-rolled substitutes. It also explains the framework-dependency trade-off because excessive mocking magic can harm readability.

### Part 3 — The Test Code

### Ch 6 — Unit Testing Asynchronous Code
Promises and `async`/`await` let a test wait for asynchronous work and observe its result. Fake timers provide deterministic control over time-dependent code. The chapter compares polling with signal-based completion so tests finish reliably without arbitrary delays.

### Ch 7 — Trustworthy Tests
A trustworthy test fails when production behavior breaks and passes when that behavior works. It has one good reason to fail, and its name makes the failure comprehensible. It is also deterministic, so the same code and conditions always produce the same result. Untrustworthy tests are worse than no tests because they consume attention without providing dependable evidence.

### Ch 8 — Maintainable Tests
The major anti-patterns include over-specification, brittle assertions, magic strings, duplicated setup, and tests that read like Rube Goldberg machines. These problems raise the cost of changing production behavior and diagnosing failures. Refactor tests with the same care given to production code.

### Ch 9 — Readable Tests
Readable tests communicate the scenario, action, and expected result at a glance. Good names, factory methods, builders, and focused helpers remove irrelevant setup details. A visible AAA structure and an absence of test logic keep the example straightforward.

### Part 4 — Design and Process

### Ch 10 — Test-Driven Development
The chapter explains the red-green-refactor rhythm of test-driven development. It discusses situations where TDD helps and cases where the technique may not fit. It also examines why development teams adopt the practice and why they sometimes abandon it.

### Ch 11 — Working with Existing Code
Characterization tests record how existing code currently behaves, including behavior that may not be documented. Finding seams identifies places where dependencies can be controlled without a broad rewrite. Add a focused test before changing legacy code so the existing behavior is protected.

### Ch 12 — Working in a Team
Teams need shared standards for naming, structure, and acceptable test quality. Test code belongs in code review and remains the development team's responsibility. Treating "the QA writes the tests" as the default is an antipattern because it separates implementation from fast technical feedback.

### Ch 13 — Working with Different Test Types
The test pyramid recommends many unit tests, fewer integration tests, and the fewest end-to-end tests. Each level trades execution speed and isolation for broader confidence. The chapter also presents the testing trophy as an alternative emphasis for frontend-heavy codebases.

### Ch 14 — Other Resources / Where to Go Next
The closing chapter points readers toward deeper material after they learn the book's core techniques. Recommended resources include *xUnit Test Patterns* and *Growing Object-Oriented Software, Guided by Tests*. These references extend the discussion into test smells, pattern catalogs, and outside-in design.

## Why it pairs well with GOOS
GOOS is opinionated about *style* (London-school, outside-in). Osherove is opinionated about *maintainability* in the long term. Reading both gives you both halves of test design.

## Why it's deeply integrated into `/mithril test-quality`
The "trustworthy + maintainable + readable" trio is the test-quality agent's primary scoring rubric.
