---
title: Expectations, Outcomes, and Challenges of Modern Code Review
author: Alberto Bacchelli and Christian Bird
url: https://www.microsoft.com/en-us/research/publication/expectations-outcomes-and-challenges-of-modern-code-review/
year: 2013 (ICSE)
category: Paper
focus: What code review actually delivers, and why understanding the change is the bottleneck
---

# Expectations, Outcomes, and Challenges of Modern Code Review — Bacchelli and Bird (ICSE 2013)

The study observed and interviewed developers and managers at Microsoft, then manually classified hundreds of review comments from tool-based reviews. Finding defects is the main reason people say they review, but the comments show that reviews deliver fewer defect finds than expected. They deliver more knowledge transfer, shared awareness of the code, and discussion of alternative solutions.

The authors' central conclusion is that **understanding the code and the change is the key activity of a review**, and that reviewers use many ad hoc ways to build that understanding which review tools barely support. A reviewer who only reads a diff must reconstruct intent and behavior in their head, which is where defects slip through.

## Why Mithril cites it

`skills/review.md` execute mode treats reading as the weak step and gives the reviewer a stronger way to understand a change: run it. Cited as `BB-MCR`. This paper supports the claim that reading-only review under-delivers on defects and that understanding is the constraint. It does not measure executing reviewers; that part rests on `BB-ET3`.
