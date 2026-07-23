export interface TaxPolicy {
  taxRateFor(region: string): number;
}

export interface PriceQuote {
  subtotalCents: number;
  taxCents: number;
  totalCents: number;
}

export class PriceCalculator {
  constructor(private readonly taxPolicy: TaxPolicy) {}

  quote(subtotalCents: number, region: string): PriceQuote {
    const taxRate = this.taxPolicy.taxRateFor(region);
    const taxCents = Math.round(subtotalCents * taxRate);

    return {
      subtotalCents,
      taxCents,
      totalCents: subtotalCents + taxCents,
    };
  }
}