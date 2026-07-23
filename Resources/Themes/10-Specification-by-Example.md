# 10 — Specification by Example

> **Tier 4 · Verification.** The layer upstream of test quality: getting the *right* behavior specified before any code exists, as concrete examples that are simultaneously the requirement, the acceptance test, and documentation that cannot go stale. **Skill:** [`skills/specification.md`](../../skills/specification.md) · agent `quality-specification`.

## The idea in one paragraph

Most requirement failures aren't communication failures at review time — they're ambiguity failures at specification time: "the system shall handle invalid input gracefully" means five different things to five readers, and everyone discovers which one won at UAT. Adzic's answer, distilled from ~50 team case studies, is to specify with **key examples**: concrete, testable instances (`given a card expiring 2019-01, when charged 2020-06, then decline with EXPIRED`) that one artifact carries through three jobs — the requirement the business signs, the acceptance test the build executes, and the **living documentation** that stays true because the build fails when it diverges. The examples are *derived collaboratively* (the Three Amigos — business, development, testing — because the conversation is where edge cases surface), *refined* down to the minimal set that captures the rule with incidental detail removed, written **declaratively** in the domain's ubiquitous language (behavior, never UI clicks), and *automated through a thin glue layer* that leaves the spec text readable to the people who signed it. Given-When-Then is the standard grammar; Martin's acceptance-test discipline and Humble & Farley's automated acceptance stage make the examples the gate a change must pass; acceptance-level mutation asks whether the specs would even notice a wrong system.

## The arc (how the ideas build)

- **Derive scope from goals** (Adzic, pattern 1) — don't accept a feature list; start from the business goal and work back to the smallest scope that achieves it. Teams that understand *why* propose cheaper *whats*.
- **Specify collaboratively** (pattern 2) — Three Amigos workshops, because a spec written solo encodes one person's assumptions; the cross-examination *is* the requirements process. A Gherkin file written by a developer alone after the fact is automation, not specification.
- **Illustrate with examples; refine to key examples** (patterns 3–4) — replace every abstract "shall" with concrete cases, then distill: keep only examples that change the outcome, name the boundaries (the expiring-today card, the zero-quantity order), delete incidental detail. Exhaustive combinations belong to unit/property tests, not the spec.
- **Declarative, in the ubiquitous language** (Adzic; Evans) — `Given an overdrawn account`, not `When I click login and type…`. UI-scripted scenarios are brittle (theme 09's Fragile Test at the acceptance level) and bury the rule they exist to express. The vocabulary is DDD's ubiquitous language — specs are where it's negotiated (Theme 06).
- **Automate without changing the spec** (pattern 5) — the glue layer is thin, separate, and technical; the spec text stays business-readable. Assertions about implementation details in a feature file are a layering violation.
- **Validate frequently; let the documentation live** (patterns 6–7; Humble & Farley ch. 8; Martin, *Clean Coder* ch. 7) — specs run in the pipeline's acceptance stage on every change; a spec that doesn't run rots into fiction. When they run, they *are* the documentation — the only kind structurally incapable of going stale.
- **Test the specs themselves** (acceptance-level mutation) — mutate the system's behavior (or the examples' expected outcomes) and confirm the suite objects: specs that pass against a wrong system are decoration. The acceptance-level analogue of Theme 09's mutation oracle.

## Key concepts & frameworks

- **Key example** — one artifact, three jobs: requirement, acceptance test, documentation.
- **Three Amigos / specification workshop** — the collaboration pattern that surfaces edge cases pre-code.
- **Declarative vs. imperative scenarios** — business intent vs. UI mechanics; the single most common spec finding.
- **Given-When-Then / Gherkin** — one behavior per scenario; parameterize only what varies the outcome (Scenario Outlines for boundary families).
- **Thin automation layer** — glue code binds spec to system; spec text stays clean.
- **Living documentation** — validated continuously, organized by capability, the antidote to the stale wiki.
- **Executable specification as gate** — the acceptance stage (Theme 14) runs the business's own words against the build.

## The sources

- ★ [**Specification by Example** — Adzic](../Books/Testing/28-Specification-by-Example.md) — the seven process patterns and the case-study evidence. (Given-When-Then grammar from Dan North's BDD and the Cucumber lineage, covered in the summary.)
- [**The Clean Coder** — Martin](../Books/Clean-Architecture-Trilogy/09-The-Clean-Coder.md) — ch. 7: acceptance tests as the definition of done; ambiguity as professional negligence.
- [**Continuous Delivery** — Humble & Farley](../Books/Engineering-Culture-Process/19-Continuous-Delivery.md) — ch. 8: the automated acceptance-test stage.
- [**Domain-Driven Design** — Evans](../Books/Domain-Systems-Design/10-Domain-Driven-Design.md) — the ubiquitous language the examples are written in.

## What the skill encodes (operational checklist)

- [ ] Every scenario has a definite, testable outcome — "handles gracefully" and friends are findings.
- [ ] Imperative/UI-coupled steps → rewrite declaratively at the behavior level.
- [ ] One rule per scenario; scenarios asserting several rules are split.
- [ ] Parameters audited: only outcome-changing values parameterized; scene-setting constants moved to Background/setup.
- [ ] Vocabulary check against the domain language — spec terms that contradict the code's domain terms are a Theme 06 finding surfacing here.
- [ ] Boundary examples present (the edge the rule turns on), combinatorial exhaustion absent.
- [ ] Specs wired into the build (executed, not decorative); unexecuted feature files flagged as rotting documentation.
- [ ] Glue layer thinness: implementation assertions in feature files → layering finding.

## Connects to

[08 — Test-First](08-Test-First-TDD-as-Design.md) (the failing acceptance test that starts the outside-in loop) · [09 — Test Quality](09-Test-Quality.md) (the layer below; same brittleness physics) · [06 — DDD & Conway's Law](06-Domain-Driven-Design-and-Conways-Law.md) (the ubiquitous language, negotiated in examples) · [14 — Delivery](14-Delivery.md) (the acceptance stage that keeps the documentation alive) · [02 — The Professional's Discipline](02-The-Professionals-Discipline.md) (post-validation against *written* acceptance criteria).
