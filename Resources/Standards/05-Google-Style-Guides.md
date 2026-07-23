---
title: Google Style Guides
publisher: Google
url: google.github.io/styleguide/
category: Standard — Style
focus: Python, Java, C++, Go, JS style standards
---

# Google Style Guides — Google

Per-language coding standards used inside Google's monorepo. Open-sourced. Well-maintained, opinionated, pragmatic. Covered languages include:
- C++
- Java
- Python (now mostly superseded by Black + PEP 8 in many shops, but Google's Python guide still influential)
- JavaScript
- TypeScript
- Go (the official Go style is in `gofmt` and `effective_go.html` — Google's contribution as well)
- Shell
- HTML/CSS
- Objective-C, Swift, Lisp, AngularJS, R

## What's distinctive across all of them

### Formatting decisions made for you
- Indentation, line length, brace placement, import order — all specified.
- The bet: any consistent formatting > endless debate.

### "Why" sections
Each rule has rationale. Disagree with a rule? Read the rationale before debating.

### Built around tooling
- Formatters (clang-format, gofmt, yapf, prettier) implement the style.
- Linters enforce semantic rules (errorprone, eslint configs).
- The style guide is a *spec*; tooling is the implementation.

### Pragmatic, not pretty
- Optimized for *codebases* and *teams*, not personal taste.
- Tradeoffs explicit when picked (e.g., 80-col vs 100-col line length).

## Highlights per language

### C++
- Smart pointers always over raw owning pointers.
- No exceptions in legacy code; conditional in new code.
- Templates limited; readability over cleverness.

### Java
- Block-style braces, no wildcard imports, override annotations required.
- Notable: `@Override` mandatory; null-handling conservative; AutoValue/Records preferred.

### Python (used for legacy code; new Python often follows PEP 8 + Black)
- 2-space indent (Google convention; differs from PEP 8's 4).
- Specific docstring format (Google or NumPy style).
- Type hints encouraged.

### JavaScript / TypeScript
- 2-space indent, single quotes, mandatory braces.
- TypeScript-strict in new code.

### Go
- gofmt is the spec.
- Effective Go for idioms.
- No alternative formatting allowed.

## Why use Google's even outside Google
- Battle-tested at scale.
- Tooling that maps cleanly to the spec.
- Free starting point for teams that don't want to write their own.

## Pairs with
- **Airbnb JavaScript Style Guide** for JS.
- **PEP 8** for Python.
- *Software Engineering at Google* ch. 8 (Style Guides and Rules).
