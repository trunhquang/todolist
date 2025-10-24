import '../entities/report.dart';
import '../repositories/report_repository.dart';

class CreateDailyReport {
  CreateDailyReport(this._repo);
  final ReportRepository _repo;

  Future<String> call(ReportEntity report) => _repo.createDraft(report: report);
}

class SubmitReport {
  SubmitReport(this._repo);
  final ReportRepository _repo;

  Future<void> call({required String workspaceId, required String reportId}) =>
      _repo.submit(workspaceId: workspaceId, reportId: reportId);
}

class UpdateReportDraft {
  UpdateReportDraft(this._repo);
  final ReportRepository _repo;

  Future<void> call(ReportEntity report) => _repo.updateDraft(report: report);
}

class ListReportsByDate {
  ListReportsByDate(this._repo);
  final ReportRepository _repo;

  Future<List<ReportEntity>> call({
    required String workspaceId,
    required DateTime date,
    String? userId,
    String? departmentId,
  }) =>
      _repo.listByDate(workspaceId: workspaceId, date: date, userId: userId);
}

class WatchUserReports {
  WatchUserReports(this._repo);
  final ReportRepository _repo;

  Stream<List<ReportEntity>> call({required String workspaceId, required String userId}) =>
      _repo.watchUserReports(workspaceId: workspaceId, userId: userId);
}

class AggregateDepartmentReports {
  AggregateDepartmentReports(this._repo);
  final ReportRepository _repo;

  Future<Map<String, dynamic>> call({
    required String workspaceId,
    required DateTime date,
  }) =>
      _repo.aggregateByDepartment(workspaceId: workspaceId, date: date);
}



