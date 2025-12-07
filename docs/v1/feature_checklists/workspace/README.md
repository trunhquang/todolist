## Workspace Implementation Audit
- `WORKSPACE_IMPLEMENTATION_AUDIT_REPORT.md` — coverage of V1 workspace checklist, implementation flows, gaps, and test guidance.

## Test Cases
- `WORKSPACE_CREATION_TEST_CASES.md` — step-by-step manual test cases for workspace creation feature, covering happy path, validation, error handling, and edge cases.
- `WORKSPACE_EDIT_TEST_CASES.md` — step-by-step manual test cases for workspace edit feature (name, description, brand color), covering current partial implementation and known gaps.
- `WORKSPACE_DELETE_TEST_CASES.md` — step-by-step manual test cases for workspace delete feature with Account Holder/Admin permission confirmation, covering current partial implementation and known gaps.
- `WORKSPACE_SETTINGS_TEST_CASES.md` — step-by-step manual test cases for workspace settings feature (logo, primary color, timezone, language, date/time format, currency, theme, notifications), covering current partial implementation and known gaps.
- `PERSONAL_WORKSPACE_AUTO_CREATE_TEST_CASES.md` — step-by-step manual test cases for personal workspace auto-create during registration feature, covering current missing implementation and expected behavior.
- `WORKSPACE_SWITCHING_TEST_CASES.md` — step-by-step manual test cases for workspace switching feature (fast switching and remembering last selection), covering current partial implementation and known gaps.
- `WORKSPACE_DATA_FILTERING_TEST_CASES.md` — step-by-step manual test cases for workspace data filtering feature (ensuring all data queries filter by active workspace), covering current partial implementation and known gaps.
- `WORKSPACE_USER_MANAGEMENT_TEST_CASES.md` — step-by-step manual test cases for workspace user management feature (roles, status, invite/revoke, add/remove), covering current partial implementation and known gaps.
- `ROLE_MATRIX_TEST_CASES.md` — step-by-step manual test cases for role matrix feature (Account Holder, Admin, Member, Lead, custom permissions), covering current partial implementation and known gaps.
- `PROJECTS_TEAMS_VISIBILITY_TEST_CASES.md` — step-by-step manual test cases for projects & teams visibility feature (access rights by role/team), covering current partial implementation and known gaps.
- `GOVERNANCE_SAFETY_TEST_CASES.md` — step-by-step manual test cases for governance & safety feature (audit log, quota cảnh báo, backup/restore), covering current missing implementation and expected behavior.
- `TRANSFER_OWNERSHIP_TEST_CASES.md` — step-by-step manual test cases for transfer Account Holder ownership feature, covering current missing implementation and expected behavior.
- `WORKSPACE_ARCHIVE_TEST_CASES.md` — step-by-step manual test cases for workspace archive process feature, covering current missing implementation and expected behavior.
- `WORKSPACE_NAME_SLUG_CONFLICT_TEST_CASES.md` — step-by-step manual test cases for workspace name/slug conflict checking feature, covering current partial implementation (local name check only) and missing remote checks.

## Task Lists
- `WORKSPACE_EDIT_TASKS.md` — detailed task list and expected results for completing the workspace edit information feature, including primary color support, routing fixes, and architecture compliance.
- `WORKSPACE_DELETE_TASKS.md` — detailed task list and expected results for completing the workspace delete feature, including confirmation dialog implementation, role checks in UI, and permission alignment.
- `WORKSPACE_SETTINGS_TASKS.md` — detailed task list and expected results for completing the workspace settings feature, including primary color support, validation enforcement, and GetX refactoring.
- `PERSONAL_WORKSPACE_AUTO_CREATE_TASKS.md` — detailed task list and expected results for implementing personal workspace auto-create during registration feature, including integration with auth flow, error handling, and duplicate prevention.
- `WORKSPACE_SWITCHING_TASKS.md` — detailed task list and expected results for completing the workspace switching feature, including cache parsing implementation, initial load optimization, and stale cache handling.
- `WORKSPACE_DATA_FILTERING_TASKS.md` — detailed task list and expected results for completing the workspace data filtering feature, including global guard/interceptor implementation, query auditing, and workspace validation.
- `WORKSPACE_USER_MANAGEMENT_TASKS.md` — detailed task list and expected results for completing the workspace user management feature, including WorkspaceManagementPage._manageMembers implementation, permission enum refactoring, and unified member management screen.
- `ROLE_MATRIX_TASKS.md` — detailed task list and expected results for completing the role matrix feature, including Lead role implementation, permission template management UI, custom role creation, and transfer ownership flow.
- `PROJECTS_TEAMS_VISIBILITY_TASKS.md` — detailed task list and expected results for completing the projects & teams visibility feature, including permission-based filtering service, team-based filtering logic, guard rails/interceptor implementation, and permission enforcement.
- `GOVERNANCE_SAFETY_TASKS.md` — detailed task list and expected results for implementing the governance & safety feature, including workspace audit log entity and service, quota checking and warning system, workspace-level backup/restore hooks, and governance UI.
- `TRANSFER_OWNERSHIP_TASKS.md` — detailed task list and expected results for implementing the transfer Account Holder ownership feature, including transfer ownership use case, repository and remote data source methods, transfer ownership page and controller, validation, and audit logging integration.
- `WORKSPACE_ARCHIVE_TASKS.md` — detailed task list and expected results for implementing the workspace archive process feature, including archive fields in workspace entity, archive/restore use cases, repository and remote data source methods, archive/restore UI, and filtering of archived workspaces.
- `WORKSPACE_NAME_SLUG_CONFLICT_TASKS.md` — detailed task list and expected results for completing the workspace name/slug conflict checking feature, including slug field in workspace entity, remote name/slug uniqueness checks, slug generation during creation, collision handling, and conflict checks for workspace updates.

