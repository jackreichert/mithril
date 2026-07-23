---
title: Head First Design Patterns (2nd ed.)
authors: Eric Freeman, Elisabeth Robson (with Bates, Sierra)
year: 2020 (2nd ed.); 2004 (1st)
category: Engineering Culture & Process
focus: Approachable GoF with OO design principles
---

# Head First Design Patterns (2nd ed.) — Freeman & Robson (2020)

The accessible companion to GoF. Same patterns, modern Java/Kotlin examples, illustrated and conversational. The 2nd edition adds lambdas, functional interfaces, and updated examples.

## Per-chapter summary

### Ch 1 — Welcome to Design Patterns: Intro to Patterns
Introduces the **OO design principles** that drive the patterns:
- Identify what varies and encapsulate it.
- Program to an interface, not an implementation.
- Favor composition over inheritance.
Done via the "SimUDuck" example — duck-typing literally.

### Ch 2 — Keeping Your Objects in the Know: Observer Pattern
Notify dependents of state changes. Push vs. pull. Java's built-in `Observable` deprecated; use Listeners or `PropertyChangeSupport`.

### Ch 3 — Decorating Objects: Decorator Pattern
Wrap objects to add behavior dynamically. Worked example: Starbuzz coffee with condiments. Java I/O streams as a real-world decorator hierarchy.

### Ch 4 — Baking with OO Goodness: Factory Pattern
**Simple Factory**, **Factory Method**, **Abstract Factory**. Pizza store example showing each. *Depend on abstractions, not concretions* (DIP).

### Ch 5 — One of a Kind Objects: Singleton Pattern
The classic + the gotchas (multi-threading, ClassLoader, serialization). Enum-based singleton as the safe modern form. Disclaimer on Singleton's reputation.

### Ch 6 — Encapsulating Invocation: Command Pattern
Encapsulate a request as an object. Worked example: home-automation remote with undo, macro commands, and queueing.

### Ch 7 — Being Adaptive: Adapter and Facade
**Adapter**: wraps an incompatible interface. **Facade**: simplifies a complex subsystem. The **Principle of Least Knowledge** (Law of Demeter).

### Ch 8 — Encapsulating Algorithms: Template Method
Define skeleton in superclass, override steps. Hooks for optional steps. The **Hollywood Principle**: "Don't call us, we'll call you" — a way to invert dependency.

### Ch 9 — Well-Managed Collections: Iterator and Composite
**Iterator** unifies traversal. **Composite** lets clients treat tree structure uniformly. Java's `Iterable`/`Iterator` plus `Stream`.

### Ch 10 — The State of Things: State Pattern
Object alters behavior when internal state changes. Worked example: gumball machine state diagram. Compared to Strategy.

### Ch 11 — Controlling Object Access: Proxy Pattern
Surrogate that controls access. Variants: remote, virtual (lazy), protection, smart reference. Java's `Proxy` and dynamic proxy machinery.

### Ch 12 — Patterns of Patterns: Compound Patterns
Patterns that combine: **MVC** = Strategy (controller behavior) + Composite (view tree) + Observer (model notifies view).

### Ch 13 — Patterns in the Real World: Better Living with Patterns
Pattern catalog summary, anti-patterns, how to recognize when *not* to use a pattern.

### Ch 14 — Appendix: Leftover Patterns
Bridge, Builder, Chain of Responsibility, Flyweight, Interpreter, Mediator, Memento, Prototype, Visitor — terse summaries.

## Why it pairs with GoF
GoF is reference; Head First is *learning*. Modern engineers usually read Head First first, then consult GoF when they need exact mechanics or alternative implementations.

## Key takeaway
Patterns are vocabulary first, code second. Knowing the names is more useful than knowing the implementations.
