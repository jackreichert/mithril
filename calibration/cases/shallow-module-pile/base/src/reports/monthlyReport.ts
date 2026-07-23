export interface InvoiceRow {
  customerId: string;
  totalCents: number;
  issuedAt: string;
}

export interface MonthlyReport {
  month: string;
  customerCount: number;
  revenueCents: number;
}

export function buildMonthlyReport(rows: InvoiceRow[], month: string): MonthlyReport {
  const customerIds = new Set<string>();
  let revenueCents = 0;

  for (const row of rows) {
    if (!row.issuedAt.startsWith(month)) {
      continue;
    }

    customerIds.add(row.customerId);
    revenueCents += row.totalCents;
  }

  return {
    month,
    customerCount: customerIds.size,
    revenueCents,
  };
}