---
title: Database Internals
author: Alex Petrov
year: 2019
category: Performance-Reliability
focus: Storage engines, B-trees/LSM-trees, WAL, distributed consensus, replication
---

# Database Internals — Alex Petrov (2019)

A deep dive into how storage engines and distributed data systems actually work under the hood. Feeds the **quality-persistence** and **quality-distributed** agents, and complements *Designing Data-Intensive Applications* with far deeper storage-engine and consensus internals.

## Part I — Storage Engines

### Ch 1 — Introduction and Overview
Frames the **DBMS architecture**: transport, query processor, execution engine, and storage engine. Distinguishes **memory- vs disk-based**, **column- vs row-oriented**, and **data files vs index files**. Know which trade-off your engine made before you reason about its behavior.

### Ch 2 — B-Tree Basics
Explains why **B-Trees** dominate disk storage: high fan-out, shallow height, page-sized nodes that match block I/O. Contrasts with binary trees that thrash the cache. The **branching factor** is the whole game — fewer seeks per lookup.

### Ch 3 — File Formats
Covers how records, cells, and pages are laid out on disk: **slotted pages**, cell offsets, variable-length encoding, and checksums. Binary layout is not an afterthought — it dictates read amplification and corruption detection. Version your formats.

### Ch 4 — Implementing B-Trees
The hard parts: **page splits and merges**, rebalancing, sibling pointers, and right-only appends. Introduces **B-link trees**, fence keys, and concurrent access via latch crabbing. Most real-world bugs live in the split/merge edge cases — test boundaries relentlessly.

### Ch 5 — Transaction Processing and Recovery
**ACID** mechanics: buffer management, **write-ahead logging (WAL)**, steal/no-force policies, and **ARIES** redo/undo recovery. Concurrency control via **2PL, MVCC, and optimistic schemes**; isolation levels expose real anomalies. Never trust durability you haven't fsynced.

### Ch 6 — B-Tree Variants
Surveys **copy-on-write B-Trees** (LMDB-style, no in-place writes), **lazy B-Trees** with update buffers (WiredTiger), **FD-trees**, and **Bw-Trees** (lock-free, delta-chained). Each variant trades write amplification, concurrency, or space differently. Pick by workload, not fashion.

### Ch 7 — Log-Structured Storage
**LSM-Trees**: buffer writes in a memtable, flush to immutable **SSTables**, merge via compaction. Reads pay an amplification tax mitigated by **Bloom filters** and **skiplists**; deletes use tombstones. The core read/write/space-amplification triangle — you optimize two, the third suffers.

## Part II — Distributed Systems

### Ch 8 — Introduction and Overview
Why distribution is genuinely hard: **concurrent execution**, no shared state, unreliable clocks, and **partial failure** where you can't tell crashed from slow. Sets up the FLP impossibility and the gap between **synchronous and asynchronous** system models. Local intuitions break across the network.

### Ch 9 — Failure Detection
You can never be certain a node is dead — only suspect it. Covers **heartbeats, timeouts, phi-accrual detectors**, and gossip-based detection. Tunes the **completeness vs accuracy** trade-off: declare death too fast and you cause needless failovers.

### Ch 10 — Leader Election
Algorithms to pick one coordinator: **Bully** and **ring-based** election. A leader simplifies coordination but creates a single point of contention; **stable leader** properties matter for throughput. Beware split-brain when election and failure detection disagree.

### Ch 11 — Replication and Consistency
The **consistency models** spectrum: linearizability, sequential, causal, and eventual. Explains **CAP and PACELC**, quorums, read/write overlap, and **session guarantees** (read-your-writes, monotonic reads). Pick the weakest model that still satisfies the requirement — strong consistency is expensive.

### Ch 12 — Anti-Entropy and Dissemination
How eventually-consistent systems converge: **read repair, hinted handoff, Merkle trees**, and **gossip/epidemic** dissemination. Anti-entropy is the background reconciliation that fixes divergence quorums missed. Bound the propagation, or stale data lingers forever.

### Ch 13 — Distributed Transactions
Atomic commit across nodes: **two-phase commit (2PC)** and its blocking weakness, **three-phase commit (3PC)**, and modern designs — **Calvin** (deterministic ordering), **Spanner** (TrueTime), **Percolator**. Consistent-hashing partitioning underpins them. 2PC's coordinator failure window is the classic trap.

### Ch 14 — Consensus
Getting nodes to agree despite failures: **broadcast and atomic broadcast**, virtual synchrony, **Paxos** (and Multi-Paxos, Fast Paxos, EPaxos), **ZAB/ZooKeeper**, and **Raft**. Raft trades theoretical elegance for understandability and is what most systems actually ship. Consensus is the backbone of every reliable distributed commit.

## Critiques worth knowing
Dense and reference-like — it surveys algorithms and variants rather than teaching you to build one end-to-end, so pair it with hands-on engine code. The distributed half overlaps Kleppmann's *DDIA* but goes deeper on consensus mechanics; some 2019 storage-engine examples (RocksDB internals) have since moved on.
