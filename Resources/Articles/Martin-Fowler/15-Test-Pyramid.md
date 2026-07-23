---
title: Test Pyramid (+ Practical Test Pyramid)
authors: Martin Fowler (bliki); Ham Vocke (detailed guide, martinfowler.com)
urls:
  - https://martinfowler.com/bliki/TestPyramid.html
  - https://martinfowler.com/articles/practical-test-pyramid.html
year: 2012 (Fowler bliki); 2018 (Vocke article)
category: Article — Martin Fowler
focus: Test distribution strategy, pyramid vs. anti-patterns, practical implementation
---

# Test Pyramid — Fowler (2012) + Practical Test Pyramid — Vocke (2018)

The test pyramid is the foundational model for distributing automated tests across granularity levels. Mike Cohn originated the concept (Succeeding with Agile, 2009); Fowler's bliki post spread it. Ham Vocke's longer article on martinfowler.com provides the practical implementation companion.

---

## Fowler — Test Pyramid (bliki)

### The Three Tiers

1. **Unit Tests (base, largest layer):** Low-level, focused, fast, cheap to write and maintain.
2. **Subcutaneous Tests (middle layer):** Service-level tests that bypass the UI but test business logic end-to-end. Named "subcutaneous" — just beneath the skin of the UI.
3. **End-to-End / GUI Tests (top, smallest layer):** Full-stack tests through the graphical interface. Highest confidence, highest cost.

### Problems With UI-Based Testing

Slow build times, software licensing constraints, inability to run headless, high brittleness (system changes break many tests), non-determinism vulnerability, and the record-playback trap (recorded UI tests resist change).

### Named Anti-Pattern: The Ice-Cream Cone

The inverted pyramid — most tests at the UI/E2E level, few unit tests. Expensive, brittle, slow, and poor regression coverage.

### Key Rules

1. Maintain significantly more unit tests than broad-stack tests.
2. When a high-level test fails: first reproduce the failure in a unit test, then fix the code.
3. High-level tests are a **second line of defense**, not the primary safety net.
4. End-to-end, UI-based, and customer-facing tests are three orthogonal dimensions — not synonymous.

### Important Caveat

The pyramid assumes end-to-end tests are expensive and brittle. If you have fast, reliable, cheap high-level tests, the distribution can shift. The shape is not a law.

---

## Vocke — Practical Test Pyramid (detailed guide)

### Layer-by-Layer Breakdown

**Unit Tests**

**Sociable vs. Solitary distinction** (Vocke uses both pragmatically):
- **Solitary:** Replace all collaborators with doubles
- **Sociable:** Allow real collaborators unless they are slow or have major side effects

What to test: **Public interfaces only.** Observable behavior ("if I enter x and y, will the result be z?"). Not private methods, not trivial code (getters/setters with no conditional logic), not third-party library internals.

**DAMP over DRY for tests:** Some duplication in tests is acceptable and improves clarity. Test code deserves the same care as production code but has different readability priorities.

**Integration Tests**

*Narrow integration tests* (Vocke's preference): Test one integration point at a time; replace all other services with doubles.

What to test with integration tests: all serialization/deserialization boundaries, REST API calls, database CRUD, third-party API calls, queue operations, filesystem operations.

**Wiremock:** Creates a fake HTTP server within the test process. Define canned responses via DSL. Limitation: no guarantee the fake matches the real API behavior — use Contract Tests to address this.

**Contract Tests**

**Consumer-Driven Contracts (CDC):** The consuming team writes tests expressing what they need from a provider's interface. The provider runs these tests continuously. Prevents breaking changes without heavyweight coordination.

**Pact Framework:** Specific tool for CDC. Consumer tests generate "pact files" (JSON). Provider runs pact files against their implementation. Supports JVM, Ruby, .NET, JavaScript.

**UI Tests**

Three UI testing concerns:
1. **Behavior** — automated with Selenium/Playwright
2. **Layout** — screenshot comparison tools (Galen, jlineup)
3. **Usability/Aesthetics** — manual exploratory testing only

For REST API services: use REST-assured (or similar) to fire HTTP requests against the running system instead of GUI tests. Broad coverage without GUI brittleness.

### Key Rules (Vocke)

1. **Rule 1:** If a higher-level test fails without a corresponding lower-level test failing, write a lower-level test.
2. **Rule 2:** Push tests as far down the pyramid as possible. Don't duplicate coverage at higher levels.
3. Test one condition per test.

### Terminology Note

Both Fowler and Vocke explicitly acknowledge that "unit test," "integration test," "functional test," "acceptance test," "end-to-end test" mean different things to different teams. **Local consensus within a team matters more than industry standardization.** Google's "test sizes" approach (from Simon Stewart) — Small, Medium, Large — is cited as an alternative classification that sidesteps the naming wars.

---

## Summary: The Core Insight

Write many small, fast, cheap tests. Write fewer large, slow, expensive tests. Use each layer to catch what the layer below cannot catch. Never rely primarily on the layer above when you can catch the failure below.
