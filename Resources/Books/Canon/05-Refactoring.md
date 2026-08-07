---
title: Refactoring (2nd ed.)
author: Martin Fowler
year: 1999 / 2018
category: Canon
focus: Smell catalog, refactoring mechanics, when/how to change code
---

# Refactoring (2nd ed.) — Martin Fowler (2018)

The 2018 edition swaps Java for JavaScript and tightens the catalog. 68 named refactorings, 24 code smells, all with mechanics + small examples + before/after.

## Per-chapter summary

### Ch 1 — Refactoring: A First Example
Worked example: a video-store invoice. Extract Function, Replace Temp with Query, Move Function, Replace Conditional with Polymorphism. Demonstrates the "small steps + tests after each" rhythm.

### Ch 2 — Principles in Refactoring
**Definition**: change to internal structure that doesn't alter external behavior. **Two hats**: adding feature OR refactoring — never both at once. **When to refactor**: rule of three, preparatory, comprehension, litter-pickup, planned. **Code review** as refactoring opportunity. Refactoring vs. performance tuning (refactor first, profile, then tune).

### Ch 3 — Bad Smells in Code
The 24-smell catalog. Each smell has suggested refactorings. Highlights:
The catalog gives developers names for symptoms that suggest a design may be difficult to understand or change, without treating any smell as automatic proof of a defect.
- **Bloaters**: Mysterious Name, Duplicated Code, Long Function, Long Parameter List, Global Data, Mutable Data
- **Object-Orientation Abusers**: Switch Statements, Repeated Switches, Loops, Refused Bequest
- **Change Preventers**: Divergent Change, Shotgun Surgery, Parallel Inheritance Hierarchies
- **Dispensables**: Lazy Element, Speculative Generality, Temporary Field, Comments
- **Couplers**: Feature Envy, Insider Trading, Message Chains, Middle Man
- Other: Large Class, Alternative Classes with Different Interfaces, Data Class, Data Clumps, Primitive Obsession

### Ch 4 — Building Tests
Self-testing code is the prerequisite for refactoring. Test a small unit, write tests that fail, run frequently. Testing makes refactoring safe; refactoring makes testing tractable. Mocha/Chai examples.

### Ch 5 — Introducing the Catalog
Each refactoring entry has: name, motivation, mechanics (numbered steps), example. Mechanics emphasize small steps with tests between.
This common structure makes each technique repeatable and lets readers choose a change by understanding both why it helps and how to perform it safely.

### Ch 6 — A First Set of Refactorings
The starter kit:
This chapter introduces the small transformations that form the working vocabulary for the rest of the catalog. The techniques clarify expressions, functions, variables, and phases without changing externally visible behavior. Because larger refactorings are composed from these moves, learning their mechanics establishes the book's test-after-each-step rhythm.
- Extract Function / Inline Function
- Extract Variable / Inline Variable
- Change Function Declaration
- Encapsulate Variable
- Rename Variable
- Introduce Parameter Object
- Combine Functions into Class / Module
- Split Phase

### Ch 7 — Encapsulation
This chapter focuses on controlling how data and collaborators are exposed to the rest of a program. Its refactorings replace raw representations with interfaces that can protect invariants and hide implementation decisions. The chapter also balances added indirection against cases where a delegate or extracted class no longer earns its place.
- Encapsulate Record / Collection
- Replace Primitive with Object
- Replace Temp with Query
- Extract Class / Inline Class
- Hide Delegate / Remove Middle Man
- Substitute Algorithm

### Ch 8 — Moving Features
This chapter addresses behavior or data that lives in the wrong place and therefore creates unnecessary coupling. Moving functions, fields, or statements closer to the information they use makes responsibilities easier to see. Its loop and pipeline transformations also separate unrelated work and remove code that no longer contributes to behavior.
- Move Function / Field
- Move Statements into / out of Function
- Slide Statements
- Split Loop
- Replace Loop with Pipeline
- Remove Dead Code

### Ch 9 — Organizing Data
This chapter improves the way state is represented and updated inside a program. The refactorings separate variables with multiple meanings, clarify field names, and distinguish computed information from stored state. They also help developers choose deliberately between shared identity through references and independent immutable values.
- Split Variable
- Rename Field
- Replace Derived Variable with Query
- Change Reference to Value (and vice versa)

### Ch 10 — Simplifying Conditional Logic
This chapter turns difficult branching logic into smaller decisions with explicit intent. Guard clauses, decomposed conditions, polymorphism, and special cases reduce nesting and repeated checks. Assertions then document conditions that the surrounding design expects to remain true.
- Decompose Conditional
- Consolidate Conditional Expression
- Replace Nested Conditional with Guard Clauses
- Replace Conditional with Polymorphism
- Introduce Special Case
- Introduce Assertion

### Ch 11 — Refactoring APIs
This chapter improves function and object interfaces so callers can express intent without knowing unnecessary implementation details. Its techniques separate reads from writes, remove flags and setters, and move information across an API boundary only when that placement reduces coupling. The command, factory, and parameter refactorings show that API shape should follow how behavior is used rather than a fixed object-oriented rule.
- Separate Query from Modifier
- Parameterize Function
- Remove Flag Argument
- Preserve Whole Object
- Replace Parameter with Query
- Replace Query with Parameter
- Remove Setting Method
- Replace Constructor with Factory Function
- Replace Function with Command (and vice versa)

### Ch 12 — Dealing with Inheritance
This chapter reorganizes inheritance hierarchies whose behavior or data sits at the wrong level. Pull-up, push-down, extraction, and collapse techniques align shared features with the types that actually need them. Delegate-based alternatives provide an escape when subclassing exposes too much of a superclass or creates an inflexible relationship.
- Pull Up / Push Down Method or Field
- Pull Up Constructor Body
- Replace Type Code with Subclasses
- Remove Subclass
- Extract Superclass
- Collapse Hierarchy
- Replace Subclass with Delegate
- Replace Superclass with Delegate

## Why it's foundational
- Provides a *vocabulary* for refactoring conversations.
- Mechanics are small and verifiable, which makes refactoring tool-supportable.
- Online supplement at refactoring.com is continuously updated.

## Pairs with
- **Working Effectively with Legacy Code** for refactoring code that has no tests yet.
- **xUnit Test Patterns** for refactoring brittle tests.
