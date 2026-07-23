---
title: A Note on Distributed Computing
authors: Jim Waldo, Geoff Wyant, Ann Wollrath, Sam Kendall (Sun Microsystems)
year: 1994
category: Paper
focus: Why distributed objects ≠ local objects
---

# A Note on Distributed Computing — Waldo et al. (Sun, 1994)

A short, sharp paper arguing that the "objects-everywhere" idea — making local and remote method calls look identical — is fundamentally flawed. Predicted the failures of CORBA, RMI, DCOM. Read by every distributed-systems engineer ever since.

## The thesis

> Local computing and distributed computing are *not* fundamentally the same kind of thing.

Trying to hide the distinction between local and remote calls is a *category error*. Four irreducible differences:

### 1. Latency
- Local call: nanoseconds.
- Remote call: milliseconds — millions of times slower.
- Code that's fine locally is unusable remote. Caching, batching, pre-fetching become essential.

### 2. Memory access
- Local objects share an address space.
- Remote objects don't. Pointers don't make sense across machines.
- Marshalling/unmarshalling adds cost and complexity that local code never sees.

### 3. Partial failure
- Local: a process either succeeds or crashes (atomic from outside).
- Remote: the network can succeed, fail, or *partially* succeed. The other side may or may not have done the work.
- This is the killer. Code written for local semantics has no notion of "I don't know whether the call succeeded."

### 4. Concurrency
- Local: threads share state explicitly; locks are local.
- Remote: every actor is its own concurrency domain; no shared lock. Race conditions span machines.

## The paper's punchline

You cannot hide these differences. Trying to leads to:
- Performance disasters (unmonitored RPC chains).
- Correctness disasters (partial-failure handling missed).
- Reliability disasters (no fallbacks).

You must **acknowledge the network in your design**. Distributed objects must be *first-class distributed*, not local objects with extra steps.

## Why it predicted CORBA's collapse

CORBA tried to make remote objects feel like local objects. It died because every project hit Waldo's four issues — latency, memory, failure, concurrency — and the abstraction couldn't paper over them. Same fate later: SOAP, EJBs, certain RPC frameworks.

## Modern relevance
- **gRPC, Thrift** — explicitly distributed; no pretense of locality. Successful.
- **Microservices** — the paper underpins resilience patterns (timeouts, circuit breakers, idempotency).
- **DDIA ch. 8** — every "trouble with distributed systems" lesson traces back here.

## The famous Joel Spolsky tie-in
The Law of Leaky Abstractions cites Waldo: distributed objects are the canonical leaky abstraction.

## Pairs with
- **Patterns of Distributed Systems** (Unmesh Joshi) — modern catalog.
- **Designing Data-Intensive Applications** ch. 8.
- *Release It!* — operational realization.
