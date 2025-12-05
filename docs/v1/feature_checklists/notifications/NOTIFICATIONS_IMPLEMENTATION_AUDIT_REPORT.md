# Notifications Implementation Audit Report

- **Scope**: `docs/v1/feature_checklists/notifications.md`.
- **Goal**: Status per checklist item (Implemented / Partial / Missing), key classes/flows, and verification pointers.
- **Sources reviewed**: `lib/features/notifications/domain/entities/notification.dart`, `lib/core/services/firebase_database_service.dart`, `lib/features/workspace/**`, `lib/features/tasks/**`, `lib/features/auth/presentation/controllers/auth_controller.dart` (token handling), `lib/app/pages/home/dashboard_page.dart`. No notification services/controllers found.

## Legend
- ✅ Implemented and wired
- ⚠️ Partial / placeholder / needs follow-up
- ⛔ Missing / not found

## Checklist Status
1) ⛔ **Kiến trúc: mỗi thiết bị có BE service riêng, đồng bộ Firebase token + deviceId; dùng FCM push khi thêm/xóa/sửa/assign task, thay đổi role**  
   - Only `NotificationEntity` exists; no device/FCM registration, no service layer, no push triggers.

2) ⛔ **Luồng chính: lưu token/deviceId khi login/refresh; push khi thay đổi task/project/workspace membership; retry/fallback; revoke token khi logout**  
   - `AuthController` saves ID token to StorageService (not FCM), no deviceId, no refresh/retry/revoke flows.

3) ⛔ **Quản lý đăng ký: bật/tắt nhóm thông báo (task updates, mentions, workspace changes); DND/quiet hours**  
   - Not implemented; no user prefs or UI for categories/DND.

4) ⛔ **Quan sát & audit: log gửi thông báo, thống kê success/fail/invalid tokens**  
   - Not implemented; no logging/metrics.

5) ⛔ **Thiếu cần bổ sung: in-app notification center, read/unread; real-time vs digest; quota/throttle warnings**  
   - Not implemented; no in-app inbox, no digest logic, no quota handling.

## Execution Flows (current)
- No end-to-end notification flow; only the `NotificationEntity` data class is present.

## Test & Verification
- Automated: none for notifications.  
  Suggested baseline:
  ```bash
  flutter test test/features/workspace/
  ```
  (no notification coverage; add dedicated tests when implemented).
- Manual: Not applicable yet (feature missing).

## Recommended Follow-Ups
- Add NotificationService integrating FCM: register token/deviceId on login/refresh; store per-user/workspace; revoke on logout.
- Implement topic/group or per-channel preferences (task, mentions, workspace changes) with DND/quiet hours.
- Add push triggers for task/project/workspace events with retry/backoff and invalid-token cleanup.
- Build in-app notification center with read/unread state and digest mode; log deliveries and expose metrics/quota alerts.
