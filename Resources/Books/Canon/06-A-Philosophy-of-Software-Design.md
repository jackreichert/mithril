---
title: A Philosophy of Software Design
author: John Ousterhout
year: 2018 / 2021 (2nd ed.)
category: Canon
focus: Complexity theory, deep modules, information hiding
---

# A Philosophy of Software Design — John Ousterhout (APOSD)

A Stanford CS course distilled into a thin, opinionated book. Frequently pitched as a counter-point to *Clean Code* — particularly on small-functions-as-dogma. ~190 pages.

## Per-chapter summary

### Ch 1 — Introduction (It's All About Complexity)
The single goal of software design is **managing complexity**. Two approaches: (a) code simpler/more obvious, (b) encapsulate to limit the surface area developers must understand.
The rest of the book evaluates design choices by how effectively they reduce the complexity visible to developers working on the system.

### Ch 2 — The Nature of Complexity
Complexity = anything that makes software hard to understand or modify. Symptoms: **change amplification**, **cognitive load**, **unknown unknowns**. Causes: dependencies + obscurity. Complexity is **incremental**.

### Ch 3 — Working Code Isn't Enough (Strategic vs. Tactical)
Tactical programming = ship the feature, accumulate complexity. Strategic = invest in design even when slower today. ~10–20% of time on design pays off massively. "Tactical tornadoes."

### Ch 4 — Modules Should Be Deep ⭐
Best chapter in the book. A module's interface is *cost*, its implementation is *value*. **Deep** modules: simple interface hiding rich implementation (file I/O is the canonical example). **Shallow** modules: interface ≈ implementation. Many small modules = sum of interfaces > value.

### Ch 5 — Information Hiding (and Leakage)
Module's interface should hide its design decisions. Information leakage: same knowledge encoded across multiple modules → ripple changes. *Temporal decomposition* (steps in execution order) is a leakage smell — favor functional decomposition.

### Ch 6 — General-Purpose Modules are Deeper
Not "design for every conceivable future" — design for the *current* problem in a way that handles likely variations. Specialization-by-defaults beats specialization-by-feature-flags.
A moderately general interface can serve several current uses while keeping case-specific decisions out of every caller.

### Ch 7 — Different Layer, Different Abstraction
If two layers expose the same abstraction, one is probably useless. Pass-through methods (`a.foo()` just calls `b.foo()`) → smell. Pass-through variables → smell.

### Ch 8 — Pull Complexity Downward
Better to have one module suffer pain than many modules. Configuration that *must* be set everywhere → push the default down so callers don't decide.
The module's implementation may become more sophisticated, but the system as a whole becomes simpler because that difficulty is handled once.

### Ch 9 — Better Together or Better Apart?
Bring code together when: shared info, used together, overlap, simpler combined. Split when: only some callers need it, hides more, simpler separated. *Length is not a reason to split.*
The deciding question is which arrangement hides the most knowledge behind the clearest interface, not which produces the shortest files or functions.

### Ch 10 — Define Errors Out of Existence
The common advice "throw lots of exceptions" creates complexity. Better: design APIs so error conditions can't arise (e.g., Tcl's `unset -nocomplain`). Mask them, exception aggregation, just-crash for unrecoverable.

### Ch 11 — Design It Twice
Sketch two or three radically different designs before committing. The contrast surfaces issues that single-design analysis hides. Even senior engineers do this.

### Ch 12 — Why Write Comments? The Four Excuses
The chapter rejects four common excuses about self-documenting code, lack of time, comment rot, and past examples of useless comments. It argues that all four excuses are wrong. Comments are part of the design process because they capture information and expose gaps that cannot be expressed clearly in code alone.

### Ch 13 — Comments Should Describe Things That Aren't Obvious from the Code
*Don't* repeat the code in English. Describe: **what** at a higher level, **why** it exists, **invariants** the reader must trust.
Useful comments reduce the need to reconstruct design intent from implementation details, while redundant comments merely add another representation that can become stale.

### Ch 14 — Choosing Names
Names are tiny abstractions. Use names that are both specific and consistent throughout the codebase. Avoid using the same name for different things, and choose distinct names when two concepts differ.

### Ch 15 — Write the Comments First
Counterintuitive: writing comments before code is *design*. Forces clarity about interface before implementation distorts thinking.
If the interface cannot be described simply before it exists, that difficulty is evidence that the proposed abstraction may be too complicated.

### Ch 16 — Modifying Existing Code
Each change is a chance to make the design better, not just to add a feature. Maintain comments. Don't fall into "this code already exists, I'll just add to it" rut.

### Ch 17 — Consistency
Consistency reduces cognitive load. Document conventions, enforce in review, fix violations as you find them.
Familiar patterns let readers apply knowledge from one part of the system to another without relearning arbitrary local choices.

### Ch 18 — Code Should be Obvious
Generic-name antipatterns, event-driven flow, and surprising globals are common sources of obscurity. If readers must check elsewhere to understand a statement, the code is non-obvious. The chapter favors designs in which names, control flow, and dependencies make the likely behavior clear at the point of use.

### Ch 19 — Software Trends
Quick takes: OO design (modest gain), agile (good but tactical risk), unit testing (great), TDD (good but can be tactical), design patterns (overused), getters/setters (avoid).
Each trend is judged by whether it reduces complexity rather than by its popularity or doctrinal status. Ousterhout accepts useful practices while warning that rigid application can multiply interfaces or prioritize short-term output over coherent design.

### Ch 20 — Designing for Performance
Profile, then optimize. Simpler code is often faster. Be aware of expected costs (network calls, allocations).

### Ch 21 — Conclusion
Master complexity through deep modules, information hiding, and obvious code.
Good design concentrates difficult decisions where they can be solved once and hidden from the rest of the system. Strategic, continuous investment in those qualities keeps incremental complexity from overwhelming future development.

## Where it disagrees with Clean Code
- "Functions should be small" → Ousterhout: functions should be *deep*. Splitting can fragment logic into shallow modules.
- "Comments are failures" → Ousterhout: comments are essential design artifacts.
- "Lots of small classes" → Ousterhout: small classes can multiply interfaces.

## Why it's deeply integrated into `/mithril`
The architecture and code-quality agents treat **deep vs shallow modules** and **information leakage** as primary measures.
