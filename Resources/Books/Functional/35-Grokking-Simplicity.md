---
title: Grokking Simplicity — Taming Complex Software with Functional Thinking
author: Eric Normand
year: 2021
category: Functional
focus: actions/calculations/data, immutability (copy-on-write), stratified design, first-class functions, functional architecture (onion + reactive)
---

# Grokking Simplicity — Eric Normand (2021)

A practical, illustration-heavy introduction to functional thinking that skips the jargon (no monads, no category theory) and reduces FP to one core skill: separating code into **actions** (depend on when/how often they run), **calculations** (pure input→output functions), and **data** (inert recorded facts). It feeds the **mithril-code-quality** agent's functional-discipline axis, and is the source for the Constitution's Article II rule: "prefer pure functions and immutability; push I/O and side effects to the boundaries; keep the core deterministic." The actions/calculations/data distinction IS that rule — convert actions into calculations where you can, isolate the actions you can't, and build the deterministic core out of calculations over immutable data.

## Per-chapter summary

### Ch 1 — Welcome to Grokking Simplicity
Functional programming is framed not as a demand to avoid all side effects, but as a discipline for managing them. The chapter introduces actions, calculations, and data as three categories for understanding a program. That distinction becomes the book's organizing lens and the source of every later technique.

### Ch 2 — Functional thinking in action
A running example provides a guided tour of the functional-thinking toolbox. The first half of the book will distinguish actions, calculations, and data and then introduce stratified design, while the second will cover first-class abstractions and timelines. The goal is to teach practical skills rather than formal theory.

### Ch 3 — Distinguishing actions, calculations, and data
The foundational skill is classifying every piece of a program as an action, a calculation, or data. Actions depend on when or how often they run, and anything that calls an action becomes an action too, so their influence spreads through a codebase. Calculations are deterministic and easy to test, while inert data is the easiest category to inspect and reason about.

### Ch 4 — Extracting calculations from actions
Decision and computation logic should be pulled out of an action into a pure calculation. The remaining action becomes a thin shell responsible for input, output, or another unavoidable side effect. Passing inputs as arguments and returning outputs as values instead of using shared globals shrinks the action surface and makes the logic easy to test.

### Ch 5 — Improving the design of actions
The actions that remain still need deliberate design because side effects make them harder to reason about. Implicit inputs and outputs such as global reads and mutation should become explicit arguments and return values whenever possible. Calculations should be extracted aggressively, and each function should operate at a single level of detail.

### Ch 6 — Staying immutable in a mutable language
Copy-on-write provides immutability even when the programming language permits mutation. Its three steps are to make a shallow copy, modify that copy, and return the new value. This discipline turns a mutating write into a calculation and prevents shared data from changing unexpectedly.

### Ch 7 — Staying immutable with untrusted code
Defensive copying protects immutable code from legacy or library code that may mutate its inputs. Data is deep-copied both when it enters and when it leaves the untrusted zone so neither side shares mutable references. Copy-on-write remains cheaper for code you control, while defensive copying is the fallback at boundaries you do not control.

### Ch 8–9 — Stratified design, parts 1 and 2
Organize functions into layers of abstraction so each calls only the layer just below it, keeping every function at a consistent altitude. Four patterns guide it: straightforward implementations, abstraction barriers (hide a data structure behind an interface), minimal interfaces, and comfortable layers. The call graph reveals which code is stable, reusable, and worth investing in.

### Ch 10–11 — First-class functions, parts 1 and 2
Functions and language operations can become first-class values that code can name, pass, and return. Higher-order functions remove duplication that ordinary extraction cannot reach, such as repeated `try/catch`, logging, or retry structures, by replacing the varying body with a callback. This extra indirection can be powerful, but it should be weighed against the additional effort required to follow the control flow.

### Ch 12 — Functional iteration
Functional iteration replaces many hand-written `for` loops with three core tools. `map` transforms each element, `filter` selects elements, and `reduce` combines a collection into one result. Each tool is a higher-order calculation over an immutable array, so the code states its intent instead of spelling out loop mechanics.

### Ch 13 — Chaining functional tools
`map`, `filter`, and `reduce` can be composed into pipelines that read as a sequence of data transformations. Clear names for intermediate values and callbacks help readers understand each stage. Refactoring loops into chains still requires judgment because a readable multi-pass pipeline may do more work than a fused loop.

### Ch 14 — Functional tools for nested data
The functional toolset extends to nested objects and records through operations such as `update` and `nestedUpdate`. These helpers apply functions at a key or path while using copy-on-write so the original structure is not mutated. Deep nesting remains a design smell, so abstraction barriers should prevent knowledge of the structure's depth from leaking throughout the codebase.

### Ch 15 — Isolating timelines
Timeline diagrams visualize concurrent sequences of actions and the different orders in which they may interleave. The diagrams expose bugs caused by hidden ordering assumptions or shared resources. Correctness becomes easier to establish after unnecessary sharing is removed and required ordering is made explicit.

### Ch 16 — Sharing resources between timelines
The chapter builds a Queue in plain JavaScript to serialize access to a shared resource. Only one timeline touches the resource at a time, while other operations wait for their turn. This design eliminates races by confining access through the queue rather than exposing the resource behind a lock.

### Ch 17 — Coordinating timelines
Some concurrent timelines must wait for one another before a later action can proceed. A reusable Cut acts as a barrier that fires after every required party arrives, and a once-only wrapper prevents repeated completion. Together these tools combine independent asynchronous results without depending on which operation finishes first.

### Ch 18 — Reactive and onion architectures
Reactive architecture decouples cause from effect by using first-class state cells and observers, such as `ValueCell`, that react to change. Onion architecture places a pure functional core of calculations over data inside an outer shell of actions and input/output. These complementary patterns make the rule "push side effects to the boundaries" concrete at the system level, as Article II requires.

### Ch 19 — The functional journey ahead
The closing chapter describes how readers can continue growing through practice, other programming paradigms, and optional study of mathematical theory. Functional programming is presented as one useful approach among several rather than a complete replacement for every style. The actions-calculations-data model should be applied incrementally to existing work instead of used as a reason for wholesale rewrites.

## Critiques worth knowing
- **Deliberately non-rigorous.** No monads, functors, or type-theory; some FP practitioners find it under-sells the paradigm. That's the point — it trades completeness for an on-ramp non-FP developers actually finish.
- **JavaScript-flavored.** Examples lean on JS's lack of built-in immutability, so copy-on-write/defensive-copying chapters feel less necessary in languages with persistent data structures (Clojure, Scala) or records (modern Java/Kotlin).
- **Pacing.** The illustrated "Grokking" style is repetitive for experienced readers; the high-value content is concentrated in Ch 3–9 (categories + stratified design) and Ch 15–18 (timelines + architecture).
- **Concurrency primitives are pedagogical.** The hand-rolled Queue/Cut illustrate ideas, not production tooling — see the concurrency skill for real-world atomicity/visibility/deadlock concerns.
