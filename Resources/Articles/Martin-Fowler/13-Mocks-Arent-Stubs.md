---
title: Mocks Aren't Stubs
author: Martin Fowler
url: https://martinfowler.com/articles/mocksArentStubs.html
year: 2004 (revised 2007, 2017)
category: Article — Martin Fowler
focus: Test double taxonomy, Classical vs. Mockist TDD, state vs. behavior verification
---

# Mocks Aren't Stubs — Martin Fowler (2004/2017)

The article that established the vocabulary for test doubles across the entire industry. "Mock" is not a generic synonym for any fake object — it is a *specific* type with distinct semantics. Fowler also names and analyzes the Classical vs. Mockist TDD split, which every subsequent testing book builds on.

## The Five Test Double Types (Meszaros Taxonomy)

| Type | What It Does | Verifies Calls? |
|------|-------------|-----------------|
| **Dummy** | Passed around but never used; fills parameter lists | No |
| **Fake** | Working implementation, unsuitable for production (e.g., in-memory DB) | No |
| **Stub** | Returns canned answers to calls; only responds to what's programmed | No |
| **Spy** | A stub that also records how it was called, for later assertion | Optional |
| **Mock** | Pre-programmed with expectations; verifies behavior during/after the test | **Yes — only mocks do this** |

Critical distinction: **Only mocks insist on behavior verification.** All other doubles use state verification.

## State vs. Behavior Verification

**State Verification:** After the SUT runs, examine the state of the SUT and collaborators to determine correctness. The test makes assertions on objects' properties or return values.

**Behavior Verification:** Instead of examining state, verify that the SUT made correct calls to collaborators with the expected arguments. Mocks are the mechanism; they fail if expected calls were not made.

## Classical vs. Mockist TDD

**Classical TDD:** Uses real objects wherever possible. Introduces a test double only when a collaborator is awkward to use (non-deterministic, slow, not yet implemented, expensive setup). Verification is primarily through state.

**Mockist TDD:** Always mocks any object with "interesting behavior." Enables outside-in / need-driven development — design collaborator interfaces by writing mock expectations *before* implementing the real object.

| Aspect | Classical | Mockist |
|--------|-----------|---------|
| Fixture setup complexity | Higher — real object graphs needed | Low — only SUT + immediate mocks |
| Test isolation from neighboring failures | Low — bugs ripple | High — failures isolated to broken unit |
| Coupling to implementation | Low — tests verify outcomes | High — tests coupled to method calls and signatures |
| Refactoring safety | High | Low |
| Design influence | Domain-model-first | Tell Don't Ask; role interfaces |

**Object Mother:** Classical TDD's response to complex setup — a fixture-generation class that creates complex test object graphs.

**Tell Don't Ask:** Core mockist preference — tell objects to do things rather than asking for data. Mockist tests enforce this by making getters fail mock expectations.

**Train Wreck / Law of Demeter violation:** `customer.getOrder().getItem().getPrice()`. Mockist testing discourages these by making them hard to mock.

## Design Influence

Mockist testing naturally encourages:
- **Role interfaces** — an interface represents a role, not a type; discovered through writing mock expectations
- **Collecting parameters** — instead of returning values, pass a collector object
- **Avoiding method chains** — long chains expose implementation structure

Classical testing tends toward domain-model-centric design, building the UI on top of a proven domain model.

## Fowler's Position

Self-identified Classical TDDer. Primary concern with mockism: cognitive overhead of thinking about implementation details while writing tests. Acknowledges mockism is worth exploring if: (a) test failures are hard to diagnose, or (b) objects lack behavioral richness.

**BDD (Behavior-Driven Development):** Named here as an offshoot of mockist testing that renames tests as "behaviors," emphasizing design-first thinking.

## Why It's Canonical

This article made the Meszaros five-type taxonomy widely accessible. Every subsequent discussion of test doubles — Osherove, GOOS, Khorikov — either references or implicitly builds on this vocabulary. Reading it once eliminates the most common source of confusion in testing conversations.
