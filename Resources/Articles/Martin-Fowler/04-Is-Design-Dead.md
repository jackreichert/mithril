---
title: Is Design Dead?
author: Martin Fowler
url: martinfowler.com/articles/designDead.html
category: Article — Martin Fowler
focus: XP, emergent design, planned vs. evolutionary architecture
---

# Is Design Dead? — Martin Fowler

Written in the early 2000s as XP was being mainstreamed. The article asks: if XP rejects up-front design, has design been *killed*? Fowler's answer is no — but its character changes.

## The two design schools
- **Planned Design**: think first, design upfront, then implement. Architects + diagrams + months.
- **Evolutionary Design**: design emerges from continuous refactoring guided by tests.

XP is firmly in the evolutionary camp. Critics worry that this leads to chaotic codebases.

## What XP relies on for design to *emerge*
- **Continuous testing** — refactoring is safe.
- **Continuous refactoring** — design improves with every change.
- **Pair programming** — two heads design at the keyboard.
- **Collective ownership** — anyone can fix anyone's design issue.
- **Simple design** (Beck's rules — see [05-Becks-Design-Rules](05-Becks-Design-Rules.md)).
- **Communication** — shared language, daily integration.

Without these supports, evolutionary design collapses into "no design."

## "YAGNI" — You Aren't Gonna Need It
Don't build flexibility for features that don't exist yet. Build for current needs; refactor when needs grow.

## Where planned design still helps
- Cross-cutting concerns hard to refactor in (security, logging, database schema, deployment).
- Architectural choices with high reversal cost (language, framework, persistence).
- Choices that span teams or services.

Fowler argues for **just enough up-front design** to let evolutionary design succeed.

## The lasting takeaway
The dichotomy is false. Design is iterative, but some decisions warrant more up-front thought than others. The skill is knowing which.

## Related
- Fowler's *EvolutionaryDesign* bliki entry.
- *YAGNI* bliki entry.
- Connects to **Design Stamina Hypothesis** — design pays off when development time exceeds the "design payoff line."
