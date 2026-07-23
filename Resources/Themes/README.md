# Themes — the concept guides

Nineteen cross-source concept guides that sit **between the per-source summaries and the skills**. (For the one-file horizontal cut — the recurring meta-patterns, the tension map, and the consensus list the tutor teaches from — see [`THEMES.md`](../../THEMES.md); these guides are its per-theme deep dives.) A summary condenses one book; a theme synthesizes the *idea* across every source that touches it — including where the sources disagree; a skill operationalizes the theme into review judgment; the [Constitution](../../CONSTITUTION.md) compresses it into write-time rules; the gates enforce the measurable slice. Themes are the learning on-ramp: read the theme first, then drill into the summaries it cites, then the originals.

Each theme states the idea in one paragraph, walks the arc of how the sources build it, names the real tensions instead of papering over them (this repo's house rule — e.g. Clean Code vs. APOSD on comments), lists its sources from the [master list](../../CS-Best-Practices-Resources.md), and ends with the operational checklist its skill encodes.

## The curriculum (Tier 1 → 5)

| # | Theme | Tier | Skill it grounds |
|---|-------|------|------------------|
| 01 | [Complexity & Deep Modules](01-Complexity-and-Deep-Modules.md) | 1 · Foundations | `code-quality`, `architecture` |
| 02 | [The Professional's Discipline](02-The-Professionals-Discipline.md) | 1 · Foundations | `process` |
| 03 | [Readable Code](03-Readable-Code.md) | 2 · Construction | `code-quality` |
| 04 | [Smells, Refactoring & Legacy Rescue](04-Smells-Refactoring-and-Legacy-Rescue.md) | 2 · Construction | `refactor` |
| 05 | [Architecture: Dependencies, Boundaries & Resilience](05-Architecture-Dependencies-and-Boundaries.md) | 3 · Design at scale | `architecture` |
| 06 | [Domain-Driven Design & Conway's Law](06-Domain-Driven-Design-and-Conways-Law.md) | 3 · Design at scale | `architecture` |
| 07 | [Design Patterns, with Restraint](07-Design-Patterns-with-Restraint.md) | 3 · Design at scale | `patterns` |
| 08 | [Test-First: TDD as Design](08-Test-First-TDD-as-Design.md) | 4 · Verification | `test-quality` |
| 09 | [Test Quality: The Suite as an Asset](09-Test-Quality.md) | 4 · Verification | `test-quality` |
| 10 | [Specification by Example](10-Specification-by-Example.md) | 4 · Verification | `specification` |
| 11 | [Code Review: The Human Gate](11-Code-Review.md) | 4 · Verification | `review` |
| 12 | [Security: Thinking Like an Attacker](12-Security-Review.md) | 4 · Verification | `security-review` |
| 13 | [Gates & Metrics: Measure, Don't Opine](13-Gates-and-Metrics.md) | 4 · Verification | `gates` |
| 14 | [Delivery: Making Releases Boring](14-Delivery.md) | 5 · Systems in production | `delivery` |
| 15 | [Distributed Systems: Respecting the Network](15-Distributed-Systems.md) | 5 · Systems in production | `distributed` |
| 16 | [Persistence: The Data Layer](16-Persistence.md) | 5 · Systems in production | `persistence` |
| 17 | [Concurrency: Shared Memory, Honestly](17-Concurrency.md) | 5 · Systems in production | `concurrency` |
| 18 | [Performance & Operability](18-Performance-and-Operability.md) | 5 · Systems in production | `performance`, `observability`, `persistence`, `delivery` |
| 19 | [Accessibility: Inclusive Interfaces](19-Accessibility.md) | 4 · Verification | `accessibility` |

The cross-cutting `quality-flow` agent draws on 12, 15, 16, and 18 (taint, partial failure, resource/transaction lifecycle, and source→sink cost) rather than owning a theme — see each theme's "Connects to" and the flow agent prompt.

## Read order

- **Tier 1 first, always.** Theme 01 is the axiom everything else derives from (every later theme is a complexity-management strategy in disguise); Theme 02 is the discipline that makes the rest land in practice.
- **Then follow your work.** Writing a module → 03, 07. Changing old code → 04. Drawing boundaries → 05, 06. Testing → 08–10. Reviewing → 11–13. Shipping/operating → 14–18.
- **Tensions are content, not noise.** When two canonical sources disagree (small functions vs. deep modules; comments as failure vs. comments as design; classical vs. London TDD; pyramid vs. trophy), the theme states both sides and the judgment rule the skills apply.

## How this layer relates to the rest

```
CS-Best-Practices-Resources.md      the master inventory (what exists, who owns which idea)
  └── Resources/{Books,Articles,Papers,Standards}/   one summary per source (condense)
        └── Resources/Themes/                        19 concept guides (synthesize across sources)  ← you are here
              └── skills/                            18 skill docs (operationalize for review; + tutor)
                    ├── ~/.claude/agents/quality-*   compiled agent prompts (execute)
                    ├── CONSTITUTION.md               write-time rules (prevent)
                    └── skills/gates.md + hooks/      measured thresholds (enforce)
```
