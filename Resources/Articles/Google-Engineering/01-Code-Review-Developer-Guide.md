---
title: Code Review Developer Guide
publisher: Google Engineering Practices
url: google.github.io/eng-practices
category: Article — Google Engineering
focus: Reviewer's mental model and review process
---

# Code Review Developer Guide — Google Engineering Practices

A free, open-source distillation of Google's internal code-review culture. Two perspectives: the **reviewer's guide** (you're reviewing someone's CL) and the **CL author's guide** (you're sending a CL).

## Reviewer perspective

### Standard of code review
> The primary purpose of code review is to make sure that the overall code health of Google's codebase is improving over time.

A CL doesn't need to be perfect — it needs to *improve* the codebase relative to its current state. Reviewers should:
- Approve when net positive, even with non-blocking nits.
- Reject if the CL introduces complexity, debt, or risk that exceeds value.

### The reviewer's mindset
- The author is *not* the reviewer's apprentice.
- Disagreements: the author has context; the reviewer has perspective. Both matter.
- Resolve conflicts technically, not authoritatively.
- Style debates: defer to style guide; don't litigate.

### Speed of review
- Same-day review is the default.
- Quick review > deep review when the CL is small.
- Latency in review compounds: blocked dev → context-switching → less code-quality everywhere.

## CL author perspective

### Writing CL descriptions
- First line: imperative, ≤50 chars summary.
- Body: *why*, not *what* (the diff shows what).
- Reference issue tracker, design doc.

### Small CLs
- A CL should do *one thing*.
- ≤200 lines is reviewable in one sitting.
- Large refactors: split into many small CLs by introducing the abstraction first, then rewiring callers separately.

### Handling reviewer comments
- Reply to *every* comment (with action or rationale).
- Don't take it personally.
- Push back when wrong, but explain.

## Pairs with
- *Software Engineering at Google* ch. 9 (Code Review).
- The accompanying **What to Look For in a Code Review** doc.
