---
title: The Power of 10 — Rules for Developing Safety-Critical Code
author: Gerard J. Holzmann (NASA/JPL)
year: 2006
category: Standard — Safety-Critical
focus: Safety-critical C coding rules
---

# NASA's Power of 10 Rules — Holzmann (JPL, 2006)

Ten rigid rules for writing safety-critical C code. Developed at NASA's Jet Propulsion Laboratory and used in flight software (Mars rovers, etc.).

## The ten rules

### Rule 1 — Simple control flow
**Avoid complex flow constructs.** No goto, setjmp/longjmp, or recursion.

### Rule 2 — Bounded loops
**All loops must have a fixed upper bound.** A static checker must be able to prove the bound. Prevents runaway loops in flight.

### Rule 3 — No dynamic memory after init
**Do not use dynamic memory allocation after initialization.** Heap fragmentation, allocation failures, leaks → unacceptable in flight. Pre-allocate at boot.

### Rule 4 — Short functions
**No function longer than ~60 lines** (one printed page). Easy to read, easy to verify.

### Rule 5 — Assertions
**Use ≥2 runtime assertions per function** to verify preconditions, postconditions, invariants. Assertions must be side-effect-free.

### Rule 6 — Smallest possible scope
**Declare data at the smallest possible level of scope.** Reduces accidental access; supports static checking.

### Rule 7 — Check return values
**Check return value of every non-void function. Check validity of every parameter.** No unchecked failures.

### Rule 8 — Limited preprocessor
**Limit preprocessor use** to header includes and simple macros. No conditional compilation hiding logic; no token-pasting tricks.

### Rule 9 — Limited pointer use
**No more than one level of dereference per expression.** No function pointers (or strictly limited). Improves analyzability.

### Rule 10 — Compile cleanly
**Compile with all warnings enabled at the most pedantic level — zero warnings.** Run static analyzers; treat findings as errors.

## Why these rules
- **Static analyzability.** Each rule helps a verifier prove safety properties.
- **Predictability.** No dynamic allocation, no recursion → bounded resources, bounded time.
- **Defense in depth.** Assertions catch contract violations early.

## Where the rules transfer beyond C/aerospace
- Embedded systems (medical devices, automotive).
- Financial firmware.
- Real-time systems.
- Crash-critical paths in any application.

## What the rules don't fit
- Application-tier business logic where dynamic memory and recursion are everywhere.
- Web services where compile-time analysis is less important than runtime telemetry.

But Rule 4 (short functions), Rule 5 (assertions), Rule 7 (check returns), Rule 10 (clean compile) generalize widely.

## Pairs with
- **MISRA-C** — automotive standard with similar philosophy.
- **CERT C Coding Standard** — security focus.
