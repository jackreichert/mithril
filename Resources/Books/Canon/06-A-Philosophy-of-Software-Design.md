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

### Ch 7 — Different Layer, Different Abstraction
If two layers expose the same abstraction, one is probably useless. Pass-through methods (`a.foo()` just calls `b.foo()`) → smell. Pass-through variables → smell.

### Ch 8 — Pull Complexity Downward
Better to have one module suffer pain than many modules. Configuration that *must* be set everywhere → push the default down so callers don't decide.

### Ch 9 — Better Together or Better Apart?
Bring code together when: shared info, used together, overlap, simpler combined. Split when: only some callers need it, hides more, simpler separated. *Length is not a reason to split.*

### Ch 10 — Define Errors Out of Existence
The common advice "throw lots of exceptions" creates complexity. Better: design APIs so error conditions can't arise (e.g., Tcl's `unset -nocomplain`). Mask them, exception aggregation, just-crash for unrecoverable.

### Ch 11 — Design It Twice
Sketch two or three radically different designs before committing. The contrast surfaces issues that single-design analysis hides. Even senior engineers do this.

### Ch 12 — Why Write Comments? The Four Excuses
"Good code is self-documenting" / "I don't have time" / "Comments rot" / "I've seen useless comments." All wrong. Comments are part of the design process — gaps in your ability to express something in code.

### Ch 13 — Comments Should Describe Things That Aren't Obvious from the Code
*Don't* repeat the code in English. Describe: **what** at a higher level, **why** it exists, **invariants** the reader must trust.

### Ch 14 — Choosing Names
Names are tiny abstractions. Use specific names; consistent names; avoid same name for different things; distinct names for different things.

### Ch 15 — Write the Comments First
Counterintuitive: writing comments before code is *design*. Forces clarity about interface before implementation distorts thinking.

### Ch 16 — Modifying Existing Code
Each change is a chance to make the design better, not just to add a feature. Maintain comments. Don't fall into "this code already exists, I'll just add to it" rut.

### Ch 17 — Consistency
Consistency reduces cognitive load. Document conventions, enforce in review, fix violations as you find them.

### Ch 18 — Code Should be Obvious
Generic-name antipatterns, event-driven flow, surprising globals. If readers must check elsewhere to understand, code is non-obvious.

### Ch 19 — Software Trends
Quick takes: OO design (modest gain), agile (good but tactical risk), unit testing (great), TDD (good but can be tactical), design patterns (overused), getters/setters (avoid).

### Ch 20 — Designing for Performance
Profile, then optimize. Simpler code is often faster. Be aware of expected costs (network calls, allocations).

### Ch 21 — Conclusion
Master complexity through deep modules, information hiding, and obvious code.

## Where it disagrees with Clean Code
- "Functions should be small" → Ousterhout: functions should be *deep*. Splitting can fragment logic into shallow modules.
- "Comments are failures" → Ousterhout: comments are essential design artifacts.
- "Lots of small classes" → Ousterhout: small classes can multiply interfaces.

## Why it's deeply integrated into `/quality`
The architecture and code-quality agents treat **deep vs shallow modules** and **information leakage** as primary measures.
