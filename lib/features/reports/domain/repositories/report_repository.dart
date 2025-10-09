import '../entities/report.dart';

abstract class ReportRepository {
  Future<String> createDraft({required ReportEntity report});
  Future<void> submit({required String companyId, required String reportId});
  Future<void> updateDraft({required ReportEntity report});
  Future<ReportEntity?> getById({required String companyId, required String reportId});
  Future<List<ReportEntity>> listByDate({required String companyId, required DateTime date, String? userId, String? departmentId});
  Stream<List<ReportEntity>> watchUserReports({required String companyId, required String userId});
  Future<Map<String, dynamic>> aggregateByDepartment({required String companyId, required DateTime date, required String departmentId});
}



