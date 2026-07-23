import { buildMonthlyReport, type MonthlyReport } from "./monthlyReport";
import type { ReportCommand } from "./reportRequestMapper";

export class ReportApplicationService {
  createMonthlyReport(command: ReportCommand): MonthlyReport {
    return buildMonthlyReport(command.rows, command.month);
  }
}