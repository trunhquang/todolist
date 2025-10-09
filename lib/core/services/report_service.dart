import 'package:get/get.dart';

import 'notification_service.dart';
import 'storage_service.dart';
import '../../features/reports/data/repositories/report_repository_impl.dart';
import '../../features/reports/domain/entities/report.dart';
import '../../features/reports/domain/usecases/report_usecases.dart';

class ReportService extends GetxService {
  ReportService({
    ReportRepositoryImpl? repository,
    StorageService? storageService,
    NotificationService? notificationService,
  })  : _repository = repository ?? ReportRepositoryImpl(),
        _storageService = storageService ?? Get.find<StorageService>(),
        _notificationService = notificationService ?? NotificationService();

  final ReportRepositoryImpl _repository;
  final StorageService _storageService;
  final NotificationService _notificationService;

  late final createDailyReport = CreateDailyReport(_repository);
  late final submitReport = SubmitReport(_repository);
  late final updateReportDraft = UpdateReportDraft(_repository);
  late final listReportsByDate = ListReportsByDate(_repository);
  late final watchUserReports = WatchUserReports(_repository);
  late final aggregateDepartmentReports = AggregateDepartmentReports(_repository);

  Future<String?> createTodayDraft({required String summary, List<String> completedTaskIds = const <String>[]}) async {
    final companyId = _storageService.getCompanyId();
    final userId = _storageService.getUserId();
    if (companyId == null || userId == null) return null;
    final today = DateTime.now();
    final dateOnly = DateTime(today.year, today.month, today.day);
    final report = ReportEntity(
      id: '',
      userId: userId,
      companyId: companyId,
      departmentId: _storageService.getDepartmentId(),
      date: dateOnly,
      summary: summary,
      completedTaskIds: completedTaskIds,
      status: ReportStatus.draft,
      createdAt: DateTime.now(),
    );
    return await createDailyReport(report);
  }

  Future<void> submitTodayReport(String reportId) async {
    final companyId = _storageService.getCompanyId();
    if (companyId == null) return;
    await submitReport(companyId: companyId, reportId: reportId);
    // Notify manager or user themselves
    final userId = _storageService.getUserId();
    if (userId != null) {
      await _notificationService.showReportSubmitted(userId: userId, userName: 'User');
    }
  }

  Future<void> scheduleDailyReportReminder({required DateTime time}) async {
    final userId = _storageService.getUserId();
    if (userId == null) return;
    await _notificationService.showReportReminder(userId: userId, reminderTime: time);
  }
}



