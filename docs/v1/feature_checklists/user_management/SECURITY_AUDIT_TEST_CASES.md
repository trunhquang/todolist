# Security & Audit (Audit Log, Notifications, Confirmations) - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Security & Audit** feature (audit log for role/avatar/email changes, notifications when adding/removing from workspace/team, confirmation when demoting/removing user). This feature is currently **MISSING** - no audit log system, no notification hooks for add/remove/role changes, and no confirmation flows for demotion/removal.

## Prerequisites
- User must be logged in
- User should have Account Holder or Admin role (for user management)
- Workspace should have multiple members
- Teams/Groups should exist (if testing team-related features)
- Device should have internet connection (for Firebase sync)
- Email/push notification services should be configured (if testing notifications)

---

## Test Case 1: Audit Log - Role Change

**Objective**: Verify role changes are logged in audit log (currently missing).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B exists (Member role)
- Audit logging feature is implemented

**Steps**:
1. Navigate to User Management screen
2. Change User B's role:
   - Select User B
   - Tap "Edit Role" or similar option
   - Change role from Member to Admin
   - Confirm change
3. Verify role change is successful
4. Navigate to Audit Log screen (if implemented)
5. Verify one of the following:
   - **If NOT implemented**: Audit log is not available (this is expected - feature missing)
   - **If implemented**: Audit log entry is created
6. If implemented:
   - Verify audit log entry:
     - Action: "role_changed" or "user_role_updated"
     - User: User B's ID/name (target user)
     - Old role: Member
     - New role: Admin
     - Changed by: User A's ID/name (who made the change)
     - Workspace: Workspace ID/name
     - Timestamp: Current date/time
   - Verify audit log entry is stored in Firebase
   - Verify audit log entry is not editable
7. Change role back to Member
8. Verify another audit log entry is created

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Audit logging for role changes is NOT available (missing)
- ✅ **When implemented**: Role changes are logged
- ✅ Audit log includes old and new roles
- ✅ Audit log includes who made the change
- ✅ Audit log entries are stored in Firebase

---

## Test Case 2: Audit Log - Avatar Change

**Objective**: Verify avatar changes are logged in audit log (currently missing).

**Preconditions**:
- User A is logged in
- User A has permission to change own avatar
- Audit logging feature is implemented

**Steps**:
1. Navigate to Profile page
2. Change avatar:
   - Tap "Edit Profile" or avatar
   - Select new avatar image
   - Upload/save avatar
3. Verify avatar change is successful
4. Navigate to Audit Log screen (if implemented)
5. Verify one of the following:
   - **If NOT implemented**: Audit log is not available (this is expected - feature missing)
   - **If implemented**: Audit log entry is created
6. If implemented:
   - Verify audit log entry:
     - Action: "avatar_changed" or "profile_avatar_updated"
     - User: User A's ID/name (who changed avatar)
     - Changed by: User A's ID/name (self-change)
     - Workspace: Workspace ID/name (if applicable)
     - Timestamp: Current date/time
   - Verify audit log entry is stored in Firebase
7. Change avatar again
8. Verify another audit log entry is created

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Audit logging for avatar changes is NOT available (missing)
- ✅ **When implemented**: Avatar changes are logged
- ✅ Audit log includes who changed the avatar
- ✅ Audit log entries are stored in Firebase

---

## Test Case 3: Audit Log - Email Change

**Objective**: Verify email changes are logged in audit log (currently missing).

**Preconditions**:
- User A is logged in
- User A has permission to change email
- Audit logging feature is implemented

**Steps**:
1. Navigate to Profile or Settings page
2. Change email:
   - Tap "Edit Email" or similar option
   - Enter new email address
   - Verify email (if required)
   - Save changes
3. Verify email change is successful
4. Navigate to Audit Log screen (if implemented)
5. Verify one of the following:
   - **If NOT implemented**: Audit log is not available (this is expected - feature missing)
   - **If implemented**: Audit log entry is created
6. If implemented:
   - Verify audit log entry:
     - Action: "email_changed" or "user_email_updated"
     - User: User A's ID/name (who changed email)
     - Old email: Previous email address (if logged)
     - New email: New email address
     - Changed by: User A's ID/name (self-change)
     - Workspace: Workspace ID/name (if applicable)
     - Timestamp: Current date/time
   - Verify audit log entry is stored in Firebase
   - Verify old email is logged (for security purposes)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Audit logging for email changes is NOT available (missing)
- ✅ **When implemented**: Email changes are logged
- ✅ Audit log includes old and new email addresses
- ✅ Audit log entries are stored in Firebase

---

## Test Case 4: Notification - User Added to Workspace

**Objective**: Verify notification is sent when user is added to workspace (currently missing).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B exists (not in workspace)
- Notification feature is implemented

**Steps**:
1. Navigate to User Management screen
2. Add User B to workspace:
   - Tap "Invite User" or "Add Member"
   - Enter User B's email
   - Select role (e.g., Member)
   - Send invitation or add directly
3. Verify User B is added to workspace
4. Verify one of the following:
   - **If NOT implemented**: No notification is sent (this is expected - feature missing)
   - **If implemented**: Notification is sent
5. If implemented:
   - Verify User B receives notification:
     - Email notification (if email notifications exist)
     - Push notification (if push notifications exist)
     - In-app notification (if in-app notifications exist)
   - Verify notification contains:
     - Workspace name
     - Role assigned
     - Inviter name (User A)
     - Action required (if invitation needs acceptance)
   - Verify notification is sent immediately
6. Check notification settings:
   - Verify notification preferences are respected
   - Verify user can opt out (if supported)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Notifications for user addition are NOT available (missing)
- ✅ **When implemented**: Notification is sent when user is added
- ✅ Notification contains relevant information
- ✅ Notification is sent immediately

---

## Test Case 5: Notification - User Removed from Workspace

**Objective**: Verify notification is sent when user is removed from workspace (currently missing).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B is member of workspace
- Notification feature is implemented

**Steps**:
1. Navigate to User Management screen
2. Remove User B from workspace:
   - Select User B
   - Tap "Remove" or "Remove from Workspace"
   - Confirm removal
3. Verify User B is removed from workspace
4. Verify one of the following:
   - **If NOT implemented**: No notification is sent (this is expected - feature missing)
   - **If implemented**: Notification is sent
5. If implemented:
   - Verify User B receives notification:
     - Email notification
     - Push notification
     - In-app notification
   - Verify notification contains:
     - Workspace name
     - Remover name (User A)
     - Reason for removal (if provided)
     - Effective date/time
   - Verify notification is sent immediately
6. Verify User B cannot access workspace after removal

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Notifications for user removal are NOT available (missing)
- ✅ **When implemented**: Notification is sent when user is removed
- ✅ Notification contains relevant information
- ✅ User cannot access workspace after removal

---

## Test Case 6: Notification - User Added to Team

**Objective**: Verify notification is sent when user is added to team (currently missing).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B exists (not in team)
- Team A exists
- Notification feature is implemented

**Steps**:
1. Navigate to Team Management or Team Detail page
2. Add User B to Team A:
   - Select Team A
   - Tap "Add Member" or "Add User"
   - Select User B
   - Confirm addition
3. Verify User B is added to Team A
4. Verify one of the following:
   - **If NOT implemented**: No notification is sent (this is expected - feature missing)
   - **If implemented**: Notification is sent
5. If implemented:
   - Verify User B receives notification:
     - Email notification
     - Push notification
     - In-app notification
   - Verify notification contains:
     - Team name
     - Workspace name
     - Added by (User A)
     - Team lead information
   - Verify notification is sent immediately

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Notifications for team addition are NOT available (missing)
- ✅ **When implemented**: Notification is sent when user is added to team
- ✅ Notification contains relevant information

---

## Test Case 7: Notification - User Removed from Team

**Objective**: Verify notification is sent when user is removed from team (currently missing).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B is member of Team A
- Notification feature is implemented

**Steps**:
1. Navigate to Team Detail page for Team A
2. Remove User B from Team A:
   - Select User B
   - Tap "Remove" or "Remove from Team"
   - Confirm removal
3. Verify User B is removed from Team A
4. Verify one of the following:
   - **If NOT implemented**: No notification is sent (this is expected - feature missing)
   - **If implemented**: Notification is sent
5. If implemented:
   - Verify User B receives notification:
     - Email notification
     - Push notification
     - In-app notification
   - Verify notification contains:
     - Team name
     - Workspace name
     - Removed by (User A)
     - Reason (if provided)
   - Verify notification is sent immediately

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Notifications for team removal are NOT available (missing)
- ✅ **When implemented**: Notification is sent when user is removed from team
- ✅ Notification contains relevant information

---

## Test Case 8: Notification - Role Change

**Objective**: Verify notification is sent when user role is changed (currently missing).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B exists (Member role)
- Notification feature is implemented

**Steps**:
1. Navigate to User Management screen
2. Change User B's role:
   - Select User B
   - Change role from Member to Admin
   - Confirm change
3. Verify role change is successful
4. Verify one of the following:
   - **If NOT implemented**: No notification is sent (this is expected - feature missing)
   - **If implemented**: Notification is sent
5. If implemented:
   - Verify User B receives notification:
     - Email notification
     - Push notification
     - In-app notification
   - Verify notification contains:
     - Old role: Member
     - New role: Admin
     - Changed by: User A
     - Workspace name
     - Effective date/time
   - Verify notification is sent immediately
6. Test role demotion:
   - Change User B's role from Admin to Member
   - Verify notification is sent for demotion
   - Verify notification indicates demotion

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Notifications for role changes are NOT available (missing)
- ✅ **When implemented**: Notification is sent when role is changed
- ✅ Notification includes old and new roles
- ✅ Demotion notifications are clear

---

## Test Case 9: Confirmation - Remove User from Workspace

**Objective**: Verify confirmation dialog appears when removing user from workspace (partially implemented).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B is member of workspace

**Steps**:
1. Navigate to User Management screen
2. Select User B
3. Tap "Remove" or "Remove from Workspace"
4. Verify one of the following:
   - **If NOT implemented**: Confirmation dialog does not appear (this is expected - feature missing)
   - **If implemented**: Confirmation dialog appears
5. If implemented:
   - Verify confirmation dialog:
     - Title: "Remove User" or similar
     - Message: Confirmation message with User B's name
     - Cancel button
     - Remove/Confirm button (red/danger style)
   - Tap Cancel:
     - Verify dialog closes
     - Verify User B is NOT removed
   - Tap Remove/Confirm:
     - Verify User B is removed
     - Verify success message appears
6. Verify confirmation is required (cannot bypass)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Confirmation dialog may exist but may not be comprehensive (partial)
- ✅ **When fully implemented**: Confirmation dialog appears before removal
- ✅ Confirmation cannot be bypassed
- ✅ Dialog is clear and informative

---

## Test Case 10: Confirmation - Demote User Role

**Objective**: Verify confirmation dialog appears when demoting user role (currently missing).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B exists (Admin role)
- Confirmation feature is implemented

**Steps**:
1. Navigate to User Management screen
2. Select User B (Admin)
3. Change role from Admin to Member (demotion)
4. Verify one of the following:
   - **If NOT implemented**: Confirmation dialog does not appear (this is expected - feature missing)
   - **If implemented**: Confirmation dialog appears
5. If implemented:
   - Verify confirmation dialog:
     - Title: "Demote User" or "Change Role" or similar
     - Message: Warning about demotion, impact on permissions
     - Current role: Admin
     - New role: Member
     - Warning about permission loss
     - Cancel button
     - Confirm button (warning/danger style)
   - Tap Cancel:
     - Verify dialog closes
     - Verify role is NOT changed
   - Tap Confirm:
     - Verify role is changed
     - Verify success message appears
6. Test demotion from Account Holder (if possible):
   - Verify stronger confirmation is required
   - Verify Account Holder cannot be demoted (if enforced)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Confirmation for demotion is NOT available (missing)
- ✅ **When implemented**: Confirmation dialog appears before demotion
- ✅ Dialog warns about permission loss
- ✅ Stronger confirmation for Account Holder demotion

---

## Test Case 11: Confirmation - Remove User from Team

**Objective**: Verify confirmation dialog appears when removing user from team (if implemented).

**Preconditions**:
- User A is logged in as Account Holder or Admin
- User B is member of Team A
- Confirmation feature is implemented

**Steps**:
1. Navigate to Team Detail page for Team A
2. Select User B
3. Tap "Remove" or "Remove from Team"
4. Verify one of the following:
   - **If NOT implemented**: Confirmation dialog does not appear (this is expected - feature missing)
   - **If implemented**: Confirmation dialog appears
5. If implemented:
   - Verify confirmation dialog:
     - Title: "Remove User from Team" or similar
     - Message: Confirmation message with User B's name and Team A name
     - Warning about permission loss (if applicable)
     - Cancel button
     - Remove/Confirm button
   - Tap Cancel:
     - Verify dialog closes
     - Verify User B is NOT removed
   - Tap Remove/Confirm:
     - Verify User B is removed
     - Verify success message appears

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Confirmation for team removal may not be implemented (missing)
- ✅ **When implemented**: Confirmation dialog appears before removal
- ✅ Confirmation cannot be bypassed

---

## Test Case 12: Audit Log - View Audit Logs

**Objective**: Verify audit logs can be viewed (if implemented).

**Preconditions**:
- User is logged in
- User has permission to view audit logs (Account Holder/Admin)
- Audit logging feature is implemented
- Some audit log entries exist

**Steps**:
1. Navigate to Audit Log or Security screen
2. Verify one of the following:
   - **If NOT implemented**: Audit Log screen is not available (this is expected - feature missing)
   - **If implemented**: Audit Log screen exists
3. If implemented:
   - Verify audit log list is displayed:
     - List of audit log entries
     - Each entry shows:
       - Action type (role change, avatar change, etc.)
       - User affected
       - Changed by (who made the change)
       - Timestamp
       - Workspace (if applicable)
   - Verify filters are available:
     - Filter by action type
     - Filter by user
     - Filter by date range
     - Filter by workspace
   - Verify pagination works (if many entries)
   - Verify search works (if implemented)
4. Select an audit log entry:
   - Verify details are displayed:
     - Full action details
     - Old values (if applicable)
     - New values (if applicable)
     - IP address (if logged)
     - Device information (if logged)
5. Verify export functionality (if implemented):
   - Export to CSV/PDF
   - Verify export works

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Audit log viewing is NOT available (missing)
- ✅ **When implemented**: Audit logs can be viewed
- ✅ Filters and search work
- ✅ Export works (if implemented)

---

## Test Case 13: Audit Log - Filter Audit Logs

**Objective**: Verify audit logs can be filtered (if implemented).

**Preconditions**:
- User is logged in
- User has permission to view audit logs
- Audit logging feature is implemented
- Multiple audit log entries exist (different types, users, dates)

**Steps**:
1. Navigate to Audit Log screen
2. Verify filter options are available:
   - Filter by action type (role change, avatar change, email change, etc.)
   - Filter by user (who was affected)
   - Filter by changed by (who made the change)
   - Filter by date range
   - Filter by workspace
3. Test each filter:
   - Select "Role Change" filter:
     - Verify only role change entries are displayed
   - Select specific user:
     - Verify only entries for that user are displayed
   - Select date range:
     - Verify only entries in date range are displayed
4. Test combined filters:
   - Filter by action type AND user
   - Filter by date range AND workspace
   - Verify combined filters work correctly
5. Clear filters:
   - Verify all entries are displayed again

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Audit log filtering is NOT available (missing)
- ✅ **When implemented**: Audit logs can be filtered
- ✅ Combined filters work correctly

---

## Test Case 14: Notification Preferences

**Objective**: Verify users can manage notification preferences (if implemented).

**Preconditions**:
- User is logged in
- Notification preferences feature is implemented

**Steps**:
1. Navigate to Settings or Notification Preferences screen
2. Verify one of the following:
   - **If NOT implemented**: Notification preferences are not available (this is expected - feature missing)
   - **If implemented**: Notification preferences screen exists
3. If implemented:
   - Verify notification preferences:
     - Email notifications (on/off)
     - Push notifications (on/off)
     - In-app notifications (on/off)
     - Notification types:
       - Role changes
       - Added to workspace/team
       - Removed from workspace/team
       - Avatar changes
       - Email changes
   - Toggle notification preferences:
     - Disable email notifications
     - Verify email notifications are not sent
     - Enable email notifications
     - Verify email notifications are sent again
4. Verify preferences are saved:
   - Close and reopen settings
   - Verify preferences are persisted

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Notification preferences may not be available (missing)
- ✅ **When implemented**: Users can manage notification preferences
- ✅ Preferences are saved and respected

---

## Test Case 15: Audit Log - Export for Compliance

**Objective**: Verify audit logs can be exported for compliance purposes (if implemented).

**Preconditions**:
- User is logged in
- User has permission to export audit logs (Account Holder/Admin)
- Audit logging feature is implemented
- Audit log entries exist

**Steps**:
1. Navigate to Audit Log screen
2. Verify one of the following:
   - **If NOT implemented**: Export functionality is not available (this is expected - feature missing)
   - **If implemented**: Export button/option is available
3. If implemented:
   - Tap "Export" or "Export to CSV/PDF"
   - Verify export options:
     - Export format (CSV, PDF, JSON)
     - Date range selection
     - Filter selection (export filtered results)
   - Select export options:
     - Select date range
     - Select format (CSV)
     - Export
   - Verify export file is generated:
     - File is downloaded
     - File contains audit log entries
     - File format is correct
   - Verify exported data:
     - All relevant fields are included
     - Data is accurate
     - Timestamps are correct
4. Test PDF export:
   - Export to PDF
   - Verify PDF is generated
   - Verify PDF is formatted correctly

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Audit log export is NOT available (missing)
- ✅ **When implemented**: Audit logs can be exported
- ✅ Export formats work correctly
- ✅ Exported data is accurate

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Role changes are logged (if implemented)
- [ ] Avatar changes are logged (if implemented)
- [ ] Email changes are logged (if implemented)
- [ ] Notifications are sent when user is added to workspace (if implemented)
- [ ] Notifications are sent when user is removed from workspace (if implemented)
- [ ] Notifications are sent when user is added to team (if implemented)
- [ ] Notifications are sent when user is removed from team (if implemented)
- [ ] Notifications are sent when role is changed (if implemented)
- [ ] Confirmation dialog appears when removing user (if implemented)
- [ ] Confirmation dialog appears when demoting user (if implemented)
- [ ] Confirmation dialog appears when removing user from team (if implemented)
- [ ] Audit logs can be viewed (if implemented)
- [ ] Audit logs can be filtered (if implemented)
- [ ] Notification preferences can be managed (if implemented)
- [ ] Audit logs can be exported (if implemented)

---

## Known Issues (Based on Audit Report)

1. **No Audit Log System**:
   - No audit logging for role/avatar/email changes
   - No audit log viewing/export functionality
   - **Status**: ⛔ Missing

2. **No Notification Hooks**:
   - No notifications when user is added/removed from workspace/team
   - No notifications for role changes
   - **Status**: ⛔ Missing

3. **No Confirmation Flows**:
   - No confirmation for demotion (role downgrade)
   - Confirmation for removal may exist but may not be comprehensive
   - **Status**: ⛔ Missing (partial for removal)

4. **Analytics vs Audit Log**:
   - `WorkspaceAnalytics` exists for analytics tracking
   - This is different from audit logging (compliance/security)
   - **Status**: ⚠️ Analytics exists, but audit log is missing

---

## Notes for Testers

1. **Current Status**: Security & audit features are completely missing. No audit log system, no notification hooks, and no confirmation flows for demotion.

2. **Analytics vs Audit Log**: `WorkspaceAnalytics` exists for analytics (tracking events for analytics purposes), but this is different from audit logging (compliance and security tracking). Audit logs need to be immutable and comprehensive.

3. **Confirmation Dialogs**: Some confirmation dialogs may exist (e.g., for removing users), but confirmation for demotion is missing.

4. **Notifications**: No notification system exists for user management events. Need to implement email, push, and in-app notifications.

5. **Audit Log Requirements**: Audit logs should be:
   - Immutable (cannot be edited/deleted)
   - Comprehensive (log all important changes)
   - Searchable and filterable
   - Exportable for compliance

6. **Notification Preferences**: Users should be able to control which notifications they receive.

7. **Compliance**: Audit logs are important for compliance (GDPR, SOC 2, etc.). Need to ensure all sensitive operations are logged.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- User roles (Account Holder, Admin, Member)
- Workspace context
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether it's a known issue or new bug
- Firebase data (if accessible) showing audit logs or notifications
- Whether audit logging is working
- Whether notifications are being sent
- Whether confirmation dialogs appear

