---
title: The Scrum Guide, Commitment — Definition of Done
author: Ken Schwaber and Jeff Sutherland
url: https://scrumguides.org/scrum-guide.html
year: 2020
category: Standard — Process
focus: Done as a formal, shared, all-or-nothing quality bar for a work item
---

# Scrum Guide — Definition of Done (Schwaber and Sutherland, 2020)

The Guide defines the Definition of Done as "a formal description of the state of the Increment when it meets the quality measures required for the product", and says it "creates transparency by providing everyone a shared understanding of what work was completed". The rule that matters here is binary: "If a Product Backlog item does not meet the Definition of Done, it cannot be released or even presented at the Sprint Review. Instead, it returns to the Product Backlog for future consideration." The Developers are "required to conform to the Definition of Done"; it is not weighed against other progress.

## Why Mithril cites it

The done check in `skills/review.md` treats a ticket's "What done looks like" as that bar: every line is met with evidence, or the item is not done, and one unmet line fails the whole check with no averaging. Cited as `SCRUM-DoD`. The Guide is a human-process rule and says nothing about how to verify a line; that part comes from `ANT-HARNESS`.
