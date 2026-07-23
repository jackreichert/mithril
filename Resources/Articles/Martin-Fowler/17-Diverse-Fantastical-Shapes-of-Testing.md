---
title: On the Diverse And Fantastical Shapes of Testing
author: Martin Fowler
url: https://martinfowler.com/articles/2021-test-shapes.html
year: 2021
category: Article — Martin Fowler
focus: Testing shapes debate (pyramid vs. honeycomb vs. trophy), semantic root causes, test quality over proportions
---

# On the Diverse And Fantastical Shapes of Testing — Martin Fowler (2021)

The debate between the Test Pyramid, the Honeycomb, and the Trophy is largely a **semantic argument** caused by inconsistent definitions of "unit test" and "integration test." The real problem is not which shape to use — it is that teams write low-quality tests regardless of shape.

## The Three Shapes

**Test Pyramid**
Maximum unit tests at the base, decreasing layers of integration and E2E above. Associated with solitary (mockist) testing. Emphasizes fast feedback and isolation.

**Honeycomb**
Minimal unit tests (solitary), maximum integration tests (sociable). Popularized by Spotify engineering. Emphasizes testing real interactions over isolated components.

**Trophy** (Kent C. Dodds)
Minimal static analysis and unit tests at the base, large integration test layer, few E2E tests at the top. Common framing in frontend/React communities.

## The Definitional Problem

Fowler traces two historical usages of "unit test":

1. **Waterfall-era:** Unit tests verified individual code modules in isolation *before* integration. Integration tests verified that separately-developed modules worked together.

2. **Extreme Programming (Beck):** Unit tests are any tests written by developers during daily work, contrasting with customer-written functional tests. No requirement for isolation from collaborators.

This means "unit test" in the pyramid might mean *solitary tests*, while "unit test" in the honeycomb might mean *any developer test including sociable ones*. The debate often isn't about strategy — it is about different meanings attached to the same word.

## The Sociable/Solitary Lens

Fowler connects the shapes debate to the solitary/sociable distinction (from his UnitTest bliki):
- **Pyramid advocates** are likely recommending mostly solitary unit tests + some sociable integration tests
- **Honeycomb advocates** are recommending mostly sociable tests, calling them "integration" or "service" tests

**They may not actually disagree on strategy.** They disagree on vocabulary.

## The Real Point: Justin Searls Quote

> "Nearly zero teams write expressive tests that establish clear boundaries, run quickly and reliably, and only fail for useful reasons. Focus on that instead."

The shape debate is a **distraction** from the actual work of writing high-quality tests. Proportions are irrelevant if the tests themselves are poorly written.

## Practical Conclusion

1. Align within your team on what your local terms mean
2. Use solitary vs. sociable as more precise language than unit vs. integration
3. Test quality — expressiveness, boundary clarity, speed, reliability, meaningful failures — matters more than any shape

## Connection to Other Resources

- Fowler's *Test Pyramid* (bliki) is the canonical shape reference; this article is the meta-analysis
- *UnitTest* (bliki) introduced the solitary/sociable terminology this article pivots on
- Khorikov's *Four Pillars* framework is a direct answer to the Searls challenge — it defines what "high-quality tests" means rigorously
