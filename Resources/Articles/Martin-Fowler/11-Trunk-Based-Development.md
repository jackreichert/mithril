---
title: Trunk Based Development
author: Martin Fowler (popularized; site by Paul Hammant)
url: martinfowler.com/bliki/TrunkBasedDevelopment.html
        and trunkbaseddevelopment.com
category: Article — Martin Fowler
focus: Short-lived branches, continuous integration
---

# Trunk-Based Development (TBD) — Fowler / Hammant

> All developers commit to one shared branch (trunk / main / master), at least once a day, with short-lived feature branches no older than 24–48 hours.

The opposing model is **GitFlow** (long-lived develop, release, hotfix branches), which Fowler argues actively impedes CI.

## Two flavors

### TBD without branches
Everyone commits directly to trunk. Tooling: feature flags, branch by abstraction, fast tests.

### TBD with short-lived feature branches
Branch lives < 2 days. Merged via PR after CI passes. Branch reused once and deleted.

## Why TBD wins (per DORA / *Accelerate* research)
Teams using TBD:
- Deploy more frequently.
- Have lower change-failure rates.
- Recover from incidents faster.
The DORA studies found TBD as a top predictor of high software-delivery performance.

## Prerequisites
- **Comprehensive automated tests** — caught bugs in CI minutes, not weeks.
- **Pre-commit / pre-merge gates** — broken main is unacceptable.
- **Feature flags** — incomplete features hidden from users.
- **Branch by abstraction** — large refactors without branches.
- **Small, frequent commits** — easier to review and revert.
- **Build/test pipeline under 10 minutes** to keep merge cycles fast.

## Common objections (and rebuttals)
- *"We can't commit incomplete features."* → Use feature flags; merge dark.
- *"Code review takes too long."* → Smaller PRs reviewed faster.
- *"Releases need stabilization."* → Deploy from trunk; tag releases.

## Where TBD fits poorly
- Rare release cadence (firmware, embedded, deeply regulated).
- Teams without solid CI tooling — they need to invest before TBD.

## Related
- **Continuous Integration** (Fowler) — TBD is CI made literal.
- **Feature Toggles / Flags** (Pete Hodgson) — the partner pattern.
- **Branch by Abstraction**.
- *Continuous Delivery* book (Humble & Farley).
