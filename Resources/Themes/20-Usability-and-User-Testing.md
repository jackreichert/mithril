# 20 — Usability: Obvious Interfaces, Tested with Users

> **Tier 4 · Verification (UI).** Making important tasks easy to discover, understand, complete, and recover through clear interaction design and direct observation of representative users. **Skill:** [`skills/usability.md`](../../skills/usability.md) · agent `mithril-usability`.

## The idea in one paragraph

Usability asks whether a person can complete the intended task without avoidable confusion, delay, or error. Krug's durable heuristic is "don't make me think": use recognizable conventions, clear hierarchy, meaningful labels, visible state, and strong information scent so users spend attention on their goal rather than decoding the interface. Heuristics identify plausible risks, not facts about users, so the evidence loop is equally important: give representative participants realistic tasks, observe without teaching, prioritize repeated or blocking failures, make the smallest useful correction, and test again. Accessibility and usability reinforce one another but remain distinct: an interface can conform to WCAG and still be confusing, or appear easy to some users while excluding people who use keyboards or assistive technology.

## The arc

- **Design for actual behavior** (*Don't Make Me Think*, chs. 1–2) — people scan, satisfice, and muddle through; optimize for recognition and recovery instead of idealized careful reading.
- **Make structure visible** (chs. 3–7) — selective hierarchy, conventional controls, concise copy, persistent orientation, and confident choices reduce cognitive effort.
- **Respect the whole interaction** (chs. 10–12) — mobile constraints, errors, support, privacy, and accessibility all affect the user's reservoir of trust.
- **Observe instead of debating** (*Don't Make Me Think*, chs. 8–9) — opinion cannot establish what representative users understand; realistic task observation can expose breakdowns.
- **Make testing routine** (*Rocket Surgery Made Easy*) — test a few participants frequently, debrief immediately, fix the most serious problems, and retest rather than waiting for a large end-stage study.
- **Match evidence to the claim** — small qualitative studies diagnose problems but do not estimate prevalence or prove that one design outperforms another statistically.

## Key concepts

- **Self-evidence** — labels, affordances, and state make the next action understandable without decoding designer intent.
- **Scanning and satisfacing** — users seek a plausible path, not exhaustive comprehension; hierarchy and information scent carry the path.
- **Orientation** — identity, location, available routes, current state, and a safe way back remain visible.
- **Task-based testing** — participants attempt realistic goals with observable completion states while a neutral facilitator avoids teaching.
- **Evidence ladder** — an observed repeated breakdown outweighs a heuristic concern; a heuristic concern outweighs personal taste; neither a few sessions nor analytics alone establishes causality or prevalence.
- **Iterative repair** — prioritize blocking and repeated problems, apply the smallest change that addresses the cause, and retest.

## Tensions and judgment calls

- **Conventions vs. innovation** — familiar behavior lowers cognitive cost, but a novel interaction can earn its learning cost when it creates substantial task value and is tested with its audience.
- **Fewer clicks vs. easier choices** — path length is not the governing metric; several obvious, reversible choices can outperform one dense or ambiguous decision.
- **Broad recruiting vs. representative recruiting** — loose recruiting finds many general failures cheaply, while specialized domains, accessibility needs, language, risk, and expert workflows demand closer participant matching.
- **Qualitative speed vs. quantitative confidence** — a few sessions are excellent for finding causes and generating fixes, but controlled comparison, prevalence estimates, and high-consequence decisions require stronger research designs.
- **Minimal fix vs. systemic redesign** — prefer the smallest correction that removes the observed obstacle unless repeated failures reveal a broken mental model or information architecture.

## Sources

- [**Don't Make Me Think, Revisited** — Krug](../Books/Usability/45-Dont-Make-Me-Think-Revisited.md) — scanning behavior, visual hierarchy, navigation, concise content, mobile usability, goodwill, accessibility, and inexpensive testing.
- [**Rocket Surgery Made Easy** — Krug](../Books/Usability/46-Rocket-Surgery-Made-Easy.md) — lightweight recruiting, task design, facilitation, observation, debriefing, prioritization, and iterative follow-through.
- [**WCAG 2.2**](../Standards/09-WCAG.md) — the accessibility floor that usability review complements rather than replaces.
- [**Specification by Example**](../Books/Testing/28-Specification-by-Example.md) — concrete goals and observable outcomes that help turn product intent into realistic research tasks.

## What the skill encodes

- [ ] Primary tasks and actions are discoverable from hierarchy, labels, and affordances.
- [ ] Navigation and state answer where the user is, what is available, and how to recover.
- [ ] Copy supports decisions without needless words, internal jargon, or hidden consequences.
- [ ] Feedback, errors, defaults, and reversibility preserve confidence and user control.
- [ ] Findings distinguish observed evidence, heuristic risks, and subjective preference.
- [ ] User testing uses representative-enough participants, realistic tasks, neutral facilitation, and an explicit fix-and-retest loop.
- [ ] Accessibility issues route to `mithril-accessibility`; consequential research claims route to stronger methods when lightweight testing cannot support them.

## Connects to

[19 — Accessibility](19-Accessibility.md) (whether diverse users can operate the interface) · [10 — Specification](10-Specification-by-Example.md) (task goals and observable outcomes) · [02 — Professional Discipline](02-The-Professionals-Discipline.md) (short evidence loops and replanning) · [11 — Code Review](11-Code-Review.md) (UI review findings grounded in consequences rather than taste).
