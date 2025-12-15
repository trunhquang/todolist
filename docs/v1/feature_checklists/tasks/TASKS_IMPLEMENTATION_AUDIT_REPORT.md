# Tasks Implementation Audit Report

- **Scope**: `docs/v1/feature_checklists/tasks.md`.
- **Goal**: Mark each checklist item Implemented / Partial / Missing, cite key classes/flows, and suggest verification steps.
- **Sources reviewed**: `lib/features/tasks/**/*`, `lib/core/services/firebase_database_service.dart`, `lib/core/constants/task_enums.dart?` (not found), `lib/app/routes/app_router.dart`, tests under `test/features/workspace/**` (task-specific tests largely absent).

## Legend
- ✅ Implemented and wired
- ⚠️ Partial / placeholder / needs follow-up
- ⛔ Missing / not found

## Checklist Status
1) ⚠️ **CRUD & chi tiết (tiêu đề, mô tả, trạng thái enum, ưu tiên enum, loại, deadline, tag, checklist, attachments; lưu creator/assignee/updater; comments/activity)**  
   - Entities: `TaskEntity` includes title/description/status/priority/taskType/deadline/assignee/assigner/projectId/recurring/hasDeadline; creator via `assigner`, no explicit updater; no tags/checklist/attachments fields; status/priority are strings (not enums). Activity/comments not found.  
   - UI: `task_list_page.dart`, `task_card.dart`, `create_task_form.dart` present; coverage for full detail unclear; no evidence of attachments/comments.  
   - Missing: enum enforcement (`task_enums.dart` not used), tags, checklist, attachments, audit of updater, comment/activity log.

2) ⚠️ **Assignment (team/group/member, reassign, unassign, bulk assign)**  
   - Domain/UI show single assignee string; no team/group assignment or bulk operations; reassign = overwrite assignee only. No cascade to lead/member.

3) ⚠️ **Phân loại (Daily/Project), màu theo trạng thái**  
   - `taskType` string supports `daily/project` but not enforced by enum; color mapping not found.

4) ⚠️ **Thống kê & lọc (status/priority/assignee/tag/workspace/project/team)**  
   - Task controllers include pagination/filter basics (limited review); no tag/team filters; workspaceId field exists but global filter guard not confirmed. Sorting/filter UIs not evident.

5) ⚠️ **Hiệu năng & sync (server-side pagination via FirebaseDatabaseServiceEnhanced, offline cache, conflict resolution)**  
   - Uses `FirebaseDatabaseService` (no Enhanced version in repo); pagination tests exist (`pagination_test.dart`) but not the enhanced service. Offline cache/conflict resolution not found.

6) ⚠️ **Recurring tasks**  
   - `TaskEntity.recurring` + `generate_recurring_tasks.dart` use case exist; UI wiring unclear; no scheduler hook observed in controllers.

7) ⛔ **Task dependencies/blockers**  
   - Not implemented; only `parentTaskId` for recurring instances, not blockers.

8) ⛔ **SLA thông báo khi quá hạn**  
   - Not implemented; no SLA timers or notifications.

9) ⛔ **Export/import subset tasks (backup linkage)**  
   - Not implemented; no export/import flow.

## Execution Flows (current, high level)
- **Creation/update**: `create_task_form.dart` → task controllers (e.g., `TaskController`, `PaginatedTaskController`) → repositories (`project_repository_impl`, `recurring_task_repository_impl`) → `FirebaseDatabaseService` (workspaceId required). No attachments/tags/comments pipeline found.
- **Recurring generation**: `generate_recurring_tasks.dart` use case; trigger path not identified in controllers.
- **Pagination**: controllers named `PaginatedTaskController` but rely on base `FirebaseDatabaseService` (no enhanced service).

## Test & Verification
- Automated: Pagination tests exist (`test/pagination_test.dart`, `pagination_simple_test.dart`); workspace tests do not cover task details. No dedicated task CRUD/recurring/comment tests observed.  
  Suggested commands:
  ```bash
  flutter test test/pagination_test.dart
  flutter test test/pagination_simple_test.dart
  ```
- Manual checks:
  - Create/edit/delete task with status/priority/type/deadline; note missing tags/checklist/attachments/comments.
  - Assign/reassign/unassign; verify team/group assignment not available.
  - Switch workspace and ensure queries scoped by workspaceId (likely needs verification).
  - Try recurring settings and confirm instances are generated (may fail due to missing trigger).
  - Observe lack of SLA alerts and dependency UI.

## Recommended Follow-Ups
- Introduce `task_enums.dart` usage for status/priority/type; refactor controllers/entities/UI to use enums + AppStrings.I.
- Add tags, checklist items, attachments, updater tracking, and activity/comment log entities + UI.
- Implement team/group assignment, bulk assign/reassign/unassign flows with permission checks.
- Add status→color mapping and comprehensive filters (assignee/tag/workspace/project/team/status/priority) with server-side query support.
- Replace/extend data layer with `FirebaseDatabaseServiceEnhanced` for server-side pagination; add offline cache + conflict resolution strategy.
- Wire recurring tasks trigger (scheduler or creation hook) with tests.
- Add task dependency/blocker model and SLA overdue notifications.
- Provide export/import endpoints and UI (align with backup feature).
