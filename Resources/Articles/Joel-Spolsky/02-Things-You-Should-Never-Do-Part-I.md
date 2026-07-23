---
title: Things You Should Never Do, Part I
author: Joel Spolsky
url: joelonsoftware.com/2000/04/06/things-you-should-never-do-part-i/
category: Article — Joel Spolsky
focus: Never rewrite from scratch
---

# Things You Should Never Do, Part I — Joel Spolsky (2000)

The "never rewrite" essay. Spolsky argues that rewriting code from scratch is "the single worst strategic mistake that any software company can make."

## The argument

### Why teams want to rewrite
- Code looks ugly to *new* readers.
- Old code accumulates "obvious" wins that look easy to redo.
- Junior engineers underestimate the problem; seniors who left took context.

### What old code actually contains
- **Years of bug fixes** — every weird condition handled is a real bug, not theatre.
- **Edge cases** for browsers, OSs, locales, customers.
- **Performance fixes** that look like clutter but aren't.
- **Domain knowledge** encoded as cases that *seem* arbitrary.

### What rewrites actually deliver
- Same business logic, in nicer code.
- Bugs that were fixed in old code reappear in new code.
- Years of customer-visible regressions.
- Often: company collapse during the rewrite (Netscape's Mozilla rewrite cited).

## Famous case studies in the article
- **Netscape** rewrote the browser; Microsoft used the time to ship IE5 and IE6 and won the browser wars.
- Microsoft's own "doomed rewrites" — abandoned and shipped existing code instead.

## When to refactor vs. rewrite
- **Always refactor incrementally.**
- **Never start over from a blank file** for a working product.
- Use the **Strangler Fig pattern** ([Fowler](../Martin-Fowler/08-Strangler-Fig-Pattern.md)) — replace one piece at a time.

## Where the article doesn't fit
- Greenfield work — rewrite is fine when nothing exists.
- True architectural impossibility — sometimes legacy genuinely cannot be transformed (rare).
- Replacing a *commodity* layer — moving to managed Postgres is fine.

The bar is *high*. Default: refactor.

## Spiritual cousins
- **The Second-System Effect** (Brooks) — the rewrite is often the second system.
- **Branch by Abstraction** — the *how* of safe replacement.
