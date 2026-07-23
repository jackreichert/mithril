---
title: Code Complete (2nd ed.)
author: Steve McConnell
year: 2004
category: Canon
focus: Construction fundamentals — the encyclopedia
---

# Code Complete (2nd ed.) — Steve McConnell (2004)

The encyclopedia of software construction: 35 chapters, ~900 pages, citations to empirical studies throughout. If Clean Code is opinionated essays, Code Complete is the textbook.

## Part I — Laying the Foundation

### Ch 1 — Welcome to Software Construction
Defines "construction" as detailed design + coding + debugging + unit testing + integration. ~30–80% of total project effort. The most direct lever on quality.

### Ch 2 — Metaphors for a Richer Understanding of Software Development
Software construction as building (architectural blueprints, structural decisions). Other metaphors (writing, growing) explored and rated.

### Ch 3 — Measure Twice, Cut Once: Upstream Prerequisites
Cost of fixing defects rises 10–100× across phases. Stable requirements + architecture before construction. Lists prereq checklists.

### Ch 4 — Key Construction Decisions
Language, conventions, location of work in lifecycle, programming-into-language vs programming-in-language.

## Part II — Creating High-Quality Code

### Ch 5 — Design in Construction
Wicked problems, sloppy process, multiple solutions. Heuristics over algorithms. Information hiding (Parnas), low coupling, high cohesion, levels of abstraction. Iterative design.

### Ch 6 — Working Classes
ADT-thinking, good interfaces, encapsulation, inheritance pitfalls, member functions and data. ~24 design heuristics for classes.

### Ch 7 — High-Quality Routines
Why create a routine: reduce complexity, hide sequences, hide pointer ops, improve readability. Cohesion levels (functional > sequential > communicational > temporal > procedural > logical > coincidental). Routine length advice.

### Ch 8 — Defensive Programming
Validate inputs, assertions, error-handling techniques, exception use, barricades, debugging aids. The "barricade" concept: trust internal data after sanitizing at boundaries.

### Ch 9 — The Pseudocode Programming Process
Iterative refinement: write pseudocode, refine until it's almost code, then translate. Find errors early.

## Part III — Variables

### Ch 10 — General Issues in Using Variables
Implicit declaration dangers, scope minimization, principle of proximity, single-purpose variables.

### Ch 11 — The Power of Variable Names
Length vs descriptiveness. Effective names balance specificity and readability. Naming conventions, computed-value qualifiers (Total, Sum, Average, Max, Min, Record, String, Pointer).

### Ch 12 — Fundamental Data Types
Numbers (gotchas with floating point), characters/strings, booleans, enums, arrays, named constants.

### Ch 13 — Unusual Data Types
Structures, pointers (cautions), global data (alternatives via access routines).

## Part IV — Statements

### Ch 14 — Organizing Straight-Line Code
Sequential dependence — make it explicit through ordering, parameter use, variable lifetimes.

### Ch 15 — Using Conditionals
if/else chains, switch/case, avoiding deep nesting via guard clauses, decision tables.

### Ch 16 — Controlling Loops
Choice of loop, entering, processing inside, exiting cleanly, loop variables. When to use break/continue.

### Ch 17 — Unusual Control Structures
Multiple returns, recursion (with caution), goto (controversial defense in some niche cases).

### Ch 18 — Table-Driven Methods
Data-driven branching: replace complex logic with table lookups. Direct, indexed, stair-step access.

### Ch 19 — General Control Issues
Boolean expression complexity, deep nesting (maximum 3 levels), structured programming.

## Part V — Code Improvements

### Ch 20 — The Software-Quality Landscape
Internal vs external quality. Quality assurance plan: testing, reviews, prototypes.

### Ch 21 — Collaborative Construction
Pair programming, formal inspections, walkthroughs. Inspections find defects far cheaper than testing.

### Ch 22 — Developer Testing
Unit testing limits, test cases by approach (boundary, structured basis, data flow). Limits: testing can't prove absence of defects.

### Ch 23 — Debugging
Scientific method for debugging. Source-of-defect data. Psychological pitfalls. Tools.

### Ch 24 — Refactoring
Reasons to refactor, list of canonical refactorings (predates Fowler-2018 update), strategies for safety.

### Ch 25 — Code-Tuning Strategies
Don't optimize prematurely. Measure. Pareto: 20% of code uses 80% of time. Common sources of inefficiency.

## Part VI — System Considerations

### Ch 26 — Code-Tuning Techniques
Specific techniques: logic, loops, data transformations, expressions, routines, recoding in low-level language. Caveat: always measure.

### Ch 27 — How Program Size Affects Construction
Communication paths grow O(N²); large projects need formality.

### Ch 28 — Managing Construction
Encouraging good coding (standards, configuration management, estimation, scheduling, measurement).

### Ch 29 — Integration
Phased vs incremental. Top-down, bottom-up, sandwich, risk-oriented, feature-oriented, T-shaped. Daily build + smoke test.

### Ch 30 — Programming Tools
Editors, version control, static analysis, debuggers, profilers — and why your tool quality matters.

## Part VII — Software Craftsmanship

### Ch 31 — Layout and Style
Style affects comprehension. Indenting, white space, alignment, parens, comments — all empirically studied.

### Ch 32 — Self-Documenting Code
Code structure + naming = better than comments. When you do comment: intent, summary, copyright, references.

### Ch 33 — Personal Character
Curiosity, intellectual honesty, communication, creativity, discipline, laziness (good kind), persistence, experience.

### Ch 34 — Themes in Software Craftsmanship
Conquer complexity, pick your process, write programs for people first, iterate.

### Ch 35 — Where to Find More Information
Annotated bibliography — useful index of where each Code Complete topic was originally explored.

## Why it still matters
The empirical citations (defect-rates, cost-curves, study results) ground the advice in evidence in a way that almost no other book on this list does.
