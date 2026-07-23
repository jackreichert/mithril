import { describe, expect, it, vi } from "vitest";
import { PricingService } from "./pricing";
import { InMemoryDiscountRepo } from "./testSupport";

describe("PricingService internals", () => {
  // SEEDED DEFECT (mock-of-internals / implementation coupling): spies on the
  // service's own PRIVATE method and asserts the internal call sequence.
  // A behavior-preserving refactor (inlining applyPercent) breaks this test
  // while the observable behavior stays correct — resistance-to-refactoring: 0.
  it("calls applyPercent exactly once with the discount percent", async () => {
    const repo = new InMemoryDiscountRepo([{ code: "SPRING", percent: 20 }]);
    const service = new PricingService(repo);
    const spy = vi.spyOn(service as any, "applyPercent");

    await service.priceOrder({ subtotal: 100, discountCode: "SPRING" });

    expect(spy).toHaveBeenCalledTimes(1);
    expect(spy).toHaveBeenCalledWith(100, 20);
  });

  // SEEDED DEFECT (flaky async wait): fixed sleep instead of awaiting the
  // result — passes or fails depending on scheduler timing, and wastes 500ms
  // on every run even when it passes.
  it("eventually prices the order", async () => {
    const repo = new InMemoryDiscountRepo([{ code: "SPRING", percent: 20 }]);
    const service = new PricingService(repo);

    let total = 0;
    service.priceOrder({ subtotal: 100, discountCode: "SPRING" }).then((t) => (total = t));
    await new Promise((resolve) => setTimeout(resolve, 500));

    expect(total).toBe(80);
  });
});
