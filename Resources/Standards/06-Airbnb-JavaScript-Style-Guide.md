---
title: Airbnb JavaScript Style Guide
publisher: Airbnb
url: github.com/airbnb/javascript
category: Standard — Style
focus: Most-starred JS style guide
---

# Airbnb JavaScript Style Guide — Airbnb

A "mostly reasonable" approach to JavaScript style. The most-starred JavaScript style guide on GitHub. Companion ESLint config (`eslint-config-airbnb`) applies the rules automatically.

## Sections (highlights)

### Types
- **Primitives**: passed by value.
- **Complex**: passed by reference.
- Prefer `const` over `let`, `let` over `var`.

### References
- `const` for things never reassigned.
- `let` for things reassigned (rare).
- Never `var`.

### Objects
- Literal syntax (`{}` not `new Object()`).
- Computed property names.
- Shorthand methods, shorthand properties.
- Group shorthand at the top.

### Arrays
- Literal syntax (`[]` not `new Array()`).
- `array.push()` not `array[array.length]`.
- Spread operator for copies.
- `Array.from()` for array-like.

### Destructuring
- Object destructuring for multiple values.
- Array destructuring for ordered values.
- Object destructuring for return-multiple.

### Strings
- Single quotes (`'`) not double.
- Template literals for interpolation.
- Don't concatenate with `+` for long strings.

### Functions
- Named function expressions for recursion or stack traces.
- Default parameters over mutating arguments.
- Don't reassign parameters.
- Arrow functions for callbacks.

### Arrow functions
- Implicit return for one-liners.
- Always wrap arguments in parens (consistency).

### Classes & Constructors
- Use `class`, not prototype manipulation.
- Method chains via explicit returns.
- Don't override `toString()` recklessly.

### Modules
- Always use ES modules (`import`/`export`), not CommonJS.
- Group imports: external libs, internal, relative.
- Prefer named exports.

### Iterators & Generators
- Avoid `for...in`. Prefer `map`, `filter`, `reduce`, `for...of`.
- Avoid generators in legacy code.

### Variables
- One `const` per declaration.
- Group `const`s, then `let`s.

### Comparison Operators
- `===` and `!==`, never `==`.
- Use shortcut for boolean checks.

### Whitespace
- 2-space indent.
- Trailing newline.
- Spaces around operators.
- Semicolons required.

### Type Casting & Coercion
- `String(value)` not `'' + value`.
- `Number(value)` not `+value`.
- Use `parseInt(value, 10)` (always pass radix).
- `Boolean(value)` or `!!value`.

## How to adopt
1. Install `eslint-config-airbnb` (or `airbnb-base` for non-React).
2. Configure your editor.
3. Adjust 1–2 rules if your team strongly prefers something specific.

## When it's overkill
For greenfield TypeScript projects, **TypeScript-ESLint Recommended** + **Prettier** often suffices. Airbnb still useful for stricter teams or React-heavy work.

## Pairs with
- **Prettier** for formatting (complementary).
- **ESLint** for enforcement.
- Google JavaScript Style Guide for an alternative.
