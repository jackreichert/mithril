import { PriceCalculator } from "./priceCalculator";
import { TaxRuleRegistry } from "./taxRuleRegistry";

test("quotes with the configured tax rate", () => {
  TaxRuleRegistry.instance().setRate("NY", 0.08875);

  expect(new PriceCalculator().quote(10000, "NY")).toEqual({
    subtotalCents: 10000,
    taxCents: 888,
    totalCents: 10888,
  });
});