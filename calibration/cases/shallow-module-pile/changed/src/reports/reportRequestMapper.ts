import type { InvoiceRow } from "./monthlyReport";
import type { ReportRequest } from "./reportController";

export interface ReportCommand {
  rows: InvoiceRow[];
  month: string;
}

export class ReportRequestMapper {
  toCommand(request: ReportRequest): ReportCommand {
    return {
      rows: request.rows,
      month: request.month,
    };
  }
}