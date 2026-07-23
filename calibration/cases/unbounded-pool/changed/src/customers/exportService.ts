/** Customer export — deliberately small surface for calibration. */

export type Customer = { id: string; email: string; createdAt: string };

export interface CustomerRepo {
  /** Keyset page — bounded. */
  listAfter(cursor: string | null, limit: number): Promise<Customer[]>;
  /** Loads the entire table — used only by the seeded defective path. */
  listAll(): Promise<Customer[]>;
  findById(id: string): Promise<Customer | null>;
}

/**
 * Clean path: processes one keyset page at a time.
 * False-positive bait — must NOT be flagged Critical/Important for pagination.
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

/**
 * SEEDED DEFECT 1 (unbounded pool / no saturation): fires a new Promise for every
 * customer with no concurrency bound and no queue depth metric — under load this
 * exhausts memory/FDs. No USE saturation signal on the implicit fan-out.
 *
 * SEEDED DEFECT 2 (hot-path O(n²)): for each customer, scans the full list to find
 * "duplicates" by email — nested loop over listAll().
 */
export async function exportAllWithDedup(repo: CustomerRepo): Promise<Customer[]> {
  const all = await repo.listAll(); // unbounded result set on request path
  const tasks = all.map(async (c) => {
    // O(n) scan per customer → O(n²) overall
    const dups = all.filter((other) => other.email === c.email && other.id !== c.id);
    return { ...c, dupCount: dups.length };
  });
  // Unbounded fan-out — no pool, no backpressure, no saturation metric
  return Promise.all(tasks) as unknown as Promise<Customer[]>;
}
