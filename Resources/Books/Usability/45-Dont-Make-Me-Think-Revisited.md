---
title: Don't Make Me Think, Revisited — A Common Sense Approach to Web Usability
authors: Steve Krug
year: 2014
category: Usability & Interaction Design
focus: Usability, navigation, visual hierarchy, interface conventions, mobile design, and lightweight user testing
---

<!-- markdownlint-disable MD025 -->

# Don't Make Me Think, Revisited — Steve Krug (2014)

Krug's central claim is that usable interfaces minimize unnecessary thought: people should be able to recognize what matters, understand what is clickable, and predict what will happen without decoding the designer's intent. The book explains how people actually scan and muddle through interfaces, then turns that behavior into practical guidance for hierarchy, navigation, content, mobile design, accessibility, and testing. Its examples come largely from websites, but the principles apply to product interfaces whenever users must orient themselves, choose an action, and recover from uncertainty.

## Guiding principles

### Ch 1 — Don't Make Me Think

Every avoidable question an interface creates adds to the user's cognitive workload, whether the question concerns terminology, clickability, location, or the next step. A design does not need to be self-explanatory in an absolute sense, but it should be self-evident enough that people can act confidently without stopping to decipher it. Familiar conventions, clear labels, and visible affordances usually outperform cleverness because recognition costs less effort than interpretation.

### Ch 2 — How We Really Use the Web

People rarely read a page carefully from top to bottom; they scan for words, shapes, and controls that appear relevant to their immediate goal. They also satisfice by choosing the first plausible option rather than comparing every alternative, and they muddle through even when they do not understand the underlying system. Designers should therefore optimize for rapid recognition and recovery instead of assuming patient, rational exploration.

### Ch 3 — Billboard Design 101

A page should communicate its hierarchy as quickly as a roadside billboard because users often grant it only a passing glance. Strong conventions, meaningful visual grouping, distinct headings, and an obvious primary action help the eye decide what belongs together and what deserves attention. Visual noise weakens every signal, so emphasis must be selective rather than applied to all content at once.

### Ch 4 — Animal, Vegetable, or Mineral?

The number of clicks required to reach a goal matters less than the difficulty and ambiguity of each choice along the way. A longer path of clear, low-risk decisions can feel easier than a short path containing one opaque category or surprising commitment. Navigation depth should therefore be judged by confidence, information scent, and recoverability rather than by a rigid click-count rule.

### Ch 5 — Omit Needless Words

Removing words that do not help users decide or act reduces visual noise and makes the remaining instructions easier to find. Welcome text, self-congratulatory copy, and redundant directions often consume attention without answering a user question. Concision is not the removal of necessary context; it is the discipline of preserving meaning while eliminating language that competes with the task.

## Things you need to get right

### Ch 6 — Street Signs and Breadcrumbs

Navigation should continuously answer where the user is, what major areas exist, what options are available nearby, and how to return to a known place. Persistent navigation, a clear current-state marker, descriptive page names, and breadcrumbs can provide those bearings when they reflect the actual information architecture. Search is an important parallel route, but it should complement comprehensible structure rather than excuse confusing categories.

### Ch 7 — The Big Bang Theory of Web Design

A home page must establish identity, purpose, value, major starting points, and a sense of the site's organization within a few moments. Competing stakeholders often overload this surface because it is highly visible, but treating every concern as equally prominent leaves users unable to see what the product is for. The design should prioritize the explanation and actions that help a first-time visitor form the correct mental model, while still giving returning users efficient routes to common work.

## Making sure you got them right

### Ch 8 — The Farmer and the Cowman Should Be Friends

Arguments about what users like are rarely settled by professional preference because teams and users bring different histories, goals, and contexts to the same interface. Productive design avoids false universal claims such as whether everyone likes a certain interaction and asks whether it works for the intended audience in the intended situation. Testing representative people performing realistic tasks converts opinion battles into observable evidence.

### Ch 9 — Usability Testing on 10 Cents a Day

Small, frequent usability studies reveal serious problems early enough to fix them, even when the team lacks a formal laboratory or research department. Watching a few participants attempt important tasks usually produces more actionable evidence than debating the design or waiting for one large study near release. The method is intentionally lightweight, but it still requires neutral facilitation, realistic tasks, careful observation, and prioritization of the most consequential repeated problems.

## Larger concerns and outside influences

### Ch 10 — Mobile: It's Not Just a City in Alabama Anymore

Mobile interfaces operate with less space, variable context, touch input, and an expectation that essential tasks remain available rather than being stripped away. Good mobile design forces prioritization, but hiding necessary capabilities or making users hunt through ambiguous controls is not simplification. Responsive layouts should preserve clear hierarchy, readable content, adequate targets, and task continuity across screen sizes instead of treating mobile as a reduced desktop.

### Ch 11 — Usability as Common Courtesy

Every interaction either preserves or depletes a reservoir of user goodwill. Hiding needed information, demanding unnecessary data, punishing errors, or making support difficult consumes trust, while honest expectations, useful defaults, graceful recovery, and visible help restore it. This framing connects usability to product ethics: an interface should respect people's time, attention, privacy, and ability to choose.

### Ch 12 — Accessibility and You

Accessibility is a responsibility, not an optional enhancement for a small audience, and many accessible practices improve clarity for everyone. Semantic structure, keyboard operation, text alternatives, readable contrast, and resizable content are foundational, while automated checks cannot replace testing with assistive technologies and disabled users. Krug's practical appeal should be paired with the current WCAG standard and WAI-ARIA Authoring Practices because accessibility requirements and platform capabilities continue to evolve.

### Ch 13 — Guide for the Perplexed

Teams improve usability by learning from direct observation, applying a small set of durable principles, and consulting specialists when a problem exceeds their experience. No checklist can mechanically produce a good interface because context determines which trade-offs matter and which evidence is representative. The closing guidance is therefore to keep learning and testing rather than treating the book's rules as a substitute for user contact.

## Enduring contribution and cautions

The book's enduring contribution is a vocabulary for the ordinary friction that makes interfaces harder than they need to be: ambiguity, weak hierarchy, poor information scent, needless words, and missing orientation. Its heuristics are excellent review prompts, but they are hypotheses rather than universal laws and should be tested with representative users, including disabled users, in realistic contexts. Modern use should also extend beyond page-centric websites to stateful applications, native mobile conventions, privacy and consent flows, internationalization, and design systems without losing Krug's central demand for obviousness.

## Why it belongs in Mithril

- **Usability:** supplies concrete review criteria for hierarchy, navigation, labels, affordances, content, mobile layouts, and recovery.
- **Evidence:** replaces internal preference debates with observation of representative users attempting realistic tasks.
- **Accessibility boundary:** clarifies that general ease of use and standards-based accessibility reinforce each other but are not interchangeable.
- **Restraint:** favors familiar conventions and reduced cognitive effort over novelty that makes users decode the interface.
