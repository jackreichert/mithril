# 13 — Gates & Metrics: Measure, Don't Opine

> **Tier 4 · Verification.** The objective floor beneath the reading agents: what a tool can measure, a threshold can enforce, and a human should therefore never argue about — plus the failure mode of every metric that becomes a target. **Skill:** [`skills/gates.md`](../../skills/gates.md) · agent `quality-gates` (enforcement: [`hooks/pre-commit`](../../hooks/), thresholds: [`CONSTITUTION.md`](../../CONSTITUTION.md)).

## The idea in one paragraph

The framework's division of labor is deliberate: **agents opine, gates measure**. Everything a tool can decide — lint cleanliness, cyclomatic complexity, function length, duplication, coverage floors, mutation score — is decided by the tool against an explicit, versioned threshold, for three compounding reasons: machines don't fatigue or play favorites; delegating the mechanical frees human and agent attention for judgment (Theme 11's ladder works *because* style is pre-settled); and a pass/fail floor converts "we should write better code" from aspiration into enforcement, which is the lesson Humble & Farley built into the deployment pipeline — quality checks that don't gate anything are decoration. The metric set is chosen so each measures a distinct failure: complexity per function (Ousterhout's enemy, approximated numerically), length (the Clean Code heuristic, applied as a soft ceiling), duplication (rule two of simple design, detectable mechanically), coverage (a *floor and negative indicator only* — Khorikov's warning that coverage-as-target breeds assertion-free tests is the theme's central caveat), **mutation score** (the only number that measures whether tests can fail — GOOS ch. 19's oracle), and **CRAP** (complexity × undertestedness — the interaction term nothing else catches: a complex function you can't safely change *and* can't trust tests to defend). Goodhart's law governs all of it: every one of these numbers is a proxy, useful exactly until someone optimizes the number instead of the property.

## The arc (how the ideas build)

- **The pipeline made quality enforceable** (Humble & Farley, *Continuous Delivery*) — the commit stage runs the fast checks on every change and *fails the build* on breach; a check that can't fail anything is advice, and advice loses to deadlines. The gate's location matters: fastest checks earliest (pre-commit hook), expensive ones (mutation) staged later.
- **Static analysis scales what reviewers shouldn't spend attention on** (*Software Engineering at Google* ch. 20) — Google's Tricorder lesson: mechanical findings belong to tools wired into the workflow, with low false-positive tolerance (noisy gates get ignored, then disabled); human review time is reserved for what tools can't see (design, Theme 11).
- **What to measure and why each earns its slot** — lint (mechanical consistency, settled once); cyclomatic complexity per function (branch-path count as a complexity proxy — crude but monotonic with cognitive load); function length (soft ceiling honoring Theme 03's depth caveat — length *alone* isn't the sin, so it warns rather than blocks at the margin); duplication (Beck's rule two, tool-detectable); dependency freshness/advisories (Theme 12's SCA floor).
- **Coverage, demoted honestly** (Khorikov ch. 1; SE@G ch. 11) — low coverage proves under-testing; high coverage proves *nothing* (assert-free tests cover plenty). So: a floor, never a target; a drop in the diff is a signal, a rise is not a virtue. Mandating 100% is how you buy a suite that can't fail.
- **Mutation is the oracle** (GOOS ch. 19) — seed behavior changes; count how many the suite kills. It's the direct measurement of Theme 09's pillar one (would anything fail?), and the answer to coverage's blind spot. Expensive → scheduled/staged, not per-commit.
- **CRAP names the compounding risk** (Savoia & Evans) — Change Risk Anti-Patterns: complexity² scaled by untestedness. A simple untested function is fine; a complex tested one is fine; complex *and* untested is where changes go to die. The one metric in the set sourced outside the book canon, kept because it measures the interaction.
- **Thresholds are policy, so they're versioned** (the Constitution) — numbers live in one reviewable place, apply to *changed* code first (don't brick the repo on legacy debt — Theme 04's boy-scout economics), and change by PR, not by mood. Ratchets beat amnesties: the floor only rises.
- **The failure mode is worship** (Goodhart, applied) — when the number becomes the goal, the property decays: coverage targets breed assertion-free tests, length caps breed fragmented shallow helpers (Theme 03's tension, weaponized), complexity caps breed method-splitting that relocates branches without removing them. The gate reports; judgment interprets; the reading agents exist precisely because the floor is not the ceiling.

## Key concepts & frameworks

- **Agents opine, gates measure** — the framework's division of labor.
- **Commit-stage discipline** (CD) — fast checks gate every change; a non-blocking check is decoration.
- **The metric set** — lint · cyclomatic complexity · function length · duplication · coverage floor · mutation score · CRAP; each measuring a distinct failure mode.
- **Coverage as negative indicator** — floor, not target; the perverse-incentive warning.
- **Mutation score** — the only direct measure of a suite's ability to fail.
- **CRAP** — complexity × undertestedness; the interaction term.
- **Versioned thresholds + ratchets** — policy as code, changed-code-first, floor only rises.
- **Goodhart's law** — every proxy decays under optimization; gates are floors, not definitions of good.

## The sources

- ★ [**Continuous Delivery** — Humble & Farley](../Books/Engineering-Culture-Process/19-Continuous-Delivery.md) — the pipeline as enforcement; commit-stage gates.
- [**Software Engineering at Google** — Winters et al.](../Books/Engineering-Culture-Process/18-Software-Engineering-at-Google.md) — ch. 11 coverage culture; ch. 20 static analysis that developers don't ignore.
- [**GOOS** — Freeman & Pryce](../Books/Testing/15-Growing-Object-Oriented-Software-Guided-by-Tests.md) — ch. 19: test quality beyond coverage.
- [**Unit Testing** — Khorikov](../Books/Testing/27-Unit-Testing-Principles-Practices-Patterns.md) — ch. 1: the coverage-as-target trap.
- [**A Philosophy of Software Design** — Ousterhout](../Books/Canon/06-A-Philosophy-of-Software-Design.md) + [**Clean Code** — Martin](../Books/Canon/01-Clean-Code.md) — what the complexity/length numbers are proxies *for*.
- **CRAP** — Savoia & Evans (2007); citation in [`Originals/Citations/Articles.md`](../Originals/Citations/Articles.md).

## What the skill encodes (operational checklist)

- [ ] Run the tools; report each metric as measured-value vs. explicit threshold → pass/fail. No adjectives.
- [ ] Thresholds read from the versioned source (Constitution/config), never improvised per run.
- [ ] Changed code held to the floor first; repo-wide breaches reported as debt inventory, not diff blockers.
- [ ] Coverage reported as floor-compliance and delta only; never praised as a positive score.
- [ ] Mutation survivors on critical paths listed by name — each is an untested behavior wearing a covered line.
- [ ] CRAP-flagged functions get the pairing prescription: reduce complexity or add characterization tests (Theme 04) before change.
- [ ] Tool absence/failure stated explicitly (same honesty rule as Theme 12) — a gate that didn't run is not a gate that passed.
- [ ] Metric-gaming patterns (assertion-free tests, branch-relocating splits) escalated to the reading agents as findings.

## Connects to

[09 — Test Quality](09-Test-Quality.md) (the pillars these numbers approximate) · [11 — Code Review](11-Code-Review.md) (gates free the human ladder's lower rungs) · [14 — Delivery](14-Delivery.md) (the pipeline stages where each gate runs) · [03 — Readable Code](03-Readable-Code.md) (the judgment the length/complexity proxies must not replace).
