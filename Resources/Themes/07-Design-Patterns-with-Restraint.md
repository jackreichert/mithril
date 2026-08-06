# 07 — Design Patterns, with Restraint

> **Tier 3 · Design at scale.** The GoF catalog as shared vocabulary and smell-triggered toolset — plus the modern refinements and the explicit counterweight against using patterns as a substitute for thought. **Skill:** [`skills/patterns.md`](../../skills/patterns.md) · agent `mithril-patterns`.

## The idea in one paragraph

Design patterns earn their place twice: as **vocabulary** (saying "this is a Strategy" transmits a design in two words) and as **pre-debugged solutions** to recurring force-pairs (vary this without touching that). But the two meta-principles the GoF stated *before* the catalog matter more than any of the 23 patterns: **program to an interface, not an implementation**, and **favor composition over inheritance** — most patterns are just these two principles applied to a specific tension. The mature use of the catalog is *recognition-driven*: a smell in the code (a conditional switching on type, a subclass explosion, a constructor that knows too much) points at the pattern that resolves it — you don't "add patterns," you notice the code asking for one. Bloch's *Effective Java* modernizes the mechanics (immutability by default, static factories, builders; language features like enums and lambdas quietly replace whole GoF entries), and Ousterhout supplies the counterweight this theme is named for: patterns applied without a felt force are accidental complexity with a pedigree — over-patterning is one of his named software trends to resist, and the classic abuses (Singleton as global mutable state; Visitor where a simple method would do; factories wrapping factories) read as sophistication while costing depth.

## The arc (how the ideas build)

- **The two meta-principles first** (GoF, introduction) — program to interfaces (callers depend on the abstraction, so implementations can vary) and composition over inheritance (has-a defers decisions to runtime and avoids the fragile base class; is-a hardens them at compile time). Internalize these and half the catalog becomes derivable on demand.
- **The catalog as vocabulary** (GoF; Head First Design Patterns) — creational (Factory Method, Abstract Factory, Builder, Singleton, Prototype), structural (Adapter, Facade, Decorator, Composite, Proxy, Bridge, Flyweight), behavioral (Strategy, State, Observer, Command, Template Method, Iterator, Visitor, Chain of Responsibility, Mediator, Memento, Interpreter). The value is a shared, precise shorthand in reviews and design docs — HFDP's contribution is making the *forces* behind each memorable, not just the UML.
- **Recognition by smell** (Refactoring; the skill's core table) — conditional-on-type → Strategy / State / Replace Conditional with Polymorphism; duplicated algorithm skeletons → Template Method; combinatorial subclass explosion → Decorator or Bridge; interface mismatch at a boundary → Adapter; complex subsystem exposure → Facade. The pattern is the *destination of a refactoring*, not a starting scaffold (Fowler's moves are the path; the pattern is where they arrive).
- **Compound patterns** (HFDP ch. 12; PEAA web-presentation patterns) — MVC is not one pattern but Strategy + Composite + Observer cooperating; its web descendants (Page Controller, Front Controller, MVP/MVVM/Flux) are the same forces re-balanced for different UI stacks. Recognizing the composition prevents cargo-culting the acronym.
- **Modern refinements** (Bloch, *Effective Java*) — minimize mutability (item 17: immutable value types shrink the state space — Theme 01's culprit again); composition over inheritance operationalized (item 18); static factories and Builders over telescoping constructors; language evolution absorbs patterns (enums as Singletons, lambdas as Strategies/Commands, try-with-resources as Disposal) — using the heavyweight form where the language has a lightweight one is itself a smell.
- **The counterweight** (Ousterhout, APOSD ch. 19) — patterns are means, not merit badges. Applied without a genuine force to resolve, a pattern adds interfaces (cost) without implementation value — the definition of a shallow module. The named abuses: **Singleton** (global mutable state with a design-pattern alibi — hostile to tests and to reasoning), **Visitor** (double-dispatch machinery where a method or a match expression would do), factory indirection with a single concrete product. The skill's default question is not "which pattern fits here?" but "does anything here need a pattern at all?"

## Tensions worth keeping

- **Vocabulary ⇄ cargo cult.** The same catalog that compresses communication also invites decoration. Resolution: a pattern is justified by a *named force* (what varies, what must not know about it) — a finding that recommends a pattern must state the force, and a finding may equally recommend *removing* one.
- **Classic form ⇄ language feature.** Where the language absorbed the pattern (enum singleton, lambda strategy), the classic class-diagram form is the smell, not the solution.

## The sources

- ★ [**Design Patterns** — Gamma, Helm, Johnson, Vlissides](../Books/Canon/04-Design-Patterns-GoF.md) — the catalog and, more importantly, the two meta-principles.
- [**Head First Design Patterns** — Freeman & Robson](../Books/Engineering-Culture-Process/21-Head-First-Design-Patterns.md) — the forces made memorable; compound patterns (MVC decomposed).
- [**Effective Java** — Bloch](../Books/Language-Specific/22-Effective-Java.md) — items 17–18 and the modern mechanics; patterns absorbed by the language.
- [**A Philosophy of Software Design** — Ousterhout](../Books/Canon/06-A-Philosophy-of-Software-Design.md) — ch. 19: the over-patterning counterweight.
- [**Refactoring** — Fowler](../Books/Canon/05-Refactoring.md) — patterns as refactoring destinations (Replace Conditional with Polymorphism et al.).
- [**Patterns of Enterprise Application Architecture** — Fowler](../Books/Domain-Systems-Design/11-Patterns-of-Enterprise-Application-Architecture.md) — the web-presentation compound family.

## What the skill encodes (operational checklist)

- [ ] Name patterns already latent in the diff (recognition), with the smell that invoked them.
- [ ] Every pattern recommendation states the force: what varies, what must stay ignorant of it. No force, no pattern.
- [ ] Flag pattern abuse as findings: Singleton-as-global-state, Visitor without double-dispatch need, factory chains with one product.
- [ ] Prefer the language-native form where one exists; flag heavyweight classic forms the language has absorbed.
- [ ] Composition-over-inheritance violations (deep hierarchies, fragile base classes, protected-field coupling) → name the compositional alternative.
- [ ] Immutability first for value-like types; mutable "pattern" participants get scrutiny (an Observer mutating shared state is two findings).
- [ ] When simpler-without wins, say so explicitly — "no pattern needed" is a valid, valuable review outcome.

## Connects to

[01 — Complexity & Deep Modules](01-Complexity-and-Deep-Modules.md) (a needless pattern is a shallow module) · [03 — Readable Code](03-Readable-Code.md) (pattern names are the biggest names in the codebase — they must be honest) · [04 — Smells, Refactoring & Legacy Rescue](04-Smells-Refactoring-and-Legacy-Rescue.md) (the moves that carry code *to* a pattern) · [05 — Architecture](05-Architecture-Dependencies-and-Boundaries.md) (Adapter/Facade at the boundary scale; DIP is program-to-interface writ large).
