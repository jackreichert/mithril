---
title: On the Criteria to Be Used in Decomposing Systems into Modules
author: David L. Parnas
year: 1972
journal: Communications of the ACM, Vol. 15, No. 12
category: Paper
focus: Information hiding, interface/implementation split
---

# On the Criteria to Be Used in Decomposing Systems into Modules — D. L. Parnas (1972)

The paper that introduced **information hiding** as the criterion for modular decomposition. ~6 pages. The conceptual root of nearly every modern software-design idea.

## The thesis

Two ways to decompose a system into modules:
1. **Decompose by step** — each module does one stage of the work (parse, then process, then output).
2. **Decompose by design decision** — each module hides one decision; its interface is what other modules need to know to use it; its implementation can change without ripple.

Parnas argues the *second* is dramatically better because:
- **Changes are localized** — change one decision, change one module.
- **Modules can be developed independently** — interface is the contract.
- **Comprehension is easier** — readers don't need to understand internals.

## The KWIC example

Parnas uses a "Key Word In Context" indexing system. He shows two designs:
- **Modularization 1** (by step): main loop reads → circular shifts → alphabetizes → outputs.
- **Modularization 2** (by hidden decision): each module hides a representation choice (line storage, shifter representation, alphabetizer representation, output format).

When requirements change (storage format, indexing language, output paging), Modularization 1 cascades changes through every module; Modularization 2 contains them.

## Why this paper underpins modern practice

- **Encapsulation** in OO languages.
- **Interface vs implementation** in every API.
- **Information hiding** is the rationale, not "good practice for its own sake."
- **APOSD's "Deep Modules"** is a 2018 restatement of Parnas's thesis.
- **DDIA's storage chapter**: the choice of LSM-tree vs B-tree is a Parnas-style hidden decision.

## What's most quoted
> "We propose instead that one begins with a list of difficult design decisions or design decisions which are likely to change. Each module is then designed to hide such a decision from the others."

## How it differs from "modularization for its own sake"
Parnas's argument is *predictive*: design for changes that *will* happen. Lines-of-code modularity is irrelevant; *change-locality* modularity is everything.

## Pairs with
- **Out of the Tar Pit** (Moseley & Marks) — extends the complexity argument.
- **A Philosophy of Software Design** (Ousterhout) — modern restatement.
- *Clean Architecture* — Uncle Bob's restatement at the architecture scale.
