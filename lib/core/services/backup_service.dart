import 'firebase_database_service.dart';
import 'onedrive_service.dart';
import 'storage_service.dart';
import '../errors/failures.dart';
import 'dart:async';

class BackupService {
  factory BackupService() => _instance ??= BackupService._();
  BackupService._();

  static BackupService? _instance;

  final StorageService _storage = StorageService();
  final FirebaseDatabaseService _db = FirebaseDatabaseService.instance;
  final OneDriveService _oneDrive = OneDriveService();
  Timer? _timer;
  static const String _lastBackupKey = '__last_onedrive_backup_ms';

  /// Export current company's core data (company info, projects, tasks, reports)
  /// to OneDrive as a JSON backup file.
  Future<void> exportCompanyDataToOneDrive() async {
    final companyId = _storage.getCompanyId();
    if (companyId == null || companyId.isEmpty) {
      throw const UnknownFailure(message: 'No company selected');
    }

    // Aggregate data
    final company = await _db.getCompany(companyId);
    final projects = await _db.listProjects(companyId: companyId);
    final tasks = await _db.listTasks(companyId: companyId);
    final reports = await _db.listReportsByDate(
      companyId: companyId,
      date: DateTime.now(),
    );

    final payload = <String, dynamic>{
      'companyId': companyId,
      'exportedAt': DateTime.now().toIso8601String(),
      'info': <String, dynamic>{
        'id': company?.id,
        'name': company?.name,
        'description': company?.description,
        'createdBy': company?.createdBy,
        'createdAt': company?.createdAt.millisecondsSinceEpoch,
      },
      'projects': projects.map((p) => p.toMap()).toList(),
      'tasks': tasks.map((t) => t.toMap()).toList(),
      'reports': reports.map((r) => r.toMap()).toList(),
    };

    await _oneDrive.backupAppData(payload);
  }

  /// Export only reports for the current company to OneDrive as JSON.
  Future<void> exportReportsToOneDrive() async {
    final companyId = _storage.getCompanyId();
    if (companyId == null || companyId.isEmpty) {
      throw const UnknownFailure(message: 'No company selected');
    }

    final today = DateTime.now();
    final reports = await _db.listReportsByDate(companyId: companyId, date: today);

    final payload = <String, dynamic>{
      'companyId': companyId,
      'exportedAt': DateTime.now().toIso8601String(),
      'type': 'reports',
      'reports': reports.map((r) => r.toMap()).toList(),
    };

    await _oneDrive.backupAppData(payload);
  }

  // ----- Scheduled backups -----

  void startScheduledBackups() {
    _timer?.cancel();
    // Run every 6 hours; internal gating ensures once per day
    _timer = Timer.periodic(const Duration(hours: 6), (_) async {
      await runScheduledBackupIfDue();
    });
  }

  void stopScheduledBackups() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> runScheduledBackupIfDue() async {
    final now = DateTime.now();
    final lastMs = _storage.getInt(_lastBackupKey) ?? 0;
    final last = DateTime.fromMillisecondsSinceEpoch(lastMs);
    final bool differentDay = now.year != last.year || now.month != last.month || now.day != last.day;
    if (lastMs == 0 || differentDay) {
      try {
        await exportCompanyDataToOneDrive();
        await _storage.setInt(_lastBackupKey, now.millisecondsSinceEpoch);
      } on Exception {
        // Silent fail for background schedule
      }
    }
  }

  // ----- Restore & list helpers -----

  Future<List<Map<String, dynamic>>> listBackups() {
    return _oneDrive.listBackupFiles();
  }

  Future<Map<String, dynamic>> restoreBackup(String fileId) {
    return _oneDrive.restoreAppData(fileId);
  }
}

