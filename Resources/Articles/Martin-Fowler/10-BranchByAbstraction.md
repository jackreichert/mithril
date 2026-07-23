---
title: BranchByAbstraction
author: Martin Fowler (originated by Paul Hammant)
url: martinfowler.com/bliki/BranchByAbstraction.html
category: Article — Martin Fowler
focus: Feature flag alternative for large refactors
---

# Branch by Abstraction — Fowler / Hammant

A technique for making large structural changes to a codebase **without** long-lived feature branches. Mainline-friendly.

## The procedure

1. **Create an abstraction** in front of the code you want to replace. Existing callers go through it.
2. **Refactor existing code** to be one *implementation* behind the abstraction.
3. **Build the new implementation** in parallel, behind the same abstraction.
4. **Switch implementations** for callers, one at a time, possibly via config or feature flag.
5. **Remove the old implementation** when no callers remain.
6. **Remove the abstraction** if it's no longer needed.

```
                ┌─ OldImpl   (delete eventually)
                │
   Caller ─→ Abstraction
                │
                └─ NewImpl   (target)
```

## Compared to long-lived branch

| Long-lived branch         | Branch by Abstraction          |
|---------------------------|--------------------------------|
| Diverges from main        | Stays on main                  |
| Painful merges            | No merges                      |
| Risk concentrated at end  | Risk spread continuously       |
| Hard to ship partial work | Each step shippable            |

## Compared to feature flag

| Feature flag                       | Branch by abstraction               |
|------------------------------------|-------------------------------------|
| Per-feature on/off                 | Per-component swap                  |
| Lots of `if (flag)` in code        | One indirection, no branching       |
| Hard to remove                     | Cleaner removal                     |

The two are complementary — flags can drive *which* implementation BBA selects.

## Real-world cases
- ORM migrations.
- Storage engine swaps (in-memory → Redis → DynamoDB).
- Logging library replacements.
- Auth provider migrations.

## Risks
- Abstractions can leak — design them carefully or you'll re-pay the migration.
- "Half-migrated forever" if you don't enforce a deadline.

## Pairs with
- **Strangler Fig** (system-level analog).
- **Continuous Delivery** (the practice that demands BBA).
- *Working Effectively with Legacy Code* — many of Feathers's seam techniques *are* abstraction insertion in this pattern.
