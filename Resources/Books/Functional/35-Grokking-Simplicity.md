---
title: Grokking Simplicity — Taming Complex Software with Functional Thinking
author: Eric Normand
year: 2021
category: Functional
focus: actions/calculations/data, immutability (copy-on-write), stratified design, first-class functions, functional architecture (onion + reactive)
---

# Grokking Simplicity — Eric Normand (2021)

A practical, illustration-heavy introduction to functional thinking that skips the jargon (no monads, no category theory) and reduces FP to one core skill: separating code into **actions** (depend on when/how often they run), **calculations** (pure input→output functions), and **data** (inert recorded facts). It feeds the **quality-code-quality** agent's functional-discipline axis, and is the source for the Constitution's Article II rule: "prefer pure functions and immutability; push I/O and side effects to the boundaries; keep the core deterministic." The actions/calculations/data distinction IS that rule — convert actions into calculations where you can, isolate the actions you can't, and build the deterministic core out of calculations over immutable data.

## Per-chapter summary

### Ch 1 — Welcome to Grokking Simplicity
Frames FP not as "avoid side effects" but as a discipline for *managing* them. Introduces the three categories — actions, calculations, data — as the book's organizing lens and the source of every later technique.

### Ch 2 — Functional thinking in action
A guided tour of the toolbox via a running example, previewing both halves of the book: distinguishing the three categories and stratified design (Part 1), then first-class abstractions and timelines (Part 2). Sets expectations: skills, not theory.

### Ch 3 — Distinguishing actions, calculations, and data
The foundational skill: classify every piece of code as action, calculation, or data. Actions spread through your codebase (anything that calls an action becomes one), so you want fewer of them; calculations are safe to call anywhere and trivial to test; data is the easiest to reason about.

### Ch 4 — Extracting calculations from actions
Refactor by pulling the decision/computation logic out of an action into a pure calculation, leaving the action as a thin shell that does I/O. Pass inputs as arguments and return outputs as values instead of reading/writing shared globals — this shrinks the action surface and makes the logic testable.

### Ch 5 — Improving the design of actions
Apply design judgment to the actions that remain: eliminate implicit inputs/outputs (globals, mutation) by making them explicit arguments and return values. Extract calculations aggressively and keep each function operating at a single level of detail.

### Ch 6 — Staying immutable in a mutable language
Implement immutability without language support using **copy-on-write**: copy, modify the copy, return it. The three-step discipline (shallow copy → modify copy → return) turns mutating operations (write) into calculations (read) and keeps shared data from changing under you.

### Ch 7 — Staying immutable with untrusted code
Guard the boundary between your immutable code and legacy/library code that mutates, using **defensive copying** — deep-copy data entering and leaving the untrusted zone. Copy-on-write is cheaper and preferred for code you control; defensive copying is the fallback at the edges you don't.

### Ch 8–9 — Stratified design, parts 1 and 2
Organize functions into layers of abstraction so each calls only the layer just below it, keeping every function at a consistent altitude. Four patterns guide it: straightforward implementations, abstraction barriers (hide a data structure behind an interface), minimal interfaces, and comfortable layers. The call graph reveals which code is stable, reusable, and worth investing in.

### Ch 10–11 — First-class functions, parts 1 and 2
Make functions and language operations first-class values you can name, pass, and return, removing duplication that ordinary refactoring can't reach (e.g. wrapping `try/catch`, logging, or retries). Introduces higher-order functions and the replace-the-body-with-a-callback move, plus the trade-offs of this extra indirection.

### Ch 12 — Functional iteration
Replace hand-written `for` loops with the three core functional tools — **map** (transform each element), **filter** (select elements), and **reduce** (combine to a single value). Each is a higher-order calculation over an immutable array, expressing intent declaratively instead of mechanically.

### Ch 13 — Chaining functional tools
Compose map/filter/reduce into pipelines that read as a sequence of transformations, naming intermediate steps and callbacks for clarity. Covers refactoring existing loops into chains and the readability-vs-efficiency trade-offs of multi-pass chains.

### Ch 14 — Functional tools for nested data
Extend the toolset to deeply nested objects/records with `update` (apply a function to a value at a key) and `nestedUpdate`, all built on copy-on-write so nothing is mutated. Warns about the "deep nesting" smell and uses abstraction barriers to keep the structure's depth from leaking everywhere.

### Ch 15 — Isolating timelines
Introduces **timeline diagrams** to visualize concurrent sequences of actions and spot bugs from interleaving and shared resources. The fix: cut unnecessary sharing between timelines and make ordering explicit before reasoning about correctness.

### Ch 16 — Sharing resources between timelines
Build concurrency primitives in plain JavaScript — a **Queue** to serialize access to a shared resource so only one timeline touches it at a time. Demonstrates eliminating races by confining the resource rather than locking it.

### Ch 17 — Coordinating timelines
Make timelines wait for each other when order matters, building a reusable **Cut** primitive (a barrier that fires once all parties arrive) and a once-only wrapper. Shows how to combine independent async results without depending on which finishes first.

### Ch 18 — Reactive and onion architectures
Two complementary patterns: **reactive architecture** decouples cause from effect via first-class state cells/observers (e.g. `ValueCell`) reacting to change; **onion architecture** layers the system so a pure functional core (calculations over data) sits inside, with actions and I/O at the outer shell — the explicit "push side effects to the boundaries" model that Article II encodes.

### Ch 19 — The functional journey ahead
Closing chapter: how to keep growing — practice the skills, explore other paradigms, study math/theory if desired, and where FP fits among other approaches. Encourages applying actions/calculations/data incrementally rather than rewriting.

## Critiques worth knowing
- **Deliberately non-rigorous.** No monads, functors, or type-theory; some FP practitioners find it under-sells the paradigm. That's the point — it trades completeness for an on-ramp non-FP developers actually finish.
- **JavaScript-flavored.** Examples lean on JS's lack of built-in immutability, so copy-on-write/defensive-copying chapters feel less necessary in languages with persistent data structures (Clojure, Scala) or records (modern Java/Kotlin).
- **Pacing.** The illustrated "Grokking" style is repetitive for experienced readers; the high-value content is concentrated in Ch 3–9 (categories + stratified design) and Ch 15–18 (timelines + architecture).
- **Concurrency primitives are pedagogical.** The hand-rolled Queue/Cut illustrate ideas, not production tooling — see the concurrency skill for real-world atomicity/visibility/deadlock concerns.
