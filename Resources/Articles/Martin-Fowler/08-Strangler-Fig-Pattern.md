---
title: Strangler Fig Pattern (formerly Strangler Application)
author: Martin Fowler
url: martinfowler.com/bliki/StranglerFigApplication.html
category: Article — Martin Fowler
focus: Safe legacy migration strategy
---

# Strangler Fig Pattern — Martin Fowler

Fowler observed strangler-fig vines slowly engulfing a host tree in Australia. The metaphor: build the new system *around* the old one, gradually shifting capabilities, until the old can be cut away.

## The pattern
1. Place a **facade** (router, proxy, ESB) in front of the legacy system.
2. Build new functionality in a new system *behind* the facade.
3. Route specific requests to the new system; rest stay on legacy.
4. Migrate behavior piece by piece.
5. When the legacy is empty, remove it.

```
                Facade / Router
              /              \
         Legacy ←—shrinking   New ←—growing
```

## Why it beats big-bang rewrite
- **Always-shipping** — old system runs through the migration.
- **Reversible** — bad piece in new system → route back to legacy.
- **Risk-bounded** — one capability at a time.
- **Funded incrementally** — business sees value continuously.

## Common pitfalls
- **Facade gets stale** — keep it ruthlessly simple.
- **Two systems forever** — without forcing function, the legacy never dies. Set deprecation deadlines.
- **Data sync hell** — when both systems write to overlapping data, complexity skyrockets.
- **Edge cases in legacy** become *gotchas in routing* — every feature flag is a maintenance liability.

## Variants
- **Branch by Abstraction** — strangler at the *code* level, inside one process.
- **Asset Capture** — gradually move data ownership.
- **Event Interception** — substitute legacy by listening to its events.

## Pairs with Joel Spolsky's "Things You Should Never Do, Part I"
Spolsky says don't rewrite from scratch. Strangler is the answer to "but the legacy is unmaintainable" — incremental replacement, not big-bang.

## Real-world examples
- Twitter migrating Ruby Rails → JVM services.
- Most "monolith → microservices" migrations are stranglers in disguise.
