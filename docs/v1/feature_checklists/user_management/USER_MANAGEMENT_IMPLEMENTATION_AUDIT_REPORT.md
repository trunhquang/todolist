# User Management Implementation Audit Report

- **Scope**: `docs/v1/feature_checklists/user_management.md`.
- **Goal**: Mark each item Implemented / Partial / Missing, cite flows (classes), and suggest verification.
- **Sources reviewed**: `lib/features/auth/**/*`, `lib/features/workspace/**/*`, `lib/core/services/firebase_database_service.dart`, `lib/core/constants/user_roles.dart`, `test/features/workspace/**/*`.

## Legend
- ✅ Implemented and wired
- ⚠️ Partial / placeholder / needs follow-up
- ⛔ Missing / not found

## Checklist Status
1) ⚠️ **Hồ sơ người dùng (tên, avatar, timezone, ngôn ngữ, chữ ký)**  
   - Implemented: `AuthController.updateUserProfile` updates name and avatar only; `User` entity has `preferences` but no timezone/language/signature fields.  
   - Missing: timezone/language/signature handling, validation, and persistence; no UI for profile edit beyond name/avatar.

2) ⛔ **Lưu firebase token + deviceId để phục vụ push**  
   - No deviceId capture; token saved only as ID token via `StorageService.setUserToken` (not FCM). No push registration flow.

3) ⚠️ **Quản lý trạng thái kích hoạt/khoá tài khoản**  
   - `User.isActive` exists; no controller/service UI to toggle lock/unlock; no enforcement paths observed.

4) ⚠️ **Quyền và vai trò (Account Holder/Admin/Lead/Member + custom permissions)**  
   - Implemented roles: `UserRoles` defines admin/departmentManager/teamLead/regular with permission lists.  
   - Missing: Account Holder role, Lead per workspace/team, custom permission sets for projects/tasks/teams; workspace role (AccountHolder/Admin/Member) handled separately in `WorkspaceRole` but not bridged to `User`.

5) ⚠️ **Thành viên & nhóm (thêm/xóa user vào Team/Group, gán lead, cascading)**  
   - Workspace hierarchy helpers: `WorkspaceRepositoryImpl.updateManager/listTeam`, `WorkspaceMember.managerUserId`.  
   - Missing: Team/Group assignment UI/flows; no cascading permission enforcement to tasks/projects; no user listing/filter by role/status UI.

6) ⛔ **Bảo mật & audit (audit log thay đổi role/avatar/email, thông báo khi thêm/xóa khỏi workspace/team, confirm khi hạ quyền/xóa user)**  
   - No audit log system; no notification hooks for add/remove/role changes; no confirmation flows for demotion/removal.

7) ⛔ **Transfer ownership khi Account Holder rời đi**  
   - Not implemented; no use case/controller/UI.

8) ⛔ **Giới hạn số thiết bị đăng nhập đồng thời**  
   - Not implemented; no session/device tracking.

9) ⛔ **Export danh sách user phục vụ compliance**  
   - Not implemented; no export use case or UI.

## Execution Flows (current)
- **Profile update**: `AuthController.updateUserProfile` → Firebase Auth display name/photo update → local `User` copyWith → `StorageService.setUserData`.
- **Role/permission checks**: `AuthController.hasPermission/canManageRole/hasHigherAuthority` using `UserRoles` mapping (admin/departmentManager/teamLead/regular). No workspace-specific Account Holder bridge.
- **Workspace hierarchy**: `WorkspaceController.setManager` → `WorkspaceRepositoryImpl.updateManager` (managerUserId) → remote data source.

## Test & Verification
- Automated: workspace tests exist (`test/features/workspace/**`) but no dedicated user-profile/role tests found.  
  Run workspace suite as baseline:
  ```bash
  flutter test test/features/workspace/
  ```
- Manual checks (expected gaps):
  - Edit profile: verify name/avatar updates; observe lack of timezone/language/signature fields.
  - Attempt to lock/unlock user: no UI/flow available.
  - Add/remove member to team/group: not available; manager assignment only.
  - Role changes/demotion notifications or confirmations: not present.
  - Multi-device login limit, audit log, export: not present.

## Recommended Follow-Ups
- Extend `User` preferences to include timezone, language, signature; add validation and UI using AppStrings + TD widgets; persist via database service.
- Implement FCM device registration (token + deviceId) with secure storage and sync to backend.
- Add account activation/lock management with enforcement in auth/data queries.
- Introduce Account Holder role mapping with workspace membership; support custom permission sets for projects/tasks/teams and UI to manage them.
- Build team/group membership UIs (assign lead, cascade permissions) and ensure project/task filtering by workspace + role/team.
- Add audit logging + notification hooks for add/remove/role changes; require confirmation on admin demotion/user removal.
- Add ownership transfer flow, device session limits, and user export endpoint/UI.
