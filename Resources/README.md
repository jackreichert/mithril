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
│   └── Google-Engineering/            # google.github.io/eng-practices
├── Standards/                         # OWASP, 12-Factor, NASA Power of 10, style guides
├── Papers/                            # Parnas, Waldo, Moseley/Marks, Brooks
├── Themes/                            # 19 cross-source concept guides (Tier 1→5 curriculum) — the synthesis layer
└── Originals/
    ├── README.md                      # Canonical URLs for open-licensed sources
    └── Citations/                     # URLs / ISBNs / DOIs for copyrighted material
```

## How to use

- **Learning on-ramp**: start with [`Themes/`](Themes/README.md) — 19 concept guides that synthesize the summaries across sources (with the tensions named), each ending in the checklist its skill encodes. Read the theme, then drill into the summaries it cites.
- **Skill synthesis**: cross-reference summaries against `/quality` agent prompts.
- **Onboarding**: jump into a single resource without reading the whole book.
- **Concept lookup**: see [`../CS-Best-Practices-Resources.md`](../CS-Best-Practices-Resources.md) for which resource owns which idea.
- **Cross-cutting themes**: see [`../THEMES.md`](../THEMES.md) for the horizontal cut — the ideas that recur across many sources, where they converge, and where the canon openly disagrees with itself.
- **Read the originals**: [`Originals/README.md`](Originals/README.md) has canonical URLs for the open-licensed sources (OWASP, 12-Factor, Google Eng Practices, style guides, PEP 8). [`Originals/Citations/`](Originals/Citations/) has URLs/ISBNs/DOIs for copyrighted material.
