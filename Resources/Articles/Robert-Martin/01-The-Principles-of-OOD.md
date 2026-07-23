---
title: The Principles of OOD (SOLID)
author: Robert C. Martin
url: blog.cleancoder.com (originally objectmentor.com newsletters)
category: Article — Robert Martin
focus: Original SOLID articles (SRP, OCP, LSP, ISP, DIP)
---

# The Principles of OOD — Uncle Bob's SOLID Articles

A series of newsletters from the late 1990s where Martin distilled and named the SOLID principles. Predates *Clean Architecture* by two decades; the underlying writing.

## SRP — Single Responsibility Principle
> A class should have only one reason to change.

The "reason" is a *stakeholder* (or actor in *Clean Architecture*'s framing), not a function. Code that serves two stakeholders gets pulled in two directions. Symptom: the class changes for marketing AND for finance — split it.

## OCP — Open/Closed Principle
> Software entities should be open for extension, closed for modification.

Achieve via **abstraction** + **polymorphism**. Adding a new payment method shouldn't require editing the existing payment-handling switch — add a new class implementing the existing interface.

## LSP — Liskov Substitution Principle
> Subtypes must be substitutable for their base types.

Barbara Liskov's 1987 formal definition. Practical: if `Square extends Rectangle` and `Rectangle.setWidth(w)` doesn't preserve the squareness invariant, you've violated LSP. Subclassing should preserve the contract — preconditions can't be strengthened, postconditions can't be weakened.

## ISP — Interface Segregation Principle
> Clients should not be forced to depend on methods they do not use.

Fat interfaces couple clients together. Solution: split into smaller, role-based interfaces. Even when implementations stay together, *interfaces* should reflect what each client needs. Prevents "shotgun surgery" via ripple-coupling.

## DIP — Dependency Inversion Principle
> High-level modules should not depend on low-level modules. Both should depend on abstractions.
> Abstractions should not depend on details. Details should depend on abstractions.

The most-misnamed principle. It's not about Dependency *Injection* (a technique) — it's about which way *source-code* dependencies point. Make stable policy depend on its own abstractions; let unstable details implement those abstractions.

## How they fit together
- **SRP** — what goes in a class.
- **OCP + LSP** — how to extend without breaking.
- **ISP** — which clients see what.
- **DIP** — which way dependencies point.

Together: a system whose policy is stable, replaceable, and unaffected by detail churn.

## Common confusions
- **"SRP means small classes"** — no, it means classes change for one reason. A class can be large.
- **"DIP means use DI containers"** — no, it's the *source-code dependency direction*. DI is one mechanism.
- **"OCP means rigidity"** — closed for modification of stable code, not closed forever.

## Pairs with
- *Clean Architecture* (book) — the longer treatment.
- **Effective Java** items 17–18 (immutability + composition).
