---
title: The Joel Test — 12 Steps to Better Code
author: Joel Spolsky
url: joelonsoftware.com/2000/08/09/the-joel-test-12-steps-to-better-code/
category: Article — Joel Spolsky
focus: 12-question dev environment health check
---

# The Joel Test — Joel Spolsky (2000)

A 12-question yes/no test to gauge a software team's basic engineering hygiene. Answer "yes" to count a point. 12/12 = excellent. ≤2 = serious problem.

## The 12 questions

1. **Do you use source control?**
2. **Can you make a build in one step?**
3. **Do you make daily builds?**
4. **Do you have a bug database?**
5. **Do you fix bugs before writing new code?**
6. **Do you have an up-to-date schedule?**
7. **Do you have a spec?**
8. **Do programmers have quiet working conditions?**
9. **Do you use the best tools money can buy?**
10. **Do you have testers?**
11. **Do new candidates write code during their interview?**
12. **Do you do hallway usability testing?**

## What's still timeless (most of it)
- Source control — universal now (Git won).
- One-step builds — Docker, scripts, build tools.
- Daily builds → CI/CD as default.
- Bug database — issue trackers ubiquitous.
- Fix bugs first — still wisdom; many teams violate.
- Up-to-date schedules — agile boards.
- Specs — varies; minimum viable spec wins now.
- Quiet conditions — open offices made this contentious; deep work matters.
- Best tools — debate (cloud IDE vs. local, hardware budgets).
- Testers — many teams replaced QA with engineering ownership.
- Coding interviews — universal.
- Hallway usability — supplanted by analytics + research.

## How to update for 2026
- Add: Do you have automated tests? CI? CD? Code review? Observability?
- The original 12 are *baseline*; modern teams need more.

## Why it matters as a relic
The test reflects what was *non-trivial in 2000*. In 2026, most of it is table-stakes — which itself is a victory for the field.

## Spiritual successor
**DORA / Accelerate** four key metrics:
- Deployment frequency
- Lead time for changes
- Change failure rate
- Time to restore service
