---
title: Exploratory Testing 3.0
author: James Bach and Michael Bolton
url: https://www.satisfice.com/blog/archives/1509
year: 2015
category: Article — Bach and Bolton
focus: Testing as learning through exploration and experimentation; scripted testing as a technique inside it
---

# Exploratory Testing 3.0 — James Bach and Michael Bolton (16 March 2015, revised 2025)

Bach and Bolton define testing as "the process of evaluating a product by learning about it through exploration and experimentation". Test design and execution happen together, and what the tester learns from each run shapes the next input. They define a script as "any control system or factor that influences your testing and lies outside of your realm of choice", which includes written test cases and also biases and ignorance.

The article traces exploratory testing from a 1990s reaction against rigid scripts, through a 2000s formality continuum, to the current view that exploration is what all competent testing is and scripting is one technique used inside it.

## Why Mithril cites it

Execute mode in `skills/review.md` has the reviewer pick its own inputs and let each result steer the next call, rather than only re-running the author's tests. Cited as `BB-ET3`. The article supports the method (self-chosen inputs, learning by running) and the warning that the author's own tests are a script that shares the author's blind spots. It reports no defect-detection rates.
