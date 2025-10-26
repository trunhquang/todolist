import 'package:get/get.dart';
import 'package:todolist/core/controllers/base_controller.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/services/storage_service.dart';
import 'package:todolist/features/reports/domain/entities/report.dart';
import 'package:todolist/features/reports/domain/usecases/report_usecases.dart';

/// Controller for report history page
class ReportHistoryController extends BaseController {

  ReportHistoryController({
    required ListReportsByDate listReportsByDate,
    StorageService? storageService,
  }) : _listReportsByDate = listReportsByDate,
       _storageService = storageService ?? Get.find<StorageService>();
  final ListReportsByDate _listReportsByDate;
  final StorageService _storageService;

  // Private observables
  final RxList<ReportEntity> _reports = <ReportEntity>[].obs;
  final Rx<DateTime> _selectedDate = DateTime.now().obs;
  final RxBool _isRefreshing = false.obs;

  // Public getters
  List<ReportEntity> get reports => _reports;
  DateTime get selectedDate => _selectedDate.value;
  bool get isRefreshing => _isRefreshing.value;

  @override
  void onInit() {
    super.onInit();
    // Load reports asynchronously without awaiting
    _loadReports();
  }

  /// Load reports for the selected date
  Future<void> _loadReports() async {
    await executeAsync(
      () async {
        final workspaceId = _storageService.getWorkspaceId();
        if (workspaceId == null || workspaceId.isEmpty) {
          throw Exception(AppStrings.noworkspaceIdFound);
        }

        final reports = await _listReportsByDate.call(
          workspaceId: workspaceId,
          date: _selectedDate.value,
        );

        _reports.value = reports;
        isSuccess = true;
      },
    );
  }

  /// Refresh reports
  Future<void> refreshReports() async {
    _isRefreshing.value = true;
    try {
      await _loadReports();
    } finally {
      _isRefreshing.value = false;
    }
  }

  /// Change selected date and reload reports
  Future<void> changeDate(DateTime newDate) async {
    _selectedDate.value = newDate;
    await _loadReports();
  }

  /// Navigate to create report page
  Future<void> navigateToCreateReport() async {
    // This would be implemented with NavigationService
    // await NavigationService().toNamed<void>(AppRoutes.createReport);
  }

  /// Get display text for empty state
  String get emptyStateTitle => AppStrings.noReportsFound;
  String get emptyStateSubtitle => AppStrings.noReportsForDate;
  String get createReportButtonText => AppStrings.createNewReport;
}
