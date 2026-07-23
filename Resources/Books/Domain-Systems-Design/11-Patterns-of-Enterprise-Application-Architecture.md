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
Three classic layers — Presentation, Domain Logic, Data Source. Distinct *responsibilities*, not just packages. Why layering matters: change isolation, deployability, comprehension.

### Ch 2 — Organizing Domain Logic
Three patterns for the domain layer:
- **Transaction Script** — straight-line procedure per use case. Easy until logic grows.
- **Domain Model** — object graph where behavior lives on the entities. Powerful, requires ORM.
- **Table Module** — one class per DB table; instances are rowsets. Common in .NET.
- **Service Layer** wraps domain logic for the application boundary.

### Ch 3 — Mapping to Relational Databases
ORM territory. **Active Record** (object owns its row) vs. **Data Mapper** (separate mapper). N+1, identity maps, lazy loading, inheritance mapping.

### Ch 4 — Web Presentation
**Model-View-Controller**, **Page Controller** vs **Front Controller**, **Template View** vs **Transform View**, **Application Controller**.

### Ch 5 — Concurrency
Optimistic vs. pessimistic locking. Transactional isolation levels. ACID. Long-running business transactions vs short DB transactions.

### Ch 6 — Session State
Three approaches: **Client Session State**, **Server Session State**, **Database Session State**. Trade-offs in scalability, security, complexity.

### Ch 7 — Distribution Strategies
Don't distribute objects unless you have to (cf. Waldo's "A Note on Distributed Computing"). **Remote Facade**, **Data Transfer Object**.

### Ch 8 — Putting It All Together
Decision rules for picking patterns: complexity of domain logic, scaling needs, team skill.

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
