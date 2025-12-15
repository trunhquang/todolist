import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/onedrive_service.dart';
import '../../../core/services/backup_service.dart';
import '../../../core/services/snackbar_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/td_button.dart';
import '../../../core/constants/app_strings.dart';

class BackupRestorePage extends StatefulWidget {
  const BackupRestorePage({super.key});

  @override
  State<BackupRestorePage> createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends State<BackupRestorePage> {
  final OneDriveService _oneDrive = OneDriveService();
  final BackupService _backupService = BackupService();
  bool _loading = false;
  List<Map<String, dynamic>> _files = <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    try {
      final files = await _oneDrive.listBackupFiles();
      setState(() => _files = files);
    } catch (e) {
      SnackbarService().showError(title: AppStrings.I.error, message: e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.I.backupAndRestore),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                TDButton(
                  text: AppStrings.I.refresh,
                  icon: Icons.refresh,
                  onPressed: _loading ? null : _refresh,
                ),
                TDButton(
                  text: AppStrings.I.backupToOneDrive,
                  icon: Icons.cloud_upload_outlined,
                  onPressed: _loading
                      ? null
                      : () async {
                          try {
                            setState(() => _loading = true);
                            SnackbarService().showLoading(
                              title: AppStrings.I.backup,
                              message: AppStrings.I.exportingDataToOneDrive,
                            );
                            await _backupService.exportDataToOneDrive();
                            SnackbarService().showSuccess(
                              title: AppStrings.I.backupComplete,
                              message: AppStrings.I.dataExportedToOneDriveSuccessfully,
                            );
                            await _refresh();
                          } catch (e) {
                            SnackbarService().showError(
                              title: AppStrings.I.backupFailed,
                              message: e.toString(),
                            );
                          } finally {
                            if (mounted) setState(() => _loading = false);
                          }
                        },
                ),
                TDButton(
                  text: AppStrings.I.exportReports,
                  icon: Icons.insert_chart_outlined,
                  onPressed: _loading
                      ? null
                      : () async {
                          try {
                            setState(() => _loading = true);
                            SnackbarService().showLoading(
                              title: AppStrings.I.export,
                              message: AppStrings.I.exportingReports,
                            );
                            await _backupService.exportReportsToOneDrive();
                            SnackbarService().showSuccess(
                              title: AppStrings.I.exportComplete,
                              message: AppStrings.I.reportsExported,
                            );
                            await _refresh();
                          } catch (e) {
                            SnackbarService().showError(
                              title: AppStrings.I.exportFailed,
                              message: e.toString(),
                            );
                          } finally {
                            if (mounted) setState(() => _loading = false);
                          }
                        },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _files.isEmpty
                      ? Center(
                          child: Text(
                            AppStrings.I.noDataAvailable,
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onBackground),
                          ),
                        )
                      : ListView.separated(
                          itemCount: _files.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final f = _files[index];
                            final name = f['name']?.toString() ?? 'backup.json';
                            final id = f['id']?.toString() ?? '';
                            final size = f['size']?.toString() ?? '';
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.insert_drive_file_outlined, color: AppColors.primary),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(name, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurface)),
                                        if (size.isNotEmpty)
                                          Text('${AppStrings.I.sizeLabel}: $size', style: AppTextStyles.labelSmall.copyWith(color: AppColors.onSurfaceVariant)),
                                      ],
                                    ),
                                  ),
                                  TDButton(
                                    text: AppStrings.I.restore,
                                    variant: TDButtonVariant.outlined,
                                    onPressed: id.isEmpty
                                        ? null
                                        : () async {
                                            try {
                                              setState(() => _loading = true);
                                              final data = await _backupService.restoreBackup(id);
                                              SnackbarService().showSuccess(
                                                title: AppStrings.I.restoreComplete,
                                                message: AppStrings.I.dataRestoredPreview,
                                              );
                                              // For now we only preview length in logs; future: apply to local store
                                              Get.log('Restored data keys: ${data.keys.join(', ')}');
                                            } catch (e) {
                                              SnackbarService().showError(
                                                title: AppStrings.I.restoreFailed,
                                                message: e.toString(),
                                              );
                                            } finally {
                                              if (mounted) setState(() => _loading = false);
                                            }
                                          },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}


