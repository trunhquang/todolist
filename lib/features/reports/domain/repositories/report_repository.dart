import '../entities/report.dart';

abstract class ReportRepository {
  Future<String> createDraft({required ReportEntity report});
  Future<void> submit({required String workspaceId, required String reportId});
  Future<void> updateDraft({required ReportEntity report});
  Future<ReportEntity?> getById({required String workspaceId, required String reportId});
  Future<List<ReportEntity>> listByDate({required String workspaceId, required DateTime date, String? userId});
  Stream<List<ReportEntity>> watchUserReports({required String workspaceId, required String userId});
  Future<Map<String, dynamic>> aggregateByDepartment({required String workspaceId, required DateTime date});
}



