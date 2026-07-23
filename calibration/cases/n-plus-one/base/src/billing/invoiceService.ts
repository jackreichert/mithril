import { InvoiceRepo } from "./invoiceRepo";
import type { Invoice, LineItem } from "./types";

export class InvoiceService {
  constructor(private readonly repo: InvoiceRepo) {}

  /** Clean path: batched load, no per-item queries. */
  async invoicesWithItems(customerId: number): Promise<Array<Invoice & { items: LineItem[] }>> {
    const invoices = await this.repo.findByCustomer(customerId);
    const items = await this.repo.findItemsByInvoiceIds(invoices.map((i) => i.id));
    const byInvoice = new Map<number, LineItem[]>();
    for (const item of items) {
      const bucket = byInvoice.get(item.invoiceId) ?? [];
      bucket.push(item);
      byInvoice.set(item.invoiceId, bucket);
    }
    return invoices.map((inv) => ({ ...inv, items: byInvoice.get(inv.id) ?? [] }));
  }
}
