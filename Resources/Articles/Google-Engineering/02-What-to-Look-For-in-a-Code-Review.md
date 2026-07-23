---
title: What to Look For in a Code Review
publisher: Google Engineering Practices
url: google.github.io/eng-practices/review/reviewer/looking-for.html
category: Article — Google Engineering
focus: Design, functionality, complexity, tests, naming, comments, style, docs
---

# What to Look For in a Code Review — Google Eng Practices

A specific checklist of dimensions a reviewer should evaluate. Order matters — earlier dimensions trump later ones.

## The checklist (in order)

### 1. Design
> Is the code well-designed and appropriate for your system?

Highest priority. A perfectly written CL with the wrong design is worse than a sloppy CL with the right design (the latter can be fixed; the former gets entrenched).

### 2. Functionality
> Does it behave as the author intended? Is the behavior good for users?

Reviewers should think about edge cases, concurrency, accidental data loss. Manual UI testing may be required for UI changes.

### 3. Complexity
> Could the code be simpler? Would another developer understand and use this code easily?

Watch for over-engineering — solving *general* problems instead of the *current* problem. "I'll need this someday" is rarely true.

### 4. Tests
> Does the change have tests? Are they appropriate? Do they break?

Unit tests at minimum; integration as warranted. Tests should fail when they should and pass when they should. No fragile tests, no skipped tests, no commented-out tests.

### 5. Naming
> Did the developer choose good names?

Names communicate to future readers. "Good" = specific, accurate, not too long. Domain language preferred over generic.

### 6. Comments
> Are the comments clear and useful?

Comments explain *why*, not *what*. Outdated comments are worse than no comments. TODO comments need owners.

### 7. Style
> Does the code follow style guides?

Mostly automatable now (linters, formatters). Bar for blocking on style: only if linter would fail the build.

### 8. Consistency
> Is the code consistent with the rest of the codebase?

If a convention exists in this directory, follow it. If you disagree, propose changing the convention separately, not in this CL.

### 9. Documentation
> Did the developer update relevant documentation?

Particularly: API docs, README, changelogs.

### 10. Every line
> Look at every line of code. Don't skim.

Skipping lines means reviewers miss bugs. If the diff is too big to read line-by-line, request a split.

### 11. Context
> Is the change in context with the surrounding code and the larger system?

Sometimes a CL is fine in isolation but breaks an architectural boundary or duplicates existing functionality elsewhere.

### 12. Good things
Note positive choices. Code review is education in both directions.

## Reading order is the rubric
Block on (1)–(4); flag (5)–(11) but rarely block on alone.

## Pairs with
- The CL Author's Guide.
- The "Standard of code review" essay.
