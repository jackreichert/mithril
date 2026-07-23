---
title: FP Basics series
author: Robert C. Martin
url: blog.cleancoder.com (multi-part series)
category: Article — Robert Martin
focus: OO vs FP, immutability, side-effect isolation
---

# FP Basics Series — Uncle Bob

A multi-part blog series introducing functional programming concepts to OO-trained engineers.

## Core arguments

### What functional programming actually means
- **Immutability**: variables don't vary. Once bound, never reassigned.
- **Pure functions**: same input → same output, no side effects.
- **First-class functions**: functions are values (passable, returnable).
- **Composition**: programs assembled from small, pure functions.

The book *Clean Architecture* describes FP as "removing the assignment statement" — a paradigm restriction with positive consequences.

### Why OO and FP are complementary
Martin argues:
- **OO** controls *who* depends on *what* — manages source-code dependencies.
- **FP** controls *when* state changes — manages temporal dependencies.
- A mature engineer uses both: pure functional cores with OO-style boundaries.

### Concurrency advantages
Without mutable shared state:
- No race conditions.
- No deadlocks.
- No locks needed.
This is not a small benefit — it's a categorical removal of an entire bug class.

### Immutability and persistence
"Persistent data structures" (Clojure-style) make immutability cheap by structural sharing — change-with-O(log n) cost rather than O(n) copies.

## Series highlights to read
- "FP Basics — Episode 1" — value semantics intro.
- "Functional Programming — What is it Good For?" — the concurrency case.
- "Why Clojure?" — Martin's preferred FP language and rationale.

## Critique
- The series is introductory; FP enthusiasts find the treatment shallow.
- The framing ("OO is dependency management, FP is timing") is opinionated; not universally accepted.

## Pairs with
- **SICP** — the foundational FP text.
- **Out of the Tar Pit** (Moseley & Marks) — FP-relational complexity argument.
- *Clean Architecture* ch. 6 — Martin's treatment in book form.
