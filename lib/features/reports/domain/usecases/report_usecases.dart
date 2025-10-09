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

  Future<void> call({required String companyId, required String reportId}) =>
      _repo.submit(companyId: companyId, reportId: reportId);
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
    required String companyId,
    required DateTime date,
    String? userId,
    String? departmentId,
  }) =>
      _repo.listByDate(companyId: companyId, date: date, userId: userId, departmentId: departmentId);
}

class WatchUserReports {
  WatchUserReports(this._repo);
  final ReportRepository _repo;

  Stream<List<ReportEntity>> call({required String companyId, required String userId}) =>
      _repo.watchUserReports(companyId: companyId, userId: userId);
}

class AggregateDepartmentReports {
  AggregateDepartmentReports(this._repo);
  final ReportRepository _repo;

  Future<Map<String, dynamic>> call({
    required String companyId,
    required DateTime date,
    required String departmentId,
  }) =>
      _repo.aggregateByDepartment(companyId: companyId, date: date, departmentId: departmentId);
}



