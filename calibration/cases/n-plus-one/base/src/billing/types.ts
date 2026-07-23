export interface Invoice {
  id: number;
  customerId: number;
  total: number;
  notes: string;
  version: number;
}

export interface LineItem {
  id: number;
  invoiceId: number;
  description: string;
  amount: number;
}
