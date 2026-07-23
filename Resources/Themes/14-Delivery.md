# 14 — Delivery: Making Releases Boring

> **Tier 5 · Systems in production.** The path from commit to production as an engineered system: one pipeline, trunk-based flow, environment-borne config, flags with expiry dates, migrations that never require downtime — and the four numbers that prove it's working. **Skill:** [`skills/delivery.md`](../../skills/delivery.md) · agent `quality-delivery`.

## The idea in one paragraph

The core insight of *Continuous Delivery* is that releases hurt in proportion to their size and rarity, so the cure is inversion: release so often, through a path so automated, that deployment becomes a non-event. The machinery: a single **deployment pipeline** every change traverses — commit stage (fast gates, Theme 13), automated acceptance stage (Theme 10's executable specs), then promotion of the *same artifact* through environments (build once, configure per environment, never rebuild); **trunk-based development**, because integration pain compounds with branch lifetime, and short-lived branches merging daily keep the trunk releasable (with Branch by Abstraction, Theme 04, absorbing the changes too big for one merge); **12-Factor discipline**, keeping config in the environment (the same rule Theme 12 relies on for secrets) and dev/prod parity honest; **feature flags** in Hodgson's four flavors (release, experiment, ops, permission) — each with an owner and an expiry, because a flag is deliberate debt and forgotten flags are how systems acquire haunted switches; and **expand–contract migrations**, which decouple deploy from schema so the database never holds the release hostage. Accelerate supplies the empirical spine: the DORA four keys — deploy frequency, lead time, change-failure rate, MTTR — and the research finding that kills the classic excuse: speed and stability are *not* a trade-off; elite teams win on all four at once, and the walking skeleton (Theme 08) is where a new system earns them from day one.

## The arc (how the ideas build)

- **Deploy the skeleton before the flesh** (GOOS ch. 4; Pragmatic Programmer's tracer bullets; Nygard ch. 13) — the thinnest end-to-end slice, built, deployed, and tested through the *real* pipeline first. Infrastructure risk is retired while it's cheap, and every subsequent feature inherits a working path to production.
- **One pipeline, one artifact** (Humble & Farley ch. 5–6) — every commit enters the same pipeline; the binary/image built once at the commit stage is what's promoted, byte-identical, through test and production. Rebuilding per environment reintroduces the "works in staging" lie.
- **Trunk-based flow** (Fowler/Hammant; SE@G ch. 16) — branches live hours-to-days, not weeks; integration happens continuously because deferred integration is deferred conflict, compounding. The trunk is always releasable — that's the invariant everything else defends.
- **Config from the environment; parity everywhere** (12-Factor) — code is one thing, config is per-deploy, secrets are never in the artifact; dev, staging, and prod stay similar enough that "it worked in dev" carries information. Snowflake environments are unreproducible risk.
- **Flags are scoped debt** (Hodgson) — release flags decouple deploy from release (deploy dark, enable gradually); experiment flags A/B; ops flags are kill switches; permission flags gate cohorts. Each category has a different lifetime and testing burden — and every flag has an expiry and an owner, because flag interactions grow combinatorially (2ⁿ states nobody tests).
- **The database releases on its own schedule** (Humble & Farley ch. 12) — expand–contract: add the new column/table (expand), migrate readers/writers incrementally while both shapes work, remove the old (contract) releases later. Every step is backward-compatible one release in each direction; migrations are versioned, forward-only scripts in the repo, not hand-run SQL.
- **Measure with the four keys** (Forsgren, Humble & Kim, *Accelerate*; DORA reports) — deploy frequency and lead time (speed), change-failure rate and MTTR (stability); elite performers dominate all four simultaneously, and the 24 capabilities behind them (version control for everything, test automation, trunk-based dev, loosely-coupled architecture — Theme 05 earning its delivery keep) are *causal*, not correlational. The numbers diagnose the system, never rank the people.
- **SLOs, golden signals, error budgets** (SRE; Theme 18) — instrument latency/traffic/errors/**saturation**; define SLIs/SLOs; spend the error budget on velocity and freeze risk when exhausted. Observability (high-cardinality events, trace context) makes unknown-unknowns debuggable — monitoring alone is not enough.
- **Supply chain is delivery surface** (OWASP A08; SLSA/SBOM note) — lockfiles, pinned deps, CI trust boundaries, and artifact provenance are release-engineering controls, not afterthoughts.

## Key concepts & frameworks

- **Walking skeleton / tracer bullet** — pipeline-first development; features ride an already-working path.
- **Build once, promote everywhere** — artifact immutability through environments.
- **Trunk-based development** — short-lived branches, daily integration, always-releasable trunk (+ Branch by Abstraction for the big stuff).
- **12-Factor config & parity** — environment-borne config; no snowflakes; secrets never in artifacts.
- **The flag taxonomy** (release / experiment / ops / permission) — with owner, tests, and expiry per flag.
- **Expand–contract** — zero-downtime schema evolution; deploy decoupled from migrate.
- **DORA four keys** — deploy frequency · lead time · change-failure rate · MTTR; speed and stability rise together.

## The sources

- ★ [**Continuous Delivery** — Humble & Farley](../Books/Engineering-Culture-Process/19-Continuous-Delivery.md) — the pipeline, build discipline, data migrations, dependencies.
- ★ [**Accelerate** — Forsgren, Humble & Kim](../Books/Engineering-Culture-Process/25-Accelerate.md) — the DORA evidence and capability model.
- [**Trunk Based Development** — Fowler/Hammant](../Articles/Martin-Fowler/11-Trunk-Based-Development.md) — branch-lifetime discipline. (Feature-flag taxonomy: Hodgson's *Feature Toggles* on martinfowler.com, cited in the master list.)
- [**The Twelve-Factor App**](../Standards/03-The-Twelve-Factor-App.md) — config, parity, processes, logs.
- [**Software Engineering at Google**](../Books/Engineering-Culture-Process/18-Software-Engineering-at-Google.md) — chs. 16, 22–24: version control, large-scale changes, CI/CD at scale.
- [**Release It!** — Nygard](../Books/Domain-Systems-Design/13-Release-It.md) — ch. 13: designing for deployment.
- [**GOOS** — Freeman & Pryce](../Books/Testing/15-Growing-Object-Oriented-Software-Guided-by-Tests.md) — ch. 4: the walking skeleton.

## What the skill encodes (operational checklist)

- [ ] Every commit rides the same pipeline; environment-specific build steps or rebuilt artifacts → finding.
- [ ] Branch age audited: long-lived feature branches flagged, with Branch by Abstraction as the prescribed alternative.
- [ ] Config in code (URLs, credentials, environment conditionals compiled in) → 12-Factor finding; secrets get Theme 12 severity.
- [ ] New flags carry category, owner, and expiry; expired or orphaned flags are debt findings.
- [ ] Migrations reviewed for expand–contract: any step that breaks the *previous* release's code is a zero-downtime violation.
- [ ] Destructive migration steps (drop, rename-in-place) only in a later release than the code that stops needing them.
- [ ] Deploy scripts/pipeline definitions in version control, reviewed like code (they are code — and A08 attack surface).
- [ ] Readiness framed in DORA terms: what does this change do to lead time, failure rate, and recovery?
- [ ] New endpoints/services carry golden signals + SLO/error-budget story (Theme 18).
- [ ] Lockfile/CI/provenance gaps flagged as delivery + security findings.

## Connects to

[13 — Gates & Metrics](13-Gates-and-Metrics.md) (the commit stage is where the gates live) · [10 — Specification by Example](10-Specification-by-Example.md) (the acceptance stage) · [04 — Smells, Refactoring & Legacy Rescue](04-Smells-Refactoring-and-Legacy-Rescue.md) (Branch by Abstraction keeps trunk-based honest) · [12 — Security](12-Security-Review.md) (the pipeline as supply-chain attack surface) · [16 — Persistence](16-Persistence.md) (expand–contract meets the data layer's transaction realities) · [18 — Performance & Operability](18-Performance-and-Operability.md) (USE, golden signals, SLOs).
