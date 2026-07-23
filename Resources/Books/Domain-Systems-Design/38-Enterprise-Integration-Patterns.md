---
title: Enterprise Integration Patterns
author: Gregor Hohpe & Bobby Woolf
year: 2003
category: Domain-Systems-Design
focus: asynchronous messaging patterns — channels, routing, transformation, endpoints
---

# Enterprise Integration Patterns — Gregor Hohpe & Bobby Woolf (2003)

The canonical catalog of 65 patterns for connecting applications via asynchronous messaging. It feeds the **quality-distributed** agent: it is the shared pattern vocabulary for the queue/event/async-integration code that skill reviews — naming the routers, channels, transformers, and endpoint conventions so a reviewer can say "this is a Content-Based Router missing an Invalid Message Channel" instead of describing the shape from scratch. Pattern-first, technology-neutral (JMS/MSMQ/SOAP era, but the patterns outlived the stacks).

## Per-chapter summary

### Ch 1 — Solving Integration Problems using Patterns
Frames why integration is hard: apps built independently, no shared memory, partial failure is normal. Introduces the canonical "widget-and-gadget" loan-broker example used throughout. Establishes the pattern-language form (Context → Problem → Forces → Solution) and the icon notation.

### Ch 2 — Integration Styles
Four ways to connect systems, ranked by coupling. **File Transfer** (simple, stale), **Shared Database** (consistent, contended, tight schema coupling), **Remote Procedure Invocation** (immediate but synchronous and brittle), **Messaging** (async, decoupled, the book's chosen foundation). Messaging trades immediacy for resilience and loose coupling.

### Ch 3 — Messaging Systems
The six root patterns the rest build on. **Message Channel** (the logical pipe), **Message** (the unit of data), **Pipes and Filters** (compose processing steps), **Message Router** (decide where a message goes), **Message Translator** (change format between steps), **Message Endpoint** (how an app connects to the channel).

### Ch 4 — Messaging Channels
Choosing and shaping the pipes. **Point-to-Point Channel** (one consumer wins each message) vs **Publish-Subscribe Channel** (all subscribers get a copy). **Dead Letter Channel** (where undeliverable messages go), **Invalid Message Channel** (malformed/unprocessable messages), **Guaranteed Delivery** (persist so a crash doesn't lose messages), **Channel Adapter** / **Messaging Bridge** / **Message Bus** for connecting non-messaging apps and systems.

### Ch 5 — Message Construction
What goes in the envelope and intent. **Command Message** (invoke), **Document Message** (transfer data), **Event Message** (notify). **Request-Reply** with **Return Address** (where to send the reply) and **Correlation Identifier** (match reply to request) — the backbone of async RPC. **Message Sequence** and **Message Expiration** for ordering and TTL.

### Ch 6 — Message Routing
Move messages without hard-wiring senders to receivers. **Content-Based Router** (route by payload), **Message Filter** (drop unwanted), **Recipient List** / **Dynamic Router**. **Splitter** (one message → many) and **Aggregator** (many → one) — the key stateful pair. **Scatter-Gather**, **Composed Message Processor**, **Routing Slip**, and **Process Manager** for multi-step orchestration; **Message Broker** to centralize routing.

### Ch 7 — Message Transformation
Bridge format and data-model differences between systems. **Message Translator** (general shape-shifter), **Canonical Data Model** (translate to/from one neutral model instead of N×N point translators — the most cited design lever), **Content Enricher** (add missing data), **Content Filter** (remove/simplify), **Envelope Wrapper**, **Normalizer**, **Claim Check** (stash a large payload, pass a token).

### Ch 8 — Messaging Endpoints
How application code touches the messaging system. **Messaging Gateway** (hide the messaging API behind a domain interface — keep messaging out of business logic), **Messaging Mapper**. **Polling Consumer** vs **Event-Driven Consumer**, **Competing Consumers** (scale-out), **Message Dispatcher**, **Selective Consumer**, **Durable Subscriber**. **Idempotent Receiver** (safe to receive a duplicate — the answer to at-least-once delivery), **Transactional Client**, **Service Activator**.

### Ch 9 — System Management
Operate and observe a running messaging system. **Control Bus** (manage/configure channels out-of-band), **Wire Tap** (copy traffic for inspection without disturbing it), **Message History** (trace the path a message took), **Message Store** (audit/report), **Detour**, **Smart Proxy**, **Test Message**, **Channel Purger** — observability and diagnostics for async flows.

### Interlude / Composed Messaging examples
Worked end-to-end builds (the loan-broker) composing the patterns across asynchronous, synchronous, and process-manager implementations on real platforms — showing how channels, routers, aggregators, and endpoints fit together rather than as isolated recipes.

## Critiques worth knowing
- **Technology dated, patterns not.** Examples lean on JMS, MSMQ, and 2003-era SOAP; the vocabulary maps cleanly onto Kafka, RabbitMQ, SQS/SNS, and serverless event buses today, but readers must translate.
- **Pre-streaming, pre-event-sourcing.** Written before log-based streaming (Kafka), exactly-once semantics debates, and event-sourcing/CQRS went mainstream — it under-emphasizes ordered logs, partitioning, and replay; pair with Kleppmann (DDIA) for the modern data-intensive view.
- **Catalog, not a decision guide.** Excellent at naming the pieces, lighter on when *not* to use messaging or how to bound a saga/Process Manager's failure modes — Idempotent Receiver and Guaranteed Delivery are presented as patterns, but the operational rigor around at-least-once + dedup is left to the reader.
- **Risk of over-routing.** The routing chapter's richness can tempt teams into elaborate broker/orchestration topologies where a simpler choreography would do — apply Constitution Article I (simplicity) before reaching for Process Manager + Scatter-Gather.
