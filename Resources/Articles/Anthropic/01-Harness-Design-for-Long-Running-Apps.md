---
title: Harness design for long-running application development
author: Anthropic Engineering
url: https://www.anthropic.com/engineering/harness-design-long-running-apps
category: Article — Anthropic
focus: A separate evaluator that agrees what "done" means before the work and fails on any one criterion
---

# Harness design for long-running apps — Anthropic Engineering

The post describes a generator and a separate evaluator. Before each sprint they "negotiated a sprint contract", "agreeing on what 'done' looked like for that chunk of work before any code was written". The evaluator grades against criteria, and "each criterion had a hard threshold, and if any one fell below it, the sprint failed". The post also reports two failure modes of LLM grading: "agents reliably skew positive when grading their own work", and "out of the box, Claude is a poor QA agent". Tuning the evaluator meant reading its logs for where its judgment diverged from the author's and adding examples.

## Why Mithril cites it

The done check in `skills/review.md` copies three moves: write the check for each line before running it (the contract), fail on any single unmet line (the hard threshold), and use a fresh agent that did not write the change (the leniency finding). Cited as `ANT-HARNESS`. The post is one team's experience on one kind of app and reports no measured miss rates; the calibration fixtures here are how Mithril checks its own verifier.
