---
title: Technical Debt — TechnicalDebtQuadrant
author: Martin Fowler
url: martinfowler.com/bliki/TechnicalDebtQuadrant.html
category: Article — Martin Fowler
focus: Debt quadrant — reckless/prudent × deliberate/inadvertent
---

# Technical Debt (and the Debt Quadrant) — Martin Fowler

Ward Cunningham coined "technical debt" as a metaphor for shipping imperfect code now and "paying interest" later in slower change. Fowler's contribution is the **Debt Quadrant**: not all debt is created equal.

## The metaphor
- **Principal**: the cost to fix the code itself.
- **Interest**: the *extra* cost paid every time you change code while the debt exists.
- Like financial debt: small + leveraged at high speed = useful. Unmanaged + compounding = ruin.

## The Debt Quadrant ⭐

|              | **Reckless**                        | **Prudent**                       |
|--------------|-------------------------------------|-----------------------------------|
| **Deliberate**   | "We don't have time for design."    | "We must ship now and deal with consequences." |
| **Inadvertent**  | "What's layering?"                  | "Now we know how we should have done it." |

- **Reckless / Deliberate**: refusal to learn or apply discipline. Pure liability.
- **Reckless / Inadvertent**: ignorance of design principles. Education solves it.
- **Prudent / Deliberate**: conscious trade-off, documented, scheduled to repay. *Best* form.
- **Prudent / Inadvertent**: hindsight after shipping. Inevitable; refactor when you learn.

## Why the framing matters
- Treating all debt the same → either reckless rewrites or paralysis.
- Naming the quadrant gives teams shared vocabulary for "we accept this debt now and will repay by Q3."

## Related Fowler bliki entries
- **DesignStaminaHypothesis** — pace at which good design lets you keep shipping fast.
- **CannotMeasureProductivity** — why "speed" measurements miss debt.

## Practical use in code review
When asking for a refactor, classify the debt:
- *Reckless* → block.
- *Prudent / Deliberate* → ship with TODO + ticket + repayment date.
- *Prudent / Inadvertent* → schedule refactor next sprint.
