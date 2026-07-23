---
title: Clean Code series (blog)
author: Robert C. Martin
url: blog.cleancoder.com
category: Article — Robert Martin
focus: Application of Clean Code principles
---

# Clean Code Series — blog.cleancoder.com

A long-running set of essays applying *Clean Code*'s principles to specific examples, controversies, and case studies. Tone is more conversational than the book.

## Recurring themes

### Naming
- Why generic names (`process`, `data`, `manager`) are an anti-pattern.
- The "newspaper rule": top-down readability.
- Renaming as a continuous activity, not a one-time event.

### Functions
- Defending the small-functions thesis against APOSD-style critiques.
- "Extract Till You Drop" — long blog series advocating aggressive function extraction.
- The Stepdown rule: each function calls helpers one abstraction level lower.

### Classes
- SRP violations as common sources of defects.
- "Cohesion is everything." Why low-cohesion classes get worked over by every developer in turn.

### Comments
- Strong stance: comments are failures.
- Allowable exceptions: legal headers, intent annotations, warnings, regex explanations.

### Architecture
- The "Clean Architecture" diagram revisited.
- Practical advice for layering frameworks, persistence, UI.

### Defending dogma
- A frequent essay theme: a critic objects to a Clean Code rule, Martin defends.
- Notable: defenses of small functions, of TDD as discipline rather than ceremony.

## High-frequency posts to know
- "Extract Till You Drop"
- "The Single Responsibility Principle"
- "What Killed Smalltalk Could Kill Ruby Too" (community/discipline angle)
- "Type Wars"
- "Functional Programming Basics" (see [05-FP-Basics-series.md](05-FP-Basics-series.md))

## Caveats
- Strong opinions, often dogmatic. Read with `A Philosophy of Software Design` as counterweight.
- Some essays stray into industry politics rather than craft.
- Code samples are usually Java; generalizations made loudly.

## Why include
The blog is where Uncle Bob's *current* thinking lives. Books are snapshots; blog is the running update.
