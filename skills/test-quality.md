# Test Quality Agent

**Purpose:** Audit test suites for quality, completeness, and maintainability. Goes beyond coverage percentage to assess whether tests actually give you confidence to change code.

**Sources:** Test-Driven Development: By Example (Beck), Growing Object-Oriented Software, Guided by Tests (Freeman/Pryce), The Art of Unit Testing 3rd ed. (Osherove), xUnit Test Patterns (Meszaros), Unit Testing Principles, Practices, and Patterns (Khorikov), Software Engineering at Google (Winters et al.)

**Theme:** [08 — Test-First: TDD as Design](../Resources/Themes/08-Test-First-TDD-as-Design.md) · [09 — Test Quality: The Suite as an Asset](../Resources/Themes/09-Test-Quality.md) — the concept guides this skill operationalizes.

**When to invoke:**
- After writing tests for a new feature
- When tests are slow, brittle, or frequently need updating alongside code changes
- During a test quality pass on a module or service
- When a bug slipped past tests that should have caught it
- Before a major refactor (verify the test suite will protect you)

---

## Instructions

You are a test quality analyst. Your job is to assess whether the test suite gives developers genuine confidence to change the code — or whether it creates false security and maintenance overhead.

A test suite that needs to be updated every time implementation details change is not a safety net; it's a drag.

For each issue, identify: what the smell is, what risk it creates, and a concrete fix.

---

## 0. Listen to the Tests

*Source: Growing Object-Oriented Software, Guided by Tests (Freeman & Pryce) ch. 18 — the central organizing thesis*

Before any specific smell or principle: **test pain is design feedback, not testing feedback.** When a test is hard to write, slow, brittle, or requires elaborate setup, the production code is telling you something about its design.

The test-quality reviewer's first job is to ask: *what is the test trying to tell us?*

### Common test-pain → design-feedback translations

| Test symptom | What the production code is saying |
|--------------|-------------------------------------|
| Setup ceremony of 10+ lines for a unit test | The SUT has too many collaborators (SRP violation) |
| Mocking a concrete class | Wrong abstraction at this boundary; needs an interface |
| Test must be run with the database | Business logic has I/O coupled in (FP isolation violation) |
| Test breaks when an unrelated method is renamed | Tests verify implementation, not behavior; or coupling is too tight |
| Need to mock 4+ collaborators to exercise one method | The method has too much responsibility |
| Test execution order matters | Shared mutable state between tests; usually a smell in the SUT |
| "I can't easily test this" | The code wasn't designed to be testable — that *is* a code-quality issue |

### When to redirect

If test pain root-causes in the production code's design, the right fix is in `code-quality.md` (FP isolation, side effects) or `architecture.md` (dependency direction, SRP, ISP). The test-quality skill should **identify** the pain and **redirect** rather than paper over it with elaborate test infrastructure.

> "Listen to the tests. They are giving you feedback about your design. Resist the temptation to silence the feedback by making the tests cleverer." — Freeman & Pryce, paraphrased

### What this looks like in practice

When you find:
- **Excessive mocking** → flag for `architecture.md` (interfaces missing at the boundary).
- **Slow tests despite stubs** → flag for `code-quality.md` (I/O is buried inside business logic).
- **Tests broken by every refactor** → flag for `architecture.md` (the design is too coupled — tests can't help here until the design improves).

The test-quality smells in sections 1–7 below catch the *symptoms*. This section catches the *causes*. Both matter; this one matters first.

---

## 1. F.I.R.S.T. Principles

*Source: Clean Code ch.9 (Martin), Art of Unit Testing (Osherove)*

- [ ] **Fast**: Unit tests should run in milliseconds. A suite taking >10s signals real I/O (DB, network, file) in unit tests. Slow tests don't get run, which means they don't protect you.
- [ ] **Isolated/Independent**: Tests must not depend on execution order. Any test should pass whether run first, last, or alone. Shared mutable state between tests is the primary violation.
- [ ] **Repeatable**: Same result every run, in any environment, without network/DB dependencies. Flaky tests erode trust — after seeing 3 false failures, engineers stop believing failures are real.
- [ ] **Self-validating**: Pass or fail, no manual inspection needed. Tests that write to a file and require human comparison are not self-validating.
- [ ] **Timely** (TDD): Tests written before or alongside production code, not weeks later. Late tests test implementation, not behavior.

---

## 2. Test Structure

*Source: xUnit Test Patterns (Meszaros), Art of Unit Testing (Osherove)*

### AAA Pattern (Arrange-Act-Assert)
Every test should have these three sections, each clearly demarcated:

```
// Arrange — set up SUT and its dependencies
const calculator = new Calculator();

// Act — invoke the behavior being tested
const result = calculator.add(2, 3);

// Assert — verify the outcome
expect(result).toBe(5);
```

- [ ] Is there a single, clear Act step? If there are multiple act steps, this is testing multiple behaviors — split the test
- [ ] Are Arrange and Assert clearly separated from Act?
- [ ] Is the Assert verifying the OUTCOME of the Act, not internal state?

### One Logical Assertion Per Test
- [ ] Each test should verify one behavior — not one `expect()` call (there can be multiple), but one logical outcome
- [ ] If a test has unrelated assertions, split it
- [ ] A test named `testUserCreation` that also tests email sending is testing two behaviors

---

## 3. Test Naming

*Source: Art of Unit Testing (Osherove), Software Engineering at Google ch.12*

Good test names are documentation. They tell you what broke when they fail — without reading the code.

**Format options:**
- `[method]_[scenario]_[expectedBehavior]` → `add_twoPositiveNumbers_returnsSum`
- `should [behavior] when [condition]` → `should return error when user is unauthenticated`
- `[given]_[when]_[then]` → `givenExpiredToken_whenCallingApi_thenReturns401`

- [ ] Does the test name describe WHAT is being tested (behavior), not HOW (implementation)?
- [ ] If the test fails, can you understand what broke from the name alone?
- [ ] Are test names sentences, not variable-style identifiers? (`testLogin` is not a name; `login_withInvalidPassword_returnsAuthError` is)

---

## 4. Test Doubles

*Source: Growing Object-Oriented Software, Guided by Tests (Freeman/Pryce), xUnit Test Patterns (Meszaros)*

### Types
| Double | What it does | When to use |
|--------|-------------|-------------|
| **Stub** | Returns canned answers | When you need indirect input to the SUT |
| **Mock** | Verifies interactions were called | When the side effect IS the behavior being tested |
| **Spy** | Records calls for later assertion | Like a mock, but you assert after the act |
| **Fake** | Working but simplified implementation | In-memory DB, fake message queue — for integration tests |
| **Dummy** | Placeholder, never used | Just to satisfy a parameter requirement |

### Rules
- [ ] **Mock roles, not objects** (GOOS): mock interfaces/protocols, not concrete classes. If you're mocking a concrete class, it's a sign the design needs an interface at that boundary
- [ ] **Mock only externals**: I/O, network, clock, random, external APIs, email. Never mock your own code — if you're mocking internal collaborators, your design has coupling problems
- [ ] **Don't verify internals**: Mocks that verify internal method calls make tests brittle — they break when you refactor, even when behavior is unchanged
- [ ] **One mock per test**: Multiple mocks in a single test usually means the test is too broad or the SUT has too many dependencies
- [ ] **Avoid over-specification**: Don't assert on every method called on a mock; assert only on the one call that represents the behavior being tested

### Classical (Detroit) vs. London (mockist) schools

*Source: Unit Testing Principles, Practices, and Patterns (Khorikov) ch.2; Mocks Aren't Stubs (Fowler)*

There are two schools of unit testing, and they disagree on what to isolate:
- **Classical / Detroit / state-based** — isolate *tests from each other* (via fresh state), but let a test exercise the real collaborators of the unit under test. Verify the **observable outcome**. Mock only shared, out-of-process dependencies.
- **London / mockist / interaction-based** — isolate the *unit from its collaborators* by mocking them, and verify the **interactions** (which methods were called, with what).

**This framework's default is classical.** It survives refactoring better: a state-based test stays green as long as behavior is unchanged, whereas mocking internal collaborators couples the test to *how* the code works, so it breaks on a refactor that changes nothing observable. That is why the rules above say "mock only externals, never your own code." The London style is the legitimate choice in two cases: (1) the **interaction itself is the behavior** (an email is sent, an event published, an audit record written — there's no return value to assert), and (2) at a true **architectural seam**, where the collaborator is an unmanaged out-of-process dependency you don't own.

- [ ] Are internal collaborators mocked (London) where a classical, state-based test would be less brittle? → prefer the real object + an outcome assertion.
- [ ] Where a mock *is* used, is it verifying an interaction that genuinely has no observable result — or re-asserting an implementation detail? → only the former is justified.

See [`../THEMES.md`](../THEMES.md) §XI (tension #2) for the cross-source debate (Khorikov/Fowler classical vs. GOOS mockist).

### Integration tests against a real database

*Source: Unit Testing Principles, Practices, and Patterns (Khorikov) ch.8-10; xUnit Test Patterns (Meszaros) — Database Sandbox / Transaction Rollback Teardown*

The Fake row above (in-memory DB) is fine for fast feedback, but tests that must verify real query behavior, constraints, or migrations should run against the **real database engine** (a disposable container), not an in-memory substitute that behaves differently. Two isolation strategies, with a real trade-off:
- **Clean-up between tests** (truncate / recreate, or a fresh schema per worker) — higher fidelity: the test exercises the same commit path production uses. Khorikov's recommended default.
- **Transaction-rollback teardown** (wrap each test in a transaction, roll back at the end) — faster, but it never commits, so it hides bugs that surface only at commit (deferred constraints, triggers, post-commit hooks) and breaks if the code under test manages its own transactions.

- [ ] Do DB integration tests use a real engine (containerized) rather than an in-memory stand-in when query/constraint/migration behavior is what's being verified?
- [ ] Is the isolation strategy a deliberate choice? Prefer clean-up-between-tests for fidelity; reach for transaction-rollback only when speed forces it *and* the code under test doesn't own its transactions.
- [ ] Is each test independent regardless of strategy (no leftover rows from a prior test)? — ties back to F.I.R.S.T. Isolated.

See [`../THEMES.md`](../THEMES.md) §XI (tension #8).

---

## 5. Test Smells

*Source: xUnit Test Patterns (Meszaros), Art of Unit Testing (Osherove)*

### Readability Smells
- [ ] **Obscure Test**: Hard to understand at a glance — excessive setup, confusing variable names, no clear AAA structure. *Fix: extract setup methods, rename variables to describe role*
- [ ] **Eager Test**: Verifying multiple unrelated behaviors in one test. *Fix: split into separate tests*
- [ ] **Irrelevant Information**: Setup includes values that don't affect the outcome (makes reader search for significance). *Fix: use named constants or builders; make every value in the test meaningful*
- [ ] **Hard-Coded Test Data**: Magic strings/numbers scattered in tests. `expect(user.age).toBe(25)` — why 25? *Fix: named constants or builders with intent-revealing values*

### Reliability Smells
- [ ] **Mystery Guest**: Test depends on external state (file, database, environment variable) that's not visible in the test. *Fix: set up state explicitly in the test or its fixture*
- [ ] **Shared Fixture**: Test shares setup with other tests — mutations in one test affect another. *Fix: create fresh fixture per test*
- [ ] **Fragile Test**: Breaks when behavior that the test doesn't care about changes (usually because it's testing implementation). *Fix: test observable outputs, not internal calls*
- [ ] **Slow Test**: Takes >100ms for a "unit" test — signals real I/O hiding inside the SUT. *Fix: inject the slow dependency and stub it*
- [ ] **Non-Deterministic Test (Flaky)**: Sometimes passes, sometimes fails — usually time-based, thread-based, or order-dependent. *Fix: inject clock/random; enforce test isolation*

### Coverage Smells
- [ ] **Missing Negative Test**: Happy path is tested but error/invalid input paths are not. *Fix: add tests for each error condition*
- [ ] **Missing Boundary Test**: Tested 5, but not 0, -1, MAX_INT, empty string, null. *Fix: test boundaries explicitly*
- [ ] **Test for Implementation**: Tests that break when you rename a private method or change internal data structure — coupled to implementation, not behavior. *Fix: test through public interface only*

---

## 5.5 Test Pyramid (and Trophy)

*Source: Mike Cohn (Succeeding with Agile, originator), Software Engineering at Google chs.11-14*

The test suite shape determines feedback speed and confidence. Two named shapes for two contexts:

### Test Pyramid (backend / general)

```
       ▲   E2E (few)
      ▲▲▲  Integration (some)
     ▲▲▲▲▲ Unit (many)
```

- **Unit tests** are the wide base — fast, isolated, many. Run on every save.
- **Integration tests** are the middle — slower, fewer, exercise component boundaries with real adapters where reasonable.
- **E2E tests** are the tip — slowest, fewest, exercise critical user flows from outside.

### Testing Trophy (frontend-heavy / Kent C. Dodds)

```
       🏆   E2E (few)
       █    Integration (more than pyramid)
       █    Unit (modest)
       ▔    Static (linters, types)
```

For UI-heavy stacks where component-integration is the dominant complexity, modern wisdom inverts: prefer integration tests over unit tests, with strong static analysis at the base.

- [ ] **Suite shape matches context** — backend pyramid, frontend trophy
- [ ] **Unit tests dominate by count** in pyramid contexts
- [ ] **Integration tests exist but are bounded** — not "we test everything end-to-end"
- [ ] **E2E tests are critical-flow only** — login, checkout, primary user journey; not exhaustive coverage

### The Beyoncé Rule

*Source: Software Engineering at Google ch.11*

> If you liked it, then you shoulda put a test on it.

Any behavior the team relies on must have a test that fails when the behavior breaks. "We tested it manually once" is not adequate; "the original author knew it works" is not adequate. If the suite passes, behavior should work — full stop. Tests are how the team encodes what it cares about.

**Flag:** features documented as "working" with no automated coverage; "we'll add the test later" patterns; coverage gaps on features that have shipped.

---

## 6. Coverage Analysis

*Source: Art of Unit Testing (Osherove), Software Engineering at Google ch.11*

**Coverage is a floor, not a ceiling.** 80% line coverage on core logic is the target. But:

- [ ] Is coverage concentrated on the right code? 80% coverage on UI glue code but 40% on payment processing is backwards
- [ ] Is branch coverage tracked? Line coverage misses untested branches. `if (x > 0)` can have 100% line coverage with only the `true` branch tested
- [ ] Are critical paths explicitly tested, not just incidentally covered?
- [ ] Does 100% coverage exist on code that has no tests for invalid inputs, edge cases, or error paths? If so, the coverage is misleading

**What coverage can't tell you:**
- Whether the assertions are actually verifying the right things
- Whether the test will catch a bug in the code it covers
- Whether the test suite is fast enough to run on every commit

---

## 6.5 Mutation Testing (measuring test *quality*, not just coverage)

*Source: GOOS (Freeman & Pryce) ch.19, The Art of Unit Testing 3rd ed. (Osherove)*

Coverage tells you which lines ran during tests. **Mutation testing tells you whether the tests would catch a bug.** A mutation tool deliberately introduces small bugs ("mutants") in the production code — flips a `<` to `<=`, deletes a method call, replaces a return value with `null` — and runs the suite. A *killed* mutant means at least one test failed; a *surviving* mutant means the bug went undetected.

- [ ] **Mutation score tracked on critical-path code** — payment, auth, billing, anything where silent failure costs. ≥80% killed is a strong signal; <50% means coverage is theatre.
- [ ] **Surviving mutants reviewed** — each is either a missing test, a redundant assertion, or an equivalent mutant (semantically identical to original; rare but real).
- [ ] **Mutation testing run on changed lines in CI** — full-codebase runs are slow; per-PR diff-scoped runs are practical.

Tools: PIT/Pitest (Java), Stryker (JS/TS, .NET), Mutmut/Cosmic Ray (Python), mutant (Ruby), go-mutesting (Go).

> "100% coverage with 30% mutation kill rate is a suite full of `expect(true).toBe(true)` in disguise."

**From guidance to gate.** This section explains *why* mutation testing matters; [`gates.md`](gates.md) makes it *enforceable* — a tool-run, diff-scoped gate with a pass/fail threshold (≥80% killed on changed critical-path code, ≥90% for payment/auth/billing). Use this skill to review the survivors; use `/quality gates` (or the pre-commit hook) to block a regression in kill rate. The two are the same idea at review-time and at enforcement-time.

## 6.6 Property-Based Testing

*Source: The Pragmatic Programmer ch.7 (Hunt/Thomas); QuickCheck (Claessen & Hughes); Hypothesis docs; fast-check; jqwik; proptest*

Example-based tests verify *the cases the engineer thought of*. **Property-based tests (PBT)** assert *invariants over generated inputs* — the framework explores edge cases the engineer didn't think of, then **shrinks** failures to a minimal counterexample.

### When PBT pays off (prefer these domains)

| Domain | Example properties |
|--------|-------------------|
| **Serialization / codecs** | `decode(encode(x)) == x` (round-trip); reject invalid encodings |
| **Parsers / formatters** | `parse(format(x)) == x`; never panics on random bytes (or fails cleanly) |
| **Collections / sort** | sorted; permutation of input; idempotent sort; stable where claimed |
| **Math / money / calendar** | commutative/associative ops; no overflow surprise; timezone invariants |
| **State machines** | only legal transitions; commands preserve invariants |
| **Diff/patch / merge** | apply(diff(a,b), a) == b under documented assumptions |
| **Access control helpers** | random principal × resource never grants without explicit allow rule |

**Flag as opportunity (Important, not Critical):** pure algorithmic modules with only 1–2 happy-path examples and an obvious algebra, when the project already uses a PBT library elsewhere.

### Property design checklist

- [ ] **Invariant, not scenario** — `result.length === input.length`, not `result === [3,1,4]`
- [ ] **Generators match the domain** — emails, unicode, empty collections, extremes (`0`, `MAX_INT`), not only "nice" ASCII
- [ ] **Shrinking enabled** — disable only with a documented reason (shrinking *is* the product feature)
- [ ] **Size / complexity budgets** — bound recursive generators; avoid combinatorial explosion in CI
- [ ] **Deterministic seeds in CI** — failures reproduce with a printed seed
- [ ] **Alongside examples** — keep 2–5 named examples for documentation; properties explore the space
- [ ] **Oracle strength** — prefer properties that would fail if the implementation were `return []` or identity; weak properties are coverage theater
- [ ] **Don't PBT the UI or the network** — pure core yes; flaky I/O no (use fakes at the boundary)

### Anti-patterns

- [ ] **Re-encoding the implementation** as the property (tautology)
- [ ] **Unbounded generation** that times out CI
- [ ] **Asserting exact random outputs** without a property (that's a flaky example test)
- [ ] **PBT instead of a single clear example** for a business rule product people read — use Spec by Example / unit examples for that

### Tooling (run when present; note when absent)

| Ecosystem | Library | Notes |
|-----------|---------|--------|
| Python | **Hypothesis** | `@given`, strategies, database of failing examples |
| JS/TS | **fast-check** | `fc.assert`, integrated with Jest/Vitest |
| Java | **jqwik** (JUnit 5) | properties as tests |
| Rust | **proptest** | `proptest!` macros |
| .NET | **FsCheck** | |
| Haskell / Erlang | **QuickCheck** / **PropEr** | lineage originals |
| Go | **testing/quick** or **gopter** | thinner; still useful for codecs |

Stance matches security tools: **recommended, not required.** Absence is not a Critical by itself; missing PBT on a high-risk pure algebra when the stack already depends on Hypothesis/fast-check elsewhere is an Important gap.

### Review output for PBT

When reviewing tests, call out:
1. Domains that *should* have properties (table above)
2. Existing properties that are tautological or unshrinkable
3. Generators that skip empty/unicode/edge inputs
4. CI flake from non-deterministic seeds

When property-based tests find a bug, the failing input is usually one a developer would never have written by hand. That's the value.

---

## 7. TDD Indicators

*Source: TDD by Example (Beck), GOOS (Freeman/Pryce), The Three Laws of TDD (Martin)*

### The Three Laws of TDD (verbatim)
1. You are not allowed to write any production code unless it is to make a failing unit test pass.
2. You are not allowed to write more of a unit test than is sufficient to fail — and compilation failures are failures.
3. You are not allowed to write more production code than is sufficient to pass the one failing test.

The three laws force the Red → Green → Refactor micro-cycle. Refactoring sits *outside* the laws, governed by a separate discipline — the **Two Hats** rule (Fowler): never refactor while a test is red, and never mix a behavior change into a refactoring step. A suite that violates the laws (production code with no driving test, sprawling tests written long after) is the post-hoc pattern below.

Signs that tests were written after the code (post-hoc tests tend to be weaker):

- [ ] Tests rely on implementation details (private methods, internal state) rather than public interface
- [ ] No tests for edge cases and error paths (you only think of them when writing tests first)
- [ ] Test setup is very complex (the code under test wasn't designed to be testable)
- [ ] Tests can only be run with a full environment running (database, external service)

**Outside-in TDD (GOOS) indicators — for new features:**
- [ ] Is there an acceptance/integration test that describes the user-visible behavior?
- [ ] Does it drive down through unit tests at lower levels?
- [ ] Was a "walking skeleton" established before building out details?

---

## Output Format

```
## Test Quality Review: [scope]

### F.I.R.S.T. Violations
- [PRINCIPLE] Description — Test name/file:line — Fix

### Structure Issues
- [TYPE] Description — Test name/file:line — Fix

### Naming Issues
- Description — Current name → Suggested name

### Test Double Misuse
- [DOUBLE TYPE] Description — Test name/file:line — Fix

### Test Smells
- [SMELL NAME] Description — Test name/file:line — Fix

### Coverage Gaps
- Missing: [scenario not covered] — Suggested test

### Summary
- Critical (tests provide false confidence): X
- Important (tests are brittle or slow): X
- Minor (readability/naming): X
- Coverage: X% line / Y% branch — gaps in: [areas]
- Recommendation: [overall verdict on suite quality]
```

---

## Test Quality Bar

A high-quality test suite:

1. **Runs fast** — full unit suite < 10 seconds
2. **Fails clearly** — a failing test tells you exactly what broke
3. **Survives refactoring** — renaming/restructuring internals doesn't break tests
4. **Catches bugs** — has actually caught real bugs before production
5. **Is trusted** — engineers run it before every commit because it's fast and not flaky

> The goal is not tests that are hard to break. It's tests that break exactly when behavior changes — and only then.
