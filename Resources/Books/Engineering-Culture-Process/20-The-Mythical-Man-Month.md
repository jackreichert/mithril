---
title: The Mythical Man-Month — Essays on Software Engineering
author: Frederick P. Brooks Jr.
year: 1975 / 1995 (anniversary ed.)
category: Engineering Culture & Process
focus: Complexity, estimation, team coordination
---

# The Mythical Man-Month — Fred Brooks (1975, 1995 anniv.)

A book of essays from the IBM OS/360 project. Half the essays are 50 years old; almost all are still cited weekly in software conversations.

## Per-essay summary

### Ch 1 — The Tar Pit
The joys (creation, novelty, building tools, learning) and woes (perfection demanded, others' will, dependencies, obsolescence) of programming. The tar pit metaphor: the bigger the project, the harder it is to move.

### Ch 2 — The Mythical Man-Month
The book's title essay. **Brooks's Law**: "Adding manpower to a late software project makes it later." Why: training overhead + communication overhead. *Man-months are a fictional unit when tasks aren't partitionable.*

### Ch 3 — The Surgical Team
Mills's idea of small teams led by a single chief programmer. Quality over quantity. Communication overhead minimized.

### Ch 4 — Aristocracy, Democracy, and System Design
**Conceptual integrity** is the most important consideration in system design. A few minds must own the architecture.

### Ch 5 — The Second-System Effect
The danger of the *second* system: over-engineered, over-featured, gilded, slow to ship. First systems are lean from inexperience; third systems are lean from learning. The middle one is the trap.

### Ch 6 — Passing the Word
Architecture must be communicated to all implementers. Specifications, formal definitions, manuals.

### Ch 7 — Why Did the Tower of Babel Fail?
**Communication and organization**. The project failed not for technical reasons but because builders couldn't talk. Documentation, project workbook.

### Ch 8 — Calling the Shot
Estimation: programmers are bad at it. Productivity numbers from real projects vary 10×. Treat schedules as informed guesses, refine continuously.

### Ch 9 — Ten Pounds in a Five-Pound Sack
Memory and code-size budgets. Trade-offs are inherent. Mention to engineers: "size is part of cost."

### Ch 10 — The Documentary Hypothesis
A small set of canonical documents (project workbook) anchors a project: schedule, budget, organization, allocation, estimate, specification.

### Ch 11 — Plan to Throw One Away
Famous advice (later partially recanted): the first system you build will be wrong; plan to throw it away. The "build one to throw away" line. In the 1995 essay, Brooks softens to "incremental development."

### Ch 12 — Sharp Tools
Investing in tools is investing in productivity. Personal tools, team tools, project libraries.

### Ch 13 — The Whole and the Parts
Bug-finding strategies. Top-down, bottom-up, system testing. Build the *whole* — not just the parts.

### Ch 14 — Hatching a Catastrophe
"How does a project get to be a year late? One day at a time." Tracking schedule slippage. Chronic causes (impossible commitments, missing skills) vs. acute (one-off events).

### Ch 15 — The Other Face
Documentation aimed at the *user*, not the program. Self-documenting programs (which he later admits was over-promised).

### Ch 16 — No Silver Bullet — Essence and Accident in Software Engineering ⭐
The famous 1986 paper. **Essential complexity** is the inherent difficulty of the problem; **accidental complexity** is what we add through tools and process. Software's essence is *complex, conformant, changeable, invisible* — no single technique will give 10× productivity.

### Ch 17 — "No Silver Bullet" Refired (1995 add)
Re-evaluation of NSB after 9 years. OO, reuse, environments — improvements but not bullets. The thesis still holds.

### Ch 18 — Propositions of The Mythical Man-Month: True or False? (1995 add)
Brooks's own self-grade on each chapter's claims.

### Ch 19 — The Mythical Man-Month after 20 Years (1995 add)
Reflective survey: what the book got right, what it got wrong (waterfall fetishism, the throw-one-away line).

## Why it endures
The OS/360 stories are dated; the lessons aren't. Brooks's Law, conceptual integrity, the second-system effect, essence vs accident — every senior engineer should be able to recognize them in current projects.
