import type { DiscountRepo } from "./testSupport";

export class PricingService {
  constructor(private readonly discounts: DiscountRepo) {}

  async priceOrder(order: { subtotal: number; discountCode?: string }): Promise<number> {
    if (!order.discountCode) return order.subtotal;
    const discount = await this.discounts.findByCode(order.discountCode);
    if (!discount) return order.subtotal;
    return this.applyPercent(order.subtotal, discount.percent);
  }

  private applyPercent(amount: number, percent: number): number {
    return Math.round(amount * (1 - percent / 100));
  }
}
