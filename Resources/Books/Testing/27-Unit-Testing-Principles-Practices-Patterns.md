---
title: Unit Testing — Principles, Practices, and Patterns
author: Vladimir Khorikov
year: 2020
category: Testing
focus: Classical vs. London school, Four Pillars, test doubles, integration testing
---

# Unit Testing: Principles, Practices, and Patterns — Vladimir Khorikov (2020)

The best intermediate-to-advanced treatment of *what makes a test valuable*. Where Beck and Osherove show you how to write tests, Khorikov derives *why* specific practices work from first principles. All examples are C# but every concept applies universally. Reviewers consistently rank it alongside Refactoring and Clean Code.

## Part 1 — The Bigger Picture

### Ch 1 — The Goal of Unit Testing

Tests exist to enable **sustainable software growth** — the safety net that lets you refactor and add features without fear of regressions. Coverage is a *negative* indicator only: low coverage signals under-testing; high coverage does not signal quality. Mandating 100% coverage creates perverse incentives (assertion-free tests, trivial code tests). A good test suite: runs on every change, targets the most important production code, provides maximum value with minimum maintenance cost.

### Ch 2 — What Is a Unit Test?

The definitional chapter. There is no industry consensus on "unit," so Khorikov maps the space via the two major schools:

| Dimension | Classical School (Detroit/Chicago) | London School (Mockist) |
|---|---|---|
| Unit of isolation | A unit of **behavior** (can span many classes) | A unit of **code** (single class or function) |
| What gets isolated | Tests from each other via shared mutable state | The class under test from all collaborators |
| Test doubles used for | Shared, out-of-process dependencies only | All mutable dependencies, including internal classes |
| Verification style | State-based | Behavior-based (method calls) |
| Failure diagnosis | Failures may ripple through related tests | Failures isolated precisely to the broken class |

Khorikov favors the **Classical school**. His critique of the London school: mocking internal collaborators means tests verify inter-class communication — an implementation detail, not a business requirement. This makes tests brittle under refactoring.

### Ch 3 — The Anatomy of a Unit Test

**AAA structure:** Arrange (set up SUT and dependencies) → Act (call exactly one method) → Assert (verify observable outcomes). Tests should be named after the **business behavior**, not the implementation method: `Delivery_with_past_date_is_invalid` not `Test_Delivery_IsValid_ReturnsFalse`. Parameterized tests are appropriate for edge cases of the same behavior — not as a substitute for clear naming.

---

## Part 2 — Making Your Tests Work For You

### Ch 4 — The Four Pillars of a Good Unit Test ⭐

The conceptual core of the book. Every test scores 0–1 on each pillar. Value = product of all four. **A zero on any single pillar kills the test's value entirely.**

**Pillar 1 — Protection Against Regressions**
How effectively does the test catch bugs? Measured by: amount of code exercised × code complexity × domain significance. Tests of trivial getters score near zero.

**Pillar 2 — Resistance to Refactoring**
Does the test fail when code is refactored without changing observable behavior? **The most critical pillar.** False positives (tests that fail on valid refactoring) erode developer trust and eventually get ignored. Tests that check implementation details (internal method calls, private state) fail here. Tests that verify observable behavior (return values, state of out-of-process dependencies) pass.

**Pillar 3 — Fast Feedback**
Unit tests must run in milliseconds. Slow tests discourage frequent execution.

**Pillar 4 — Maintainability**
Two components: (a) readability — how easy to understand the test? and (b) execution cost — does the test require standing up external systems?

**The inherent tension:** Pillars 1–3 conflict at their extremes. The resolution: mock only **unmanaged external dependencies**, never internal collaborators.

**Test type mapping:**
- End-to-end: High on Pillars 1 and 2, low on 3 and 4
- Unit tests: Optimal balance across all four
- London-school over-mocking: High on 3 and 4, catastrophically low on Pillar 2

### Ch 5 — Mocks and Test Fragility

**Stubs vs. mocks (Khorikov's formulation):**
- **Stubs:** Simulate incoming interactions (return canned data). Do not assert on stubs — doing so is over-specification.
- **Mocks:** Verify outgoing interactions (calls to external systems). Only mock observable side effects to *unmanaged* dependencies.

**Observable behavior vs. implementation details:**
Observable behavior = directly tied to a client goal + produces an externally visible side effect in an out-of-process dependency. Whether a controller sends an email is observable behavior. Which internal domain methods it calls to make that decision is an implementation detail.

**Hexagonal architecture insight:** Mocks are appropriate only at the outer hexagon boundary (your system ↔ unmanaged external systems). Mocking within the inner hexagon (between your own classes) is the source of test fragility.

### Ch 6 — Styles of Unit Testing

Three styles, ranked best to worst:

1. **Output-Based Testing (Functional Style):** Call a pure function, compare the return value. No side effects. Scores highest on all four pillars. Requires a functional architecture.

2. **State-Based Testing:** Mutate an object, verify its final state. Common in OOP. Risk of over-specification if you verify internal rather than observable state.

3. **Communication-Based Testing:** Verify that the SUT called mocks with specific arguments. Use only for externally observable communications with unmanaged dependencies (e.g., "was an email sent to the third-party SMTP?"). Scores lowest when overused.

**Functional Core / Mutable Shell pattern:**
- **Functional Core:** Pure functions, immutable arguments, returns decisions, no external calls — test with output-based tests.
- **Mutable Shell:** Acts on the Core's decisions, manages all I/O and state mutation — test with integration tests.

**DDD layer alignment:**
- Domain Layer → output-based unit tests
- Application Service Layer → integration tests
- Infrastructure Layer → mock only unmanaged dependencies

### Ch 7 — Refactoring Toward Valuable Unit Tests

**Code classification (two axes):**

| | Few Collaborators | Many Collaborators |
|---|---|---|
| **High Complexity** | Domain models → unit test | Overcomplicated code → refactor |
| **Low Complexity** | Trivial code → skip | Controllers → integration test |

**Humble Object Pattern:** Split difficult-to-test code by separating orchestration logic from testable business logic. Move hard-to-test dependencies to a "humble" wrapper.

**Domain Events:** Register business-significant actions in the domain; controllers dispatch them to external handlers. Keeps domain logic pure and testable.

---

## Part 3 — Integration Testing

### Ch 8 — Why Integration Testing?

**Integration test definition:** Any test involving at least one out-of-process dependency. Higher on Pillars 1 and 2 than unit tests, lower on 3 and 4.

**Dependency typology:**
- **Managed Dependencies:** Out-of-process dependencies your application owns exclusively (your private database). Test against real instances — **do not mock**. Verify final state.
- **Unmanaged Dependencies:** Out-of-process dependencies shared with external consumers (message buses, third-party APIs, SMTP). Must be mocked — external consumers depend on specific interaction contracts.

**Integration test strategy:** Two tests per business scenario: (1) happy-path exercising all real collaborators, and (2) one or two edge-case tests for failure paths not coverable at unit level.

### Ch 9 — Mocking Best Practices

- Mock only **unmanaged** dependencies, never managed ones
- Mocks appear in integration tests only, never in unit tests
- **Mock the types you own** — create an anti-corruption layer over third-party interfaces
- Test at the edge — assert against the most external observable point, exercising all intermediate layers
- Prefer **handwritten spies** over framework mocks for readability and avoiding over-specification

### Ch 10 — Testing the Database

Use a real database (Docker). Preferred isolation strategy: **cleanup between tests** — delete data added during each test afterward. Avoids limitations of:
- Transaction rollback (not universally supported, hides rollback bugs)
- In-memory databases (diverge from production semantics)
- Per-test DB recreation (too slow)

Each test creates its own data. Shared baseline data creates test coupling.

---

## Part 4 — Unit Testing Anti-patterns

### Ch 11 — Unit Testing Anti-patterns

1. **Testing Private Methods:** Private methods don't need direct testing. If a private method is complex enough to warrant a test, it signals a design problem — extract it to a new class.

2. **Exposing Private State:** Adding public getters/setters solely to enable assertions. Tests should only verify observable behavior, not internal state.

3. **Leaking Domain Knowledge to Tests:** Replicating business logic in test expectations (e.g., computing expected values using the same algorithm as production). Use hardcoded expected values.

4. **Code Pollution:** Adding `if (isTesting) { ... }` branches to production code.

5. **Mocking Concrete Classes:** Mocking a class you own couples tests to implementation. If you need a test double, create an interface expressing the role.

6. **Working With Time:** Never call the system clock directly. Three injection patterns: (a) Argument Injection — preferred for domain methods (pass as parameter), (b) Injected Service — via DI, (c) Ambient Context — global function, last resort.

---

## Core ideas

- **The fundamental goal** is sustainable software growth, not test count or coverage percentage.
- **Classical > London school** because mocking internals couples tests to implementation details, destroying Pillar 2.
- **Output-based testing** is the gold standard — push logic into pure functions.
- **Mock only unmanaged external dependencies** — never internal collaborators, never managed dependencies.
- **Integration tests use real managed dependencies** (real database, real queues you own).

## Why it belongs alongside the existing canon

Beck (TDD by Example) teaches the *discipline*. Freeman & Pryce (GOOS) teach the *outside-in design approach*. Osherove (Art of Unit Testing) teaches *maintainability*. Khorikov answers the foundational question all three skip: *what makes a test valuable and how do you measure it?* The Four Pillars framework and the Classical/London analysis are the conceptual backbone behind the `/quality test-quality` agent's scoring rubric.
