# Backup & Export Audit Docs

## Implementation Audit
- `BACKUP_IMPLEMENTATION_AUDIT_REPORT.md` — status vs checklist, flows, verification, and gaps.

## Test Cases
- `EXCEL_EXPORT_TEST_CASES.md` — step-by-step manual test cases for Excel export feature (export Excel list of tasks/projects, hidden if not enabled), covering current missing implementation (not implemented; no export pipeline or toggle) and required fixes.
- `SCHEDULED_BACKUP_TEST_CASES.md` — step-by-step manual test cases for scheduled backup feature (backup định kỳ lên OneDrive/Firebase Storage cho Account Holder/Admin), covering current missing implementation (not implemented; no backup scheduler/service or role guard) and required fixes.

## Task Lists
- `EXCEL_EXPORT_TASKS.md` — detailed task list and expected results for completing the Excel export feature, including adding Excel package to pubspec.yaml, creating feature toggle entity and service, creating ExcelExportService, adding export UI to task/project pages (hidden when toggle is disabled), adding permission checks, adding file sharing functionality, and unit tests.
- `SCHEDULED_BACKUP_TASKS.md` — detailed task list and expected results for completing the scheduled backup feature, including adding role guard to BackupService, implementing exportDataToOneDrive() method, creating FirebaseStorageBackupService, adding backup destination selection, adding backup scheduler configuration, adding backup settings UI, adding failure notification system, adding storage quota checking, adding backup progress indicator, and unit tests.
