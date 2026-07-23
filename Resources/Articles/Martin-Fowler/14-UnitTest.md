---
title: UnitTest
author: Martin Fowler
url: https://martinfowler.com/bliki/UnitTest.html
year: 2014 (revised 2017)
category: Article — Martin Fowler
focus: Definitional clarity on unit tests, solitary vs. sociable distinction
---

# UnitTest — Martin Fowler (2014/2017)

A short but foundational bliki entry. A testing expert once noted covering "24 different definitions of unit test" in a single training course. Fowler doesn't impose a single definition — he maps the definitional space and introduces the solitary/sociable distinction as more precise and useful.

## What Most People Agree On

Despite definitional variation, three characteristics are consistent:
1. **Low-level scope** — focuses on small parts of the system
2. **Developer-written** — programmers write their own tests via frameworks (a major shift from pre-XP practice where specialized testers handled this)
3. **Fast** — executes significantly faster than other test types

## What "Unit" Actually Means

- OOP context: typically a class
- Functional context: typically a single function
- Behavioral context (Khorikov's view): a unit of behavior that may span many classes

Fowler: "However you define it doesn't really matter" as long as the definition is **consistent within a team.**

## Solitary vs. Sociable Tests ⭐

**Solitary Tests:** Use test doubles for all collaborators. A failure always means the unit under test is broken — no cross-contamination from neighboring failures. The mockist/London school preference.

**Sociable Tests:** Test units with real collaborator objects. Assumes everything outside the focus area works (verified by its own tests). The classical/XP school preference.

Historical note: The rise of Mock Objects in the 2000s (Steve Freeman, Tim Mackinnon, Philip Craig — the mockist school from London XP group) popularized solitary testing. Even classical testers use doubles selectively for non-determinism, slow external resources, or unavailable systems.

## Suite Organization and Speed

**Compile Suite:** Run on every compile. Includes only tests relevant to current work. Must run in seconds — some practitioners (Gary Bernhardt) target ~300ms.

**Commit Suite:** Run before every commit. Includes all unit tests. Kent Beck's rule: no more than 10 minutes. Dan Bodart: 10 seconds. Fowler's principle: fast enough not to discourage frequent execution.

## Historical Context: The Developer Testing Shift

Traditional wisdom held that programmers couldn't effectively test their own code due to conceptual blindness. XP advocates argued: (a) programmers can develop testing skills, and (b) feedback delay from separate testing groups is unacceptable. xUnit frameworks (JUnit, NUnit, etc.) were built specifically to reduce friction for developer-written tests.

## Why It Matters

The solitary/sociable distinction is more precise than unit/integration in most conversations. When two people argue about "unit tests," they are often arguing past each other because one means solitary and the other means sociable. Aligning on this terminology resolves the debate faster than any other move.
