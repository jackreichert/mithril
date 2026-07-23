---
title: Working Effectively with Legacy Code
author: Michael Feathers
year: 2004
category: Canon
focus: Seams, test harnesses, safe change in untested systems
---

# Working Effectively with Legacy Code — Michael Feathers (2004)

Defines **legacy code** as "code without tests." Catalogues techniques for safely getting code into a test harness so refactoring becomes possible.

## Per-chapter / per-part summary

### Part I — The Mechanics of Change

**Ch 1 — Changing Software**
Four reasons to change: add feature, fix bug, improve design, optimize. Tension: preserve behavior while changing it. Tests provide the safety net.

**Ch 2 — Working with Feedback**
Tests as a vise. Unit tests must be fast, isolated, run on every change. Edit-and-pray vs. cover-and-modify.

**Ch 3 — Sensing and Separation**
Two reasons we break dependencies: **sensing** (observe behavior) and **separation** (run code without unwanted dependencies).

**Ch 4 — The Seam Model** ⭐
A **seam** is a place where you can alter behavior without editing in place. Three types:
- **Preprocessing seams** (C/C++ macros).
- **Link seams** (swap libraries at link time).
- **Object seams** (subclass + override).
Each seam has an **enabling point** that controls behavior.

### Part II — Changing Software (chapters of "I have to change … but …" titles)

The bulk of the book. Each chapter is keyed to a real-world constraint. Highlights:

- **Ch 5 — Tools.** Refactoring tools, mock libraries, test runners, automated reverse-engineering.
- **Ch 6 — I don't have much time and I have to change it.** Sprout method/class, wrap method/class.
- **Ch 7 — It takes forever to make a change.** Lag time + dependency analysis.
- **Ch 8 — How do I add a feature?** TDD when possible; sprout/wrap when not.
- **Ch 9 — I can't get this class into a test harness.** Constructor parameter pollution, hidden dependency, irritating parameters, signature shyness, can't instantiate. Each gets its own technique.
- **Ch 10 — I can't run this method in a test harness.** Hidden methods, broken languages.
- **Ch 11 — I need to make a change. What methods should I test?** Effect sketches, propagation rules.
- **Ch 12 — I need to make many changes in one area.** Interception points, pinch points.
- **Ch 13 — I need to make a change, but I don't know what tests to write.** Characterization tests, golden master, generated tests.
- **Ch 14 — Dependencies on libraries are killing me.** Skin and wrap the library.
- **Ch 15 — My application is all API calls.** Skin-and-wrap, layer of indirection.
- **Ch 16 — I don't understand the code well enough to change it.** Notes, sketches, deletion-and-revert experiments.
- **Ch 17 — My application has no structure.** Telling the story of the system; finding its concept of "axis."
- **Ch 18 — My test code is in the way.** Naming and locating tests.
- **Ch 19 — My project is not object-oriented. How do I make safe changes?** Procedural function pointers, link seams, preprocessing seams.
- **Ch 20 — This class is too big and I don't want it to get any bigger.** SRP violations, sprout/extract, encapsulate global references.
- **Ch 21 — I'm changing the same code all over the place.** Open/closed, extract method, lift up, shotgun-surgery prevention.
- **Ch 22 — I need to change a monster method and I can't write tests for it.** Sense the variables, extract small methods carefully under partial-coverage, characterization tests.
- **Ch 23 — How do I know that I'm not breaking anything?** Single-goal editing, preserve signatures, lean on the compiler.
- **Ch 24 — We feel overwhelmed. It isn't going to get any better.** Team practices, reading sessions, kata.

### Part III — Dependency-Breaking Techniques (Ch 25)
A reference catalogue of ~25 techniques (Adapt Parameter, Break Out Method Object, Definition Completion, Encapsulate Global Reference, Expose Static Method, Extract and Override Call/Factory Method/Getter, Extract Implementer/Interface, Introduce Instance Delegator/Static Setter, Link Substitution, Parameterize Constructor/Method, Primitivize Parameter, Pull Up Feature, Push Down Dependency, Replace Function with Function Pointer, Replace Global Reference with Getter, Subclass and Override Method, Supersede Instance Variable, Template Redefinition, Text Redefinition).

## Core mental model
1. Identify change points.
2. Find seams to break dependencies.
3. Cover with characterization tests (test what it *does*, not what it *should*).
4. Refactor under the safety net.
5. Add the new feature.

## Why it's deeply integrated into `/quality refactor`
The refactoring agent uses the seam model and characterization-test-first protocol when working with untested code.
