---
title: Tidy First? A Personal Exercise in Empirical Software Design
author: Kent Beck
year: 2023
category: Canon
focus: tidyings, structure vs behavior, coupling/cohesion, software design economics
---

# Tidy First? — Kent Beck (2023)

A short, practical book on *empirical software design*: improving the structure of code through small, safe, individually reversible changes called **tidyings**, and deciding *when* — before, after, later, or never — to make them. Beck reframes design as an economic activity governed by the time value of money and optionality, not a one-time upfront ritual. This summary feeds the **quality-refactor** and **quality-code-quality** agents, and directly backs the Constitution's Article II "Two Hats" rule (never mix a behavior change with a refactoring in the same step) plus Beck's four rules of simple design. Part I is a catalog of moves; Part II is the discipline of batching them; Part III is the theory that justifies the whole exercise.

## Per-chapter summary

### Part I — Tidyings (the catalog of small moves)
- **Guard Clauses** — replace nested conditionals with early returns so the precondition is stated once at the top.
- **Dead Code** — delete code that no longer runs; version control is your safety net.
- **Normalize Symmetries** — make code that does the same thing look the same, so genuine differences stand out.
- **New Interface, Old Implementation** — write the interface you wish you had, delegating to the existing implementation behind it.
- **Reading Order** — reorder elements in a file to match how a reader needs to encounter them, not the order they were written.
- **Cohesion Order** — move related elements adjacent so coupled code sits together before any extraction.
- **Move Declaration and Initialization Together** — keep a variable's declaration next to where it gets its value to shrink the reader's working memory.
- **Explaining Variables** — name a subexpression with a variable so intent is on the page instead of in a comment.
- **Explaining Constants** — replace a magic literal with a symbolic constant that says what the number means.
- **Explicit Parameters** — pass values in explicitly rather than smuggling them through a map, environment, or hidden state.
- **Chunk Statements** — insert a blank line between logical groups of statements to signal a shift in concern.
- **Extract Helper** — pull a coherent block into a named helper once its boundary and purpose are clear.
- **One Pile** — when over-fragmented, inline the scattered pieces back into one place to see the whole before re-splitting better.
- **Explaining Comments** — add a comment only for what the code genuinely cannot say (the *why*, the surprise, the trap).
- **Delete Redundant Comments** — remove comments that merely restate the code; they rot and lie.

### Part II — Managing (when and whether to tidy)
- **Separate Tidying** — keep tidying commits/PRs distinct from behavior changes so each reviews cleanly (the Two Hats rule in practice).
- **Chaining** — one tidying naturally reveals the next; let them compound but stay aware of the chain's length.
- **Batch Sizes** — smaller batches cut review cost, merge conflicts, and the risk of a half-finished change; ship frequently.
- **Rhythm** — tidying is minutes-to-an-hour of work, not a project; if it grows larger, step back and re-decide.
- **Getting Untangled** — when tidying and behavior changes are already mixed, prefer to revert and redo separately over untangling by hand.
- **First, After, Later, Never** — choose tidying timing by payoff: *first* if it eases the imminent change, *after* if you learned the shape, *later* if not yet, *never* if the code won't be touched.

### Part III — Theory (the economics that justify it)
- **Beneficially Relating Elements** — software design is the activity of arranging elements and their relationships to your benefit.
- **Structure and Behavior** — code creates value two ways: *behavior* (what it does now) and *structure* (the optionality to change behavior cheaply later); tidying invests in structure.
- **Economics: Time Value and Optionality** — design decisions are financial decisions weighing money over time against future options.
- **A Dollar Today > A Dollar Tomorrow** — discounting argues *against* premature tidying: don't spend now for a payoff that may never come.
- **Options** — but messy code you'll change is a held option; tidying first buys cheaper future changes — this pulls the other way.
- **Options Versus Cash Flows** — reconcile the tension: tidy when the option value (uncertain future change) outweighs the discounted cost of doing it now.
- **Reversible Structure Changes** — tidyings are cheap precisely because they're reversible; reversibility is what makes aggressive small moves safe.
- **Coupling** — Beck's operational definition: two elements are coupled if changing one forces changing the other; coupling is what makes change expensive.
- **Constantine's Equivalence** — the cost of software is dominated by the cost of change, which is dominated by coupling — so reducing coupling is the lever.
- **Coupling Versus Decoupling** — decoupling has its own cost and can over-abstract; decouple only where the coupling actually bites.
- **Cohesion** — gather strongly-related elements so a change lands in one place; cohesion is the constructive counterpart to reducing coupling.

## Critiques worth knowing
- **Deliberately thin.** Each tidying is a page or two with little worked code; readers wanting deep refactoring mechanics are better served by Fowler's *Refactoring* — Beck assumes you already know *how* and focuses on *when/whether*.
- **First of a planned series.** The subtitle and book promise sequels on managing and on theory at scale; the economics in Part III is sketched, not fully developed, so the optionality argument can feel more evocative than rigorous.
- **Coupling definition is contested.** Beck's "change one forces change in the other" is operational and useful but blurs structural vs. logical coupling that other authors separate; treat it as a working lens, not a taxonomy.
- **Judgment-heavy.** "First, After, Later, Never" gives a frame but no formula — the call still rests on experience, which is honest but offers little to a junior looking for rules.
- **Pairs with the Constitution.** The book is the canonical source for Article II's Two Hats and the separate-commits discipline; lean on it when reviewing diffs that mix refactoring with feature work.
