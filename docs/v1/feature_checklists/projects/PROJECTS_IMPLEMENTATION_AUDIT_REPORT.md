# Projects Implementation Audit Report

- **Scope**: `docs/v1/feature_checklists/projects.md`.
- **Goal**: Status per checklist item (Implemented / Partial / Missing), key classes/flows, and verification pointers.
- **Sources skimmed**: `lib/features/tasks/domain/entities/project.dart`, `lib/features/tasks/presentation/pages/project_list_page.dart`, `lib/features/tasks/presentation/controllers/project_controller.dart`/`paginated_project_controller.dart`, `lib/features/tasks/data/repositories/project_repository_impl.dart`, `lib/core/services/firebase_database_service.dart`. Tests for projects not found.

## Legend
- ✅ Implemented and wired
- ⚠️ Partial / placeholder / needs follow-up
- ⛔ Missing / not found

## Checklist Status
1) ⚠️ **CRUD & lifecycle (create/edit/archive/restore/delete with permissions)**  
   - Create/edit/delete flows exist via project controllers/repository; archive/restore support not evident; permissions enforced indirectly (workspace-based, not role-based UI checks).

2) ⚠️ **Project status enum (planned/in_progress/on_hold/completed/canceled)**  
   - `Project` entity uses string status; no enum (`task_enums.dart` absent). Need enum + mapping to comply.

3) ⚠️ **Tasks within project (add/remove/edit; assign team/group/member; filters by status/priority/assignee/tag; status breakdown)**  
   - Tasks link via `projectId`. No team/group assignment support; filter/tag coverage unclear; status breakdown not implemented.

4) ⚠️ **Scope & permissions (workspace + role/team; project membership assign/revoke/roles)**  
   - Workspace scoping present (`workspaceId`). No dedicated project member roles/permissions or UI to assign/revoke.

5) ⚠️ **Tracking & reporting (project dashboard, task charts, burndown/burnup, overdue/near-due list, change log for status/members/deadline/budget)**  
   - `project_progress_card.dart` provides progress display, but no burndown/burnup or change log; overdue/near-due not surfaced.

6) ⛔ **Milestones/phase linked to tasks**  
   - Not implemented; no milestone entity/UI.

7) ⛔ **Rules for moving tasks between projects**  
   - Not implemented; no validation or flow.

8) ⛔ **SLA for status updates and deadline reminders**  
   - Not implemented; no SLA timers/notifications.

9) ⛔ **Project templates (predefined task sets)**  
   - Not implemented.

## Execution Flows (current, high level)
- Project CRUD: project pages/controllers → `project_repository_impl.dart` → `FirebaseDatabaseService` using `workspaceId` and `projectId`.
- Task linkage: tasks carry `projectId`; controllers can filter by project (not fully verified for filters).
- Progress display: `project_progress_card.dart` shows basic metrics only.

## Test & Verification
- Automated: no dedicated project tests spotted. Suggested smoke:
  ```bash
  flutter test test/pagination_test.dart
  ```
  (projects not covered; add project-specific tests).
- Manual checks:
  - Create/edit/delete project; verify status handling (strings, no enum).
  - Attempt archive/restore: flow likely missing.
  - Add tasks to project; filter by project; check absence of team/group assignment and tag filters.
  - Look for project member management UI (not present).
  - Inspect dashboards for burndown/burnup/overdue (not present).

## Recommended Follow-Ups
- Introduce project status enum and enforce through controllers/UI; map to AppStrings and colors.
- Implement archive/restore lifecycle with permission checks.
- Add project membership (roles, permissions) and team/group-aware task assignment within projects.
- Build task filters (status/priority/assignee/tag/project/team) and status breakdown per project.
- Add burndown/burnup, overdue/near-due lists, and change log (status/member/deadline/budget).
- Add milestones/phases linked to tasks; rules for moving tasks across projects.
- Add SLA reminders for project/task deadlines and status updates.
- Provide project templates (predefined tasks) to speed setup and cover tests.
