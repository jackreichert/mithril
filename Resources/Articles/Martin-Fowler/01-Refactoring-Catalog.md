---
title: Refactoring Catalog
author: Martin Fowler
url: refactoring.com
category: Article — Martin Fowler
focus: 68 named refactoring moves with mechanics
---

# Refactoring Catalog — refactoring.com

The web companion to *Refactoring* (2nd ed.). Continuously updated. ~68 entries, each with: name, motivation, mechanics (numbered steps), example.

## Structure
Every catalog entry is keyed to a smell from *Refactoring* ch. 3 and follows the same format:
- **Description** (one line)
- **Motivation** (when to use)
- **Mechanics** (numbered, small steps with tests after each)
- **Example** (before/after JavaScript)

## Why it's useful as a separate resource
- The book's catalog uses one specific JavaScript example each. The website is *kept current* and lets you skim alphabetically or by smell.
- Each refactoring is permalinked (`refactoring.com/catalog/extractFunction.html`) for easy citation in code review.

## High-frequency entries to know cold
- Extract Function / Inline Function
- Extract Variable
- Rename Variable / Field / Function
- Replace Conditional with Polymorphism
- Replace Nested Conditional with Guard Clauses
- Move Function / Field
- Combine Functions into Class
- Replace Primitive with Object
- Decompose Conditional
- Introduce Parameter Object
- Replace Loop with Pipeline
- Replace Subclass with Delegate
- Hide Delegate / Remove Middle Man
- Encapsulate Variable / Record / Collection
- Split Phase

## Companion smell catalog
The site also publishes the [Code Smells](../Martin-Fowler/02-Code-Smells.md) list as a parallel index — clicking a smell takes you to suggested refactorings.
