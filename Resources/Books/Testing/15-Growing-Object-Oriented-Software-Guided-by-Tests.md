---
title: Growing Object-Oriented Software, Guided by Tests (GOOS)
authors: Steve Freeman, Nat Pryce
year: 2009
category: Testing
focus: Outside-in TDD, mock roles not objects
---

# Growing Object-Oriented Software, Guided by Tests — Freeman & Pryce (2009)

The "London-school" TDD book. Where Beck shows TDD bottom-up, GOOS shows it **outside-in** with **mocks of roles**, not just isolation. Authors are also the creators of jMock.

## Per-part / per-chapter summary

### Part I — Introduction

**Ch 1 — What Is the Point of Test-Driven Development?**
TDD as a feedback engine that drives design. Tests fail → design feedback. Slow tests → coupling feedback. Hard-to-test → SRP feedback.

**Ch 2 — Test-Driven Development with Objects**
Introduces "mock objects to discover roles." Mocks aren't a testing trick — they're a *design* tool that surfaces collaborators.

**Ch 3 — An Introduction to the Tools**
JUnit, jMock, Hamcrest matchers, build setup.

### Part II — The Process of Test-Driven Development

**Ch 4 — Kick-Starting the Test-Driven Cycle**
Start with a **walking skeleton**: a thin end-to-end deployable slice that passes one acceptance test. From day 0, you have automated build + deploy + acceptance test.

**Ch 5 — Maintaining the Test-Driven Cycle**
Outer loop: failing acceptance test. Inner loop: red-green-refactor unit tests. Each unit test reveals new collaborators (roles), expressed as mocked interfaces.

**Ch 6 — Object-Oriented Style**
Tell-don't-ask. Composite simpler than the sum of its parts. Context-independent objects. No global state.

**Ch 7 — Achieving Object-Oriented Design**
Listen to the tests. Painful tests = painful design. The book's organizing thesis.

### Part III — A Worked Example (Auction Sniper)

A fully working chat-bot-driven auction-bidding agent, built outside-in across ~10 chapters. Each chapter follows the cycle:

**Ch 8 — The Auction Sniper Project**
Frame the problem. Acceptance criteria.

**Ch 9 — The Walking Skeleton**
End-to-end test that proves everything is hooked up — even with stub logic.

**Ch 10 — Sniping for One Item**
First feature; introduces XMPP collaborator and `Auction` role.

**Ch 11 — The Sniper Makes a Bid**
Discover `SniperListener` role through tests pressing on what to mock.

**Ch 12 — The Sniper Wins the Auction**
State machine emerges from failing tests.

**Ch 13 — Displaying Price Details**
UI roles emerge as a result of test pressure.

**Ch 14 — Refactoring the Auction Sniper**
The mid-build cleanup; testable design appears.

**Ch 15 — Sniping for Multiple Items**
Generalization. Existing tests catch regressions.

**Ch 16 — Towards a Real User Interface**
GUI-test driven Swing UI.

**Ch 17 — Handling Failure**
Disconnect, lost messages, error states. Tests for the unhappy path.

### Part IV — Sustainable Test-Driven Development

**Ch 18 — Listening to the Tests**
The most important chapter. Test smells = design smells.
- Setup ceremony → too many collaborators (SRP violation).
- Many mocks → wrong abstraction.
- Mocking concrete classes → coupling.
- Long pre-test setup → hidden temporal coupling.

**Ch 19 — Coverage**
Coverage measures what you ran, not what you assert. Mutation testing for confidence.

**Ch 20 — Managing the Test Suite**
Naming, organization, fast/slow split, build pipelines.

**Ch 21 — Test Readability**
Test as specification: Arrange-Act-Assert, custom matchers, builders.

**Ch 22 — Constructing Complex Test Data**
Object Mother, Builder pattern for tests.

**Ch 23 — Test Diagnostics**
Good failure messages. Custom matchers for context-rich diagnostics.

**Ch 24 — Test Flexibility**
Avoid over-specification. Test behavior, not implementation.

### Part V — Advanced Topics

**Ch 25 — Testing Persistence**
Schema-managed tests, isolation.

**Ch 26 — Unit Testing and Threads**
Isolation strategies for concurrent code.

**Ch 27 — Testing Asynchronous Code**
Polling, timeouts, completion semaphores.

## Core ideas
- **Outside-in**: drive from acceptance test inward, discovering collaborators as roles.
- **Mocks of roles, not objects**: design abstraction first, implementation later.
- **Listen to the tests**: pain in tests is feedback about design, not testing.
- **Walking skeleton**: end-to-end on day 1.

## Why it's deeply integrated into `/quality test-quality`
The "listen to the tests" thesis underpins every test smell the test-quality agent flags.
