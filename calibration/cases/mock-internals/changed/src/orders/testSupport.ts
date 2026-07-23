export interface Discount {
  code: string;
  percent: number;
}

export interface DiscountRepo {
  findByCode(code: string): Promise<Discount | null>;
}

/** In-memory fake for the repo boundary — the sanctioned test double. */
export class InMemoryDiscountRepo implements DiscountRepo {
  constructor(private readonly discounts: Discount[]) {}
  async findByCode(code: string): Promise<Discount | null> {
    return this.discounts.find((d) => d.code === code) ?? null;
  }
}
