---
title: Painless Software Schedules
author: Joel Spolsky
url: joelonsoftware.com/2000/03/29/painless-software-schedules/
category: Article — Joel Spolsky
focus: Evidence-based estimation
---

# Painless Software Schedules — Joel Spolsky (2000)

A practical method for software estimation that survived two decades. Later refined by Joel into "Evidence-Based Scheduling" (FogBugz 6, 2007).

## The original simple method

1. **Use a spreadsheet** with one row per task.
2. **Break tasks down** into items of 4–16 hours each.
3. **Track three columns**: original estimate, current estimate, hours worked.
4. **Update daily.**
5. **Add buffer rows** for the inevitable surprises.
6. **Compute "ship date" by summing remaining estimates / available time.**

## Why it works
- **Small tasks** are estimated more accurately than big ones.
- **Tracking actuals** calibrates future estimates per engineer.
- **Daily updates** surface slippage early.
- **Honest buffer** is more reliable than wishful thinking + emergency overtime.

## Common pitfalls
- Tasks larger than 16 hours hide complexity — break them down.
- "Vacation, holidays, training" days disappear — block them off.
- Optimistic estimates ratchet → cynicism. Use *historical* velocity per person.
- Pretending to know unknowns. When you don't know, write a research task.

## Evidence-Based Scheduling (the 2007 evolution)

For each task estimate, **also record actual hours when complete**. Build a per-engineer ratio (estimate ÷ actual). Use Monte Carlo on past ratios to produce a *probability distribution* of ship dates rather than a point estimate.

Output: "75% confidence we ship by Aug 21, 95% by Sep 4."

## Why probability matters
A point estimate is a single guess; a distribution acknowledges uncertainty. Stakeholders make better decisions with confidence intervals than with false precision.

## Limitations
- Doesn't help with *what* to build, only *when*.
- Doesn't help when requirements churn faster than tasks complete.
- Personal estimation is noisier than ensemble estimation (Wideband Delphi, planning poker).

## Pairs with
- **The Mythical Man-Month** ch. 8 ("Calling the Shot").
- *The Clean Coder* ch. 10 (PERT, three-point estimates).
- DORA's "lead time for changes" as a downstream metric.
