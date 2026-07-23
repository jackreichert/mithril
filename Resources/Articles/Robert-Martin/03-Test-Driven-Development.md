---
title: Test-Driven Development (blog series)
author: Robert C. Martin
url: blog.cleancoder.com (multiple posts)
category: Article — Robert Martin
focus: Why TDD is a professional discipline
---

# Test-Driven Development — Uncle Bob's Blog Series

A running argument that TDD isn't a tactic but a *professional discipline* — comparable to surgeons washing their hands.

## Core arguments

### TDD as professional duty
- "Imagine a doctor who doesn't wash their hands."
- Untested code is unprofessional in mature engineering.
- Code without tests is a *liability* on the balance sheet, not an asset.

### The Three Laws of TDD ⭐
1. You may not write production code unless you've first written a failing unit test.
2. You may not write more of a unit test than is sufficient to fail.
3. You may not write more production code than is sufficient to pass the failing test.

Operationally: cycle every ~30 seconds. Many objections to TDD come from running cycles too long.

### Why TDD enables clean code
- Tests press *design pressure* — hard-to-test code is hard-to-use code.
- Tests are a safety net for refactoring.
- Tests document behavior with running examples.

### Why the "tests slow me down" objection is false
- Calculate cost over the *life of the software*, not the keystroke.
- Debugging time disappears when failures are localized to one cycle.
- Refactor confidence compounds over months.

## Recurring counter-arguments addressed
- *"Some code is too hard to test."* → If it's hard to test, it's badly designed. Use seams (cf. Feathers).
- *"TDD slows initial development."* → Net throughput, not initial keystroke speed.
- *"Mocks make tests brittle."* → Use them sparingly, as roles not implementations (cf. GOOS).

## The "transformation priority premise" (TPP)
A formal-ish ordering of code transformations during TDD's "green" step, such that tests progressively force code into more general forms. From simpler (constants) to more general (loops, polymorphism). Less practiced than the Three Laws, but theoretically interesting.

## Pairs with
- *TDD by Example* (Beck) — the canonical worked example.
- *GOOS* — outside-in TDD style.
- *The Clean Coder* — TDD as professionalism.
