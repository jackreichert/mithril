---
title: xUnit Test Patterns — Refactoring Test Code
author: Gerard Meszaros
year: 2007
category: Testing
focus: Test smell catalog, pattern library
---

# xUnit Test Patterns — Gerard Meszaros (2007)

The encyclopedia of test smells and test patterns. ~900 pages, structured as: narrative chapters → smell catalog → pattern catalog → mini-patterns. The reference for "why is this test painful?"

## Part I — The Narrative

A series of teaching chapters that introduce vocabulary and motivation:

**Ch 1 — A Brief Tour**
The xUnit framework family (JUnit, NUnit, PyUnit). What "automated developer testing" actually means.

**Ch 2 — Test Smells Overview**
Three categories: Code Smells (in test code), Behavior Smells (in test execution), and Project Smells (in the test suite as a whole).

**Ch 3 — Goals of Test Automation**
Tests as *executable specs*. Tests as *bug filter*. Tests as *change-enablers*. Tests as *documentation*.

**Ch 4 — Philosophy of Test Automation**
**Test-first** vs **test-last** programming. The economics: cost of test maintenance vs. cost of catching a defect later.

**Ch 5 — Principles of Test Automation**
- Write tests first.
- Test concerns separately.
- Communicate intent.
- Keep tests independent.
- Use the front door first.
- Verify one condition per test.
- Minimize untestable code.
- Avoid test code duplication.
- Tests should be self-checking, repeatable, robust, sufficient, fast, maintainable, traceable.

**Ch 6 — Test Automation Strategy**
Per-test-class strategies, fixture sharing, picking patterns to fit your context.

**Ch 7 — XUnit Basics**
Setup, exercise, verify, teardown — the four phases.

**Ch 8 — Transient Fresh Fixtures**
Each test creates and destroys its world.

**Ch 9 — Persistent Fresh Fixtures**
DB-backed test isolation.

**Ch 10 — Result Verification**
State vs. behavior verification. Custom assertions.

**Ch 11 — Using Test Doubles**
Five flavors: dummy, stub, spy, mock, fake. The terminology that everyone now uses.

**Ch 12 — Organizing Our Tests**
Per-class, per-feature, per-fixture organization options.

**Ch 13 — Testing with Databases**
Database sandboxes, transaction rollbacks, schema management.

**Ch 14 — A Roadmap to Effective Test Automation**
How to introduce these patterns to a team without paralyzing it.

## Part II — The Test Smells Catalog ⭐

**Code Smells (in test source)**
- Obscure Test
- Conditional Test Logic
- Hard-to-Test Code
- Test Code Duplication
- Test Logic in Production

**Behavior Smells (at test runtime)**
- Assertion Roulette (which assertion failed?)
- Erratic Test (Flaky)
- Fragile Test (breaks on unrelated changes)
- Frequent Debugging (hard to diagnose)
- Manual Intervention (not automated end-to-end)
- Slow Tests

**Project Smells (suite as a whole)**
- Buggy Tests
- Developers Not Writing Tests
- High Test Maintenance Cost
- Production Bugs (despite tests)

Each smell has: causes, related smells, and *which patterns to apply* to fix it.

## Part III — The Patterns Catalog ⭐

Hundreds of patterns, grouped:

### Test Strategy Patterns
Test Automation Manifesto, Recorded Test, Scripted Test, Data-Driven Test, Test Automation Framework.

### XUnit Basics Patterns
Test Method, Four-Phase Test, Assertion Method, Testcase Class.

### Fixture Setup Patterns
Fresh Fixture, Shared Fixture, In-line Setup, Delegated Setup, Implicit Setup, Lazy Setup, Suite Fixture, Setup Decorator, Chained Tests.

### Result Verification Patterns
State Verification, Behavior Verification, Custom Assertion, Delta Assertion, Guard Assertion, Unfinished Test Assertion.

### Fixture Teardown Patterns
Garbage-Collected Teardown, In-line Teardown, Implicit Teardown, Automated Teardown.

### Test Double Patterns
Test Stub, Test Spy, Mock Object, Fake Object, Configurable Test Double, Hard-Coded Test Double, Test-Specific Subclass.

### Test Organization Patterns
Test Method, Testcase Class per Class / per Feature / per Fixture, Test Helper, Test Utility Method.

### Database Patterns
Database Sandbox, Stored Procedure Test, Table Truncation Teardown, Transaction Rollback Teardown.

### Design-for-Testability Patterns
Dependency Injection, Dependency Lookup, Humble Object, Test Hook.

### Value Patterns
Literal Value, Derived Value, Generated Value, Distinct Generated Value, Dummy Object.

## Why it's deeply integrated into `/quality test-quality`
The smell catalog is essentially the rubric for the test-quality agent. The pattern names give precise prescriptions for fixes.
