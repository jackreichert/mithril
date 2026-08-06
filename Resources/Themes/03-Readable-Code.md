# 03 — Readable Code: Naming, Functions, Comments

> **Tier 2 · Construction.** The craft of code a stranger can maintain in six months — and the two most famous disagreements in the canon, resolved by judgment instead of dogma. **Skill:** [`skills/code-quality.md`](../../skills/code-quality.md) · agent `mithril-code-quality`.

## The idea in one paragraph

Code is read far more often than it is written, so readability is not polish — it is the primary economic property of source code, and obscurity is one of the two root causes of complexity (Theme 01). The construction canon converges on a working method: names are tiny abstractions that must carry real information (Clean Code ch. 2; APOSD ch. 14; *The Art of Readable Code*); functions should present one coherent narrative at one level of abstraction; comments exist to say what the code *cannot* — why it exists, what invariants hold, what the higher-level intent is; errors are handled in one place, with the better move being to design the error case away entirely; and Beck's Four Rules of Simple Design give the priority order when goals conflict (passes tests → no duplication → reveals intent → fewest elements, in that order). What makes this theme unusual is that its two strongest sources — Martin and Ousterhout — openly disagree on the two most-quoted rules, and the framework treats that tension as content: the judgment rules below are the skill's actual position.

## The arc (how the ideas build)

- **The frame: four rules, in priority order** (Beck via Clean Code ch. 12; Fowler, *Beck's Design Rules*) — a design is simple when it passes the tests, contains no duplication, expresses intent, and minimizes elements — and earlier rules win conflicts. This is the litmus test the rest of the theme hangs off.
- **Names carry the information budget** (Clean Code ch. 2; APOSD ch. 14; *Art of Readable Code*) — intention-revealing, pronounceable, searchable; specific beats generic (`userOrders`, not `data`); consistent — never the same name for two things, never two names for one thing. Boswell & Foucher's test: pack information into the name until a new reader's first guess about its meaning is right.
- **Functions: one narrative, one level** (Clean Code ch. 3; Code Complete ch. 5–7) — do one thing, keep one level of abstraction per function, minimize arguments, no flag parameters, command–query separation. Martin's line-count heuristics (≤20 lines) are the famous part —
- **— and the counterpoint that matters** (APOSD ch. 4, 9) — Ousterhout: depth beats brevity. Splitting a coherent 60-line narrative into six shallow helpers can *raise* total interface cost above the value delivered; *length alone is never a reason to split*. The skill's resolution: extract when the fragment has a name that genuinely abstracts; keep together when separation forces readers to chase call chains.
- **Comments: failure vs. design — the second great tension** (Clean Code ch. 4 vs. APOSD ch. 12–15) — Martin: every comment is a failure to express in code; most rot. Ousterhout: comments are part of the design process itself — write interface comments *first*, and the four excuses ("code is self-documenting…") are all wrong. Resolution: both reject comments that narrate *what*; the skill demands comments that capture **why**, **invariants**, and **higher-level what** — precisely the things code cannot say — and rejects the rest.
- **Errors: handle once, or define away** (Clean Code ch. 7; APOSD ch. 10; Pragmatic Programmer fail-fast) — exceptions over return codes, context in the message, don't return or pass null; but before admiring the handler, ask whether the API can make the error state unrepresentable. Fail fast when the error is real: a crash at the fault beats corruption at a distance.
- **Duplication, formatting, consistency** (Clean Code ch. 5, 17; Code Complete ch. 31; APOSD ch. 17) — DRY is about duplicated *knowledge*, not duplicated text — two accidentally-similar snippets serving different decisions may rightly stay separate; formatting and convention-consistency are cognitive-load tools, enforced by tooling (Theme 13), not review comments.

## Tensions worth keeping

- **Small functions ⇄ deep modules.** Line count is a heuristic; interface-to-implementation ratio is the measure. Default when in doubt: fewer, deeper functions.
- **Comments as failure ⇄ comments as design.** Never narrate the code; always record why, invariants, and non-obvious contracts. A missing "why" comment is as much a finding as a redundant "what" comment.

## The sources

- ★ [**Clean Code** — Martin](../Books/Canon/01-Clean-Code.md) — chs. 2–5, 7, 12, 17: the naming/functions/comments/formatting/error-handling core and the smell list.
- ★ [**A Philosophy of Software Design** — Ousterhout](../Books/Canon/06-A-Philosophy-of-Software-Design.md) — chs. 9–10, 12–15, 18: the counterweight, and the comments-first method.
- [**Code Complete** — McConnell](../Books/Canon/02-Code-Complete.md) — chs. 5–7 construction; ch. 31 layout; ch. 25 code-tuning (performance claims need measurement).
- [**The Art of Readable Code** — Boswell & Foucher](../Books/Language-Specific/23-The-Art-of-Readable-Code.md) — surface-level clarity: names, loops, conditionals.
- [**The Pragmatic Programmer** — Hunt & Thomas](../Books/Canon/03-The-Pragmatic-Programmer.md) — DRY (knowledge, not text), fail fast, Design by Contract.
- [**Beck's Design Rules** — Fowler](../Articles/Martin-Fowler/05-Becks-Design-Rules.md) — the four rules and their priority order.
- [**FP Basics series** — Martin](../Articles/Robert-Martin/05-FP-Basics-series.md) + [Clean Architecture ch. 6](../Books/Clean-Architecture-Trilogy/08-Clean-Architecture.md) — immutability and side-effect isolation as readability tools.

## What the skill encodes (operational checklist)

- [ ] Every flagged name gets a concrete better name in the finding, not just "unclear."
- [ ] Function findings argue depth (interface cost vs. value), not raw length.
- [ ] Extract only when the new name genuinely abstracts; flag fragmented call-chains as harshly as long functions.
- [ ] Comments narrating *what* → remove; missing *why*/invariant/contract comments → add. Both directions are findings.
- [ ] Error handling: one handling site per error; context in the message; no null returns/params; ask "can this error be defined out of existence?" first.
- [ ] Duplication findings identify the duplicated *knowledge* (the decision that will diverge), not just similar text.
- [ ] Style/formatting nits deferred to linters and gates — review attention goes to what tools can't see.

## Connects to

[01 — Complexity & Deep Modules](01-Complexity-and-Deep-Modules.md) (readability attacks obscurity; depth attacks dependencies) · [04 — Smells, Refactoring & Legacy Rescue](04-Smells-Refactoring-and-Legacy-Rescue.md) (the smells catalog names what this theme's judgment detects) · [09 — Test Quality](09-Test-Quality.md) (tests are code; the same readability bar applies) · [13 — Gates & Metrics](13-Gates-and-Metrics.md) (the measurable slice — length, complexity, lint — is enforced there).
