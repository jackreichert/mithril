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

### Ch 3 — Sensing and Separation
Developers break dependencies for two reasons: **sensing** and **separation**. Sensing creates a way for a test to observe behavior that would otherwise remain hidden. Separation allows code to run without invoking unwanted collaborators, making the behavior practical to exercise in a test harness.

**Ch 4 — The Seam Model** ⭐
A **seam** is a place where you can alter behavior without editing in place. Three types:
- **Preprocessing seams** (C/C++ macros).
- **Link seams** (swap libraries at link time).
- **Object seams** (subclass + override).
Each seam has an **enabling point** that controls behavior.

### Part II — Changing Software (chapters of "I have to change … but …" titles)

The bulk of the book. Each chapter is keyed to a real-world constraint. Highlights:

### Ch 5 — Tools
Refactoring tools, mock libraries, test runners, and automated reverse-engineering tools shorten the feedback loop when changing legacy code. They help developers understand structure, substitute dependencies, and verify behavior more reliably than manual repetition. The chapter treats tools as support for disciplined change rather than substitutes for understanding the code.

### Ch 6 — I don't have much time and I have to change it
Sprout Method and Sprout Class place new behavior in separately testable code when the existing code cannot safely be changed first. Wrap Method and Wrap Class preserve the original behavior while adding a controlled place for new behavior around it. These techniques trade immediate structural perfection for a small, testable change that does not deepen the original problem.

### Ch 7 — It takes forever to make a change
Long build and test cycles create lag time that discourages frequent feedback. Dependency analysis helps identify the collaborators that force a supposedly small change to compile or run with the rest of the system. Breaking those dependencies can produce a faster local test loop and make incremental work practical again.

### Ch 8 — How do I add a feature?
The preferred approach is test-driven development when the surrounding code can already run in a test harness. When it cannot, sprout and wrap techniques isolate the new feature from risky existing structure. In both cases, the feature is introduced behind tests rather than mixed directly into unverified legacy behavior.

### Ch 9 — I can't get this class into a test harness
Classes can resist testing because of constructor parameter pollution, hidden dependencies, irritating parameters, signature shyness, or an inability to instantiate the class in isolation. The chapter gives each obstacle a specific dependency-breaking technique instead of recommending one universal mocking strategy. The goal is to make the smallest structural change that permits construction and observation under test.

### Ch 10 — I can't run this method in a test harness
A method may remain inaccessible even after its class can be constructed because the method is hidden or the language restricts substitution. The chapter shows how to expose or redirect behavior without broadly weakening encapsulation. These techniques create a narrow test point while keeping production behavior unchanged.

### Ch 11 — I need to make a change. What methods should I test?
Effect sketches map how a proposed change can propagate through calls, data, and collaborators. Propagation rules help identify the methods whose behavior could be affected even when they are not edited directly. Tests can then cover the relevant effects instead of surrounding the entire system indiscriminately.

### Ch 12 — I need to make many changes in one area
An interception point is a location where tests can observe or redirect the effects of several changes. A pinch point is a narrower dependency through which many affected paths pass. Finding these points lets a developer protect a broad area with fewer focused tests before making related changes.

### Ch 13 — I need to make a change, but I don't know what tests to write
Characterization tests record what existing code actually does, including behavior that may not match current expectations. Golden-master comparisons and generated tests can capture a large output surface when hand-written examples are impractical. These tests establish a behavioral baseline without pretending that every observed result is desirable forever.

### Ch 14 — Dependencies on libraries are killing me
Direct use of a library throughout an application spreads an external interface into code that should express domain concerns. The Skin and Wrap technique places a locally controlled interface around the library. That boundary simplifies tests and limits the changes required when the library evolves or is replaced.

### Ch 15 — My application is all API calls
When application logic is buried among API calls, the code has no place where behavior can run independently. Skin-and-wrap techniques introduce a layer of indirection between policy and the external API. The resulting boundary provides a test seam and gives domain logic an interface expressed in its own terms.

### Ch 16 — I don't understand the code well enough to change it
Notes and structural sketches externalize relationships that are difficult to hold in working memory. Temporary deletion-and-revert experiments reveal which code and dependencies matter without committing the exploratory edits. These techniques turn passive reading into controlled investigation before a real change begins.

### Ch 17 — My application has no structure
Developers can uncover structure by telling the story of the system in a few high-level responsibilities. The chapter also looks for the system's concept of an "axis," the organizing idea around which behavior varies or divides. Naming that structure makes later dependency-breaking and extraction decisions less arbitrary.

### Ch 18 — My test code is in the way
Poorly named or poorly located tests can make a suite harder to navigate than the production code it protects. Consistent naming should reveal the unit, scenario, and behavior under examination. Deliberate test placement then keeps related tests discoverable without coupling them to fragile implementation details.

### Ch 19 — My project is not object-oriented. How do I make safe changes?
Procedural systems still contain seams even when subclassing and object substitution are unavailable. Function pointers, link seams, and preprocessing seams can redirect dependencies for a test build. The same principle applies across paradigms: identify an enabling point that changes behavior without editing the code under test in place.

### Ch 20 — This class is too big and I don't want it to get any bigger
A growing class often contains several responsibilities that change for different reasons. Sprout and extract techniques place new or existing behavior in a more cohesive unit, while encapsulating global references reduces hidden coupling. These moves stop further growth and create safer opportunities for later decomposition.

### Ch 21 — I'm changing the same code all over the place
Repeated edits across many locations indicate shotgun surgery and a missing place for the shared decision. Extract Method and lift-up techniques consolidate behavior behind a common abstraction. Applying the open/closed principle then allows future variants to extend that abstraction instead of reopening every caller.

### Ch 22 — I need to change a monster method and I can't write tests for it
The first step is to sense important variables so tests can observe intermediate behavior without covering the entire method at once. Small methods can then be extracted carefully while partial coverage and characterization tests pin the behavior already understood. This incremental approach reduces risk without requiring a complete rewrite before useful testing can begin.

### Ch 23 — How do I know that I'm not breaking anything?
Single-goal editing limits each step to one reason for change, which makes unexpected effects easier to identify. Preserving signatures avoids forcing unrelated callers to change at the same time. Compiler feedback and focused tests provide overlapping checks while the internal structure evolves.

### Ch 24 — We feel overwhelmed. It isn't going to get any better
Legacy rescue becomes sustainable when the team treats improvement as a shared, repeated practice rather than an individual campaign. Reading sessions build a common understanding of difficult areas, while kata develops dependency-breaking skills away from production pressure. Small improvements made during ordinary work can gradually replace helplessness with reliable feedback.

### Part III — Dependency-Breaking Techniques (Ch 25)
A reference catalogue of ~25 techniques (Adapt Parameter, Break Out Method Object, Definition Completion, Encapsulate Global Reference, Expose Static Method, Extract and Override Call/Factory Method/Getter, Extract Implementer/Interface, Introduce Instance Delegator/Static Setter, Link Substitution, Parameterize Constructor/Method, Primitivize Parameter, Pull Up Feature, Push Down Dependency, Replace Function with Function Pointer, Replace Global Reference with Getter, Subclass and Override Method, Supersede Instance Variable, Template Redefinition, Text Redefinition).
Each entry explains how to create a test seam when a particular language feature or dependency blocks direct testing. The catalog serves as a practical reference after earlier chapters have identified the change point and the reason a dependency must be broken.

## Core mental model
1. Identify change points.
2. Find seams to break dependencies.
3. Cover with characterization tests (test what it *does*, not what it *should*).
4. Refactor under the safety net.
5. Add the new feature.

## Why it's deeply integrated into `/mithril refactor`
The refactoring agent uses the seam model and characterization-test-first protocol when working with untested code.
