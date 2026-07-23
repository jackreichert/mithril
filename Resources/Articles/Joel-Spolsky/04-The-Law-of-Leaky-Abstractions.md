---
title: The Law of Leaky Abstractions
author: Joel Spolsky
url: joelonsoftware.com/2002/11/11/the-law-of-leaky-abstractions/
category: Article — Joel Spolsky
focus: All non-trivial abstractions leak
---

# The Law of Leaky Abstractions — Joel Spolsky (2002)

> All non-trivial abstractions, to some degree, are leaky.

When an abstraction hides complexity, the underlying complexity *still exists* and occasionally surfaces — through performance, errors, or edge cases.

## Examples Joel cites

- **TCP** abstracts a "reliable byte stream" over packets that lose, reorder, and corrupt. When the network is bad, your "reliable" connection stalls — TCP has leaked.
- **String over byte arrays** in some languages — works until you process non-ASCII data, when encoding details leak through.
- **Iterating a 2D array** row-by-row vs. column-by-column — same logical operation, but cache effects make one orders of magnitude faster. Memory layout has leaked.
- **SQL** abstracts data retrieval — until performance forces you to think about indexes, query plans, and joins.
- **ORMs** abstract SQL — until N+1 queries surface.
- **Remote procedure calls** abstract distributed systems — until a network partition creates partial failures (cf. Waldo, "A Note on Distributed Computing").

## Implications

### You can't escape understanding the layers below
A senior engineer must understand TCP even when using HTTP, must understand SQL even when using an ORM. The abstractions save *time*, not *understanding*.

### Junior engineers are dangerous in leaky territory
A new hire on a high-level framework writes correct code until the abstraction leaks — at which point they have no model for what's happening.

### Abstractions accumulate, not remove, things to learn
Modern web stack: HTTP → REST → GraphQL → ORM → SQL → indexes → disk → networks. You must know *all* layers because any can leak.

## Counter-balancing thought
Despite leaks, abstractions are net positive — most of the time the leak doesn't happen, and you ship faster. The cost is paid only at the boundary of unusual conditions.

## Pairs with
- **A Note on Distributed Computing** (Waldo et al.) — *the* canonical leaky abstraction at distance.
- **No Silver Bullet** (Brooks) — accidental complexity *is* often abstraction overhead.
- *DDIA* — every chapter is full of "the abstraction breaks down at scale."
