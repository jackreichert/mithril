/** Customer export — deliberately small surface for calibration. */

export type Customer = { id: string; email: string; createdAt: string };

export interface CustomerRepo {
  /** Keyset page — bounded. */
  listAfter(cursor: string | null, limit: number): Promise<Customer[]>;
  findById(id: string): Promise<Customer | null>;
}

/**
 * Clean path: processes one keyset page at a time on a bounded concurrency pool.
 * Do NOT flag this at Critical/Important — it is the false-positive bait.
 */
export async function exportPage(
  repo: CustomerRepo,
  cursor: string | null,
  limit = 100,
): Promise<{ rows: Customer[]; nextCursor: string | null }> {
  const rows = await repo.listAfter(cursor, limit);
  const nextCursor = rows.length === limit ? rows[rows.length - 1]!.id : null;
  return { rows, nextCursor };
}
