# Reports & Analytics Implementation Audit Report

- **Scope**: `docs/v1/feature_checklists/reports.md`.
- **Goal**: Status per checklist item (Implemented / Partial / Missing), key classes/flows, and verification guidance.
- **Sources reviewed**: `lib/features/reports/**/*`, `lib/features/tasks/**/*`, `lib/core/services/firebase_database_service.dart`, `lib/app/pages/home/dashboard_page.dart` (for dashboards), `test/` (no report-focused tests found).

## Legend
- ✅ Implemented and wired
- ⚠️ Partial / placeholder / needs follow-up
- ⛔ Missing / not found

## Checklist Status
1) ⚠️ **Báo cáo tổng quan: tổng số task theo trạng thái/ưu tiên/loại (workspace-wide)**  
   - Entities/controllers for reports exist (`ReportEntity`, `ReportController`), but aggregation logic over tasks by status/priority/type not found. No task-enum enforcement; metrics field is generic.

2) ⚠️ **Biểu đồ cột/hình tròn cho task per status/priority**  
   - Dashboard has metrics placeholders (not fully reviewed), but dedicated chart implementation for reports not evident; no charts tied to reports feature.

3) ⚠️ **Phân tách theo workspace/project/team/group/assignee; khoảng thời gian**  
   - `ReportEntity` carries `workspaceId` and `completedTaskIds`; no filtering/query layer shown for project/team/assignee or date range. No UI for scoped filtering.

4) ⚠️ **Project analytics: trạng thái project, tỷ lệ hoàn thành, burnup/burndown, danh sách task quá hạn/sắp quá hạn**  
   - `project_progress_card.dart` exists; no dedicated project analytics in reports module; overdue/near-due listing not implemented.

5) ⛔ **Xuất/nhập (Excel/PDF), lưu cấu hình bộ lọc**  
   - No export/import or saved-filter implementation found.

6) ⛔ **Quyền truy cập báo cáo theo vai trò**  
   - No access control specific to reports; relies on generic roles only.

7) ⛔ **Lịch chạy báo cáo định kỳ và gửi email/notification**  
   - Not implemented; no scheduler or notification hook for reports.

8) ⛔ **Định nghĩa KPI cụ thể cho team/project**  
   - Not implemented; no KPI models or UI.

## Execution Flows (current)
- Reports feature skeleton: `ReportController`, `ReportHistoryController`, `ReportRepositoryImpl` with basic CRUD (not fully audited); `ReportEntity` supports metrics map. No end-to-end flow for generating analytics from tasks/projects.
- Dashboards: `dashboard_page.dart` includes high-level widgets but not wired to a reports pipeline.

## Test & Verification
- Automated: no dedicated report tests found.  
  Suggested starting points:
  ```bash
  flutter test test/features/workspace/  # sanity; no report coverage
  ```
- Manual checks (expected gaps):
  - Try to generate or view a report: likely missing UI/flows.
  - Verify task analytics per status/priority/type: not present.
  - Check project analytics and overdue task listing: not present.
  - Attempt export or saved filters: not available.
  - Role-based access to reports: not enforced.

## Recommended Follow-Ups
- Implement task aggregation by status/priority/type scoped by workspace/project/team/assignee and date range; provide chart widgets (bar/pie) using TD components.
- Add report generation service/use cases that read tasks/projects with server-side filters.
- Add overdue/near-due task queries and project progress (burnup/burndown) calculations.
- Build export (Excel/PDF) and saved-filter storage; consider staged rollout toggle.
- Enforce report access control (roles/permissions) and add scheduled report delivery via email/notification.
- Define KPIs per team/project and surface in reports UI.
