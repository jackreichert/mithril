# Cross-Cutting Themes — What the Whole Library Agrees (and Disagrees) On

A synthesis *across* the resource summaries in [`Resources/`](Resources/). Where [`CS-Best-Practices-Resources.md`](CS-Best-Practices-Resources.md) is the **per-resource index** ("which book owns which idea") and [`CONSTITUTION.md`](CONSTITUTION.md) is the **write-time rule set**, this document is the **horizontal cut**: the ideas that recur across many sources, the sources that back each one, and — most usefully — the places where the canon openly disagrees with itself. For the vertical cut — **20** per-theme deep guides in a Tier 1→5 curriculum, each ending in the operational checklist its skill encodes — see [`Resources/Themes/`](Resources/Themes/README.md) (including Theme 18 — Performance & Operability, Theme 19 — Accessibility, and Theme 20 — Usability).

> **How it was built.** Six readers each read one cluster of the library in full (Canon + Language; Architecture + Domain; Testing; Culture/Process; Articles; Standards + Papers) and extracted themes-with-citations. This document merges those into cross-cutting themes. Every theme lists the sources that actually state it — not generalized from memory. *(Extended 2026-06 with 13 books spanning concurrency, performance, reliability, functional programming, security, and distributed/DDD depth; extended 2026-08 with Martin's Agile Software Development, expanded standalone chapter summaries across the book library, and Krug's usability and lightweight user-testing practice.)*
>
> **How to read it.** Each theme is one paragraph of claim + the sources that converge on it + the tension, if any. The two most valuable sections are at the end: **§XI Map of Cross-Source Tensions** (where to expect a judgment call) and **§XII Near-Universal Consensus** (what you can treat as settled). When two themes pull apart, the tie-break order is [`CONSTITUTION.md` Article I](CONSTITUTION.md#article-i--conflict-precedence-the-tie-break-order).

---

## I. The Master Frame — Complexity Is the Enemy

Everything below is, ultimately, a tactic for keeping software understandable and changeable as it grows. This frame is stated most directly by **APOSD** ("the single goal of software design is managing complexity" — change amplification, cognitive load, unknown unknowns) and **Out of the Tar Pit** (state + control are the two great multipliers), grounded in **Brooks / No Silver Bullet** (*essential* complexity is inherent to the problem; *accidental* complexity is what our tools impose — and the easy 10× wins are mostly spent). **Code Complete** ("conquer complexity") and **Team Topologies** (cognitive load as the *governing* constraint on a team) carry the same idea up to the team scale, where Team Topologies' intrinsic/extraneous/germane load maps almost exactly onto Brooks's essential/accidental split.

**The fault line that runs through the whole library:** there are two opposed strategies for containing complexity, and most disagreements downstream are really about which one applies here.
- **Hide it** — Parnas information hiding, APOSD deep modules, OWASP ASVS control families, DDD bounded contexts. Wrap complexity behind a narrow contract.
- **Eliminate it** — Out of the Tar Pit (remove needless state/control), NASA Power of 10 (ban recursion, dynamic memory, unbounded loops), functional purity. Don't hide it; make it not exist.

Brooks is **pessimistic** about headroom (little accidental complexity left to remove); Moseley & Marks are **optimistic** (most current complexity is still accidental and removable). Same frame, opposite estimates of how much is fixable.

---

## II. Code-Level Craft

**Names are the primary carrier of meaning.** The single strongest consensus in the corpus — no dissent. Intention-revealing, specific over generic, units/constraints in the name, no `Manager`/`Data`/`Info` filler. *(Clean Code ch.2; Art of Readable Code ch.2–3; Code Complete ch.11; APOSD ch.14 "names are tiny abstractions"; Beck's rule 2 "reveals intention"; Uncle Bob & Google review rubric.)*

**Comments explain *why*, not *what*.** Agreement on the substance, sharp disagreement on attitude. Capture intent, invariants, trade-offs the code can't state; delete paraphrase. But **Clean Code** frames a comment as "a failure to express intent in code," while **APOSD ch.12** directly attacks that stance — "good code is self-documenting" is listed as one of "The Four Excuses," and writing comments *first* is treated as a design act. *(+ Code Complete ch.32; Art of Readable Code ch.5–6; Google review dimension 6.)*

**Functions/units do one thing — but "how small" is contested (see §XI).** One coherent responsibility at one level of abstraction. *(Clean Code ch.3; Art of Readable Code ch.10; Code Complete ch.7 cohesion hierarchy; NASA Power of 10 rule 4 ≤~60 lines.)*

**DRY — about knowledge, not text — but not prematurely.** One authoritative representation per piece of *knowledge* (Pragmatic Programmer), ranked #2 in Beck's simple-design rules. Tempered by Refactoring's rule of three: don't abstract two coincidentally-similar copies. *(+ Clean Code; Refactoring "Duplicated Code".)*

**Fail fast, handle errors explicitly — with one notable dissent.** Validate at boundaries, raise specific exceptions, never swallow, never signal errors with `null`/magic values. *(Clean Code ch.7; Code Complete ch.8 "barricade"; Pragmatic Programmer Design-by-Contract; Effective Java 69–77; NASA rule 7; OWASP input validation.)* The dissent: **APOSD ch.10 "Define Errors Out of Existence"** argues the "throw lots of exceptions" advice itself *creates* complexity — better to design APIs so the error can't arise. (Effective Java item 69, "exceptions only for the exceptional," partially sides with APOSD.) **Domain Modeling Made Functional** lands a third way: encode the error in the *type* — a `Result`/railway-oriented pipeline with illegal states made unrepresentable — so the caller must handle it without exceptions *or* silent `null`s.

**Functional discipline: pure core, immutable data, push I/O to the edges.** A thread that runs from **SICP** (higher-order procedures as the primary tool) through **Effective Java** (lambdas, minimize mutability) and **Uncle Bob's FP Basics** ("no assignment → no race conditions") to **Grokking Simplicity** (the actions / calculations / data triad *is* "push I/O to the edges," made teachable), **Domain Modeling Made Functional** (immutable values, workflows-as-pipelines, types over flags), **Out of the Tar Pit** (FRP), **Clean Architecture ch.6** (functional programming "removes assignment"), and the testing books' **functional-core / mutable-shell**. Brake on the enthusiasm: Effective Java 45 ("streams judiciously") and APOSD ch.20 (simpler imperative code is often faster *and* clearer).

**Minimize mutable and shared state, especially under concurrency.** Broad consensus; shared mutable state is *the* concurrency hazard. Every concurrency bug reduces to one of three broken single-threaded assumptions — **atomicity** ("this happens all at once"), **visibility** ("a write is seen by the next read" — the memory model), and **liveness/ordering** ("threads make progress sensibly" — deadlock, starvation, pool exhaustion) — the decomposition **Java Concurrency in Practice** makes canonical (safe publication, `@GuardedBy`, the JMM happens-before rules). The cheapest fix is to design the sharing away: immutability and confinement need no locks; everything else is discipline for the state you couldn't eliminate. This is the sharpest instance of §I's **hide-it vs. eliminate-it** fault line — lock-and-share (hide) vs. share-nothing/immutable (eliminate), where the canon leans hard toward eliminate. Note the boundary split: *in-process* concurrency shares memory (locks, atomics, `volatile`, async/event-loop — Effective Java ch.11), while *cross-process* concurrency has no shared memory and "no shared lock can fix it" (Waldo, §IV) — the same word, two different problems with different fixes. *(Java Concurrency in Practice — the canonical, book-length treatment of all three; Effective Java 17, 78–84; Clean Code ch.13; DDIA ch.7; Release It! Blocked Threads; Pragmatic Programmer "shared state is incorrect state"; Art of Readable Code ch.9; SICP ch.3; Uncle Bob FP Basics "no assignment → no race conditions".)*

---

## III. Design & Architecture

**Decompose by what changes (information hiding), not by execution steps.** **Parnas's** founding result: split a system so each module hides one decision likely to change — change then stays local; decompose-by-step makes change cascade. Realized as **APOSD** deep modules (simple interface, rich implementation; pass-through methods are a smell), **Code Complete** ADTs, **Effective Java** minimize accessibility, **Clean Code** Law of Demeter. *(Out of the Tar Pit explicitly ties APOSD's deep modules back to Parnas.)*

**One reason to change (SRP / cohesion) — distinct from "small."** Uncle Bob's own file corrects the common misreading: "a class can be large"; SRP is about the *axis* of change, not line count. *(Principles of OOD; Clean Code ch.10; Code Complete ch.7; Refactoring's Divergent Change / Shotgun Surgery smells.)*

**Dependencies point inward, toward stability and abstractions (SOLID/DIP).** Martin's **Agile Software Development** gives the worked class-level derivation and package-level REP/CCP/CRP + ADP/SDP/SAP principles; the Dependency Rule (Clean Architecture) and ports-defined-by-the-core (Hexagonal / Cockburn) scale the same idea into system boundaries. DIP is about source-code dependency direction, not DI containers, but abstractions should answer observed change pressure rather than every imaginable future. No dependency cycles; depend toward stability. *(+ Effective Java composition-over-inheritance; GoF "program to an interface.")*

**Isolate the domain from frameworks, UI, and the database.** "The Database/Web/Framework is a Detail" (Clean Architecture ch.30–32); Screaming Architecture; DDD's persistence-ignorant Repository; Hexagonal's core that "knows nothing about HTTP, DB, queues." *(YAGNI check, from the Hexagonal file itself: a 200-line CLI does not need ports and adapters.)*

**Favor composition over inheritance; program to interfaces.** Consensus across **GoF**, **Effective Java 18–20**, **Head First Design Patterns** ("encapsulate what varies"), **Clean Code** (DI, separate construction from use).

**Wrap and isolate third-party / boundary code.** Define your own interface; learning tests document external behavior and catch upgrade regressions. Named patterns: Adapter, Facade (GoF), Anticorruption Layer (DDD), "skin and wrap the library" (Feathers). *(+ Clean Code ch.8.)*

**A shared, ubiquitous language binds model to code.** DDD's Ubiquitous Language + Bounded Contexts + Context Map (with **Implementing DDD**'s how-to layer — aggregates, domain events, the context-mapping integration patterns); operationalized by Clean Coder's acceptance tests ("requirements are communication, not contract") and expressed structurally by Screaming Architecture.

---

## IV. Distributed Systems & Persistence

**The network is not transparent — remote ≠ local.** **Waldo's** four irreducible differences (latency, no shared memory, **partial failure** — "I don't know whether the call succeeded" — and concurrency) predicted the collapse of CORBA/RMI/DCOM; gRPC/Thrift succeed by being *explicitly* distributed. Echoed by **DDIA ch.8**, **PEAA** ("don't distribute objects unless you have to," citing Waldo), **Fowler/Microservices** and **Newman/Building Microservices** ("design for failure," information-hiding service boundaries, the "distributed monolith" as the failure mode), and **Joel's Law of Leaky Abstractions** (RPC leaks into partial failure). Caution flagged: **Clean Architecture ch.27** — service/deployment boundaries do *not* by themselves create decoupling, so don't map DDD contexts onto microservices uncritically.

**Production systems need explicit failure-containment.** **Release It!** stability patterns — Timeouts, Circuit Breaker, Bulkheads, Fail Fast, Back Pressure, Let It Crash — against its named antipatterns (Cascading Failure, Blocked Threads). Underpinned by DDIA's replication/idempotence mechanics and Clean Architecture's Humble Object (keep the fragile part thin). **Enterprise Integration Patterns** supplies the async-messaging vocabulary for the same goal — Guaranteed Delivery, Dead Letter Channel, Idempotent Receiver, Message Endpoint — when the boundary is a queue rather than a call.

**Correctness under concurrency needs explicit transaction & consistency boundaries.** **DDIA ch.7** ("weak isolation hides scary bugs" — lost updates, write skew, phantoms) + **PEAA** (optimistic/pessimistic locking, Unit of Work, Offline Locks) + **DDD** / **Implementing DDD** (the Aggregate *is* the transactional consistency boundary; Vernon's rules: design *small* aggregates, reference other aggregates by identity, and accept eventual consistency between them).

**Persistence is a mapped, hidden concern — and the N+1 is the classic pathology.** PEAA's catalog (Active Record vs. Data Mapper, Identity Map, Lazy Load), DDD's Repository, DDIA's storage engines beneath the ORM. Persistence stays at the edge; ORM mappings don't leak into the domain. Below the ORM, **SQL Performance Explained** (how an index is used, why `SELECT *` over-fetches and breaks-on-add, sargable predicates, keyset over OFFSET pagination) and **Database Internals** (B-tree vs. LSM storage engines, the write-ahead log) explain the cost model the mapping hides — the layer where the N+1's sibling, the unindexed `SELECT *`, lives.

**Long-lived systems evolve their contracts additively (expand-contract).** DDIA ch.4 (forward/backward compatibility; Avro/Protobuf/Thrift), Release It! ch.13–14 ("multiple versions running simultaneously is normal," backward-compatible schema migrations), Clean Architecture's OCP as the design-level analog.

---

## V. Testing

**Tests are the safety net that makes all other change safe.** The precondition for refactoring and the definition of legacy code ("code without tests" — Feathers). *(Refactoring ch.4; WEWLC; Clean Code ch.9; Pragmatic Programmer; Khorikov "sustainable growth"; xUnit Patterns "change-enablers"; Joel Test.)*

**TDD: red → green → refactor, test-first.** Canonical in **Beck**; the **Three Laws** (Uncle Bob); the nested acceptance/unit loop (GOOS). **Agile Software Development** makes the two layers explicit: programmer tests guide design and protect refactoring, while customer acceptance tests decide whether a story is complete. Disagreement is over *rigor*, not value — Uncle Bob frames it as near-mandatory professional discipline; Osherove notes teams adopt and abandon it; APOSD rates TDD "good but can be tactical."

**Test behavior, not implementation.** The crux pillar — a valid refactor must leave the suite green. *(Khorikov "resistance to refactoring"; GOOS ch.24; Osherove over-specification; xUnit "Fragile Test"; Spec by Example "automation leaking into specs.")* This theme **is** the classical/London fault line (see §XI).

**Test quality beats test quantity — and coverage is a weak signal.** F.I.R.S.T., AAA, intention-revealing names, no logic in tests, refactor tests like production code. Coverage measures what *ran*, not what was *asserted* — a negative indicator only; **mutation testing** is the real oracle. The pyramid-vs-honeycomb-vs-trophy debate is "largely semantic" (Fowler). *(Osherove; xUnit Patterns smell catalog; Khorikov pillars 3–4; Fowler Test Pyramid + Diverse Shapes; "a flaky test is worse than no test" — Eradicating Non-Determinism.)*

**Tests double as executable specification and living documentation.** **Specification by Example's** "key example" does three jobs at once (requirement + test + never-stale docs); Given/When/Then; the Three Amigos. *(+ xUnit "tests as executable specs"; GOOS "test as specification"; Clean Coder acceptance tests; behavior-named tests.)*

**Acceptance tests and usability tests answer different questions.** An acceptance test proves that specified behavior works; it does not prove that a person can discover the path, understand the choices, or recover from a mistake. **Don't Make Me Think** supplies the heuristic layer — scanning, hierarchy, information scent, orientation, concise labels, and visible state — while **Rocket Surgery Made Easy** supplies the evidence loop: observe representative-enough participants attempting realistic goals, fix the most serious repeated breakdowns, and retest. A heuristic review identifies plausible risk, and a few qualitative sessions diagnose causes, but neither can support statistical prevalence claims or universal statements about users.

**The test-double vocabulary is shared; *when to mock* is not.** Everyone uses Meszaros's five flavors (dummy/stub/spy/mock/fake) and "stubs answer, mocks verify." The split: mock *only the outer, unmanaged boundary* and use real objects/state inside (Khorikov, classical; Fowler self-identifies here) vs. *mock internal roles outside-in* to discover collaborators (GOOS, London). A concrete method-level disagreement rides along: **Khorikov rejects transaction-rollback** test teardown (use a real DB + cleanup) while **xUnit Patterns endorses Transaction Rollback Teardown** as a named pattern.

---

## VI. Change Discipline (Refactoring & Migration)

**The Two Hats — never mix refactoring with behavior change.** One hat at a time; never refactor while a test is red; keep refactor commits separate from feature commits. **Tidy First?** sharpens this into a delivery rule — ship "structure" changes in their own PRs, separate from "behavior" PRs — and supplies a catalog of small, safe tidyings (guard clauses, explaining variables, cohesion order) plus the *economics* of when to tidy now vs. later (coupling cost, optionality, reversibility). *(Refactoring ch.2; Tidy First?; Three Laws of TDD; Google "refactors in separate CLs.")*

**Refactoring is continuous, small-step, behavior-preserving — design emerges from it.** Evolutionary > heavy up-front design, *made safe by* continuous testing (Fowler "Is Design Dead?"); smells point to *where* (judgment, not dogma); under a safety net of characterization tests for legacy code (Feathers).

**Replace legacy incrementally; never big-bang rewrite.** Joel's "single worst strategic mistake" (old code encodes years of bug fixes) → Fowler's **Strangler Fig** ("explicitly the answer to Spolsky") and **Branch by Abstraction** (each step shippable, no long-lived branch). Exceptions are named, not denied (greenfield, commodity-layer swaps).

**Manage technical debt deliberately.** Fowler's quadrant: prudent-deliberate debt with a repayment plan is fine; reckless debt is blocked. *(+ Joel Test: bug database, "fix bugs before new features.")*

**Premature optimization is wrong — measure, then tune.** Clarity first; optimize against profiled hot spots; simpler code is often faster; measure percentiles, not averages (DDIA). **Systems Performance** supplies the methodology — the USE method (utilization/saturation/errors per resource), latency-percentile analysis, "don't tune without a measured bottleneck"; **SQL Performance Explained** is the database-shaped instance (index to match the query *before* you denormalize). *(Code Complete 25–26; APOSD ch.20; Effective Java 67; Refactoring; Systems Performance; SQL Performance Explained; Pragmatic Programmer's rough big-O sense.)*

---

## VII. Delivery & Operability

**Automate the path to production.** The deployment pipeline as the central artifact (Continuous Delivery), CI with pre/post-submit and hermetic builds (SE at Google), and the **Accelerate/DORA** evidence that these capabilities *predictively cause* high performance.

**Build once, promote one artifact; integrate on trunk; deploy ≠ release.** Trunk-based development with short-lived branches and feature flags beats GitFlow (Continuous Delivery, SE at Google, Accelerate, Fowler TBD). Decouple *deploy* from *release* via flags + canary/blue-green (CD ch.10). Joel Test #1–3 (source control, one-step build, daily builds) is the spiritual ancestor.

**Speed and stability are not opposed.** Accelerate's headline finding — elite teams beat low performers on all four DORA metrics at once; the trade-off is an artifact of low maturity. *(Partial tension with Brooks's Law, but that's about headcount, not pipeline.)*

**Config in the environment; stateless processes; observability as a prerequisite.** **12-Factor** (config as env vars never committed, logs to stdout, disposability, dev/prod parity) + **Release It!** (control plane, instrumentation, externalized state) + **OWASP A05/A09** (misconfiguration; "if you can't detect the breach you can't respond"). **Site Reliability Engineering** turns "observability is a prerequisite" into mechanism — SLIs/SLOs, error budgets, the four golden signals (latency, traffic, errors, saturation), blameless postmortems, and eliminating toil. *(Minor tension: 12-Factor XI "apps just write to stdout" vs. ASVS ch.7 "apps must control log content to avoid PII leakage.")*

---

## VIII. Security

**Validate untrusted input at the boundary.** Treat every input as hostile until proven otherwise. *(OWASP A03 Injection / A10 SSRF; ASVS ch.5; NASA rule 7 — same discipline, framed as analyzability rather than attack defense.)*

**Secure by design, not by patch.** OWASP A04 "Insecure Design" (2021) — architectural flaws ("missing threat model") can't be retrofitted; "fix before code, not in code." Backed by **Shostack's Threat Modeling** (the four-question frame — *what are we building, what can go wrong, what do we do about it, did we do a good job* — plus STRIDE and trust-boundary data-flow diagrams), **Building Secure and Reliable Systems** (security and reliability are intertwined design properties, designed-in not bolted-on), ASVS ch.1 (threat modeling first), and Brooks ("great designers dominate quality"). This is a precedence claim: a design/security flaw outranks a style fix.

**Defense in depth; never commit secrets; least privilege.** ASVS's tiered levels (L1/L2/L3) and 14 control families; OWASP as the lightweight checklist that pairs with ASVS for depth. Strong hashing (Argon2id/bcrypt), pinned/audited dependencies, no PHI/PII in prompts, logs, or fixtures. **Building Secure and Reliable Systems** anchors least privilege and zero-trust as design defaults — no ambient authority, a small trusted computing base, design for understandability and for recovery.

---

## IX. People, Process & Scale

**Communication/coordination cost is the real scaling tax.** Brooks's Law ("adding manpower to a late project makes it later"); the surgical team; "Tower of Babel failed on communication, not technology." **Team Topologies** reframes this as a structural problem — shape teams to minimize cross-team channels (collaboration = high cost, X-as-a-Service = low cost). *(+ SE at Google: bus factor, the "genius myth.")*

**Org structure and system structure mirror each other (Conway) — but which leads?** A genuine disagreement: **Brooks** puts *architecture first* (a small group owns conceptual integrity, then communicates it down); **Team Topologies** puts *team shape first* (the Inverse Conway Maneuver — form teams to emit the architecture you want).

**Small, reviewable units of work; review for net-positive code health.** Google: a CL does one self-contained thing (≤~200 lines), same-day review, an *ordered* rubric (Design > Functionality > Complexity > Tests > Naming > … > Style) that itself encodes Article-I-style precedence. *(+ TBD small commits; Joel 4–16h task sizing for estimate accuracy.)*

**Removing and changing existing systems is the hard, under-resourced part at scale.** "Adding features is easy; removing them is hard" + **Hyrum's Law** ("every observable behavior will be relied upon") — SE at Google. *(Disagreement: Google "live at head / SemVer's lies" vs. Continuous Delivery's endorsement of semantic versioning.)*

**Knowledge and docs are first-class — treat docs like code.** Source-controlled, reviewed, owned; doc-rot is real; an outdated comment is worse than none. *(SE at Google; modernizes Brooks's project workbook / "Passing the Word.")*

**Professionalism: honest commitments, realistic estimates, unchanged discipline under pressure.** "I'll try is a lie"; estimation ≠ commitment (PERT/Wideband Delphi); don't code tired. *(Clean Coder — the file flags its own preachier chapters as lower-signal than its TDD/estimation material; + Joel's Painless Schedules.)*

**Plans are revisable; feedback is not optional.** **Agile Software Development** turns evidence-based estimation into an iteration loop: user stories keep scope negotiable, measured delivery velocity informs the next plan, and customer acceptance tests define completion. This complements commitment discipline rather than weakening it — distinguish a forecast that should update from a concrete promise that should be renegotiated explicitly when evidence changes.

**Build for change / evolvability — and know when up-front design earns its keep.** YAGNI and "build for current needs" (Beck rule 4, Is-Design-Dead, "you shouldn't start with microservices") — *but* high-reversal-cost decisions (security, schema, framework) warrant deliberate up-front thought. The exception is the rule's necessary companion.

---

## X. The Recurring Meta-Patterns

Four patterns surface *independently* in multiple clusters — strong signals because no single author is the source:

1. **Precedence ordering when rules conflict.** Beck's four simple-design rules are priority-ordered; Google's review rubric is ordered (design > style); Fowler's debt quadrant ranks debt types; OWASP says design flaws beat implementation bugs. Multiple authors converge on *comprehension/correctness wins over cleverness/style* — exactly what [Constitution Article I](CONSTITUTION.md#article-i--conflict-precedence-the-tie-break-order) codifies.
2. **"You can't hide X."** Waldo (can't hide the network), Brooks (can't tool away essential complexity), OWASP A04 (can't patch away a design flaw), Joel (every abstraction leaks). Three+ independent statements of the same humility principle: the hard parts resist abstraction.
3. **Vocabulary collisions are a first-class problem.** Fowler names this twice (UnitTest, Diverse Shapes): "unit," "mock," "isolated" each carry two definitions. "Align locally on terms" beats arguing industry standardization.
4. **Hide-it vs. eliminate-it** (from §I): the two complexity-containment strategies that every other source falls between.

---

## XI. Map of Cross-Source Tensions

The library is not monolithic. These are the documented disagreements — each is a place to expect a judgment call, resolved by [Article I precedence](CONSTITUTION.md#article-i--conflict-precedence-the-tie-break-order) and context.

| # | Tension | Pole A | Pole B | How to resolve |
|---|---------|--------|--------|----------------|
| 1 | **Function/module granularity** ⭐ | Clean Code — many small functions, "Extract Till You Drop" | APOSD — deep modules; "length is not a reason to split"; small functions fragment logic into shallow interfaces | Optimize for the *reader's* time-to-understand; split when a name genuinely abstracts, not to hit a line count. Both source files flag this tension themselves. |
| 2 | **Mocking philosophy** ⭐ | London/mockist (GOOS) — mock internal roles outside-in | Classical/Detroit (Khorikov, Fowler) — real objects + state; mock only the outer unmanaged boundary | Default classical (refactor-safe); reserve mocks for I/O/clock/network/3rd-party. |
| 3 | **Comments' legitimacy** | Clean Code — "comments are a failure" | APOSD — comments are essential design artifacts; write them first | Same rule in practice (explain *why*); don't treat a needed comment as shameful. |
| 4 | **Error handling** | Clean Code / Pragmatic — exception-forward | APOSD ch.10 — "define errors out of existence" | Prefer designing the error away; raise specifically when it can't be designed away. |
| 5 | **Domain purity vs. pragmatic persistence** | Clean Architecture / DDD — DB is a detail; persistence-ignorant Repository | PEAA — Active Record / Table Module deliberately fuse domain + row | Scale-dependent: Active Record for simple CRUD, Data Mapper/Repository when the domain is rich. |
| 6 | **Conway direction** | Brooks — architecture first, communicate down | Team Topologies — team shape first (Inverse Conway) | Use team design as a lever, but protect conceptual integrity. |
| 7 | **Versioning** | SE at Google — "live at head," SemVer's lies | Continuous Delivery — semantic versioning contracts | Monorepo + live-at-head internally; SemVer at external/published boundaries. |
| 8 | **DB test isolation** | Khorikov — real DB + cleanup; reject rollback | xUnit Patterns — Transaction Rollback Teardown | Prefer real-DB cleanup for fidelity; rollback only when speed forces it. |
| 9 | **TDD rigor** | Uncle Bob — near-mandatory discipline | Osherove/APOSD — pragmatic, "can be tactical" | TDD where logic is non-trivial; don't dogmatize it for trivial/glue code. |
| 10 | **Complexity headroom** | Brooks — little accidental left to remove | Out of the Tar Pit — most is still removable | Both: attack accidental complexity; don't expect a silver bullet for the essential. |
| 11 | **Style specifics** | Google Python 2-space, Black 88-col | PEP 8 4-space, 79-col | The meta-rule (consistency > the choice) holds; pick one per language and enforce by tooling. |
| 12 | **Governance** | Accelerate / Team Topologies — autonomous teams, lightweight approval | SE at Google — aggressive central enforcement (mandatory formatters, every change reviewed) | Centralize the *floor* (style, gates); decentralize the *choices* above it. |
| 13 | **Reversibility ideal vs. leaks** | Hexagonal/Clean — swap any technology cleanly | Leaky Abstractions / DDIA — N+1, query plans, partial failure leak through | Design for reversibility *and* understand the layer below; don't trust the swap to be free. |
| 14 | **Reliability vs. security on failure** | Release It! / SRE — degrade gracefully, fail *open* to stay available | Security — fail *closed*; deny on uncertainty | **Building Secure and Reliable Systems**: name the property each component optimizes — auth/secrets/authorization fail closed; non-critical reads may fail open behind a circuit breaker. |
| 15 | **Reliability target** | Release It! — engineer for stability, "design so it doesn't fail" | SRE — 100% is the wrong target; spend an explicit *error budget* to move faster | Set an SLO; while the budget is spent, freeze risk and harden; with budget to spare, ship. Reliability is a feature with a cost, not an absolute. |
| 16 | **Usability convention vs. innovation** | Krug — familiar conventions minimize cognitive effort and make actions self-evident | Novel interactions can create value unavailable through familiar patterns | Innovation must earn its learning cost on an important task and be tested with representative users; reviewer preference alone proves neither clarity nor confusion. |

⭐ = the two headline disagreements, both flagged inside the source summaries themselves.

---

## XII. Near-Universal Consensus

Where essentially every source that addresses the topic agrees — treat these as settled defaults:

- **Names reveal intent** (no dissent anywhere).
- **Comments explain *why*, not *what*** (dispute is only over tone, §XI-3).
- **DRY on knowledge, not coincidental text** (rule-of-three caveat aside).
- **Composition over inheritance; program to interfaces.**
- **Dependencies point toward stable abstractions (SOLID/DIP).**
- **Isolate the domain core from I/O, frameworks, and persistence.**
- **Remote ≠ local; design for partial failure.**
- **Tests are the prerequisite for safe change.**
- **Test behavior, not implementation** (the dispute is *how* to isolate, §XI-2 — not *whether*).
- **Coverage is a floor and a weak signal; mutation score is the real oracle.**
- **The Two Hats — separate refactoring from behavior change.**
- **Replace legacy incrementally; avoid big-bang rewrites.**
- **Measure before optimizing; prefer clarity; watch percentiles** (profile the bottleneck first — the USE method, *Systems Performance*).
- **Be deliberate at the persistence boundary** — explicit columns over `SELECT *`, indexes matched to the query's `WHERE`/`ORDER BY`, bounded result sets (*SQL Performance Explained*, PEAA, DDIA).
- **Validate untrusted input at the boundary; never commit secrets; least privilege.**
- **Config in the environment; observability is a prerequisite, not an afterthought.**
- **Small, reviewable units of work; review for net-positive code health.**
- **Interactive interfaces should make important tasks discoverable, provide visible feedback and recovery, and be observed with representative users when uncertainty matters.**
- **Minimize mutable/shared state, especially under concurrency** — and where sharing is unavoidable, guard atomicity, visibility, and liveness explicitly (in-process ≠ cross-process; *Java Concurrency in Practice* is the canonical reference).

---

## XIII. References

Every source cited above by short name (e.g. "APOSD," "DDIA," "Waldo"), with its local summary file and canonical citation. Full citation data is drawn from [`Resources/Originals/Citations/`](Resources/Originals/Citations/) and [`Resources/Originals/README.md`](Resources/Originals/README.md); nothing is mirrored — copyrighted works link to ISBN/DOI/purchase, open-licensed works link to the canonical URL.

### Books — Canon

| Short name | Full citation | Summary |
|------------|---------------|---------|
| **Clean Code** | Robert C. Martin (2008). *Clean Code*. Prentice Hall. ISBN 978-0132350884 | [01](Resources/Books/Canon/01-Clean-Code.md) |
| **Code Complete** | Steve McConnell (2004). *Code Complete*, 2nd ed. Microsoft Press. ISBN 978-0735619678 | [02](Resources/Books/Canon/02-Code-Complete.md) |
| **Pragmatic Programmer** | Hunt & Thomas (1999/2019). *The Pragmatic Programmer*, 20th anniv. ed. Addison-Wesley. ISBN 978-0135957059 | [03](Resources/Books/Canon/03-The-Pragmatic-Programmer.md) |
| **GoF / Design Patterns** | Gamma, Helm, Johnson, Vlissides (1994). *Design Patterns*. Addison-Wesley. ISBN 978-0201633610 | [04](Resources/Books/Canon/04-Design-Patterns-GoF.md) |
| **Refactoring** | Martin Fowler (2018). *Refactoring*, 2nd ed. Addison-Wesley. ISBN 978-0134757599. Catalog: <https://refactoring.com> | [05](Resources/Books/Canon/05-Refactoring.md) |
| **APOSD** | John Ousterhout (2018/2021). *A Philosophy of Software Design*. Yaknyam Press. ISBN 978-1732102217 | [06](Resources/Books/Canon/06-A-Philosophy-of-Software-Design.md) |
| **WEWLC** | Michael Feathers (2004). *Working Effectively with Legacy Code*. Prentice Hall. ISBN 978-0131177055 | [07](Resources/Books/Canon/07-Working-Effectively-with-Legacy-Code.md) |
| **Tidy First?** | Kent Beck (2023). *Tidy First?*. O'Reilly. ISBN 978-1098151249 | [34](Resources/Books/Canon/34-Tidy-First.md) |

### Books — Clean Architecture Trilogy

| Short name | Full citation | Summary |
|------------|---------------|---------|
| **Clean Architecture** | Robert C. Martin (2017). *Clean Architecture*. Prentice Hall. ISBN 978-0134494166 | [08](Resources/Books/Clean-Architecture-Trilogy/08-Clean-Architecture.md) |
| **Clean Coder** | Robert C. Martin (2011). *The Clean Coder*. Prentice Hall. ISBN 978-0137081073 | [09](Resources/Books/Clean-Architecture-Trilogy/09-The-Clean-Coder.md) |

### Books — Domain & Systems Design

| Short name | Full citation | Summary |
|------------|---------------|---------|
| **DDD** | Eric Evans (2003). *Domain-Driven Design*. Addison-Wesley. ISBN 978-0321125217 | [10](Resources/Books/Domain-Systems-Design/10-Domain-Driven-Design.md) |
| **PEAA** | Martin Fowler (2002). *Patterns of Enterprise Application Architecture*. Addison-Wesley. ISBN 978-0321127426 | [11](Resources/Books/Domain-Systems-Design/11-Patterns-of-Enterprise-Application-Architecture.md) |
| **DDIA** | Martin Kleppmann (2017). *Designing Data-Intensive Applications*. O'Reilly. ISBN 978-1449373320 | [12](Resources/Books/Domain-Systems-Design/12-Designing-Data-Intensive-Applications.md) |
| **Release It!** | Michael T. Nygard (2018). *Release It!*, 2nd ed. Pragmatic Bookshelf. ISBN 978-1680502398 | [13](Resources/Books/Domain-Systems-Design/13-Release-It.md) |
| **Newman / Building Microservices** | Sam Newman (2021). *Building Microservices*, 2nd ed. O'Reilly. ISBN 978-1492034025 | [37](Resources/Books/Domain-Systems-Design/37-Building-Microservices.md) |
| **EIP / Hohpe & Woolf** | Gregor Hohpe & Bobby Woolf (2003). *Enterprise Integration Patterns*. Addison-Wesley. ISBN 978-0321200686. <https://www.enterpriseintegrationpatterns.com> | [38](Resources/Books/Domain-Systems-Design/38-Enterprise-Integration-Patterns.md) |
| **IDDD / Vernon** | Vaughn Vernon (2013). *Implementing Domain-Driven Design*. Addison-Wesley. ISBN 978-0321834577 | [41](Resources/Books/Domain-Systems-Design/41-Implementing-Domain-Driven-Design.md) |

### Books — Concurrency

| Short name | Full citation | Summary |
|------------|---------------|---------|
| **JCiP** | Brian Goetz, Tim Peierls, Joshua Bloch, Joseph Bowbeer, David Holmes, Doug Lea (2006). *Java Concurrency in Practice*. Addison-Wesley. ISBN 978-0321349606 | [29](Resources/Books/Concurrency/29-Java-Concurrency-in-Practice.md) |

### Books — Performance & Reliability

| Short name | Full citation | Summary |
|------------|---------------|---------|
| **SQL Performance Explained / Winand** | Markus Winand (2012). *SQL Performance Explained*. ISBN 978-3950307825. Free: <https://use-the-index-luke.com> | [30](Resources/Books/Performance-Reliability/30-SQL-Performance-Explained.md) |
| **Database Internals / Petrov** | Alex Petrov (2019). *Database Internals*. O'Reilly. ISBN 978-1492040347 | [31](Resources/Books/Performance-Reliability/31-Database-Internals.md) |
| **Systems Performance / Gregg** | Brendan Gregg (2020). *Systems Performance*, 2nd ed. Addison-Wesley. ISBN 978-0136820154 | [32](Resources/Books/Performance-Reliability/32-Systems-Performance.md) |
| **SRE** | Beyer, Jones, Petoff, Murphy, eds. (2016). *Site Reliability Engineering*. O'Reilly. ISBN 978-1491929124. Free: <https://sre.google/books> | [33](Resources/Books/Performance-Reliability/33-Site-Reliability-Engineering.md) |

### Books — Functional

| Short name | Full citation | Summary |
|------------|---------------|---------|
| **Grokking Simplicity / Normand** | Eric Normand (2021). *Grokking Simplicity*. Manning. ISBN 978-1617296208 | [35](Resources/Books/Functional/35-Grokking-Simplicity.md) |
| **DMMF / Wlaschin** | Scott Wlaschin (2018). *Domain Modeling Made Functional*. Pragmatic Bookshelf. ISBN 978-1680502541 | [36](Resources/Books/Functional/36-Domain-Modeling-Made-Functional.md) |

### Books — Security

| Short name | Full citation | Summary |
|------------|---------------|---------|
| **BSRS** | Adkins, Beyer, Blankinship, Lewandowski, Oprea, Stubblefield (2020). *Building Secure and Reliable Systems*. O'Reilly. ISBN 978-1492083122. Free: <https://sre.google/books> | [39](Resources/Books/Security/39-Building-Secure-and-Reliable-Systems.md) |
| **Shostack / Threat Modeling** | Adam Shostack (2014). *Threat Modeling: Designing for Security*. Wiley. ISBN 978-1118809990 | [40](Resources/Books/Security/40-Threat-Modeling.md) |

### Books — Testing

| Short name | Full citation | Summary |
|------------|---------------|---------|
| **Beck / TDD by Example** | Kent Beck (2002). *Test-Driven Development: By Example*. Addison-Wesley. ISBN 978-0321146533 | [14](Resources/Books/Testing/14-Test-Driven-Development-By-Example.md) |
| **GOOS** | Freeman & Pryce (2009). *Growing Object-Oriented Software, Guided by Tests*. Addison-Wesley. ISBN 978-0321503626 | [15](Resources/Books/Testing/15-Growing-Object-Oriented-Software-Guided-by-Tests.md) |
| **Osherove / Art of Unit Testing** | Roy Osherove (2024). *The Art of Unit Testing*, 3rd ed. Manning. ISBN 978-1617297472 | [16](Resources/Books/Testing/16-The-Art-of-Unit-Testing.md) |
| **Meszaros / xUnit Test Patterns** | Gerard Meszaros (2007). *xUnit Test Patterns*. Addison-Wesley. ISBN 978-0131495050 | [17](Resources/Books/Testing/17-xUnit-Test-Patterns.md) |
| **Khorikov** | Vladimir Khorikov (2020). *Unit Testing Principles, Practices, and Patterns*. Manning. ISBN 978-1617296277 | [27](Resources/Books/Testing/27-Unit-Testing-Principles-Practices-Patterns.md) |
| **Spec by Example / Adzic** | Gojko Adzic (2011). *Specification by Example*. Manning. ISBN 978-1617290084 | [28](Resources/Books/Testing/28-Specification-by-Example.md) |

### Books — Engineering Culture & Process

| Short name | Full citation | Summary |
|------------|---------------|---------|
| **SE at Google** | Winters, Manshreck, Wright (2020). *Software Engineering at Google*. O'Reilly. ISBN 978-1492082798. Free: <https://abseil.io/resources/swe-book> | [18](Resources/Books/Engineering-Culture-Process/18-Software-Engineering-at-Google.md) |
| **Continuous Delivery** | Humble & Farley (2010). *Continuous Delivery*. Addison-Wesley. ISBN 978-0321601919 | [19](Resources/Books/Engineering-Culture-Process/19-Continuous-Delivery.md) |
| **Mythical Man-Month / Brooks** | Fred Brooks (1975/1995). *The Mythical Man-Month*. Addison-Wesley. ISBN 978-0201835953 | [20](Resources/Books/Engineering-Culture-Process/20-The-Mythical-Man-Month.md) |
| **Head First Design Patterns** | Freeman & Robson (2020). *Head First Design Patterns*, 2nd ed. O'Reilly. ISBN 978-1492078005 | [21](Resources/Books/Engineering-Culture-Process/21-Head-First-Design-Patterns.md) |
| **Accelerate / DORA** | Forsgren, Humble, Kim (2018). *Accelerate*. IT Revolution. ISBN 978-1942788331. Reports: <https://dora.dev> | [25](Resources/Books/Engineering-Culture-Process/25-Accelerate.md) |
| **Team Topologies** | Skelton & Pais (2019). *Team Topologies*. IT Revolution. ISBN 978-1942788812. <https://teamtopologies.com> | [26](Resources/Books/Engineering-Culture-Process/26-Team-Topologies.md) |
| **Martin / Agile** | Robert C. Martin (2002). *Agile Software Development: Principles, Patterns, and Practices*. Prentice Hall. ISBN 978-0135974445 | [44](Resources/Books/Engineering-Culture-Process/44-Agile-Software-Development.md) |

### Books — Usability & Interaction Design

| Short name | Full citation | Summary |
|------------|---------------|---------|
| **Don't Make Me Think / Krug** | Steve Krug (2014). *Don't Make Me Think, Revisited*, 3rd ed. New Riders / Pearson. ISBN 978-0321965516 | [45](Resources/Books/Usability/45-Dont-Make-Me-Think-Revisited.md) |
| **Rocket Surgery / Krug** | Steve Krug (2009). *Rocket Surgery Made Easy*. New Riders. ISBN 978-0321657299 | [46](Resources/Books/Usability/46-Rocket-Surgery-Made-Easy.md) |

### Books — Language-Specific

| Short name | Full citation | Summary |
|------------|---------------|---------|
| **Effective Java** | Joshua Bloch (2018). *Effective Java*, 3rd ed. Addison-Wesley. ISBN 978-0134685991 | [22](Resources/Books/Language-Specific/22-Effective-Java.md) |
| **Art of Readable Code** | Boswell & Foucher (2011). *The Art of Readable Code*. O'Reilly. ISBN 978-0596802295 | [23](Resources/Books/Language-Specific/23-The-Art-of-Readable-Code.md) |
| **SICP** | Abelson & Sussman (1996). *Structure and Interpretation of Computer Programs*, 2nd ed. MIT Press. ISBN 978-0262510875. CC BY-SA: <https://sarabander.github.io/sicp/> | [24](Resources/Books/Language-Specific/24-SICP.md) |

### Papers

| Short name | Full citation | Summary |
|------------|---------------|---------|
| **Parnas** | D. L. Parnas (1972). "On the Criteria to Be Used in Decomposing Systems into Modules." *CACM* 15(12):1053–1058. DOI [10.1145/361598.361623](https://dl.acm.org/doi/10.1145/361598.361623) | [01](Resources/Papers/01-On-the-Criteria-to-Be-Used-in-Decomposing-Systems-into-Modules.md) |
| **Waldo** | Waldo, Wyant, Wollrath, Kendall (1994). "A Note on Distributed Computing." Sun Microsystems Labs TR SMLI TR-94-29. [Princeton course PDF](https://www.cs.princeton.edu/courses/archive/fall03/cs518/papers/waldo94.pdf) | [02](Resources/Papers/02-A-Note-on-Distributed-Computing.md) |
| **Out of the Tar Pit / Moseley & Marks** | Ben Moseley & Peter Marks (2006). "Out of the Tar Pit." SPA 2006. [Author PDF](http://curtclifton.net/papers/MoseleyMarks06a.pdf) | [03](Resources/Papers/03-Out-of-the-Tar-Pit.md) |
| **No Silver Bullet / Brooks** | Frederick P. Brooks Jr. (1986/1987). "No Silver Bullet — Essence and Accident in Software Engineering." *IEEE Computer* 20(4):10–19. [IEEE Xplore](https://ieeexplore.ieee.org/document/1663532). Also ch.16 of *Mythical Man-Month* | [04](Resources/Papers/04-No-Silver-Bullet.md) |

### Standards

| Short name | Full citation | Summary |
|------------|---------------|---------|
| **OWASP Top 10** | OWASP (2021). *OWASP Top 10*. CC BY-SA 4.0. <https://owasp.org/Top10/2021/> | [01](Resources/Standards/01-OWASP-Top-10.md) |
| **OWASP ASVS** | OWASP (v4.0.3). *Application Security Verification Standard*. CC BY-SA 4.0. <https://github.com/OWASP/ASVS> | [02](Resources/Standards/02-OWASP-ASVS.md) |
| **12-Factor** | Adam Wiggins et al. *The Twelve-Factor App*. CC BY-SA 3.0. <https://12factor.net> | [03](Resources/Standards/03-The-Twelve-Factor-App.md) |
| **NASA Power of 10** | Gerard Holzmann (2006). "The Power of Ten — Rules for Developing Safety-Critical Code." *IEEE Computer* (June 2006). [PDF](https://web.eecs.umich.edu/~imarkov/10rules.pdf) | [04](Resources/Standards/04-NASA-Power-of-10.md) |
| **Google Style Guides** | Google. *Google Style Guides*. CC BY 3.0. <https://google.github.io/styleguide/> | [05](Resources/Standards/05-Google-Style-Guides.md) |
| **Airbnb JS** | Airbnb. *JavaScript Style Guide*. MIT. <https://github.com/airbnb/javascript> | [06](Resources/Standards/06-Airbnb-JavaScript-Style-Guide.md) |
| **PEP 8** | van Rossum, Warsaw, Coghlan. *PEP 8 — Style Guide for Python Code*. Public domain. <https://peps.python.org/pep-0008/> | [07](Resources/Standards/07-PEP-8.md) |

### Articles

| Short name | Full citation | Summary |
|------------|---------------|---------|
| **Fowler — bliki / articles** | Martin Fowler, martinfowler.com (© all rights reserved). Code Smells, Technical Debt Quadrant, Is Design Dead?, Beck's Design Rules, CQRS, Event Sourcing, Strangler Fig, Microservices, Branch By Abstraction, Trunk-Based Development, Test Pyramid, Diverse Shapes of Testing, Mocks Aren't Stubs, UnitTest, Eradicating Non-Determinism. Index: <https://martinfowler.com> | [Martin-Fowler/](Resources/Articles/Martin-Fowler/) |
| **Cockburn — Hexagonal** | Alistair Cockburn. "Hexagonal Architecture (Ports & Adapters)." <https://alistair.cockburn.us/hexagonal-architecture/> | [12](Resources/Articles/Martin-Fowler/12-Hexagonal-Architecture.md) |
| **Uncle Bob — articles** | Robert C. Martin, blog.cleancoder.com / butunclebob.com (© all rights reserved). Principles of OOD/SOLID (<http://butunclebob.com/ArticleS.UncleBob.PrinciplesOfOod>), Clean Code series, TDD series, [Three Laws of TDD](http://butunclebob.com/ArticleS.UncleBob.TheThreeRulesOfTdd), FP Basics | [Robert-Martin/](Resources/Articles/Robert-Martin/) |
| **Joel Spolsky** | Joel Spolsky, joelonsoftware.com (© all rights reserved). [The Joel Test](https://www.joelonsoftware.com/2000/08/09/the-joel-test-12-steps-to-better-code/), [Things You Should Never Do](https://www.joelonsoftware.com/2000/04/06/things-you-should-never-do-part-i/), [Painless Software Schedules](https://www.joelonsoftware.com/2000/03/29/painless-software-schedules/), [Law of Leaky Abstractions](https://www.joelonsoftware.com/2002/11/11/the-law-of-leaky-abstractions/) | [Joel-Spolsky/](Resources/Articles/Joel-Spolsky/) |
| **Google Eng Practices** | Google. *Engineering Practices — Code Review Developer Guide*. CC BY 3.0. <https://google.github.io/eng-practices/> | [Google-Engineering/](Resources/Articles/Google-Engineering/) |
| **CRAP metric** | Alberto Savoia & Bob Evans (2007). *crap4j*. <https://www.artima.com/weblogs/viewpost.jsp?thread=210575> |  |

---

*Derived from the summaries in [`Resources/`](Resources/). For the per-resource index see [`CS-Best-Practices-Resources.md`](CS-Best-Practices-Resources.md); for the write-time rules these themes inform see [`CONSTITUTION.md`](CONSTITUTION.md). Full source citations in §XIII above.*
