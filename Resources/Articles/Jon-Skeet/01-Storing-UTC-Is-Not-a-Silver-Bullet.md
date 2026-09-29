---
title: Storing UTC is not a silver bullet
author: Jon Skeet
url: https://codeblog.jonskeet.uk/2019/03/27/storing-utc-is-not-a-silver-bullet/
year: 2019
category: Article — Jon Skeet
focus: Instants vs local civil times, time-zone rule changes, keeping the source value
---

# Storing UTC is not a silver bullet — Jon Skeet (2019)

Skeet (author of Noda Time and a long-time maintainer of date/time libraries) argues against the blanket rule "always convert to UTC and store that". UTC is the right representation for some values and the wrong one for others; the distinction is what the value *means*.

## The core distinction

- **Instants** — "when did this happen?" A log timestamp or a clock-in recorded by a machine is a point on the global timeline. UTC is the right storage form.
- **Local civil times** — "9am in Paris on a future date", "the shift starts at 22:00 local". The meaning is tied to a place's wall clock. Converting it to UTC at write time bakes in today's time-zone rules.

## Why conversion loses information

Time-zone rules change several times a year worldwide (IANA publishes regular updates, sometimes with little notice). A future local time converted to UTC under the old rules now points at the wrong wall-clock time, and the original intent cannot be recovered. The UTC value is *derived* data; the local time plus its zone is the *source*.

## What to keep instead

For future or user-entered local times, store the local date/time and the zone identifier (not just an offset). Derive the UTC instant when you need it, and be able to re-derive it after a rules update.

## How it maps to review

The same reasoning governs any calculation whose meaning is a *local calendar* concept — "today", "the last N days", "this shift's date", "midnight rollover". Those must be computed in the relevant zone. Doing the date arithmetic in UTC gives a different calendar day for part of every day (for a US Eastern business, the hours after 00:00 UTC), so window boundaries shift silently.

## Connection to other resources

- DDIA Ch 8 (Kleppmann) covers the *instant* side: wall clocks jump and cannot order events across machines. This article covers the *civil* side DDIA does not: local calendar values that are not instants at all.
- Property-based testing of calendar math (see `Books/Canon/03-The-Pragmatic-Programmer.md`) is the natural way to probe zone and midnight boundaries.

## Critiques worth knowing

- A blog post, not a book. Its authority comes from the author's library-maintainer experience and its agreement with the IANA tz database's own guidance, not from peer review.
- It is focused on storage; it says less about computation. Applying it to date-window arithmetic, as above, is this framework's extension of the argument.
