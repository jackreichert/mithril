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

  async findItemsByInvoice(invoiceId: number): Promise<LineItem[]> {
    return query("SELECT * FROM line_items WHERE invoice_id = $1", [invoiceId]);
  }

  async findById(invoiceId: number): Promise<Invoice | null> {
    const rows = await query("SELECT * FROM invoices WHERE id = $1", [invoiceId]);
    return rows[0] ?? null;
  }

  // SEEDED DEFECT (lost update): blind write — no optimistic version check,
  // so an edit made between the user's read and this save is silently overwritten.
  async saveNotes(invoiceId: number, notes: string): Promise<void> {
    await query("UPDATE invoices SET notes = $1 WHERE id = $2", [notes, invoiceId]);
  }
}
