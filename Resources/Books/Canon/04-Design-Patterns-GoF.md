---
title: Design Patterns — Elements of Reusable Object-Oriented Software
authors: Gamma, Helm, Johnson, Vlissides ("Gang of Four")
year: 1994
category: Canon
focus: Creational, structural, behavioral patterns
---

# Design Patterns (GoF) — Gamma, Helm, Johnson, Vlissides (1994)

The book that named the patterns we still talk about. 23 patterns in 3 categories, plus an extended introduction on what a pattern *is*.

## Introduction concepts
- **Pattern** = solution + context + forces + consequences. Catalogued so future readers recognize the situation.
- **Program to an interface, not an implementation.**
- **Favor object composition over class inheritance.**
- Frameworks vs. toolkits vs. patterns: granularity differs.

## The 23 patterns

### Creational (5)
Patterns about *how* objects get instantiated.

| Pattern | One-line intent |
|---------|-----------------|
| **Abstract Factory** | Create families of related objects without specifying concrete classes |
| **Builder** | Separate construction of a complex object from its representation |
| **Factory Method** | Subclasses decide which class to instantiate |
| **Prototype** | Clone a fully configured prototype rather than constructing |
| **Singleton** | One instance, global access (often-criticized) |

### Structural (7)
Patterns about *composing* classes/objects.

| Pattern | One-line intent |
|---------|-----------------|
| **Adapter** | Convert one interface into another the client expects |
| **Bridge** | Decouple abstraction from implementation so both can vary |
| **Composite** | Tree of part-whole hierarchies treated uniformly |
| **Decorator** | Add responsibilities to an object dynamically |
| **Facade** | Simplified interface to a subsystem |
| **Flyweight** | Share fine-grained objects to save memory |
| **Proxy** | Surrogate that controls access (lazy, remote, protection) |

### Behavioral (11)
Patterns about *responsibility* and *communication*.

| Pattern | One-line intent |
|---------|-----------------|
| **Chain of Responsibility** | Pass request along chain until one handles it |
| **Command** | Encapsulate a request as an object |
| **Interpreter** | Define grammar + interpret sentences in it |
| **Iterator** | Sequential access without exposing internals |
| **Mediator** | Centralize complex communications between objects |
| **Memento** | Capture and restore an object's state externally |
| **Observer** | Notify dependents of state change (pub-sub) |
| **State** | Object alters behavior when internal state changes |
| **Strategy** | Encapsulate interchangeable algorithms |
| **Template Method** | Skeleton in superclass, steps overridable |
| **Visitor** | Add operations to objects without modifying their classes |

## Patterns as language
The book's lasting contribution isn't the catalog; it's giving us a vocabulary. "Use a strategy here" is a 4-word architecture conversation that used to take 20 minutes.

## Critiques worth knowing
- Some patterns (Singleton, Visitor, Memento) routinely cause more problems than they solve.
- Several patterns (Iterator, Observer, Command) became language features (Java streams, C# events, lambdas) and feel anachronistic to read about as "patterns."
- The C++ examples date the prose; pair with **Head First Design Patterns** for modern OO style.

## Most-cited 7 (de facto canon)
Strategy, Observer, Decorator, Adapter, Factory Method, Composite, Template Method.
