---
title: The Pragmatic Programmer (20th anniversary ed.)
authors: Andrew Hunt, David Thomas
year: 1999 / 2019
category: Canon
focus: Mindset, habits, tool mastery, orthogonality
---

# The Pragmatic Programmer — Hunt & Thomas (1999, 20th anniv. 2019)

A handbook of professional habits. The 2019 anniversary edition tightens the prose and updates examples. ~100 numbered tips with stories and exercises.

## Per-topic summary (chapter by chapter)

### Ch 1 — A Pragmatic Philosophy
**Tip 1:** Care about your craft. Take responsibility (no "stone soup" excuses). The Broken Windows theory: don't let bad code rot. Software entropy is a choice. Be a catalyst for change. Remember the big picture (boiled-frog problem). Knowledge portfolio: invest deliberately, diversify languages, attend conferences, read books. Communicate effectively (RFC-2026 audience analysis).

### Ch 2 — A Pragmatic Approach
**DRY** (Don't Repeat Yourself) — a principle about *knowledge*, not just code. **Orthogonality**: components that change independently. **Reversibility**: avoid one-way decisions. **Tracer bullets**: end-to-end thin slice through every layer. **Prototypes**: throwaway exploration. **Estimation**: practice it; track your accuracy.

### Ch 3 — The Basic Tools
The shell over the GUI. Master your editor (one editor, very well). Version control everything. Debugging mindset (read error messages, reproduce, binary search, rubber-duck). Text-manipulation power tools. Engineering daybook.

### Ch 4 — Pragmatic Paranoia
**Design by Contract** (Eiffel-style preconditions/postconditions/invariants). Crash early. Use assertions even in production for "can't happen" cases. Finish what you start (resource lifecycle). When uncertain, end-to-end beats top-down. Don't outrun your headlights — make small steps.

### Ch 5 — Bend, or Break
Decoupling: minimize coupling, no train wrecks, avoid global data. Configuration (externalize). Concurrency / temporal coupling (analyze workflows, separate process from work). State, blackboards, and event-driven architectures. Transforming programming (each function = data → data).

### Ch 6 — Concurrency
Shared state is incorrect state. Actors and processes. Whiteboards / blackboard architectures. Watch for shared resources, race conditions, deadlocks.

### Ch 7 — While You Are Coding
Listen to your lizard brain (instincts mean something). Programming by coincidence is fragile — know *why* it works. Algorithm speed (rough O(n) sense). Refactoring (when, what, how). **Test to code** — TDD as design feedback. Property-based testing. Stay safe out there: validate inputs, sanitize, principle of least privilege.

### Ch 8 — Before the Project / Pragmatic Projects
Requirements gathering: requirements aren't on tablets. Solving impossible puzzles: identify real constraints. Working together: pragmatic teams, organize around function, scheduling, version control, common environment. Pride and prejudice: signing your work.

## Highlights / tips most quoted
- "Don't live with broken windows."
- "Good-enough software."
- "Critically analyze what you read and hear."
- "Use tracer bullets to find the target."
- "Don't program by coincidence."
- "Refactor early, refactor often."
- "Test your software, or your users will."
- "Sign your work."

## Why it's enduring
Less prescriptive than Clean Code, more attitude-shaping than Code Complete. Reads more like Stoic philosophy for engineers than a textbook.
