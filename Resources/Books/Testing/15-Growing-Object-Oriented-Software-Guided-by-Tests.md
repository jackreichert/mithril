---
title: Growing Object-Oriented Software, Guided by Tests (GOOS)
authors: Steve Freeman, Nat Pryce
year: 2009
category: Testing
focus: Outside-in TDD, mock roles not objects
---

# Growing Object-Oriented Software, Guided by Tests — Freeman & Pryce (2009)

The "London-school" TDD book. Where Beck shows TDD bottom-up, GOOS shows it **outside-in** with **mocks of roles**, not just isolation. Authors are also the creators of jMock.

## Per-part / per-chapter summary

### Part I — Introduction

### Ch 1 — What Is the Point of Test-Driven Development?
TDD acts as a feedback engine that drives design as well as verifies behavior. A failing test provides immediate design feedback about the next capability the system needs. Slow tests expose coupling, while hard-to-test code often exposes a violation of the Single Responsibility Principle.

### Ch 2 — Test-Driven Development with Objects
The chapter introduces mock objects as a way to discover roles. Mocks are not merely a testing trick; they are a *design* tool that surfaces the collaborators an object needs. Expressing those collaborators as roles helps responsibilities and interfaces emerge from examples.

### Ch 3 — An Introduction to the Tools
The authors introduce JUnit for running tests and jMock for describing interactions with collaborators. Hamcrest matchers make expectations and failures more readable. The build setup ties these tools into a repeatable development cycle.

### Part II — The Process of Test-Driven Development

### Ch 4 — Kick-Starting the Test-Driven Cycle
Start with a **walking skeleton**, which is a thin end-to-end deployable slice that passes one acceptance test. From day 0, the project has an automated build, deployment path, and acceptance test. This early infrastructure proves that the major components can communicate before detailed features accumulate.

### Ch 5 — Maintaining the Test-Driven Cycle
The outer development loop begins with a failing acceptance test for user-visible behavior. Within that loop, red-green-refactor unit tests provide faster feedback on individual design steps. Each unit test can reveal a new collaborator role, which is expressed as a mocked interface until an implementation is needed.

### Ch 6 — Object-Oriented Style
The authors favor tell-don't-ask objects that perform work instead of exposing data for clients to manipulate. Collaborating objects should form a composite that is simpler to use than the sum of its parts. Context-independent objects and the absence of global state keep responsibilities explicit and tests isolated.

### Ch 7 — Achieving Object-Oriented Design
Developers should listen to the feedback their tests provide about the design. Tests that are painful to set up or maintain usually indicate equally painful production structure. This connection between test quality and design quality is the book's organizing thesis.

### Part III — A Worked Example (Auction Sniper)

A fully working chat-bot-driven auction-bidding agent, built outside-in across ~10 chapters. Each chapter follows the cycle:

### Ch 8 — The Auction Sniper Project
The worked example frames an application that bids in online auctions on a user's behalf. The authors define acceptance criteria in terms of behavior visible at the system boundary. Those criteria provide the outer test loop that will guide the implementation.

### Ch 9 — The Walking Skeleton
An end-to-end test proves that the auction application, user interface, and external messaging system are connected. The first implementation uses stub logic because business completeness is not yet the goal. Passing this test establishes a deployable path through the whole system.

### Ch 10 — Sniping for One Item
The first feature lets the sniper participate in an auction for one item. Tests introduce the XMPP messaging collaborator and an `Auction` role that hides protocol details from the domain logic. The design grows inward from the acceptance test as each missing collaborator becomes necessary.

### Ch 11 — The Sniper Makes a Bid
The sniper must respond to auction price messages by making an appropriate bid. Unit tests discover a `SniperListener` role while expressing which collaborators need to be notified. Mock expectations clarify the outgoing interactions without exposing XMPP mechanics to the core object.

### Ch 12 — The Sniper Wins the Auction
New acceptance behavior requires the application to recognize when its bid has won. Failing tests reveal the states and transitions needed to track the sniper's progress. The state machine emerges from observed scenarios instead of being designed speculatively.

### Ch 13 — Displaying Price Details
The user interface begins displaying current prices and bidding details. Test pressure reveals UI-facing roles that translate domain changes into presentation updates. This keeps formatting and widget concerns outside the auction logic.

### Ch 14 — Refactoring the Auction Sniper
The authors pause feature work for a mid-build cleanup. With the tests green, they improve names, responsibilities, and object boundaries without changing behavior. The resulting structure shows how a testable design has emerged from the preceding cycles.

### Ch 15 — Sniping for Multiple Items
The application generalizes from one auction to several simultaneous items. Existing tests catch regressions while new tests define collection and lifecycle behavior. The change demonstrates how a focused design can be extended after concrete cases establish its shape.

### Ch 16 — Towards a Real User Interface
The worked example evolves toward a real Swing user interface. GUI-facing tests drive the visible behavior while isolating the domain model from widget details. The chapter shows how outside-in development can cross a graphical boundary without abandoning fast inner-loop tests.

### Ch 17 — Handling Failure
The application must cope with disconnections, lost messages, and explicit error states. Acceptance and unit tests describe these unhappy paths instead of assuming the network always works. The resulting behavior makes failures visible to users and keeps recovery responsibilities explicit.

### Part IV — Sustainable Test-Driven Development

### Ch 18 — Listening to the Tests
This central chapter explains how test smells often reveal design smells. Excessive setup, awkward mocks, and ordering requirements point to misplaced responsibilities or coupling in production code. Instead of masking that test pain with more helpers, developers should use it to reconsider object boundaries.
- Setup ceremony → too many collaborators (SRP violation).
- Many mocks → wrong abstraction.
- Mocking concrete classes → coupling.
- Long pre-test setup → hidden temporal coupling.

### Ch 19 — Coverage
Coverage measures which code ran, not whether tests made meaningful assertions about it. A high percentage therefore cannot prove that a suite detects defects. Mutation testing provides stronger confidence by checking whether tests fail when production behavior is deliberately changed.

### Ch 20 — Managing the Test Suite
Test naming and organization should help developers locate behavior and diagnose failures. Separating fast tests from slower system tests preserves quick local feedback while retaining broader checks. Build pipelines run the appropriate groups at increasing levels of integration.

### Ch 21 — Test Readability
Tests should read as specifications of behavior rather than scripts of implementation details. Arrange-Act-Assert gives each example a recognizable structure. Custom matchers and builders remove distracting mechanics while preserving the values that matter to the scenario.

### Ch 22 — Constructing Complex Test Data
Complex fixtures can obscure the behavior a test intends to explain. Object Mother helpers provide reusable examples, while test-data builders let each test vary only the relevant fields. Used carefully, these patterns make setup concise without hiding important preconditions.

### Ch 23 — Test Diagnostics
Good failure messages explain what behavior failed and show the relevant values. Custom matchers can provide context-rich diagnostics that generic equality assertions omit. Clear diagnostics reduce the need to reproduce a failure in a debugger.

### Ch 24 — Test Flexibility
Avoid over-specification that makes tests fail after harmless internal changes. Assertions and mock expectations should describe required behavior rather than implementation sequence. Flexible tests remain useful during refactoring because they protect contracts instead of incidental structure.

### Part V — Advanced Topics

### Ch 25 — Testing Persistence
Persistence tests need a known schema and controlled data. Schema-managed fixtures keep the test database aligned with the application. Isolation prevents one test's records or transactions from influencing another test's result.

### Ch 26 — Unit Testing and Threads
Concurrent code is difficult to test when scheduling and shared state are uncontrolled. The chapter presents isolation strategies that move coordination behind testable boundaries. Tests should synchronize on meaningful events rather than depend on arbitrary timing.

### Ch 27 — Testing Asynchronous Code
Asynchronous tests must wait for observable completion without hanging forever. Polling, bounded timeouts, and completion semaphores provide ways to coordinate with work that finishes later. The chosen mechanism should produce deterministic failures and useful diagnostics when completion never occurs.

## Core ideas
- **Outside-in**: drive from acceptance test inward, discovering collaborators as roles.
- **Mocks of roles, not objects**: design abstraction first, implementation later.
- **Listen to the tests**: pain in tests is feedback about design, not testing.
- **Walking skeleton**: end-to-end on day 1.

## Why it's deeply integrated into `/mithril test-quality`
The "listen to the tests" thesis underpins every test smell the test-quality agent flags.
