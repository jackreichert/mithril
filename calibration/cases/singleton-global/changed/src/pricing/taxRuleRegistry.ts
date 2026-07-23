export class TaxRuleRegistry {
  private static current: TaxRuleRegistry | undefined;
  private readonly rates = new Map<string, number>();

  static instance(): TaxRuleRegistry {
    if (!TaxRuleRegistry.current) {
      TaxRuleRegistry.current = new TaxRuleRegistry();
    }

    return TaxRuleRegistry.current;
  }

  setRate(region: string, rate: number): void {
    this.rates.set(region, rate);
  }

  taxRateFor(region: string): number {
    return this.rates.get(region) ?? 0;
  }
}