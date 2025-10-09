import 'package:get/get.dart';

import '../../domain/entities/report.dart';
import '../../domain/repositories/report_repository.dart';
import '../../../../core/services/firebase_database_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/offline_queue_service.dart';

class ReportRepositoryImpl implements ReportRepository {
  ReportRepositoryImpl({
    FirebaseDatabaseService? databaseService,
    StorageService? storageService,
    OfflineQueueService? offlineQueueService,
  })  : _databaseService = databaseService ?? Get.find<FirebaseDatabaseService>(),
        _storageService = storageService ?? Get.find<StorageService>(),
        _offlineQueueService = offlineQueueService ?? OfflineQueueService.instance;

  final FirebaseDatabaseService _databaseService;
  final StorageService _storageService;
  final OfflineQueueService _offlineQueueService;

  @override
  Future<String> createDraft({required ReportEntity report}) async {
    final companyId = report.companyId;
    try {
      return await _databaseService.createReport(companyId: companyId, report: report);
    } catch (_) {
      // Fallback to offline queue
      await _offlineQueueService.enqueue({
        'op': 'create_report',
        'companyId': companyId,
        'payload': report.toMap(),
      });
      return 'temp_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  @override
  Future<void> submit({required String companyId, required String reportId}) async {
    try {
      await _databaseService.submitReport(companyId: companyId, reportId: reportId);
    } catch (_) {
      await _offlineQueueService.enqueue({
        'op': 'submit_report',
        'companyId': companyId,
        'reportId': reportId,
      });
    }
  }

  @override
  Future<void> updateDraft({required ReportEntity report}) async {
    final companyId = report.companyId;
    try {
      await _databaseService.updateReport(companyId: companyId, report: report);
    } catch (_) {
      await _offlineQueueService.enqueue({
        'op': 'update_report',
        'companyId': companyId,
        'payload': report.toMap(),
      });
    }
  }

  @override
  Future<ReportEntity?> getById({required String companyId, required String reportId}) async {
    try {
      return await _databaseService.getReport(companyId: companyId, reportId: reportId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<ReportEntity>> listByDate({
    required String companyId,
    required DateTime date,
    String? userId,
    String? departmentId,
  }) async {
    try {
      return await _databaseService.listReportsByDate(
        companyId: companyId,
        date: date,
        userId: userId,
        departmentId: departmentId,
      );
    } catch (_) {
      return <ReportEntity>[];
    }
  }

  @override
  Stream<List<ReportEntity>> watchUserReports({
    required String companyId,
    required String userId,
  }) {
    return _databaseService.watchUserReports(companyId: companyId, userId: userId);
  }

  @override
  Future<Map<String, dynamic>> aggregateByDepartment({
    required String companyId,
    required DateTime date,
    required String departmentId,
  }) async {
    try {
      final reports = await _databaseService.listReportsByDate(
        companyId: companyId,
        date: date,
        departmentId: departmentId,
      );

      final totalReports = reports.length;
      final submittedReports = reports.where((r) => r.status == ReportStatus.submitted).length;
      final totalCompletedTasks = reports.fold<int>(0, (sum, report) => sum + report.completedTaskIds.length);
      final avgTasksPerReport = totalReports > 0 ? totalCompletedTasks / totalReports : 0.0;
      final submissionRate = totalReports > 0 ? (submittedReports / totalReports) * 100 : 0.0;

      return {
        'totalReports': totalReports,
        'submittedReports': submittedReports,
        'draftReports': totalReports - submittedReports,
        'totalCompletedTasks': totalCompletedTasks,
        'avgTasksPerReport': avgTasksPerReport,
        'submissionRate': submissionRate,
        'reports': reports.map((r) => r.toMap()).toList(),
      };
    } catch (_) {
      return {
        'totalReports': 0,
        'submittedReports': 0,
        'draftReports': 0,
        'totalCompletedTasks': 0,
        'avgTasksPerReport': 0.0,
        'submissionRate': 0.0,
        'reports': <Map<String, dynamic>>[],
      };
    }
  }
}