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

  /**
   * Monthly statement for a customer.
   * SEEDED DEFECT (N+1 across files): one query per invoice inside the loop —
   * the per-item query lives in invoiceRepo.ts, so per-file review of either
   * file alone can miss it.
   */
  async monthlyStatement(customerId: number): Promise<string[]> {
    const invoices = await this.repo.findByCustomer(customerId);
    const lines: string[] = [];
    for (const invoice of invoices) {
      const items = await this.repo.findItemsByInvoice(invoice.id);
      const sum = items.reduce((acc, i) => acc + i.amount, 0);
      lines.push(`Invoice ${invoice.id}: ${items.length} items, total ${sum}`);
    }
    return lines;
  }

  /** Edit-notes flow: read → user edits in the UI → save. */
  async updateNotes(invoiceId: number, notes: string): Promise<void> {
    await this.repo.saveNotes(invoiceId, notes);
  }
}
