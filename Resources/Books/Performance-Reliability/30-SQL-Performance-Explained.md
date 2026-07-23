---
title: SQL Performance Explained
author: Markus Winand
year: 2012
category: Performance-Reliability
focus: Indexing, B-tree anatomy, query performance, joins, sorting, pagination
---

# SQL Performance Explained — Markus Winand (2012)

A developer-focused, vendor-neutral field guide to making SQL fast — the index is a structure you design, not a switch the DBA flips. It feeds the **quality-persistence** agent and is the source for the SQL-hygiene rules in `skills/persistence.md §10`: the **no `SELECT *` in production code; name explicit columns** rule (over-fetching, killing **covering indexes**, breaking silently when columns are added) plus the indexing / `WHERE` / `ORDER BY` / `LIMIT` guidance below.

## Per-chapter summary

### Ch 1 — Anatomy of an Index
An index is a **doubly-linked list of leaf nodes** plus a **B-tree** that finds the right leaf in logarithmic time. Understand both halves: the tree locates the entry, the linked list serves ranges. **An index is a distinct data structure with its own storage and write cost** — every index slows `INSERT`/`UPDATE`/`DELETE`, so add them deliberately, not reflexively.

### Ch 2 — The Where Clause
This is the chapter that decides most query performance. Build composite indexes for the **predicates you actually filter on**, and put the most selective/equality columns first — **column order in a concatenated index is everything**. Beware the **slow indexes** trap: an index on the wrong leading column, a function or implicit cast wrapping a column (`WHERE UPPER(name)=...`), or a `LIKE '%x'` leading wildcard all **disable the index** and force a full scan. Bind parameters help the cache but can hide skewed data distributions from the optimizer.

### Ch 3 — Testing and Scalability
Performance measured on a tiny dev dataset lies — **test against realistic data volumes** because response time degrades non-linearly as rows and concurrency grow. Distinguish **response time** (one query) from **throughput** (system load); an index that wins on a small table can lose under contention. Read the **execution plan**, not the wall-clock guess.

### Ch 4 — The Join Operation
The three join algorithms have different index needs: **nested loops** wants an index on the join column of the inner (looked-up) table, **hash join** wants indexes on the independent `WHERE` predicates feeding each side, and **sort-merge** wants both inputs ordered. Index the join the way the optimizer will execute it. **Avoid the N+1 pattern** — one set-based join beats a query-per-row loop.

### Ch 5 — Clustering Data
**Clustering** means storing related rows physically close so one read fetches many. A **covering index** (index-only scan) is the cheapest form: list the queried columns in the index so the **table is never touched** — the strongest argument for naming explicit columns and never `SELECT *`. Index-organized / clustered tables trade write cost and a single clustering key for read locality.

### Ch 6 — Sorting and Grouping
A `ORDER BY` or `GROUP BY` that matches an **index's order is free** — the database walks the already-sorted leaf chain and skips an explicit sort. Order the index columns to satisfy both the `WHERE` filter and the sort direction (mind `ASC`/`DESC` mismatches). An explicit sort is a **pipeline-blocking** operation that buffers the whole result before returning the first row.

### Ch 7 — Partial Results
**Top-N and pagination** queries should fetch only what they show. An index supplying the sort order lets the database stop early after `LIMIT`/`FETCH FIRST` rows — a **pipelined Top-N**. Prefer **keyset (seek) pagination** (`WHERE id > :last ORDER BY id`) over `OFFSET`: offset re-scans and discards every skipped row, so page 1000 is 1000x slower, while keyset stays constant-time.

### Ch 8 — Insert, Delete and Update
Indexes are a **read optimization paid for on write** — each one must be maintained on every modifying statement, and the cost rises with index count and width. `INSERT` cannot benefit from indexes; `DELETE` and `UPDATE` need an index to *find* the rows but then pay to *maintain* every affected index. **Drop indexes you don't query**, and remember an `UPDATE` only touches indexes covering the changed columns.

## Critiques worth knowing
Examples target 2012-era Oracle/SQL Server/PostgreSQL/MySQL, so syntax and a few cost numbers are dated — but the B-tree mechanics and the optimizer-reasoning it teaches are timeless. It is deliberately silent on columnar/analytical engines, modern covering-index variants (`INCLUDE`), and distributed/NewSQL planners, so pair it with current docs for OLAP or sharded workloads.
