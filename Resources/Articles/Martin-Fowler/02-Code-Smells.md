---
title: Code Smells
author: Martin Fowler (with Kent Beck originating the term)
url: martinfowler.com/bliki/CodeSmell.html
category: Article — Martin Fowler
focus: Bloaters, OO abusers, change preventers, dispensables, couplers
---

# Code Smells — Fowler (term coined by Beck)

A **code smell** is a surface indication that *usually* corresponds to a deeper design problem. Smells suggest *where* to look; they don't dictate fixes.

## The classic smell catalogue (24 entries from Refactoring 2nd ed.)

Refactoring 2nd-ed groups the smells into five cluster names that are widely cited:

### Bloaters
Code that has grown so large or so duplicated that it impedes change.
- **Mysterious Name**
- **Duplicated Code**
- **Long Function**
- **Long Parameter List**
- **Global Data**
- **Mutable Data**

### Object-Orientation Abusers
Patterns that misuse OO mechanisms.
- **Switch Statements**
- **Repeated Switches**
- **Loops** (often replaceable with pipelines)
- **Refused Bequest** (subclass uses little of the parent)

### Change Preventers
Code where one logical change forces edits in many places.
- **Divergent Change** (one module, many reasons to change)
- **Shotgun Surgery** (one change, many modules)
- **Parallel Inheritance Hierarchies**

### Dispensables
Code that isn't pulling its weight.
- **Lazy Element**
- **Speculative Generality**
- **Temporary Field**
- **Comments** (when they replace clarification of code)

### Couplers
Code with too much coupling between modules.
- **Feature Envy** (a method more interested in another class's data)
- **Insider Trading** (modules trading too much information)
- **Message Chains** (`a.b().c().d()`)
- **Middle Man** (class that just delegates)

### Other
- **Large Class**
- **Alternative Classes with Different Interfaces**
- **Data Class** (anaemic; data without behavior)
- **Data Clumps** (variables that always travel together)
- **Primitive Obsession** (using ints/strings where types should be)

## Practical use
- In code review: flag the smell, propose a refactoring from the catalogue.
- In refactoring: if a smell triggers but no refactoring fits cleanly, the smell may be acceptable in this context — judgment, not dogma.

## Pairs with
- *Refactoring* ch. 3 (the book chapter introducing this list).
- xUnit Test Patterns (test smells, the "test" version of this catalogue).
