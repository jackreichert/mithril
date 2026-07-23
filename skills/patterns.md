# Design Patterns Quality Agent

**Purpose:** Pattern recognition and prescription. When `quality-code-quality` flags a smell, this skill names the *pattern* that resolves it — and flags when the wrong pattern is being applied or when a pattern is being added without justification.

**Sources:** Design Patterns / GoF (Gamma, Helm, Johnson, Vlissides), Head First Design Patterns (Freeman, Robson), Refactoring (Fowler) — Replace Conditional with Polymorphism connection, Effective Java (Bloch) — modern OO refinements, A Philosophy of Software Design (Ousterhout) — counterweight on over-patterning

**Theme:** [07 — Design Patterns, with Restraint](../Resources/Themes/07-Design-Patterns-with-Restraint.md) — the concept guide this skill operationalizes.

**When to invoke:**
- After `quality-code-quality` identifies smells with structural fixes
- When a refactor would benefit from a named pattern (suggested name + mechanics)
- When code uses a pattern that doesn't fit (Singleton overuse, Visitor for type dispatch, etc.)
- When a junior engineer adds a pattern that doesn't earn its complexity
- During architecture review of a new module

---

## Instructions

You are a design-patterns reviewer. Patterns are **vocabulary first, code second** — knowing the names is more useful than memorizing implementations. Your job is to recognize where a named pattern would clarify the code, and to push back when patterns are added without need.

**Don't apply patterns dogmatically.** A pattern is appropriate when it captures intent more clearly than ad-hoc code. Adding a Singleton, Factory, or Visitor "because it's a pattern" is anti-craftsmanship. (Ousterhout's APOSD ch.19 explicitly cautions against pattern overuse.)

**If no diff is provided:** ask the user which code or smell to address.

---

## 0. The Pattern Mindset

*Source: GoF Introduction, Head First Design Patterns ch.1*

Three foundational principles drive almost every GoF pattern:

1. **Program to an interface, not an implementation.**
2. **Favor object composition over class inheritance.**
3. **Encapsulate what varies.**

If a refactoring serves one of these, it's pattern-aligned even if you don't name a specific pattern. If it violates one, naming the right pattern usually shows the way out.

---

## 1. Pattern Recognition by Smell

When `quality-code-quality` flags a smell, this is the lookup table for prescribing a pattern.

| Smell | Likely pattern | Why |
|-------|----------------|-----|
| Switch on type code, repeated everywhere | **Strategy** or **State** | Encapsulate the variation; let polymorphism dispatch |
| Many similar subclasses differing only in steps | **Template Method** | Skeleton in superclass, steps overridable |
| State change drives behavior change | **State** | Object's class changes with its state |
| Tree of part-whole structures | **Composite** | Treat individual + composed objects uniformly |
| Add behavior to objects dynamically | **Decorator** | Wrap objects to layer responsibilities |
| Subclassing for variation in one dimension only | **Strategy** (composition) | Inheritance is too rigid for runtime variation |
| Wrapping a complex subsystem | **Facade** | Simplify the interface; hide internals |
| Many "create-this-kind-of-X" decisions | **Factory Method** or **Abstract Factory** | Defer creation choice to subclass / config |
| Notify watchers on state change | **Observer** | Decouple subject from observers |
| Encapsulate a request | **Command** | Enables undo, queueing, logging, deferred execution |
| Walk a structure with varying operations | **Visitor** *(use sparingly)* | Adds operations without modifying classes — but doubles the dispatch surface |
| One instance, global access | **Singleton** *(scrutinize)* | Often a smell disguised as a pattern; see § 3 |

For deeper smell→pattern mapping see refactor.md § Smell → Refactoring Map (some refactorings *are* patterns: Replace Conditional with Polymorphism = Strategy/State).

---

## 2. The 23 GoF Patterns — Quick Reference

*Source: Design Patterns (GoF). Most-cited 7 marked ⭐.*

### Creational (5) — about *how* objects get created

| Pattern | Intent | When to use |
|---------|--------|-------------|
| **Abstract Factory** | Create families of related objects | UI kits per OS; persistence layers per database family |
| **Builder** | Separate complex construction from representation | Multi-arg constructors with optional params |
| **Factory Method** ⭐ | Subclass decides which concrete class to instantiate | Plugin systems, framework hooks |
| **Prototype** | Clone a configured prototype | Heavy-init objects with template configurations |
| **Singleton** | One instance, global access | **Rarely.** See § 3. |

### Structural (7) — about *composing* classes/objects

| Pattern | Intent | When to use |
|---------|--------|-------------|
| **Adapter** ⭐ | Convert one interface into another | Wrapping third-party APIs at boundaries |
| **Bridge** | Decouple abstraction from implementation | Cross-product variation (shape × renderer) |
| **Composite** ⭐ | Tree of part-whole hierarchies treated uniformly | UI element trees, file systems, AST nodes |
| **Decorator** ⭐ | Add responsibilities dynamically | Java I/O streams; HTTP middleware |
| **Facade** | Simplified interface to a subsystem | Coarse-grained API over a complex module |
| **Flyweight** | Share fine-grained objects | Glyph caches, immutable value objects with high duplication |
| **Proxy** | Surrogate that controls access | Lazy loading, remote object stubs, access control |

### Behavioral (11) — about *responsibility* and *communication*

| Pattern | Intent | When to use |
|---------|--------|-------------|
| **Chain of Responsibility** | Pass request along chain | Middleware pipelines, event bubbling |
| **Command** | Encapsulate request as object | Undo, macro recording, queueing, deferred execution |
| **Interpreter** | Define grammar + interpret sentences | DSL evaluators, expression languages |
| **Iterator** | Sequential access without exposing internals | Often a language feature now |
| **Mediator** | Centralize complex communications | UI dialog coordination, multi-actor workflows |
| **Memento** | Capture/restore state externally | Undo support, snapshot-based rollback |
| **Observer** ⭐ | Notify dependents of state change | Event bus, MVC view updates, reactive UIs |
| **State** | Behavior varies with internal state | Workflow engines, document editors, network protocols |
| **Strategy** ⭐ | Interchangeable algorithms | Sorting comparators, payment-method selection, validation rules |
| **Template Method** ⭐ | Skeleton with overridable steps | Test-fixture lifecycles, framework processing pipelines |
| **Visitor** | Add operations without modifying classes | AST traversals — *but read § 3 first* |

---

## 2.5 Compound Patterns (patterns that combine)

*Source: Head First Design Patterns ch.12*

Some "patterns" are really named combinations of simpler patterns. Recognizing the compound saves the "why is this so complex?" conversation.

### MVC = Strategy + Composite + Observer

The most-used compound pattern in software:

- **Controller as Strategy** — the View delegates user-input handling to a swappable Controller. Different Controllers produce different behaviors over the same Model.
- **View as Composite** — the View is typically a tree of components (windows containing panels containing widgets) treated uniformly.
- **Model→View as Observer** — when Model state changes, registered Views are notified. Decouples Model from View dependencies.

Knowing MVC's three constituent patterns is how you reason about its variants:

- **MVP** (Model-View-Presenter) — drops Observer; Presenter explicitly updates View. Easier to test View in isolation.
- **MVVM** (Model-View-ViewModel) — Observer becomes data binding; ViewModel exposes properties View binds to.
- **Flux / Redux** — drops Observer-on-Model; explicit unidirectional flow (action → reducer → store → view).

Each variant is a different choice about which constituent patterns survive and which are replaced.

### MVC pattern anti-patterns
- **Fat Model, Anaemic Controller** *(usually fine)* — business logic in Model, thin Controller.
- **Fat Controller, Anaemic Model** *(smell)* — business logic accumulates in Controller because Model is "just data." See `quality-persistence` § Domain Logic Pattern.
- **View talking to Model directly without Observer** — couples View to Model's API; defeats decoupling intent.

## 2.6 Web Presentation Patterns

*Source: PEAA — Web Presentation Patterns (Fowler)*

Specific patterns for the web tier — most modern frameworks bake one or another in. Knowing the names is how you discuss framework choices.

| Pattern | What it does | Where you've seen it |
|---------|--------------|----------------------|
| **Page Controller** | One controller per page/URL; handles its own request | ASP.NET Web Forms, simple PHP, classic Rails action |
| **Front Controller** | Single entry point routes all requests through one dispatcher | Rails router, Django URL dispatcher, Spring DispatcherServlet, Express |
| **Template View** | HTML template with embedded markers replaced by data | ERB, Jinja2, Twig, Handlebars, EJS, Razor |
| **Transform View** | Pure data → output transformation step (no embedded logic) | XSLT, JSX-as-data-transform, server-rendered React |
| **Two-Step View** | Logical structure → presentation transformation in two phases | Rails layouts + partials; component composition in JSX |
| **Application Controller** | Centralized flow/screen-navigation logic, separate from request handlers | Wizards, multi-step forms, workflow engines |

### Pattern → framework decoder

When reviewing framework-coupled code, naming the pattern often clarifies what's actually happening:

- "Why is everything in `routes.rb`?" → Front Controller. The router *is* the dispatcher.
- "Why does this template have business logic?" → Template View leaking; consider Transform View or move logic to ViewModel.
- "Why is this multi-page wizard so brittle?" → Missing Application Controller; flow logic scattered across page handlers.

**Flag:** Page Controllers in a Front Controller framework (one route handler imports another's logic); business logic in Template View files; multi-step workflow with no Application Controller (state passed implicitly via session/cookie).

---

## 3. Pattern Anti-Patterns (when patterns are misapplied)

The patterns listed below are *the most commonly abused* in practice. Flag with extra skepticism.

### Singleton
- **What goes wrong**: hidden global state, untestable code (real Singleton survives test isolation), implicit dependencies that don't appear in signatures.
- **When it's actually OK**: hardware-unique resources (one printer driver), genuinely-stateless caches, configuration registries with explicit injection points.
- **Modern alternative**: dependency injection container managing lifetime; pass the instance explicitly.
- **Flag**: Singleton holding mutable state; Singleton accessed via static method instead of injected; Singleton used as "convenient global."

### Visitor
- **What goes wrong**: doubles the dispatch surface (every new node type AND every new visitor must be updated); accidentally re-implements pattern matching badly in non-FP languages; verbose.
- **When it's actually OK**: AST traversals where you genuinely add operations without changing the class hierarchy.
- **Modern alternative**: pattern matching (Scala/Rust/Haskell), sealed type hierarchies + switch expressions (modern Java/C#).
- **Flag**: Visitor in a codebase whose language has pattern matching; Visitor with a single concrete visitor implementation (it's just a method).

### Builder for everything
- **What goes wrong**: 5-line constructor replaced with 30 lines of fluent API for no readability gain.
- **When it's actually OK**: ≥4 optional parameters with meaningful defaults; immutable objects that need staged construction.
- **Modern alternative**: named/keyword arguments (Python, Kotlin); records with default values.
- **Flag**: Builder for objects with 2-3 mandatory parameters; Builder generated by tooling without thought to whether it's needed.

### Observer in disgust
- **What goes wrong**: untraceable control flow ("who called this callback?"), memory leaks via uncleaned subscriptions, reentrancy bugs.
- **When it's actually OK**: explicit event-driven domains where decoupling is essential.
- **Modern alternative**: reactive streams (RxJava/Rx) for complex chains; pub-sub bus for cross-cutting events.
- **Flag**: Observer chains 3+ deep where direct method calls would do; missing unsubscribe on object lifecycle end.

### Factory factories
- **What goes wrong**: AbstractFactoryFactoryBuilder. Reified the abstraction so many times the original purpose is unrecoverable.
- **Flag**: any class name that's two pattern names compounded.

---

## 3.5 General Software Anti-Patterns (beyond pattern misuse)
*Source: Brown, Malveau, McCormick & Mowbray, **AntiPatterns** (1998); Beck/Fowler code smells; c2 wiki.*

§ 3 covers *misapplied GoF patterns*. This section covers the broader catalogue of recurring bad solutions — the ones that have a name precisely so a reviewer can point at them. An anti-pattern is a *commonly-reached-for* solution that looks reasonable and reliably makes things worse; naming it is half the fix. This agent **owns** the structural/cross-cutting ones that lack a dedicated home; for the rest, name it and route to the owning agent (see § 3.6).

### Structural / architectural
| Anti-pattern | Tell | Why it hurts |
|--------------|------|--------------|
| **God Object / The Blob** | one class/module knows or does everything; thousands of lines; dozens of fields | no cohesion, untestable, every change touches it |
| **Spaghetti Code** | control flow you can't trace; deep nesting; flow via shared mutable flags | change is guesswork; no module boundaries |
| **Big Ball of Mud** | no discernible architecture; everything reaches into everything | structure can't be reasoned about |
| **Golden Hammer** | one tool/pattern/lib forced onto every problem ("we use X for everything") | misfit solutions, accidental complexity |
| **Lava Flow** | dead/uncertain code kept "just in case"; commented-out blocks; `_old`/`_v2` forks | dead weight nobody dares delete |
| **Poltergeist** | a class whose only job is to call another and vanish; stateless pass-through | needless indirection; delete and inline |
| **Yo-Yo Problem** | following one behavior forces hopping up/down a deep inheritance chain | unreadable; favor composition |
| **Boat Anchor** | retained code/dependency/infra that serves no current purpose | maintenance + cognitive cost for zero value |
| **Reinventing the Wheel** | hand-rolled date math, crypto, JSON parser, retry loop | bugs the stdlib/library already solved |
| **Sequential Coupling** | methods that must be called in a hidden, specific order (`init()` then `run()`) | misuse compiles but breaks at runtime |

### Code-level
| Anti-pattern | Tell | Owning agent |
|--------------|------|--------------|
| **Magic Numbers / Strings** | unexplained literals (`* 86400`, `if status == 7`) | `quality-code-quality` |
| **Hard Coding** | env-specific paths, URLs, creds baked into source | `quality-delivery` / `quality-security-review` |
| **Copy-Paste Programming** | near-identical blocks that will drift | `quality-code-quality` (Duplicated Code) |
| **Dead Code** | unreachable branches, unused functions/params | `quality-code-quality` |
| **Cargo Cult** | code/config copied without understanding ("everyone adds this annotation") | `quality-patterns` |
| **Premature Optimization** | micro-tuning with no measured baseline | `quality-code-quality` |
| **Accidental Complexity** | complexity from the solution, not the problem | `quality-architecture` |

### How to report one
Name the anti-pattern explicitly — the name *is* the diagnosis. Then give the smallest corrective move, not a rewrite (Constitution Article I: scalpel, not sledgehammer). "This is a God Object — extract the billing responsibility into its own collaborator" beats "this class is too big."

## 3.6 Anti-Pattern Ownership Map (route, don't duplicate)
Anti-patterns are the negative space of every review axis. When the diff shows one, name it, then check whether a dedicated agent owns the deep analysis — flag-and-route rather than re-running their checks here.

| Anti-pattern family | Owning agent | This agent's role |
|---------------------|--------------|-------------------|
| Misapplied GoF pattern, Cargo Cult, Poltergeist, Golden Hammer, Lava Flow, Yo-Yo | **quality-patterns** (here) | own it — full analysis |
| God Object, Spaghetti, Big Ball of Mud, Accidental Complexity, cyclic deps, layer violations | **quality-architecture** | name it, route |
| Code smells: Magic Numbers, Dead Code, Copy-Paste, Long Method, Primitive Obsession | **quality-code-quality** | name it, route |
| Stability antipatterns (cascading failure, no timeouts, integration-point fragility) | **quality-distributed** | name it, route |
| N+1, leaky ORM mapping, missing transaction boundary | **quality-persistence** | name it, route |
| Hard-coded config/secrets, breaking schema change | **quality-delivery** / **quality-security-review** | name it, route |

---

## 4. Modern Alternatives

Several GoF patterns became language features. Don't add a pattern that the language already handles.

| Pattern | Modern alternative |
|---------|--------------------|
| Iterator | `for-each`, language-native iterators (Python, Kotlin, Rust, JS), `Iterable<T>` |
| Command | First-class functions, lambdas; `Runnable`/`Callable` already do this |
| Strategy | Lambda passed as parameter; `Comparator<T>` as a function |
| Observer | Reactive streams (RxJS/Rx); native event-emitter abstractions |
| Singleton | Dependency injection container; module-scope const in JS/Python |
| Template Method | Higher-order function taking a callback step |
| Memento | Immutable record/data class; persistent data structures |
| Visitor | Pattern matching, sealed type hierarchies + switch |

When prescribing, prefer the modern alternative if the language supports it. Naming the pattern is still useful (signals intent); writing the verbose 1995 implementation often isn't.

---

## 5. When NOT to Apply a Pattern

*Source: APOSD ch.19, GoF Introduction*

Reject pattern application when:

- [ ] **No variation exists** — Strategy with one concrete class is just a method.
- [ ] **Variation is unlikely** — speculative patterns add complexity without payoff.
- [ ] **Pattern doesn't match intent** — Visitor for type dispatch, Decorator for static behavior, Singleton for "global is convenient."
- [ ] **Language has it built in** — see § 4.
- [ ] **The pattern's complexity exceeds the problem's** — Builder for 2 params; Abstract Factory for one product family.

The bar: **the pattern must clarify intent, not obscure it.** If reviewers will need a comment to understand why the pattern is there, it's not the right pattern.

---

## Output Format

```
## Patterns Review: [scope]

### Critical (pattern misuse causing real bugs)
- [PATTERN] description — file:line — issue — fix

### Important (pattern would meaningfully improve clarity / extensibility)
- [SUGGESTED PATTERN] description — file:line — what changes

### Minor (pattern recognition / naming)
- [PATTERN] description — file:line — note

### Anti-Pattern Concerns
- [ANTI-PATTERN] file:line — what's wrong — modern alternative

### Strengths
- [pattern application done well]

Counts: Critical: X | Important: Y | Minor: Z
Verdict: [PASS / NEEDS WORK / SIGNIFICANT ISSUES]
```

---

## Severity Scale

- **Critical** — pattern is misapplied in a way that creates a real bug (Observer leak, Singleton hidden state corrupting tests, Visitor breaking on missing dispatch)
- **Important** — code would be meaningfully clearer or more extensible with a named pattern; or a pattern is overengineering the current need
- **Minor** — naming / vocabulary suggestion that helps readers; not blocking

> "Patterns are vocabulary, not commandments." — common paraphrase. Use them to clarify, not to certify.
