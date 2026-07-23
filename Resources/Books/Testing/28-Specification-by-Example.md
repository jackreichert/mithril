---
title: Specification by Example
author: Gojko Adzic
year: 2011
category: Testing
focus: Executable specifications, collaborative requirements, living documentation, BDD/ATDD
---

# Specification by Example — Gojko Adzic (2011)

How teams build the *right* software by turning requirements into concrete, testable examples that double as automated acceptance tests and as documentation that never goes stale. Adzic distilled the book from case studies of ~50 teams; the result is a set of named **process patterns** rather than a tool manual. It is the canonical reference behind ATDD, BDD (Dan North's Given-When-Then), and the Gherkin/Cucumber family. Where unit-testing books cover *how to verify code*, this one covers *how to specify behavior before there is code* — the layer upstream of `test-quality.md`.

The core idea: a single artifact — a **key example** — serves three jobs at once. It is the requirement (what the business wants), the acceptance test (executed against the system), and the documentation (a living description of how the system behaves). One source of truth, never diverging.

## The Key Process Patterns

The spine of the book — seven patterns teams converged on independently:

1. **Deriving scope from goals.** Don't take requirements as a fixed list of features. Start from the business goal, and collaboratively derive the scope (the features/examples) that achieve it. The team that understands the *why* proposes cheaper solutions than the ones handed down.
2. **Specifying collaboratively.** Requirements are written *together* by business, development, and testing — the "**Three Amigos**" — in specification workshops, not thrown over a wall. The conversation surfaces the assumptions and edge cases that a solo author misses.
3. **Illustrating using examples.** Replace abstract prose ("the system shall handle invalid input gracefully") with concrete examples (`given a card expiring 2019-01, when charged on 2020-06, then decline with EXPIRED`). Examples are unambiguous in a way descriptions never are.
4. **Refining the specification.** Distill the raw examples into **key examples**: the minimal set that captures the rule, each precise and self-explanatory, with *incidental* detail removed. Keep only the values that affect the outcome. Avoid scripts that describe UI clicks; describe *behavior*, declaratively.
5. **Automating validation without changing the specifications.** Make the examples executable, but keep the automation layer *thin* and *separate* — the spec text stays readable to non-programmers; a small glue layer binds it to the system. Don't pollute the specification with technical detail or assertions about implementation.
6. **Validating frequently.** Run the executable specifications continuously, against the real system, as part of the build. A spec that isn't run rots. Frequent validation is what keeps the examples honest and the documentation true.
7. **Evolving a living documentation system.** The validated specifications become the project's **living documentation** — always consistent with the running system because the build fails when they diverge. This replaces stale wikis and out-of-date requirement docs.

## What makes a good example / scenario

- **Key examples, not exhaustive ones.** Pick the examples that illustrate the *rule* and its boundaries; don't enumerate every combination (that's the unit/property tests' job).
- **Declarative, not imperative.** State the business intent ("given an overdrawn account") not the mechanics ("click login, type x, press submit"). Imperative, UI-coupled scenarios are brittle and obscure the requirement.
- **Precise and testable.** Every example must have a definite expected outcome. "Handles gracefully" is not an example.
- **One concept per scenario.** A scenario that tests several rules at once can't document any of them clearly.
- **Parameterize only what varies.** Fields that change the outcome become parameters; constants that are just scene-setting stay fixed or move to shared setup. Redundant parameters add noise and dilute the example's point.
- **Ubiquitous language.** Examples are written in the domain's vocabulary (DDD's ubiquitous language), so business and developers read the same words to mean the same thing.

## Gherkin / Given-When-Then (the BDD expression)

The most common executable form, from Dan North's BDD and the Cucumber lineage:

- **`Feature`** — the capability being specified.
- **`Scenario`** — one key example.
- **`Given`** (context/preconditions) → **`When`** (the action/event) → **`Then`** (the expected, observable outcome).
- **`Background`** — setup shared by every scenario in a feature, factored out so each scenario shows only what's distinctive.
- **`Scenario Outline` + `Examples`** — one scenario shape run over a table of parameter rows; the right tool when the same rule has several boundary cases.

## Common anti-patterns the book warns against

- **Specifications written after the code** — then they're just tests, not a shared requirement, and they encode whatever the code happens to do.
- **Imperative, UI-scripted scenarios** — slow, brittle, and they hide the business rule behind mechanics.
- **Incidental detail** — values in an example that don't affect the outcome make the reader hunt for what matters.
- **Automation leaking into specifications** — assertions about internal state, technical jargon, or implementation steps in the spec text break the "readable by the business" property.
- **Specifications that aren't run** — unvalidated specs drift from the system and become misleading documentation, worse than none.

## Relationship to the rest of the canon

- Sits **above** `test-quality.md`: acceptance-level executable specs drive the outside-in TDD loop (GOOS) that the test-quality skill assesses at the unit level.
- Pairs with **DDD** (`architecture.md`): both depend on a ubiquitous language shared by business and developers.
- The **Beyoncé Rule** (SE@Google) is the enforcement cousin: every relied-on behavior has a test; Specification by Example is *how* the team decides which behaviors matter and writes them down first.
