---
title: The CL Author's Guide
publisher: Google Engineering Practices
url: google.github.io/eng-practices/review/developer/
category: Article — Google Engineering
focus: How to write reviewable code
---

# The CL Author's Guide — Google Eng Practices

The mirror image of the Reviewer's Guide. Practical advice on creating CLs (changelists) that are easy to review and quick to land.

## Sections

### Writing good CL descriptions
- **First line**: imperative summary, ≤50 chars (≤72 hard cap).
- **Blank line**, then body.
- **Body**: explain *why*, *what's the user-visible effect*, *what alternatives were considered*.
- Link to issue tracker, design doc, related CLs.
- Treat the description as documentation that future readers (and `git blame`) will use.

### Small CLs
- A CL should do **one self-contained thing**.
- ≤200 lines diff is the sweet spot.
- Refactors should be in separate CLs from feature work.
- Large changes broken into series; the description of each links to others.

### How to handle reviewer comments
- **Reply to every comment**, even if just "Done."
- Don't be defensive. Reviewer comments are improvements, not attacks.
- If you disagree, push back with reasoning. The reviewer may concede or you may concede — either is fine.
- Mark resolved/unresolved threads clearly.

### When you disagree with a reviewer
- Provide reasoning, not authority.
- Ask if a quick chat resolves the standoff.
- Escalate to a third reviewer if necessary.
- Style/lint disputes go to the style guide, not the review thread.

### Speed
- The author should be ready to address comments quickly to maintain context.
- Don't context-switch off a CL until it lands; finish it.

## Anti-patterns the doc explicitly calls out
- Squashing multiple unrelated changes.
- Including a refactor inside a feature CL.
- Description that says "Misc fixes" or "Updates."
- Not running tests locally.
- Dismissing reviewer comments.
- Giant CLs that split-by-file rather than split-by-concern.

## Pairs with
- Reviewer's Guide.
- *Software Engineering at Google* ch. 9.
