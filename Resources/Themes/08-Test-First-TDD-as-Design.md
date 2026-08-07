# 08 — Test-First: TDD as Design

> **Tier 4 · Verification.** The red-green-refactor discipline, the outside-in school that grows architecture from acceptance tests, and the honest account of the classical-vs-London split. Tests as a *design pressure*, not just a safety net. **Skill:** [`skills/test-quality.md`](../../skills/test-quality.md) (TDD indicators) · agent `mithril-test-quality`.

## The idea in one paragraph

Test-driven development is a design practice that happens to produce tests. Beck's loop — write a failing test (**red**), make it pass with the simplest thing that could work (**green**), then improve the structure under the net (**refactor**) — works in deliberately small steps, keeping the code demonstrably working every few minutes and forcing interfaces to be designed from the *caller's* side before an implementation exists to bias them. Martin's Three Laws compress the loop to its enforcement form (no production code without a failing test; no more test than suffices to fail; no more production code than suffices to pass). Freeman & Pryce scale it from the unit to the system: start every feature outside-in from a failing **acceptance test**, stand up a **walking skeleton** (the thinnest end-to-end slice, built and deployed for real) before any feature is thick, and use mocks not as isolation tape but as an interface-discovery tool — **mock roles, not objects**. Their deepest contribution is ch. 18's *listen to the tests*: when a test is hard to write — too much setup, too many collaborators to fake, no way to observe the outcome — the *design* is what's complaining, and simplifying the test by improving the design is the whole feedback loop working as intended. The field's honest split — classical (Detroit) vs. London (mockist) — is a real difference in what "unit" means; Khorikov's adjudication (mock only at boundaries you don't own; verify state, not conversation) is this framework's default.

## The arc (how the ideas build)

- **The loop and its size** (Beck, *TDD by Example*) — red-green-refactor in baby steps: the increment is one *behavior*, not one method; "fake it till you make it" and triangulation are legitimate gears. The discipline's payoff is psychological as much as technical — the next step is always small, known, and reversible.
- **The loop, legislated** (Martin, *The Three Laws of TDD*; *TDD* article) — the three laws turn the loop into a rule an agent (or reviewer) can check evidence of: production changes trace to failing tests; tests and code grow in interlocking slivers.
- **Two test layers, one feedback system** (Martin, *Agile Software Development* chs. 2, 4) — programmer tests guide small design decisions and protect refactoring, while customer acceptance tests decide whether a story is complete. XP connects them through short iterations and continuous integration: acceptance tests pull from the outside, programmer tests drive the inside, and neither layer substitutes for the other.
- **Outside-in: start where the user is** (Freeman & Pryce, GOOS) — the first test of a feature is an end-to-end acceptance test that fails for the *right reason*; unit tests are then driven inward from it. The **walking skeleton** builds/deploys/tests the thinnest possible slice through the real architecture first — infrastructure risk is retired before features exist (Theme 14 inherits this).
- **Mocks as design probes** (GOOS; Fowler, *Mocks Aren't Stubs*) — in the GOOS school, writing a test with a mock is how you *discover* the collaborator's interface: name the role, let the test demand the methods the role needs. This is interface design happening in the test file — which only works when mocking **roles you own**, not concrete third-party classes.
- **Listen to the tests** (GOOS ch. 18 — the organizing principle) — hard-to-test is design feedback, never a testing problem: an object needing ten dependencies is too coupled; needing to expose internals to assert means missing an observable outcome; a bloated setup means a missing abstraction. The response is always to fix the design, not to reach for a more powerful mocking tool.
- **The two schools, named honestly** (Khorikov ch. 2; Fowler) — **classical/Detroit**: the unit is a *behavior*; use real collaborators; isolate tests from each other; verify state. **London/mockist**: the unit is a *class*; mock all collaborators; verify interactions. London localizes failures beautifully but couples tests to implementation structure — the refactoring-brittleness Theme 09 measures. This framework's default is classical, with GOOS-style role mocks reserved for genuine boundaries.
- **The caveats that keep it honest** (Ousterhout, APOSD ch. 19; Fowler, *Is Design Dead?*) — TDD executed tactically (test-pass myopia, no refactor step) accretes complexity like any other tactical programming; emergent design still requires design judgment applied *continuously* (Fowler's answer to "is design dead?" is no — it moved into the refactor step). The refactor third of the loop is where Themes 03 and 04 live; skip it and TDD becomes a test-generation ritual.

## Tensions worth keeping

- **Classical ⇄ London.** Not a style war but a trade: failure localization vs. refactoring robustness. Default classical; go mockist only at owned-role boundaries (GOOS's actual position, often misquoted).
- **Test-first dogma ⇄ design judgment.** The loop produces feedback, not design; APOSD's warning stands — a green suite over a tactical design is still a tactical design.

## The sources

- ★ [**Test-Driven Development: By Example** — Beck](../Books/Testing/14-Test-Driven-Development-By-Example.md) — the loop, baby steps, the two classic worked examples.
- [**Agile Software Development** — Martin](../Books/Engineering-Culture-Process/44-Agile-Software-Development.md) — XP as the surrounding system, programmer vs. acceptance tests, and the bowling-calculator programming episode.
- ★ [**Growing Object-Oriented Software, Guided by Tests** — Freeman & Pryce](../Books/Testing/15-Growing-Object-Oriented-Software-Guided-by-Tests.md) — outside-in, walking skeleton, mock roles, and ch. 18's listen-to-the-tests.
- [**Unit Testing: Principles, Practices, and Patterns** — Khorikov](../Books/Testing/27-Unit-Testing-Principles-Practices-Patterns.md) — ch. 2: the schools, adjudicated.
- [**The Three Laws of TDD** — Martin](../Articles/Robert-Martin/04-The-Three-Laws-of-TDD.md) and [**Test Driven Development** — Martin](../Articles/Robert-Martin/03-Test-Driven-Development.md) — the loop as professional discipline.
- [**Mocks Aren't Stubs** — Fowler](../Articles/Martin-Fowler/13-Mocks-Arent-Stubs.md) — the taxonomy and the classical/mockist framing.
- [**Is Design Dead?** — Fowler](../Articles/Martin-Fowler/04-Is-Design-Dead.md) — where design lives in an evolutionary process.

## What the skill encodes (operational checklist)

- [ ] Look for test-first evidence: does each production behavior change come with a test that would fail without it?
- [ ] New features start from a failing acceptance-level test where the harness exists (outside-in); flag thick features on untested infrastructure (missing walking skeleton).
- [ ] Hard-to-test code is reported as a *design* finding (name the coupling/missing seam), never as "add a more powerful mock."
- [ ] Mocks verify roles at owned boundaries; mocking concrete internals or third-party types is a finding (school violation + brittleness).
- [ ] State verification preferred over interaction verification unless the interaction *is* the requirement.
- [ ] The refactor step left evidence: if tests were added but the structure they strained against is untouched, say so.

## Connects to

[04 — Smells, Refactoring & Legacy Rescue](04-Smells-Refactoring-and-Legacy-Rescue.md) (the refactor third of the loop) · [09 — Test Quality](09-Test-Quality.md) (what the tests the loop produces must look like) · [10 — Specification by Example](10-Specification-by-Example.md) (the acceptance test that starts the outside-in descent) · [14 — Delivery](14-Delivery.md) (the walking skeleton becomes the pipeline's first citizen).
