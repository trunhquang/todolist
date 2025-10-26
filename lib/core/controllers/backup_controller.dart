import 'package:get/get.dart';
import 'package:todolist/core/controllers/base_controller.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/services/backup_service.dart';
import 'package:todolist/core/services/storage_service.dart';
import 'package:todolist/core/errors/failures.dart';

/// Controller for backup and restore functionality
class BackupController extends BaseController {
  final BackupService _backupService;
  final StorageService _storageService;

  BackupController({
    required BackupService backupService,
    required StorageService storageService,
  }) : _backupService = backupService,
       _storageService = storageService;

  // Private observables
  final _isBackingUp = false.obs;
  final _isRestoring = false.obs;
  final _isExportingReports = false.obs;
  final _backupProgress = 0.0.obs;
  final _restoreProgress = 0.0.obs;
  final _lastBackupDate = Rxn<DateTime>();
  final _backupSize = RxnString();
  final _availableBackups = <Map<String, dynamic>>[].obs;

  // Public getters
  bool get isBackingUp => _isBackingUp.value;
  bool get isRestoring => _isRestoring.value;
  bool get isExportingReports => _isExportingReports.value;
  double get backupProgress => _backupProgress.value;
  double get restoreProgress => _restoreProgress.value;
  DateTime? get lastBackupDate => _lastBackupDate.value;
  String? get backupSize => _backupSize.value;
  List<Map<String, dynamic>> get availableBackups => _availableBackups;

  @override
  void onInit() {
    super.onInit();
    _loadBackupInfo();
    _loadAvailableBackups();
  }

  /// Load backup information
  Future<void> _loadBackupInfo() async {
    try {
      final lastBackupMs = _storageService.getInt('__last_onedrive_backup_ms');
      if (lastBackupMs != null) {
        _lastBackupDate.value = DateTime.fromMillisecondsSinceEpoch(lastBackupMs);
      }
      
      // This would be calculated from actual backup size
      _backupSize.value = '2.5 MB';
    } catch (e) {
      // Handle error silently for backup info
    }
  }

  /// Load available backups from OneDrive
  Future<void> _loadAvailableBackups() async {
    try {
      final backups = await _backupService.listBackups();
      _availableBackups.value = backups;
    } catch (e) {
      // Handle error silently
    }
  }

  /// Create backup to OneDrive
  Future<void> createBackup() async {
    _isBackingUp.value = true;
    _backupProgress.value = 0.0;

    try {
      await executeAsync(
        () async {
          // Simulate backup progress
          for (int i = 0; i <= 100; i += 10) {
            _backupProgress.value = i / 100;
            await Future.delayed(const Duration(milliseconds: 100));
          }

          // Perform actual backup
          await _backupService.exportDataToOneDrive();
          
          // Update backup info
          _lastBackupDate.value = DateTime.now();
          _backupSize.value = '2.5 MB'; // This would be calculated from actual backup size
          
          // Save backup info to storage
          await _storageService.setInt('__last_onedrive_backup_ms', DateTime.now().millisecondsSinceEpoch);
          
          // Reload available backups
          await _loadAvailableBackups();
        },
        showLoading: false, // We handle loading state manually
        successMessage: AppStrings.backupComplete,
      );
    } finally {
      _isBackingUp.value = false;
      _backupProgress.value = 0.0;
    }
  }

  /// Restore backup from OneDrive
  Future<void> restoreBackup(String fileId) async {
    _isRestoring.value = true;
    _restoreProgress.value = 0.0;

    try {
      await executeAsync(
        () async {
          // Simulate restore progress
          for (int i = 0; i <= 100; i += 10) {
            _restoreProgress.value = i / 100;
            await Future.delayed(const Duration(milliseconds: 100));
          }

          // Perform actual restore
          await _backupService.restoreBackup(fileId);
        },
        showLoading: false, // We handle loading state manually
        successMessage: AppStrings.restoreComplete,
      );
    } finally {
      _isRestoring.value = false;
      _restoreProgress.value = 0.0;
    }
  }

  /// Export reports to OneDrive
  Future<void> exportReports() async {
    _isExportingReports.value = true;

    try {
      await executeAsync(
        () async {
          await _backupService.exportReportsToOneDrive();
        },
        successMessage: AppStrings.exportComplete,
      );
    } finally {
      _isExportingReports.value = false;
    }
  }

  /// Refresh available backups
  Future<void> refreshBackups() async {
    await _loadAvailableBackups();
  }

  /// Get display text for backup status
  String get backupStatusText {
    if (lastBackupDate != null) {
      return 'Last backup: ${_formatDate(lastBackupDate!)}';
    }
    return 'No backup found';
  }

  /// Get display text for backup size
  String get backupSizeText {
    if (backupSize != null) {
      return 'Size: $backupSize';
    }
    return '';
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Check if backup is available
  bool get hasBackup => lastBackupDate != null;

  /// Get backup button text
  String get backupButtonText {
    if (isBackingUp) {
      return 'Backing up... ${(backupProgress * 100).toInt()}%';
    }
    return AppStrings.backupToOneDrive;
  }

  /// Get restore button text
  String get restoreButtonText {
    if (isRestoring) {
      return 'Restoring... ${(restoreProgress * 100).toInt()}%';
    }
    return AppStrings.restore;
  }

  /// Get export button text
  String get exportButtonText {
    if (isExportingReports) {
      return AppStrings.exportingReports;
    }
    return AppStrings.exportReports;
  }

  /// Get Power BI button text
  String get powerBIButtonText => AppStrings.openPowerBiDashboard;

  /// Get backup file display name
  String getBackupDisplayName(Map<String, dynamic> backup) {
    final name = backup['name']?.toString() ?? 'Unknown';
    final created = backup['createdDateTime']?.toString();
    
    if (created != null) {
      try {
        final date = DateTime.parse(created);
        return '${_formatDate(date)} - $name';
      } catch (e) {
        return name;
      }
    }
    
    return name;
  }

  /// Get backup file size
  String getBackupSize(Map<String, dynamic> backup) {
    final size = backup['size']?.toString();
    if (size != null) {
      final bytes = int.tryParse(size) ?? 0;
      if (bytes > 1024 * 1024) {
        return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
      } else if (bytes > 1024) {
        return '${(bytes / 1024).toStringAsFixed(1)} KB';
      } else {
        return '$bytes B';
      }
    }
    return 'Unknown size';
  }
}
