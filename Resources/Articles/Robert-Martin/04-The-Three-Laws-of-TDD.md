---
title: The Three Laws of TDD
author: Robert C. Martin
url: blog.cleancoder.com / butunclebob.com
category: Article — Robert Martin
focus: Red, green, refactor mechanics
---

# The Three Laws of TDD — Uncle Bob

## The laws (verbatim)

1. **You are not allowed to write any production code unless it is to make a failing unit test pass.**
2. **You are not allowed to write any more of a unit test than is sufficient to fail; and compilation failures are failures.**
3. **You are not allowed to write any more production code than is sufficient to pass the one failing unit test.**

## What the laws produce

Following them strictly forces a cycle:
- A test compile-fails → write the bare class skeleton.
- The test fails an assertion → write minimal code to pass.
- Repeat with a new test that exercises a new behavior.

Cycle time: ~30 seconds typical, ~2 minutes max.

## Common misreadings

- *"You must run all tests on every cycle."* — No. The *new* test must be red, then green.
- *"You can't write multiple tests at a time."* — Correct: write *one* failing test, make it pass, then move on.
- *"Refactor isn't in the laws."* — Refactoring is governed by separate discipline ("two hats" — never refactor while red).

## The red-green-refactor rhythm

```
red   → write a tiny failing test
green → write the simplest production code to pass
refactor → improve code AND test, keeping green
```

Stay green between cycles. Cycles short.

## Why the laws are *laws* (not guidelines)

Martin frames them as discipline because:
- Following them when convenient yields no benefit; following them rigorously yields clean design.
- The rigor itself produces design feedback (tests "hurt" → code is wrong).

## Pairs with
- *TDD by Example* (Beck) — the laws are inferred there but not stated.
- The "Three Laws" video on Clean Coders.
- GOOS — adds outside-in to the laws.
