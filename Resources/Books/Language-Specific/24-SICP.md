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
Procedures are introduced as black boxes whose users can rely on behavior without knowing implementation details. The substitution model explains evaluation, while the comparison of recursion and iteration shows why Scheme's tail-call optimization can make recursive syntax use iterative space. Higher-order procedures that accept or return functions are treated as a primary abstraction tool rather than an advanced feature. Numerical examples include Newton's method for square roots, exponentiation, and the greatest common divisor.

### Ch 2 — Building Abstractions with Data
Pairs provide the foundation for compound structures such as lists, trees, and sets. Constructors and selectors create a data-abstraction boundary, while the closure property means pairs can contain other pairs and form structures of arbitrary depth. Symbolic and tagged data lead to generic operations implemented through coercion, dispatch tables, and message passing. The chapter ultimately shows that data and procedures can serve as interchangeable forms of abstraction.

### Ch 3 — Modularity, Objects, and State
The assignment operation `set!` introduces local state and programs whose behavior depends on history. Object-oriented programming appears as a style that can be constructed in Scheme without dedicated language syntax. The chapter also covers concurrency through serializers, deadlocks, and fairness, then introduces streams as potentially infinite data structures evaluated on demand. Together these models show object-oriented and functional programming as alternative views of the same underlying problems.

### Ch 4 — Metalinguistic Abstraction ⭐
The chapter builds a Scheme interpreter in Scheme to reveal how a programming language evaluates expressions. Section 4.1 implements the meta-circular evaluator, an interpreter expressed in the language it interprets. Variations then explore lazy evaluation, nondeterministic computing through the `amb` evaluator, and a Prolog-like logic-programming language. This progression from evaluator to new language models is the chapter that earns much of the book's reputation.

### Ch 5 — Computing with Register Machines
The chapter builds a simulator for register machines, an explicit model of low-level computation. It then compiles Scheme procedures into register-machine instructions and explains garbage collection for reclaiming inaccessible memory. This end-to-end path connects high-level Scheme abstractions to the execution model that implements them.

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
