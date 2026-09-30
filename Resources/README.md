# CS Best Practices — Resource Library

One file per resource from [`CS-Best-Practices-Resources.md`](../CS-Best-Practices-Resources.md). Each file is a focused summary written for this framework; books include chapter-level breakdowns where relevant.

## Layout

```
Resources/
├── Books/
│   ├── Canon/                         # Foundational construction & design
│   ├── Clean-Architecture-Trilogy/    # Uncle Bob's architecture & professionalism
│   ├── Domain-Systems-Design/         # DDD, enterprise, distributed systems
│   ├── Testing/                       # TDD, unit testing, test patterns
│   ├── Engineering-Culture-Process/   # Scale, delivery, team dynamics, DORA, Team Topologies
│   └── Language-Specific/             # Java, readability, foundational CS
├── Articles/
│   ├── Martin-Fowler/                 # martinfowler.com / refactoring.com
│   ├── Robert-Martin/                 # blog.cleancoder.com
│   ├── Joel-Spolsky/                  # joelonsoftware.com
│   ├── Jon-Skeet/                     # codeblog.jonskeet.uk
│   └── Google-Engineering/            # google.github.io/eng-practices
├── Standards/                         # OWASP, 12-Factor, NASA Power of 10, style guides
├── Papers/                            # Parnas, Waldo, Moseley/Marks, Brooks
├── Themes/                            # 20 cross-source concept guides (Tier 1→5 curriculum) — the synthesis layer
└── Originals/
    ├── README.md                      # Canonical URLs for open-licensed sources
    └── Citations/                     # URLs / ISBNs / DOIs for copyrighted material
```

## How to use

- **Learning on-ramp**: start with [`Themes/`](Themes/README.md) — 20 concept guides that synthesize the summaries across sources (with the tensions named), each ending in the checklist its skill encodes. Read the theme, then drill into the summaries it cites.
- **Skill synthesis**: cross-reference summaries against `/mithril` agent prompts.
- **Onboarding**: jump into a single resource without reading the whole book.
- **Concept lookup**: see [`../CS-Best-Practices-Resources.md`](../CS-Best-Practices-Resources.md) for which resource owns which idea.
- **Cross-cutting themes**: see [`../THEMES.md`](../THEMES.md) for the horizontal cut — the ideas that recur across many sources, where they converge, and where the canon openly disagrees with itself.
- **Read the originals**: [`Originals/README.md`](Originals/README.md) has canonical URLs for the open-licensed sources (OWASP, 12-Factor, Google Eng Practices, style guides, PEP 8). [`Originals/Citations/`](Originals/Citations/) has URLs/ISBNs/DOIs for copyrighted material.

## Short-id citation index

Skill text cites sources by these ids so long citations stay out of the prompts. Paths are relative to `Resources/`.

| Id | Source | Summary |
|----|--------|---------|
| `CC2-8` | Code Complete, Ch 8 Defensive Programming | `Books/Canon/02-Code-Complete.md` |
| `BSRS-5/8` | Building Secure and Reliable Systems, Ch 5 Least Privilege and Ch 8 Design for Resilience | `Books/Security/39-Building-Secure-and-Reliable-Systems.md` |
| `PP-2` | The Pragmatic Programmer, Ch 2 A Pragmatic Approach (DRY) | `Books/Canon/03-The-Pragmatic-Programmer.md` |
| `PP-4` | The Pragmatic Programmer, Ch 4 Pragmatic Paranoia (Crash Early) | `Books/Canon/03-The-Pragmatic-Programmer.md` |
| `EIP-ch` | Enterprise Integration Patterns, channels, routing and endpoints (Invalid Message and Dead Letter Channel, Resequencer, Competing Consumers) | `Books/Domain-Systems-Design/38-Enterprise-Integration-Patterns.md` |
| `DDIA-9` | Designing Data-Intensive Applications, Ch 9 Consistency and Consensus | `Books/Domain-Systems-Design/12-Designing-Data-Intensive-Applications.md` |
| `DDIA-11` | Designing Data-Intensive Applications, Ch 11 Stream Processing | `Books/Domain-Systems-Design/12-Designing-Data-Intensive-Applications.md` |
| `RI-stab` | Release It!, stability patterns (Bulkheads) | `Books/Domain-Systems-Design/13-Release-It.md` |
| `GEP-CL` | Google Eng Practices, The CL Author's Guide (small CLs, descriptions) | `Articles/Google-Engineering/03-The-CL-Authors-Guide.md` |
| `GEP-LF` | Google Eng Practices, What to Look For in a Code Review (Documentation) | `Articles/Google-Engineering/02-What-to-Look-For-in-a-Code-Review.md` |
| `APOSD-12/13` | A Philosophy of Software Design, Ch 12-13 (comments) | `Books/Canon/06-A-Philosophy-of-Software-Design.md` |
| `JCIP-2` | Java Concurrency in Practice, Ch 2 Thread Safety (check-then-act, by analogy) | `Books/Concurrency/29-Java-Concurrency-in-Practice.md` |
| `XUTP` | xUnit Test Patterns, smell catalog and Ch 8 Transient Fresh Fixtures | `Books/Testing/17-xUnit-Test-Patterns.md` |
| `MF-ND` | Fowler, Eradicating Non-Determinism in Tests | `Articles/Martin-Fowler/16-Eradicating-Non-Determinism-in-Tests.md` |
| `SQLPE-5` | SQL Performance Explained, Ch 5 Clustering Data (covering indexes) | `Books/Performance-Reliability/30-SQL-Performance-Explained.md` |
| `SQLPE-7` | SQL Performance Explained, Ch 7 Partial Results (paging) | `Books/Performance-Reliability/30-SQL-Performance-Explained.md` |
| `SKEET-UTC` | Jon Skeet, Storing UTC is not a silver bullet | `Articles/Jon-Skeet/01-Storing-UTC-Is-Not-a-Silver-Bullet.md` |
