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

### Ch 6 — A First Set of Refactorings
The starter kit:
- Extract Function / Inline Function
- Extract Variable / Inline Variable
- Change Function Declaration
- Encapsulate Variable
- Rename Variable
- Introduce Parameter Object
- Combine Functions into Class / Module
- Split Phase

### Ch 7 — Encapsulation
- Encapsulate Record / Collection
- Replace Primitive with Object
- Replace Temp with Query
- Extract Class / Inline Class
- Hide Delegate / Remove Middle Man
- Substitute Algorithm

### Ch 8 — Moving Features
- Move Function / Field
- Move Statements into / out of Function
- Slide Statements
- Split Loop
- Replace Loop with Pipeline
- Remove Dead Code

### Ch 9 — Organizing Data
- Split Variable
- Rename Field
- Replace Derived Variable with Query
- Change Reference to Value (and vice versa)

### Ch 10 — Simplifying Conditional Logic
- Decompose Conditional
- Consolidate Conditional Expression
- Replace Nested Conditional with Guard Clauses
- Replace Conditional with Polymorphism
- Introduce Special Case
- Introduce Assertion

### Ch 11 — Refactoring APIs
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
