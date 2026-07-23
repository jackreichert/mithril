---
title: Structure and Interpretation of Computer Programs (SICP)
authors: Harold Abelson, Gerald Jay Sussman, with Julie Sussman
year: 1996 (2nd ed.)
category: Language-Specific
focus: Abstraction, recursion, interpreters — foundational
---

# Structure and Interpretation of Computer Programs — Abelson & Sussman (1996, 2nd ed.)

The MIT 6.001 textbook. Uses Scheme to teach **abstraction**, **recursion**, **state**, **modularity**, and how to build **interpreters**. Routinely cited as the best CS textbook ever written. Available free at mitpress.mit.edu/sicp.

## Per-chapter summary

### Ch 1 — Building Abstractions with Procedures
Procedures as black boxes; substitution model of evaluation; recursion vs iteration (and why Scheme's tail-call optimization makes them equivalent in space). Higher-order procedures (functions that take or return functions) introduced *as primary*, not advanced. Numerical examples: square root via Newton, exponentiation, GCD.

### Ch 2 — Building Abstractions with Data
Compound data: pairs, lists, trees. Data abstraction via constructors and selectors. The "closure property" of pair: if pairs can hold pairs, you have lists, trees, sets. Symbolic data, tagged data, generic operations. The "tower of types" — coercion, dispatch tables, message passing. Builds toward the realization that data and procedure are interchangeable abstractions.

### Ch 3 — Modularity, Objects, and State
Local state via `set!`. Object-oriented programming as a *style*, achievable in Scheme without language support. Concurrency: serializers, deadlocks, fairness. **Streams** — infinite data structures with delayed evaluation. The chapter that shows OO and FP as alternative views of the same problem.

### Ch 4 — Metalinguistic Abstraction ⭐
Build a Scheme interpreter in Scheme. Section 4.1 implements the meta-circular evaluator. Lazy evaluation, non-deterministic computing (the `amb` evaluator), logic programming (a Prolog-like sub-language). The chapter that earns the book's reputation.

### Ch 5 — Computing with Register Machines
Build a register-machine simulator. Compile Scheme down to register-machine instructions. Garbage collection. End-to-end: high-level Scheme → low-level execution model.

## Why it remains foundational
- **Procedural abstraction**, **data abstraction**, **higher-order functions**, **recursion**, **modular state**, **interpreters** — every modern language traces back through SICP's vocabulary.
- The "metacircular evaluator" is the cleanest known explanation of what an interpreter actually does.
- Reading it changes how you think; few CS books can claim that.

## Honest caveats
- Scheme is unfamiliar to most working programmers.
- Some sections (register machines, certain numeric examples) feel dated.
- The book is *long* (~700 pages, dense exercises).

## Modern alternatives
- **Composing Programs** (UC Berkeley CS 61A) — SICP-in-Python, online.
- **Software Foundations** — same spirit, in Coq, for type theory.
- **How to Design Programs** — Felleisen's pedagogically focused alternative.
