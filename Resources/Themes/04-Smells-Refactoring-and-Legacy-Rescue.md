# 04 — Smells, Refactoring & Legacy Rescue

> **Tier 2 · Construction.** How code gets better without getting broken: the smell vocabulary, the catalog of behavior-preserving moves, the legacy-code playbook for when there are no tests, and the strategies for replacements too big to do in one step. **Skill:** [`skills/refactor.md`](../../skills/refactor.md) · agent `quality-refactor`.

## The idea in one paragraph

Refactoring is a precise term the industry has diluted: a change that improves internal structure **without changing observable behavior**, performed as a sequence of small, individually-safe steps under a green test suite — not "I rewrote it and I'm pretty sure it still works." Fowler's contribution is a *shared vocabulary at both ends*: a catalog of **smells** that names why code resists change (Bloaters, OO Abusers, Change Preventers, Dispensables, Couplers), and a catalog of **named moves** with mechanics (Extract Function, Move Field, Replace Conditional with Polymorphism…) so the response to a smell is a lookup, not an improvisation. Feathers supplies the harder half of reality: legacy code is *code without tests*, and you can't refactor safely without tests you often can't write without refactoring first — a loop you break at **seams**, with **characterization tests** that pin current behavior (bugs included), and a ranked catalog of dependency-breaking techniques. At system scale, Fowler's Branch by Abstraction and Strangler Fig replace the big-bang rewrite that Spolsky documented as the single worst strategic mistake a software company can make; and the technical-debt quadrant governs *when* any of this is worth doing.

## The arc (how the ideas build)

- **Smells give the problem a name** (Refactoring ch. 3; Fowler, *Code Smells*) — a smell is a surface signal, not a verdict: Long Method, Feature Envy, Shotgun Surgery, Divergent Change, Data Clumps, Primitive Obsession. The five families sort them by the kind of resistance they create. Naming the smell is what turns "this code is bad" into an actionable finding.
- **Moves give the response mechanics** (Refactoring ch. 6–12; the online catalog) — each named refactoring has stepwise mechanics that keep the code compiling and the tests green *between every step*. The smell→move map is the skill's core table: Feature Envy → Move Function; conditional-on-type → Replace Conditional with Polymorphism; Long Parameter List → Preserve Whole Object / Parameterize Function.
- **The two-hats rule** (Refactoring ch. 2) — you are either adding behavior or restructuring, never both in the same commit. Mixed commits are unreviewable (Theme 11) and unbisectable.
- **Legacy: break the loop at a seam** (Feathers, WELC) — a **seam** is a place where behavior can be altered without editing the code (object seams via injection, parameter seams, link seams). Find the seam, write **characterization tests** that record what the code *actually does now* — not what it should do — then refactor under that net. Sprout Method/Class and Wrap Method let new code be born tested even when the host can't be.
- **Dependency-breaking, ranked by invasiveness** (WELC ch. 25) — twenty-four named techniques (Extract Interface, Parameterize Constructor, Subclass and Override, Break Out Method Object…) for getting a stubborn class into a harness, ordered so you reach for the least-invasive first.
- **Too big for either: replace in flight** (Fowler bliki; Spolsky) — **Branch by Abstraction** swaps an in-process component behind a temporary abstraction while trunk keeps shipping (Theme 14's complement to long-lived branches); **Strangler Fig** grows the replacement system around the old one, routing traffic over incrementally. Both exist because Spolsky's verdict on the from-scratch rewrite — you throw away years of accumulated bug fixes for a system that starts at zero — keeps being right.
- **Debt decides when** (Fowler, *Technical Debt*) — the quadrant (reckless/prudent × deliberate/inadvertent) separates "we knowingly took a shortcut with a payoff date" from "we didn't know better." Prudent-deliberate debt with a repayment plan is a tool; reckless debt is just damage. Refactoring effort goes where interest payments are highest — code you change often — not where the mess merely offends.

## Key concepts & frameworks

- **Behavior-preserving, small steps, green between steps** — the definition; anything else is rewriting.
- **The five smell families** (Bloaters / OO Abusers / Change Preventers / Dispensables / Couplers) — sorting by resistance type.
- **Smell → move mapping** — findings should name both halves: the smell and the specific catalog move that answers it.
- **Legacy code = code without tests** (Feathers) — the operational definition that makes the playbook necessary.
- **Seams & enabling points** — object, parameter, and link seams; where behavior can change without editing.
- **Characterization tests** — pin actual behavior first; they document, they don't judge.
- **Sprout & Wrap** — add new, tested code alongside untestable old code.
- **Branch by Abstraction vs. Strangler Fig** — in-process vs. system-level incremental replacement; both anti-big-bang.
- **The debt quadrant** — reckless/prudent × deliberate/inadvertent; pay interest-heavy debt first.

## The sources

- ★ [**Refactoring, 2nd ed.** — Fowler](../Books/Canon/05-Refactoring.md) — the smell catalog (ch. 3) and the moves (ch. 6–12); with the [online catalog](../Articles/Martin-Fowler/01-Refactoring-Catalog.md) and [Code Smells](../Articles/Martin-Fowler/02-Code-Smells.md).
- ★ [**Working Effectively with Legacy Code** — Feathers](../Books/Canon/07-Working-Effectively-with-Legacy-Code.md) — seams, characterization tests, sprout/wrap, the ch. 25 dependency-breaking catalog.
- [**Technical Debt** — Fowler](../Articles/Martin-Fowler/03-Technical-Debt.md) — the quadrant; when to pay.
- [**Branch by Abstraction** — Fowler/Hammant](../Articles/Martin-Fowler/10-BranchByAbstraction.md) and [**Strangler Fig** — Fowler](../Articles/Martin-Fowler/08-Strangler-Fig-Pattern.md) — large-scale replacement without stopping the world.
- [**Things You Should Never Do, Part I** — Spolsky](../Articles/Joel-Spolsky/02-Things-You-Should-Never-Do-Part-I.md) — why the rewrite keeps losing.
- [**Clean Code** — Martin](../Books/Canon/01-Clean-Code.md) — ch. 17 smells and heuristics, cross-checked against Fowler's catalog.

## What the skill encodes (operational checklist)

- [ ] Every refactor finding names the smell *and* the specific catalog move (with mechanics), not just "clean this up."
- [ ] Refactoring commits contain zero behavior change; behavior commits contain zero restructuring (two hats).
- [ ] No refactoring recommendation without a test-safety answer: existing suite, or characterization tests first.
- [ ] Untested code paths get the Feathers playbook: name the seam, least-invasive dependency-breaking technique first.
- [ ] Large-scale restructuring proposals must be incremental (Branch by Abstraction / Strangler Fig) — a big-bang rewrite recommendation is itself a finding.
- [ ] Prioritize by debt interest: smells in frequently-changed code outrank identical smells in stable code.

## Connects to

[03 — Readable Code](03-Readable-Code.md) (the qualities refactoring restores) · [08 — Test-First](08-Test-First-TDD-as-Design.md) (red-green-*refactor*: the third step is this theme) · [09 — Test Quality](09-Test-Quality.md) (resistance-to-refactoring determines whether the net holds) · [14 — Delivery](14-Delivery.md) (Branch by Abstraction is what makes trunk-based development survive big changes).
