# 02 — The Professional's Discipline

> **Tier 1 · Foundations.** Before construction technique: how a professional plans, commits, estimates, and validates — the checks that happen *around* the code. **Skill:** none at review time (the process agent was retired: a diff carries little evidence of planning). Failure-edge coverage lives in [`skills/test-quality.md`](../../skills/test-quality.md).

## The idea in one paragraph

Most catastrophic software failures are process failures wearing a technical costume: the edge case nobody listed, the dependency nobody mapped, the estimate that was really a wish, the "yes" that should have been a "no." The canon's answer is a small set of disciplines applied at two moments. *Before* writing: measure twice (McConnell's prerequisites), sketch more than one design (Ousterhout's "design it twice"), fire a tracer bullet through the whole stack before building any layer thick (Hunt & Thomas), and make commitments in the only honest grammar there is — "I will, by <date>" — rather than "should" or "soon" (Martin). *After* writing: validate against the actual requirements, check the algorithmic cost, and surface the assumptions you discovered you were making. Brooks supplies the physics the discipline respects: adding people to a late project makes it later, communication paths grow quadratically, and there is no silver bullet coming — so schedule honesty (Spolsky's evidence-based estimates) isn't pessimism, it's arithmetic.

## The arc (how the ideas build)

- **Say no precisely, say yes precisely** (Martin, *The Clean Coder* ch. 2–3) — professionals raise specific objections at the moment they see the problem, not silent overcommitment followed by a late surprise. A real commitment is "I will do X by Y"; anything else ("I'll try," "should be done soon") is an estimate wearing a promise's clothes.
- **Prerequisites before construction** (McConnell, *Code Complete* ch. 3) — "measure twice, cut once": problem definition, requirements sanity, and architectural context checked *before* code, because defects injected upstream cost an order of magnitude more to fix downstream.
- **Design it twice** (Ousterhout, APOSD ch. 11) — sketch two or three genuinely different designs before committing; the contrast surfaces issues single-design analysis cannot. Cheap insurance even (especially) for senior engineers who trust their first idea.
- **Tracer bullets and blast radius** (Hunt & Thomas, *The Pragmatic Programmer*) — build a thin end-to-end slice first to verify the whole path under real conditions, then thicken; and before any change, map what it can break (decoupling chapters: the blast radius question). Design by Contract makes the assumptions explicit enough to validate.
- **Estimate with evidence, not hope** (Spolsky, *Painless Software Schedules*; Martin, *Clean Coder* ch. 10) — fine-grained tasks, original-vs-current estimates kept side by side, and the schedule updated by what the data says, not what the deadline needs. An estimate is a probability distribution, not a number.
- **Replan from measured delivery** (Martin, *Agile Software Development* ch. 3) — user stories make scope negotiable, while completed work from prior iterations supplies a measured velocity for the next plan. The iteration cadence stays fixed, but story selection changes as estimates, priorities, and actual throughput teach the team more; evidence-based scheduling becomes a continuous feedback loop rather than a one-time forecast.
- **Respect the physics** (Brooks, *The Mythical Man-Month*) — Brooks's Law (adding people late adds communication before it adds output), the Tower of Babel (projects fail on coordination, not competence), and No Silver Bullet (expect incremental gains; distrust any plan that requires a miracle tool).
- **Validate after, on purpose** (McConnell ch. 25–26; Martin ch. 7) — post-flight: does it meet the stated requirements (acceptance-level, not vibes), what's the Big-O under production data shapes, and which assumptions did the implementation quietly introduce?

## Key concepts & frameworks

- **Commitment grammar** (Clean Coder) — "I will, by <date>" vs. the weasel tenses; specific objections over silent overcommitment.
- **Prerequisites / upstream defect economics** (Code Complete ch. 3) — the earlier a defect is injected and the later found, the more it costs; hence pre-flight checks at all.
- **Design it twice** (APOSD ch. 11) — comparative design beats first-idea commitment.
- **Tracer bullets / walking skeleton** (Pragmatic Programmer; cross-ref GOOS ch. 4) — end-to-end first, thickness later.
- **Blast radius** (Pragmatic Programmer, decoupling) — enumerate what a change can break before making it.
- **Evidence-based scheduling** (Spolsky) — estimates tracked against actuals; the schedule is a measurement instrument.
- **Brooks's Law + quadratic communication paths** (MMM ch. 2, 7) — team-size and lateness intuition corrected by arithmetic.
- **The five pre-flight / four post-validation checks** — the skill's distillation: (pre) edge cases enumerated, alternatives considered, dependencies mapped, design sketched twice, estimate stated with confidence; (post) requirements met, Big-O acceptable, assumptions surfaced, contracts validated.

## The sources

- ★ [**The Clean Coder** — Martin](../Books/Clean-Architecture-Trilogy/09-The-Clean-Coder.md) — commitment discipline, acceptance criteria, estimation, pressure.
- [**Code Complete** — McConnell](../Books/Canon/02-Code-Complete.md) — ch. 3 prerequisites; ch. 5 design in construction; ch. 8 defensive programming; ch. 25–26 tuning as validation.
- [**The Pragmatic Programmer** — Hunt & Thomas](../Books/Canon/03-The-Pragmatic-Programmer.md) — tracer bullets, pragmatic paranoia, Design by Contract, decoupling.
- [**The Mythical Man-Month** — Brooks](../Books/Engineering-Culture-Process/20-The-Mythical-Man-Month.md) — Brooks's Law, Babel, essence vs. accident.
- [**A Philosophy of Software Design** — Ousterhout](../Books/Canon/06-A-Philosophy-of-Software-Design.md) — ch. 11 Design It Twice; ch. 3 strategic vs. tactical.
- [**Painless Software Schedules** — Spolsky](../Articles/Joel-Spolsky/03-Painless-Software-Schedules.md) — evidence-based estimation. (Environment sanity check: [The Joel Test](../Articles/Joel-Spolsky/01-The-Joel-Test.md).)
- [**Agile Software Development** — Martin](../Books/Engineering-Culture-Process/44-Agile-Software-Development.md) — ch. 2 XP as an integrated feedback system; ch. 3 measured-velocity planning; ch. 4 acceptance tests as story completion.

## What the skill encodes (operational checklist)

- [ ] Pre-flight: edge cases enumerated in writing before implementation starts.
- [ ] Pre-flight: at least one alternative design named and rejected for a stated reason (design-it-twice evidence).
- [ ] Pre-flight: dependencies and blast radius mapped — what does this change touch, and what touches it?
- [ ] Pre-flight: the first slice is a tracer bullet (end-to-end, thin), not a fully-built bottom layer.
- [ ] Pre-flight: the estimate is a real commitment or explicitly labeled an estimate — never "should be fine."
- [ ] Post-validation: implementation checked against the *written* requirements, not the remembered ones.
- [ ] Post-validation: Big-O stated for the hot paths under production-shaped data.
- [ ] Post-validation: assumptions the code introduced are listed and either verified or flagged.

## Connects to

[01 — Complexity & Deep Modules](01-Complexity-and-Deep-Modules.md) (strategic vs. tactical is this theme's daily decision) · [10 — Specification by Example](10-Specification-by-Example.md) (acceptance criteria as the post-validation oracle) · [11 — Code Review](11-Code-Review.md) (the reviewer audits what pre-flight should have produced) · [14 — Delivery](14-Delivery.md) (the walking skeleton is the tracer bullet, industrialized).
