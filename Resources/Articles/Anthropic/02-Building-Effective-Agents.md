---
title: Building effective agents
author: Anthropic Engineering
url: https://www.anthropic.com/engineering/building-effective-agents
category: Article — Anthropic
focus: Evaluator-optimizer workflows need clear criteria; agents need ground truth from the environment
---

# Building effective agents — Anthropic Engineering

In the evaluator-optimizer workflow one model produces a response and another evaluates it in a loop. The post says this is "particularly effective when we have clear evaluation criteria, and when iterative refinement provides measurable value". It also says that during agent runs "it's crucial for the agents to gain 'ground truth' from the environment at each step", for example tool results or code execution, rather than trusting its own reading.

## Why Mithril cites it

Two rules in the done check come from it. A done line with no clear, checkable criterion is marked UNCHECKABLE and blocks, rather than being judged loosely. The verdict rests on a command's exit code and output, not on reading the diff. Cited as `ANT-BEA`. The post is advisory design guidance, not an enforced mechanism.
