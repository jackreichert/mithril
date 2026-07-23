---
title: Effective Java (3rd ed.)
author: Joshua Bloch
year: 2018
category: Language-Specific
focus: Idiomatic Java; principles transfer to all OO languages
---

# Effective Java (3rd ed.) — Joshua Bloch (2018)

90 numbered "items" of practical Java wisdom, written by the architect of the Collections Framework. Almost all items teach OO principles that transfer beyond Java.

## Per-chapter summary (90 items grouped)

### Ch 2 — Creating and Destroying Objects (items 1–9)
- **Item 1**: Static factory methods over constructors (named, can return subtypes, can cache).
- **Item 2**: Builder when many constructor params.
- **Item 3**: Singleton via enum (safe, serializable).
- **Item 4**: Private constructor for utility classes.
- **Item 5**: Dependency Injection over hardcoded resources.
- **Item 6**: Avoid creating unnecessary objects (autoboxing, regex compilation).
- **Item 7**: Eliminate obsolete object references (memory-leak sources).
- **Item 8**: Avoid finalizers and cleaners.
- **Item 9**: try-with-resources over try-finally.

### Ch 3 — Methods Common to All Objects (items 10–14)
- **Item 10**: `equals` general contract (reflexive, symmetric, transitive, consistent, non-null).
- **Item 11**: Always override `hashCode` when you override `equals`.
- **Item 12**: Always override `toString`.
- **Item 13**: Override `clone` judiciously (or avoid).
- **Item 14**: Consider implementing `Comparable`.

### Ch 4 — Classes and Interfaces (items 15–25)
- **Item 15**: Minimize accessibility (private > package-private > protected > public).
- **Item 16**: Public classes use accessor methods, not public fields.
- **Item 17**: Minimize mutability.
- **Item 18**: Composition over inheritance.
- **Item 19**: Design and document for inheritance — or prohibit it.
- **Item 20**: Prefer interfaces over abstract classes.
- **Item 21**: Design interfaces for posterity (default methods).
- **Item 22**: Interfaces for types only (not constants).
- **Item 23**: Class hierarchies over tagged classes.
- **Item 24**: Static member classes over non-static.
- **Item 25**: One top-level class per file.

### Ch 5 — Generics (items 26–33)
- Don't use raw types. Eliminate unchecked warnings. Lists > arrays. Generic types/methods. Bounded wildcards (PECS: producer extends, consumer super). Heterogeneous container.

### Ch 6 — Enums and Annotations (items 34–41)
- Enums over int constants. Instance fields over ordinals. EnumSet over bit fields. EnumMap. Use interfaces to extend enums. Annotations over naming conventions. Always use `@Override`. Marker interfaces over marker annotations.

### Ch 7 — Lambdas and Streams (items 42–48)
- Lambdas over anonymous classes. Method references. Standard functional interfaces. Use streams judiciously (not always). Side-effect-free lambdas. Collection-returning over Stream-returning when ambiguous. Use parallel streams with caution.

### Ch 8 — Methods (items 49–56)
- Validate parameters. Make defensive copies. Design method signatures carefully. Avoid long parameter lists. Return types interfaces. Varargs judiciously. Empty collections over null. Optional return type sparingly. Document with Javadoc.

### Ch 9 — General Programming (items 57–68)
- Minimize variable scope. for-each over for. Standard libraries. Avoid float/double for monetary. Primitives over boxed when possible. Strings sparingly. String concatenation perf. Interfaces over reflective access. Avoid native methods. Optimize *judiciously* (profile first). Naming conventions.

### Ch 10 — Exceptions (items 69–77)
- Use exceptions only for exceptional. Checked for recoverable, runtime for programming errors. Avoid unnecessary checked. Standard exceptions. Throw exceptions appropriate to abstraction. Document all thrown. Include failure-capture info. Failure-atomic methods. Don't ignore exceptions.

### Ch 11 — Concurrency (items 78–84)
- Synchronized access to shared mutable. Avoid excessive synchronization. Executors over Threads. Concurrency utilities over wait/notify. Document thread safety. Lazy initialization judiciously. Don't depend on Thread scheduler. Threads are not the answer to async.

### Ch 12 — Serialization (items 85–90)
- Avoid Java serialization. Implement Serializable with caution. Custom serialized form. Write `readObject` defensively. Serialization proxy pattern.

## Why it transcends Java
Items 1, 15, 17, 18, 49, 57, 67 — these are universal OO principles in Java disguise. Easily the highest-density book on OO design beyond GoF.
