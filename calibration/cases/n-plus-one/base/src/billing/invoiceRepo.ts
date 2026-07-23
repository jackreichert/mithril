import { query } from "../db";
import type { Invoice, LineItem } from "./types";

export class InvoiceRepo {
  async findByCustomer(customerId: number): Promise<Invoice[]> {
    return query("SELECT * FROM invoices WHERE customer_id = $1", [customerId]);
  }

  /** Batched: one query for all line items of many invoices. */
  async findItemsByInvoiceIds(invoiceIds: number[]): Promise<LineItem[]> {
    if (invoiceIds.length === 0) return [];
    return query("SELECT * FROM line_items WHERE invoice_id = ANY($1)", [invoiceIds]);
  }
}
