---
title: Beck's Design Rules (Rules of Simple Design)
author: Kent Beck (popularized by Fowler)
url: martinfowler.com/bliki/BeckDesignRules.html
category: Article — Martin Fowler
focus: Simple design — passes tests, reveals intent, no duplication, fewest elements
---

# Beck's Design Rules — Martin Fowler

Kent Beck's four rules of simple design, in priority order. From *Extreme Programming Explained*; popularized in Fowler's bliki and integrated into Clean Code (ch. 12).

## The four rules

In priority order — apply (1) first, then (2), then (3), then (4):

1. **Passes the tests** — Code must work. Without tests, the rest is vapor.
2. **Reveals intention** — Reads like the problem it solves.
3. **No duplication** — One place for any concept of knowledge.
4. **Fewest elements** — No unnecessary classes, methods, or abstractions.

## The discipline

- When you finish a feature, run through the rules.
- If multiple rules conflict, the higher-numbered rule loses. Speculative abstractions (rule 4 violations because nothing duplicates yet) come down.
- Continuous refactoring keeps you near simple design.

## Common reorderings (and why Fowler keeps Beck's)
Some teams promote "DRY" above "intent." Fowler argues this leads to *too clever* abstractions where intent is sacrificed to remove repetition. Beck's order — intent first, then DRY — keeps comprehension primary.

## Variations seen elsewhere
- **Three rules**: works, readable, evolvable.
- **Two rules**: makes its intent obvious + passes tests.

Beck's four are the most-cited.

## Practical use
- Code review checklist for "is this good enough to ship?"
- Refactoring goal — keep moving toward all four.
- Connects to *Refactoring* (Fowler) — every catalog entry can be motivated by which Beck rule it serves.
