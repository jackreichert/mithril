# 11 — Code Review: The Human Gate

> **Tier 4 · Verification.** The discipline of judging a change — what to look at first, what standard to hold it to, and the author's half of the bargain. The theme behind the framework's own reviewing conduct. **Skill:** [`skills/review.md`](../../skills/review.md) · agent `mithril-review`.

## The idea in one paragraph

Google's engineering-practices guides — the closest thing the industry has to a tested, published review doctrine — settle the two questions every review stumbles on. *What standard?* **A change ships when it definitely improves the overall code health of the system, even if it isn't perfect** — reviewers who demand perfection block progress and teach authors to batch changes into unreviewable lumps; reviewers who rubber-stamp let health decay one approval at a time. *What order?* **Design first** — is this change a good idea, does it belong here, does it integrate sanely — because a beautifully-named, well-tested implementation of the wrong design is wasted effort compounding; then functionality (does it do what the author intended, and is that good for users), then complexity (can a future maintainer understand it — over-engineering is flagged *now*, not when the speculative generality rusts), then tests (real ones, that would fail), and only then naming, comments, and style — with mechanical style delegated to linters and gates (Theme 13) so humans never argue about tabs. The author's half (the CL Author's Guide): **small changes** — ~200 lines is the sweet spot and beyond ~400 review quality collapses — one concern per change, refactors never mixed with behavior changes, and a description that states *why*. The framework adds calibrated conduct: findings carry confidence, comment on the code never the author, and the verdict is explicit.

## The arc (how the ideas build)

- **The standard** (*The Standard of Code Review*) — net improvement over the current state, not perfection. This single sentence resolves most review stand-offs: "I wouldn't have done it this way" is not a blocking finding; "this makes the system harder to change" is. Continuous small improvement beats gated perfection.
- **The priority order** (*What to Look For in a Code Review*) — design > functionality > complexity > tests > naming > comments > style > documentation. The order is triage: a design objection invalidates everything downstream of it, so raising naming nits on a doomed design wastes both parties' time. The framework's severity model (Critical/Important/Minor) maps onto this ladder.
- **Complexity means "can't understand it quickly"** — including *speculative* complexity: functionality nobody needs yet, generality no caller exercises. The reviewer is the last line of defense against over-engineering, because the author is, by construction, in love with the abstraction (Theme 07's counterweight applied by a second pair of eyes).
- **Tests get reviewed as code** — do they exist, would they actually fail on regression, do they assert behavior (Theme 09's pillars applied in the diff)? A test that can't fail is a design-level finding disguised as thoroughness.
- **The author's duties** (*The CL Author's Guide*) — small, single-concern CLs with honest descriptions; refactoring and behavior change in separate commits (Theme 04's two hats, enforced at the PR boundary); respond to findings with fixes or reasons, not silence. Review latency is a function of CL size before anything else.
- **Conduct that scales** (SE@G's review culture) — comment on the code, not the coder; explain *why* with a principle or a source, not "I prefer"; prefix genuinely optional polish with "Nit:"; unblock fast — a review is a service with an SLA, not an audition. Knowledge transfer is a first-class output of review, not a side effect.
- **Calibrated findings** (the framework's own addition) — every finding carries confidence (the `review` skill's ≥80 threshold for assertions of fact), severity tied to the priority ladder, and a concrete fix. "This might be wrong" without a failure scenario is noise wearing a badge.

## Key concepts & frameworks

- **Net-positive standard** — approve when the codebase is better with this change than without it.
- **The priority ladder** — design > functionality > complexity > tests > naming > comments > style; severity follows altitude.
- **CL-size discipline** — ~200-line sweet spot, >400 split; one concern per change; refactor ≠ behavior.
- **Speculative complexity as a reviewable defect** — YAGNI enforced by the second reader.
- **Nit-prefixing & confidence scoring** — optional polish labeled as such; assertions of fact held to a threshold.
- **Review as knowledge transfer** — the review record is documentation of *why*; terse LGTMs teach nothing.

## The sources

- ★ [**Code Review Developer Guide** — Google](../Articles/Google-Engineering/01-Code-Review-Developer-Guide.md) — the umbrella doctrine (and the net-positive standard).
- ★ [**What to Look For in a Code Review** — Google](../Articles/Google-Engineering/02-What-to-Look-For-in-a-Code-Review.md) — the priority ladder, dimension by dimension.
- [**The CL Author's Guide** — Google](../Articles/Google-Engineering/03-The-CL-Authors-Guide.md) — small CLs, descriptions, the author's half.
- [**Software Engineering at Google** — Winters et al.](../Books/Engineering-Culture-Process/18-Software-Engineering-at-Google.md) — review as culture and knowledge-sharing at scale.
- [**The Clean Coder** — Martin](../Books/Clean-Architecture-Trilogy/09-The-Clean-Coder.md) — the professional posture the reviewer and author both owe the work.

## What the skill encodes (operational checklist)

- [ ] Findings ordered and severity-weighted by the ladder: design objections first, style never blocking.
- [ ] The verdict applies the net-positive standard — explicit SHIP IT / NEEDS WORK / SIGNIFICANT ISSUES, not vibes.
- [ ] Oversized or multi-concern diffs flagged as review-quality risks in their own right (with the split suggested).
- [ ] Refactoring mixed with behavior change → finding (unreviewable and unbisectable).
- [ ] Speculative generality and unneeded configurability flagged as complexity findings now.
- [ ] Necessity asked of every new mechanism: the nearest existing config, flag, helper, or hook is named and shown not to cover the case; a finding needs a verified alternative.
- [ ] Tests in the diff reviewed for would-actually-fail, not just presence.
- [ ] Every finding: principle cited, concrete fix proposed, confidence carried; "Nit:" on the optional.
- [ ] Comments address the code; explanations teach the why (source-linked when the canon has one).

## Connects to

[02 — The Professional's Discipline](02-The-Professionals-Discipline.md) (review audits what pre-flight should have produced) · [03 — Readable Code](03-Readable-Code.md) + [05 — Architecture](05-Architecture-Dependencies-and-Boundaries.md) (the substance behind the ladder's top rungs) · [13 — Gates & Metrics](13-Gates-and-Metrics.md) (everything mechanical is delegated there, keeping humans on judgment) · [04 — Smells, Refactoring & Legacy Rescue](04-Smells-Refactoring-and-Legacy-Rescue.md) (the two-hats rule, enforced at the PR).
