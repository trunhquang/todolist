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
    final workspaceId = report.workspaceId;
    try {
      return await _databaseService.createReport(workspaceId: workspaceId, report: report);
    } catch (_) {
      // Fallback to offline queue
      await _offlineQueueService.enqueue({
        'op': 'create_report',
        'workspaceId': workspaceId,
        'payload': report.toMap(),
      });
      return 'temp_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  @override
  Future<void> submit({required String workspaceId, required String reportId}) async {
    try {
      await _databaseService.submitReport(workspaceId: workspaceId, reportId: reportId);
    } catch (_) {
      await _offlineQueueService.enqueue({
        'op': 'submit_report',
        'workspaceId': workspaceId,
        'reportId': reportId,
      });
    }
  }

  @override
  Future<void> updateDraft({required ReportEntity report}) async {
    final workspaceId = report.workspaceId;
    try {
      await _databaseService.updateReport(workspaceId: workspaceId, report: report);
    } catch (_) {
      await _offlineQueueService.enqueue({
        'op': 'update_report',
        'workspaceId': workspaceId,
        'payload': report.toMap(),
      });
    }
  }

  @override
  Future<ReportEntity?> getById({required String workspaceId, required String reportId}) async {
    try {
      return await _databaseService.getReport(workspaceId: workspaceId, reportId: reportId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<ReportEntity>> listByDate({
    required String workspaceId,
    required DateTime date,
    String? userId,
  }) async {
    try {
      return await _databaseService.listReportsByDate(
        workspaceId: workspaceId,
        date: date,
        userId: userId,
      );
    } catch (_) {
      return <ReportEntity>[];
    }
  }

  @override
  Stream<List<ReportEntity>> watchUserReports({
    required String workspaceId,
    required String userId,
  }) {
    return _databaseService.watchUserReports(workspaceId: workspaceId, userId: userId);
  }

  @override
  Future<Map<String, dynamic>> aggregateByDepartment({
    required String workspaceId,
    required DateTime date,
  }) async {
    try {
      final reports = await _databaseService.listReportsByDate(
        workspaceId: workspaceId,
        date: date,
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