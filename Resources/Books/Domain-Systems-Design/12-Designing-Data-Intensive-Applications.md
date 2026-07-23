---
title: Designing Data-Intensive Applications (DDIA)
author: Martin Kleppmann
year: 2017
category: Domain & Systems Design
focus: Storage, replication, transactions, distributed systems
---

# Designing Data-Intensive Applications — Martin Kleppmann (2017)

The reference book on distributed-data systems for application engineers. Combines OLTP, OLAP, replication, partitioning, and consensus into one coherent narrative — without the abstraction-bombing of academic texts.

## Per-chapter summary

### Part I — Foundations of Data Systems

**Ch 1 — Reliable, Scalable, and Maintainable Applications**
The three primary concerns. Defines reliability (faults vs. failures), scalability (load parameters, performance metrics — percentiles, not averages), maintainability (operability, simplicity, evolvability).

**Ch 2 — Data Models and Query Languages**
Relational vs. document vs. graph. Normalization, locality, schema-on-read vs. schema-on-write. Declarative vs. imperative. MapReduce.

**Ch 3 — Storage and Retrieval** ⭐
The two storage families:
- **Log-Structured** (LSM-trees, Bitcask, LevelDB, RocksDB, Cassandra, HBase) — append-only + compaction.
- **Page-Oriented** (B-trees, used by every traditional RDBMS).
Indexes (secondary, multi-column, full-text, fuzzy). Column-oriented storage for analytics.

**Ch 4 — Encoding and Evolution**
Forward + backward compatibility. JSON/XML, Thrift, Protocol Buffers, Avro. Schema evolution. Database, RPC, message-passing encodings.

### Part II — Distributed Data

**Ch 5 — Replication**
Single-leader, multi-leader, leaderless. Synchronous vs. asynchronous replication. Replication lag. Read-your-writes, monotonic reads, consistent prefix reads.

**Ch 6 — Partitioning**
Key-range, hash, hot-spot mitigation. Secondary index challenges. Rebalancing strategies.

**Ch 7 — Transactions** ⭐
ACID demystified. Read committed, snapshot isolation (MVCC), serializable. Lost updates, write skew, phantoms. Why "weak isolation" hides scary bugs.

**Ch 8 — The Trouble with Distributed Systems**
Network unreliability, clock unreliability (monotonic vs. wall clock), process pauses (GC, swap). The truth: there is no truly reliable wall clock.

**Ch 9 — Consistency and Consensus**
Linearizability vs. serializability. Total order broadcast. Distributed transactions, 2PC, Paxos, Raft. Membership and coordination services (ZooKeeper, etcd).

### Part III — Derived Data

**Ch 10 — Batch Processing**
MapReduce mechanics, joins, output. Beyond MapReduce: dataflow engines (Spark, Tez, Flink). The unix-philosophy roots.

**Ch 11 — Stream Processing**
Event logs, Kafka. CDC (Change Data Capture), event sourcing. Stream-stream joins, windowing, fault tolerance, exactly-once via transactions or idempotence.

**Ch 12 — The Future of Data Systems**
Unbundling the database. Lambda + Kappa architectures. Doing the right thing — privacy, ethics, surveillance. The ethical responsibilities of data engineers.

## Why it endures
Every "we need to scale" conversation in the last decade has used DDIA's vocabulary. Kleppmann's prose is precise and the diagrams are exceptional.

## Pairs with
- **Release It!** for production realities of these systems.
- **Patterns of Distributed Systems** (Unmesh Joshi) — newer pattern catalog for the same space.
