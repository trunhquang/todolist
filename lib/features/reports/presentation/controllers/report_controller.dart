import 'package:get/get.dart';

import '../../../../core/services/report_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/report.dart';

class ReportController extends GetxController {
  ReportController({ReportService? reportService})
      : _reportService = reportService ?? Get.find<ReportService>();

  final ReportService _reportService;

  final _isLoading = false.obs;
  final _error = RxnString();
  final _reports = <ReportEntity>[].obs;

  bool get isLoading => _isLoading.value;
  String? get error => _error.value;
  List<ReportEntity> get reports => _reports;

  Future<void> loadTodayReports() async {
    try {
      _isLoading.value = true;
      _error.value = null;
      final storageService = Get.find<StorageService>();
      final companyId = storageService.getCompanyId();
      final userId = storageService.getUserId();
      if (companyId == null || userId == null) return;
      final today = DateTime.now();
      final dateOnly = DateTime(today.year, today.month, today.day);
      final items = await _reportService.listReportsByDate(
        companyId: companyId,
        date: dateOnly,
        userId: userId,
      );
      _reports.assignAll(items);
    } catch (e) {
      _error.value = 'Failed to load reports: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<String?> createDraft({required String summary, List<String> completedTaskIds = const <String>[]}) async {
    return _reportService.createTodayDraft(summary: summary, completedTaskIds: completedTaskIds);
  }

  Future<void> submit(String reportId) async {
    await _reportService.submitTodayReport(reportId);
    await loadTodayReports();
  }
}



