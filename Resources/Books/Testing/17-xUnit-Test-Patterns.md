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

### Ch 1 — A Brief Tour
The chapter introduces the xUnit framework family, including JUnit, NUnit, and PyUnit. These frameworks share a common architecture for defining, running, and reporting tests. The tour also explains what automated developer testing means in day-to-day software work.

### Ch 2 — Test Smells Overview
Test smells are recurring symptoms that indicate trouble in test code or its surrounding process. Code Smells appear in test source, while Behavior Smells appear during test execution. Project Smells describe problems in the test suite or development organization as a whole.

### Ch 3 — Goals of Test Automation
Automated tests can serve as *executable specifications* that state expected behavior in runnable form. They act as a *bug filter* and enable change by detecting regressions quickly. Well-written tests also become documentation that shows future readers how the system is intended to behave.

### Ch 4 — Philosophy of Test Automation
The chapter compares **test-first** programming with writing tests after production code. Each approach affects design feedback, defect discovery, and the role tests play during development. The economic decision weighs ongoing test-maintenance cost against the greater cost of catching defects later.

### Ch 5 — Principles of Test Automation
- Write tests first.
- Test concerns separately.
- Communicate intent.
- Keep tests independent.
- Use the front door first.
- Verify one condition per test.
- Minimize untestable code.
- Avoid test code duplication.
- Tests should be self-checking, repeatable, robust, sufficient, fast, maintainable, traceable.

### Ch 6 — Test Automation Strategy
A test automation strategy determines how tests are grouped and how their fixtures are managed. Per-test-class organization and fixture-sharing choices have different isolation and maintenance costs. Teams should select patterns that fit their system and constraints rather than apply one structure everywhere.

### Ch 7 — XUnit Basics
An xUnit test follows four recognizable phases. Setup creates the fixture, exercise invokes the behavior, verify checks the outcome, and teardown restores the environment. Keeping these phases clear makes a test easier to read and diagnose.

### Ch 8 — Transient Fresh Fixtures
A transient fresh fixture gives every test a newly created test environment. Each test builds the state it needs and destroys that state afterward. This isolation prevents order dependence and stops one test's changes from leaking into another.

### Ch 9 — Persistent Fresh Fixtures
Persistent fresh fixtures provide isolated state for tests that use a database or another durable store. Each test receives known records even though the underlying technology preserves data beyond a process call. Careful setup and cleanup prevent persistent state from coupling otherwise independent tests.

### Ch 10 — Result Verification
Result verification determines whether exercising the system produced the expected outcome. State verification inspects observable values, while behavior verification checks significant interactions. Custom assertions can express domain meaning and provide clearer failure diagnostics.

### Ch 11 — Using Test Doubles
Test doubles replace dependencies that are inconvenient or inappropriate to use in a focused test. The five principal flavors are dummy, stub, spy, mock, and fake, and each serves a different purpose. This taxonomy provides the precise terminology now widely used to discuss isolated tests.

### Ch 12 — Organizing Our Tests
Tests can be organized around production classes, features, or shared fixture needs. Each structure makes some relationships easy to see while hiding others. The appropriate choice depends on how the team searches for behavior and maintains the suite.

### Ch 13 — Testing with Databases
Database tests need controlled schemas and data so that results remain repeatable. Database sandboxes separate test activity from development and production records. Transaction rollbacks and explicit schema management are two techniques for restoring a known state.

### Ch 14 — A Roadmap to Effective Test Automation
The final narrative chapter explains how to introduce the catalog's practices to a team. Adoption should address the most costly test problems first instead of attempting every pattern at once. This incremental roadmap improves automation without paralyzing ongoing delivery.

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

## Why it's deeply integrated into `/mithril test-quality`
The smell catalog is essentially the rubric for the test-quality agent. The pattern names give precise prescriptions for fixes.
