import { describe, expect, it } from "vitest";
import { PricingService } from "./pricing";
import { InMemoryDiscountRepo } from "./testSupport";

describe("PricingService", () => {
  // Clean, behavior-level test: real collaborator (in-memory fake at the
  // boundary), state-based assertion, behavior-named.
  it("applies the best available discount to the order total", async () => {
    const repo = new InMemoryDiscountRepo([{ code: "SPRING", percent: 20 }]);
    const service = new PricingService(repo);

    const total = await service.priceOrder({ subtotal: 100, discountCode: "SPRING" });

    expect(total).toBe(80);
  });
});
