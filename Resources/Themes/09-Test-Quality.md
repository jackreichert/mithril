# 09 — Test Quality: The Suite as an Asset

> **Tier 4 · Verification.** What separates a suite that enables change from one that punishes it: the four pillars, the double taxonomy, the smell catalog, flakiness eradication, and distribution strategy — with coverage demoted to what it really is. **Skill:** [`skills/test-quality.md`](../../skills/test-quality.md) · agent `mithril-test-quality` (mutation floor: [`skills/gates.md`](../../skills/gates.md)).

## The idea in one paragraph

A test suite is a codebase whose maintenance you've committed to forever; the only question is whether it pays rent. Khorikov gives the valuation model — every test scores on four pillars, **protection against regressions**, **resistance to refactoring**, **fast feedback**, and **maintainability**, and because the value is the *product*, a zero on any pillar zeroes the test: a brittle test that fails on every rename protects nothing, however thorough its assertions. Resistance to refactoring is the pillar teams lose first, and its cause is always the same — tests coupled to *implementation* (which methods were called, in what order) instead of *observable behavior* (what the caller can see). The craft baseline is Osherove's F.I.R.S.T. and AAA structure with behavior-named tests; the failure modes are Meszaros's smell catalog (Obscure Test, Eager Test, Mystery Guest, Fragile Test, Shared Fixture…); the doubles discipline is Fowler's taxonomy plus GOOS's "mock roles, not objects"; and the strategy layer — pyramid, trophy, honeycomb — is Fowler's point that the *shape* is contextual but the principle isn't: push tests as low as they can go while still testing something real. Two numbers keep everyone honest: coverage, which is only ever a *negative* indicator (low proves under-testing; high proves nothing), and **mutation score**, the oracle that measures whether the suite actually notices when the code lies (GOOS ch. 19; enforced at the gates).

## The arc (how the ideas build)

- **The baseline: F.I.R.S.T. + AAA** (Osherove; Clean Code ch. 9) — Fast, Independent, Repeatable, Self-validating, Timely; Arrange-Act-Assert with **one act per test** and a name that states the business behavior and expected outcome (`delivery_with_past_date_is_invalid`), so a failure reads as a spec violation without opening the file.
- **The valuation model: four pillars, multiplied** (Khorikov ch. 4 ⭐) — protection against regressions (does it exercise meaningful code?), resistance to refactoring (does it survive structure changes that preserve behavior?), fast feedback, maintainability. Multiplicative: maximize the minimum, not the average. The first two trade off — the art is refusing false positives (failures without broken behavior) without giving up real coverage.
- **Test behavior, not implementation** (Khorikov; GOOS) — the anti-brittleness rule: assert on outcomes observable at the API the caller uses; treat private methods and call sequences as none of the test's business. Every interaction assertion is a bet that the conversation *is* the requirement — usually it isn't.
- **Doubles, precisely** (Fowler, *Mocks Aren't Stubs*; Osherove; xUnit Patterns ch. 11) — dummy / fake / stub / spy / mock are different tools: stubs feed inputs (queries), mocks verify outputs (commands). GOOS's rule bounds their use: mock **roles you own** at boundaries; never third-party concretes, never internals. Over-mocking is the London-school failure mode surfacing as pillar-two collapse.
- **The smell catalog** (Meszaros, xUnit Patterns) — Obscure Test (can't tell what's asserted), Eager Test (many behaviors in one), Mystery Guest (behavior depends on unseen external state), Fragile Test, Erratic/Flaky Test, Slow Test, Hard-Coded Test Data, Shared Fixture coupling. Naming the smell turns "this test is annoying" into a finding with a known fix.
- **Flakiness is eradicated, not managed** (Fowler, *Eradicating Non-Determinism in Tests*) — root causes are finite: lack of isolation, async waits done with sleeps instead of polling/callbacks, time and date dependence, remote services in the loop, resource leaks. Quarantine is triage (keep the suite trusted while you fix), never a destination — a permanently quarantined test is a deleted test with extra steps.
- **Shape follows context** (Cohn's pyramid; Vocke's *Practical Test Pyramid*; Dodds's trophy; Fowler's *Shapes of Testing*) — the pyramid's real claims survive every re-drawing: lower tests are faster and more precise; the anti-pattern is the ice-cream cone (manual + E2E heavy). The trophy's integration-heavy middle is right where units are trivial glue. The debate is semantic ("what's a unit?" — solitary vs. sociable); the principle is cost-per-signal.
- **The honest numbers** (Khorikov ch. 1; GOOS ch. 19; SE@G ch. 11) — coverage is a negative indicator and a corrupting target (Theme 13); mutation testing asks the question coverage can't: *if the code changes behavior, does anything fail?* The Beyoncé Rule assigns ownership: if you liked it, you shoulda put a test on it — unprotected behavior is fair game for breakage.

## Tensions worth keeping

- **Protection ⇄ resistance.** More assertions catch more regressions and break on more refactors. Resolve toward observable behavior: assert everything the caller can see, nothing they can't.
- **Solitary ⇄ sociable units.** Both legitimate (Fowler, *UnitTest*); what's non-negotiable is that the choice is deliberate and the double count stays minimal.

## The sources

- ★ [**Unit Testing: Principles, Practices, and Patterns** — Khorikov](../Books/Testing/27-Unit-Testing-Principles-Practices-Patterns.md) — the four pillars and the behavior-vs-implementation rule.
- [**The Art of Unit Testing** — Osherove](../Books/Testing/16-The-Art-of-Unit-Testing.md) — F.I.R.S.T., AAA, the maintainable-test craft.
- [**xUnit Test Patterns** — Meszaros](../Books/Testing/17-xUnit-Test-Patterns.md) — the smell catalog and fixture strategies.
- [**GOOS** — Freeman & Pryce](../Books/Testing/15-Growing-Object-Oriented-Software-Guided-by-Tests.md) — ch. 18 listen to the tests; ch. 19 mutation as the coverage oracle.
- [**Mocks Aren't Stubs**](../Articles/Martin-Fowler/13-Mocks-Arent-Stubs.md) · [**UnitTest**](../Articles/Martin-Fowler/14-UnitTest.md) · [**Test Pyramid**](../Articles/Martin-Fowler/15-Test-Pyramid.md) · [**Eradicating Non-Determinism**](../Articles/Martin-Fowler/16-Eradicating-Non-Determinism-in-Tests.md) · [**Shapes of Testing**](../Articles/Martin-Fowler/17-Diverse-Fantastical-Shapes-of-Testing.md) — Fowler's testing bliki spine.
- [**Software Engineering at Google**](../Books/Engineering-Culture-Process/18-Software-Engineering-at-Google.md) — ch. 11: the Beyoncé Rule; testing culture at scale.
- [**Clean Code** — Martin](../Books/Canon/01-Clean-Code.md) — ch. 9: tests held to production standards.

## What the skill encodes (operational checklist)

- [ ] Score suspect tests against the four pillars; a zero on any pillar is the finding (name which).
- [ ] Assertions on private state, call order, or internal collaborators → behavior-coupling finding with the observable-outcome rewrite.
- [ ] Test names state behavior + expected outcome; `test1`/`testGetUser` style → finding.
- [ ] One act per test; multi-behavior tests split (Eager Test).
- [ ] Doubles audited: right kind (stub for queries, mock for commands), owned roles only, minimal count.
- [ ] Flaky patterns (sleeps, real clock, real network, shared mutable fixtures) → root-cause finding, not a retry annotation.
- [ ] Coverage cited only as a negative signal; missing-mutation-signal on critical logic → route to gates.
- [ ] New/changed behavior without a covering test → Beyoncé Rule finding.

## Connects to

[08 — Test-First](08-Test-First-TDD-as-Design.md) (the loop that produces these tests) · [10 — Specification by Example](10-Specification-by-Example.md) (the acceptance layer above) · [13 — Gates & Metrics](13-Gates-and-Metrics.md) (coverage floors and mutation scores, measured) · [03 — Readable Code](03-Readable-Code.md) (tests are code; Obscure Test is its readability failure).
