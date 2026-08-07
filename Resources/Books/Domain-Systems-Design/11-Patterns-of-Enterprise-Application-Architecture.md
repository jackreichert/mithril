---
title: Patterns of Enterprise Application Architecture (PEAA)
author: Martin Fowler
year: 2002
category: Domain & Systems Design
focus: Layering, ORMs, concurrency, session state
---

# Patterns of Enterprise Application Architecture — Martin Fowler (2002)

A pattern catalog for typical enterprise web/database applications. Predates the microservices era but the patterns underpin every ORM, web framework, and middleware in active use.

## Part I — The Narrative (overview chapters)

### Ch 1 — Layering
Enterprise applications commonly separate three layers: Presentation, Domain Logic, and Data Source. These layers represent distinct *responsibilities*, not merely packages or folders. Clear layering isolates changes, clarifies deployment choices, and makes the system easier to comprehend.

### Ch 2 — Organizing Domain Logic
The structure of domain logic should match the complexity of the business rules it represents. The chapter compares three core patterns for that logic and also explains how a Service Layer defines the application's boundary. Choosing deliberately prevents a simple design from becoming tangled as behavior grows:
- **Transaction Script** — straight-line procedure per use case. Easy until logic grows.
- **Domain Model** — object graph where behavior lives on the entities. Powerful, requires ORM.
- **Table Module** — one class per DB table; instances are rowsets. Common in .NET.
- **Service Layer** wraps domain logic for the application boundary.

### Ch 3 — Mapping to Relational Databases
Object-relational mapping connects an in-memory object model to relational database tables. **Active Record** lets an object own persistence for its row, while **Data Mapper** keeps persistence in a separate mapper. The chapter also explains recurring concerns such as N+1 queries, identity maps, lazy loading, and inheritance mapping.

### Ch 4 — Web Presentation
Web presentation patterns divide request handling, navigation, and rendering into explicit responsibilities. **Model-View-Controller**, **Page Controller** versus **Front Controller**, and **Template View** versus **Transform View** offer different ways to make those responsibilities visible. **Application Controller** centralizes control over screen flow when navigation becomes too complex for individual pages.

### Ch 5 — Concurrency
Enterprise applications must coordinate concurrent work without confusing a business transaction with a database transaction. Optimistic locking detects conflicting updates, while pessimistic locking prevents them by reserving access in advance. Isolation levels and ACID properties govern short database transactions, but long-running business transactions require additional application-level strategies.

### Ch 6 — Session State
Session state can live in one of three places: the client, the application server, or a database. **Client Session State**, **Server Session State**, and **Database Session State** make different trade-offs in scalability, security, and complexity. The appropriate choice depends on how long the state must survive, how safely it can be trusted, and whether requests may reach different server processes.

### Ch 7 — Distribution Strategies
Do not distribute objects unless the system genuinely requires a process or network boundary, as Waldo's "A Note on Distributed Computing" also cautions. Remote calls have different latency and failure behavior from local method calls, so fine-grained object interfaces become brittle when exposed over a network. **Remote Facade** provides a coarse-grained boundary, while **Data Transfer Object** packages data for efficient transfer across it.

### Ch 8 — Putting It All Together
Patterns should be selected as a coherent architecture rather than as isolated recipes. The main decision factors are the complexity of the domain logic, scaling needs, and the team's skill and experience. A simpler pattern is preferable when it satisfies those forces because every additional layer or mapping mechanism carries a cost.

## Part II — The Pattern Catalog (~40 patterns)

### Domain Logic Patterns
- Transaction Script
- Domain Model
- Table Module
- Service Layer

### Data Source Architectural Patterns
- Table Data Gateway (one class per table, rowset interface)
- Row Data Gateway (one object per row)
- Active Record
- Data Mapper

### Object-Relational Behavioral Patterns
- Unit of Work
- Identity Map
- Lazy Load (Lazy Initialization, Virtual Proxy, Value Holder, Ghost)

### Object-Relational Structural Patterns
- Identity Field
- Foreign Key Mapping
- Association Table Mapping
- Dependent Mapping
- Embedded Value
- Serialized LOB
- Single Table Inheritance
- Class Table Inheritance
- Concrete Table Inheritance
- Inheritance Mappers

### Object-Relational Metadata Mapping Patterns
- Metadata Mapping
- Query Object
- Repository

### Web Presentation Patterns
- Model View Controller
- Page Controller
- Front Controller
- Template View
- Transform View
- Two Step View
- Application Controller

### Distribution Patterns
- Remote Facade
- Data Transfer Object

### Offline Concurrency Patterns
- Optimistic Offline Lock
- Pessimistic Offline Lock
- Coarse-Grained Lock
- Implicit Lock

### Session State Patterns
- Client Session State
- Server Session State
- Database Session State

### Base Patterns
- Gateway
- Mapper
- Layer Supertype
- Separated Interface
- Registry
- Value Object
- Money
- Special Case
- Plugin
- Service Stub
- Record Set

## Why it still matters
Every modern ORM (Hibernate, ActiveRecord, Entity Framework, SQLAlchemy, TypeORM, Prisma) implements these patterns. Knowing them by name is how you debug ORM-related performance issues.
