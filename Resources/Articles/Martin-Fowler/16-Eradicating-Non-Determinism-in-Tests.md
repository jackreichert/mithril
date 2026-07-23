---
title: Eradicating Non-Determinism in Tests
author: Martin Fowler
url: https://martinfowler.com/articles/nonDeterminism.html
year: 2011
category: Article — Martin Fowler
focus: Flaky tests, root causes, quarantine strategy, determinism as a hard requirement
---

# Eradicating Non-Determinism in Tests — Martin Fowler (2011)

A non-deterministic test — one that "passes sometimes and fails sometimes, without any noticeable change in the code, tests, or environment" — is **worse than no test**. This article is the definitive treatment of why flakiness must be eliminated aggressively, and how to do it.

## Why Non-Determinism Is Dangerous

Two failure modes:
1. The test becomes useless as a regression detector — developers cannot distinguish real failures from flakiness.
2. Non-determinism is *infectious* — once a team starts ignoring flaky tests, that discipline erodes across the entire suite.

## The Quarantine Strategy

Before fixing, move non-deterministic tests to a separate **quarantine suite**. This protects the main deployment pipeline while allowing focused remediation.

Critical constraint: enforce a **hard limit** on quarantine — either a maximum count (e.g., no more than 8 quarantined tests at once) or a time limit (e.g., no test quarantined for more than 1 week). Without a constraint, quarantine becomes a graveyard.

## Five Root Causes and Their Fixes

### 1 — Lack of Isolation
Tests must not share mutable state. One test's data must not affect another's execution.

Two remediation approaches:
- **Rebuild from scratch** (preferred) — cleaner, easier to debug
- **Proper cleanup after each test** — delete data the test added

Specific tactics: transaction rollback after each test, database file copying for speed, eliminating global/static data contamination.

### 2 — Asynchronous Behavior
Rule: **"Never use bare sleeps to wait for asynchronous responses: use a callback or polling."**

Two proper approaches:
- **Callbacks** — ideal; the async service notifies the test when complete
- **Polling with timeout** — repeatedly check at short intervals with a configurable maximum wait

All timing values must be constants or environment variables, **never hardcoded literals**.

### 3 — Remote Services
Integration with external systems introduces availability and latency instability. Solution: test doubles mimicking remote behavior. Use **Contract Tests** to verify doubles accurately reflect real system behavior.

### 4 — Time Dependencies
Direct system clock calls create non-determinism. Fix: **always wrap the system clock** so it can be substituted for testing. Clock stubs freeze time at predetermined values. Consider detecting direct clock calls via static analysis to enforce this discipline.

### 5 — Resource Leaks
When applications fail to release database connections, file handles, or memory, random tests fail depending on when exhaustion occurs. Fix: configure resource pools with **size-1 constraints during testing**. This forces immediate failure when any test leaks a resource, making the leaking test immediately identifiable.

## Key Principles

- Isolation enables flexible test execution and parallelization
- Determinism is non-negotiable for regression suite reliability
- Early detection + quarantine prevents systemic corruption
- Flaky tests are an **active liability**, not a minor inconvenience

## Connection to Other Resources

- Vocke's *Practical Test Pyramid* identifies remote service interaction as a key source of flakiness → narrow integration tests and Wiremock are the structural fix
- Khorikov's *Unit Testing* identifies time injection patterns as the fix for clock-dependent non-determinism
- Fowler's *UnitTest* bliki identifies fast suite execution as a forcing function that exposes flakiness early
