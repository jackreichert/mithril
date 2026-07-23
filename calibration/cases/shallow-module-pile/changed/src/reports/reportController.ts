import type { InvoiceRow, MonthlyReport } from "./monthlyReport";
import { ReportRequestMapper } from "./reportRequestMapper";
import { ReportApplicationService } from "./reportApplicationService";

export interface ReportRequest {
  rows: InvoiceRow[];
  month: string;
}

export class ReportController {
  private readonly mapper = new ReportRequestMapper();
  private readonly service = new ReportApplicationService();

  createMonthlyReport(request: ReportRequest): MonthlyReport {
    const command = this.mapper.toCommand(request);
    return this.service.createMonthlyReport(command);
  }
}