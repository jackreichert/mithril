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
The SimUDuck example introduces the object-oriented design principles that drive the rest of the patterns. The chapter advises readers to identify what varies and encapsulate it, program to an interface rather than an implementation, and favor composition over inheritance. Its literal duck-typing exercise shows how those principles keep changing behavior separate from stable code.

### Ch 2 — Keeping Your Objects in the Know: Observer Pattern
The Observer pattern notifies dependent objects when a subject's state changes. Implementations may push the changed data to observers or let observers pull the data they need. Because Java's built-in `Observable` is deprecated, modern code can use listeners or `PropertyChangeSupport` instead.

### Ch 3 — Decorating Objects: Decorator Pattern
The Decorator pattern wraps an object to add behavior dynamically without changing the wrapped object's class. The Starbuzz coffee example models each condiment as a decorator around a beverage. Java I/O streams provide a real-world decorator hierarchy in which wrappers add buffering and other capabilities.

### Ch 4 — Baking with OO Goodness: Factory Pattern
The chapter compares Simple Factory, Factory Method, and Abstract Factory as ways to separate object creation from object use. A pizza-store example shows how each variation moves construction decisions behind a stable abstraction. This supports the Dependency Inversion Principle by making clients depend on abstractions rather than concrete classes.

### Ch 5 — One of a Kind Objects: Singleton Pattern
The Singleton pattern ensures that a class exposes only one shared instance. The classic implementation has pitfalls involving multithreading, class loaders, and serialization. An enum-based singleton is the safer modern Java form, although the chapter also acknowledges the pattern's poor reputation and global-state risks.

### Ch 6 — Encapsulating Invocation: Command Pattern
The Command pattern encapsulates a request as an object with a uniform execution interface. A home-automation remote demonstrates how commands separate button controls from the devices they operate. Once requests are objects, the design can support undo, macro commands, and queueing without teaching the invoker every operation.

### Ch 7 — Being Adaptive: Adapter and Facade
An Adapter wraps an incompatible interface so an existing client can use it through the interface it expects. A Facade presents a simpler entry point to a complex subsystem without necessarily changing the subsystem's interfaces. Both patterns support the Principle of Least Knowledge, also called the Law of Demeter, by limiting how much one object must know about others.

### Ch 8 — Encapsulating Algorithms: Template Method
The Template Method pattern defines an algorithm's skeleton in a superclass while allowing subclasses to override selected steps. Hooks provide optional extension points without requiring every subclass to implement them. This structure illustrates the Hollywood Principle, "don't call us, we'll call you," because the high-level algorithm controls when specialized behavior runs.

### Ch 9 — Well-Managed Collections: Iterator and Composite
The Iterator pattern gives clients a uniform way to traverse a collection without exposing its representation. The Composite pattern lets clients treat individual objects and tree-shaped groups through the same interface. Java's `Iterable`, `Iterator`, and `Stream` APIs show how standardized traversal supports these ideas in everyday code.

### Ch 10 — The State of Things: State Pattern
The State pattern lets an object alter its behavior when its internal state changes. A gumball-machine state diagram turns each operating state into a separate object with its own transitions. The chapter compares State with Strategy because both delegate behavior through composition, though State focuses on lifecycle transitions rather than interchangeable policies.

### Ch 11 — Controlling Object Access: Proxy Pattern
The Proxy pattern places a surrogate in front of another object to control access to it. Variants include remote proxies, virtual or lazy proxies, protection proxies, and smart references. Java's `Proxy` API demonstrates how dynamic proxy machinery can create such intermediaries at runtime.

### Ch 12 — Patterns of Patterns: Compound Patterns
Compound patterns combine several patterns to solve a larger design problem. Model-View-Controller is the central example: Strategy varies controller behavior, Composite organizes the view tree, and Observer lets the model notify views. Recognizing the collaboration matters more than treating MVC as one indivisible pattern.

### Ch 13 — Patterns in the Real World: Better Living with Patterns
The chapter summarizes the pattern catalog as a vocabulary for recurring design decisions. It also introduces anti-patterns, which name common approaches that repeatedly create problems. Most importantly, it teaches readers to recognize when not to use a pattern because unnecessary structure can make a simple design worse.

### Ch 14 — Appendix: Leftover Patterns
The appendix gives concise introductions to patterns not covered in full chapters. These include Bridge, Builder, Chain of Responsibility, Flyweight, Interpreter, Mediator, Memento, Prototype, and Visitor. The summaries provide enough vocabulary to recognize each pattern and consult a deeper reference when it becomes relevant.

## Why it pairs with GoF
GoF is reference; Head First is *learning*. Modern engineers usually read Head First first, then consult GoF when they need exact mechanics or alternative implementations.

## Key takeaway
Patterns are vocabulary first, code second. Knowing the names is more useful than knowing the implementations.
