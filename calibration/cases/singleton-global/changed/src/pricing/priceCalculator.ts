import { TaxRuleRegistry } from "./taxRuleRegistry";

export interface TaxPolicy {
  taxRateFor(region: string): number;
}

export interface PriceQuote {
  subtotalCents: number;
  taxCents: number;
  totalCents: number;
}

export class PriceCalculator {
  quote(subtotalCents: number, region: string): PriceQuote {
    const taxRate = TaxRuleRegistry.instance().taxRateFor(region);
    const taxCents = Math.round(subtotalCents * taxRate);

    return {
      subtotalCents,
      taxCents,
      totalCents: subtotalCents + taxCents,
    };
  }
}