# Transfer Ownership When Account Holder Leaves - Task List & Expected Results

## Overview
This document lists all tasks required to implement the **Transfer Ownership When Account Holder Leaves** feature. Currently, this feature is **MISSING** - not implemented; no use case/controller/UI flow exists. This is specifically about the scenario where Account Holder wants to leave the workspace and must transfer ownership before leaving.

## Current Status: ⛔ MISSING

### What Exists (Related):
- ✅ `WorkspaceRole` enum has `accountHolder` role
- ✅ `WorkspaceMember` has `isAccountHolder` getter
- ✅ `WorkspaceController` has role management methods
- ✅ `WorkspaceRepository` supports member operations
- ✅ Permission system exists
- ✅ General transfer ownership feature is documented in workspace checklists (but not implemented)

### What's Missing/Broken:
- ⛔ No check to prevent Account Holder from leaving without transferring ownership
- ⛔ No flow to transfer ownership when Account Holder wants to leave
- ⛔ No warning/blocking when Account Holder tries to leave
- ⛔ No check for eligible users before allowing Account Holder to leave
- ⛔ No integration between leave workspace and transfer ownership flows
- ⛔ No notification to new Account Holder when previous Account Holder leaves

---

## Task List

### Task 1: Add Account Holder Leave Protection Check

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add check to prevent Account Holder from leaving workspace without transferring ownership first.

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`
- `lib/app/pages/workspace/workspace_settings_page.dart` (or wherever leave workspace is implemented)

**Implementation Steps**:
1. Update `removeUserFromWorkspace` or `leaveWorkspace` method:
   ```dart
   Future<void> leaveWorkspace() async {
     // Get current user's role in workspace
     final currentUserRole = await getUserWorkspaceRole();
     
     // Check if user is Account Holder
     if (currentUserRole?.isAccountHolder ?? false) {
       // Check if there are eligible users to transfer ownership to
       final eligibleUsers = _workspaceMembers.where((m) => 
         !m.isAccountHolder && m.isActive
       ).toList();
       
       if (eligibleUsers.isEmpty) {
         // No eligible users - cannot leave
         SnackbarService().showError(
           title: AppStrings.I.error,
           message: AppStrings.I.cannotLeaveNoEligibleUsers,
         );
         return;
       }
       
       // Account Holder must transfer ownership first
       SnackbarService().showWarning(
         title: AppStrings.I.warning,
         message: AppStrings.I.mustTransferOwnershipBeforeLeaving,
       );
       
       // Navigate to transfer ownership page with leave context
       await NavigationService().toNamed<void>(
         AppRoutes.transferOwnership,
         arguments: {'leaveAfterTransfer': true},
       );
       return;
     }
     
     // Non-Account Holder can leave normally
     // ... existing leave workspace code ...
   }
   ```

2. Add AppStrings:
   ```dart
   static const String cannotLeaveNoEligibleUsers = 'You cannot leave the workspace. You are the Account Holder and there are no eligible users to transfer ownership to. Please add at least one Admin or Member first.';
   static const String mustTransferOwnershipBeforeLeaving = 'You are the Account Holder. You must transfer ownership before leaving the workspace.';
   ```

3. Add validation for last member:
   - Check if Account Holder is the last member
   - Prevent leaving if last member

**Expected Results**:
- ✅ Account Holder cannot leave without transferring ownership
- ✅ Warning message appears when Account Holder tries to leave
- ✅ Account Holder is redirected to transfer ownership
- ✅ Error message appears if no eligible users exist

**Test Criteria**:
- Test: Try to leave as Account Holder, verify warning appears
- Test: Verify cannot leave without transferring ownership
- Test: Verify error message if no eligible users

---

### Task 2: Create Leave Workspace with Transfer Flow

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create integrated flow where Account Holder can transfer ownership and leave workspace in one flow.

**Files to Create/Modify**:
- `lib/features/workspace/presentation/pages/transfer_ownership_page.dart` (modify or create)
- `lib/features/workspace/presentation/controllers/transfer_ownership_controller.dart` (modify or create)

**Implementation Steps**:
1. Update `TransferOwnershipPage` to support leave context:
   ```dart
   class TransferOwnershipPage extends StatelessWidget {
     final bool leaveAfterTransfer;
     
     const TransferOwnershipPage({
       super.key,
       this.leaveAfterTransfer = false,
     });
     
     @override
     Widget build(BuildContext context) {
       return Scaffold(
         appBar: TDAppBar(
           title: AppStrings.I.transferOwnership,
         ),
         body: Column(
           children: [
             // Show leave context warning if applicable
             if (leaveAfterTransfer)
               TDCard(
                 type: TDCardType.warning,
                 child: Column(
                   children: [
                     Text(AppStrings.leavingWorkspaceAfterTransfer),
                     Text(AppStrings.transferOwnershipToLeave),
                   ],
                 ),
               ),
             // ... rest of transfer ownership UI ...
           ],
         ),
       );
     }
   }
   ```

2. Update `TransferOwnershipController`:
   ```dart
   class TransferOwnershipController extends GetxController {
     final bool leaveAfterTransfer;
     
     TransferOwnershipController({this.leaveAfterTransfer = false});
     
     Future<void> transferOwnership(String targetUserId) async {
       // ... existing transfer code ...
       
       // If leaveAfterTransfer is true, leave workspace after transfer
       if (leaveAfterTransfer) {
         await _workspaceController.leaveWorkspace();
       }
     }
   }
   ```

3. Add AppStrings:
   ```dart
   static const String leavingWorkspaceAfterTransfer = 'You are leaving the workspace. Please transfer ownership first.';
   static const String transferOwnershipToLeave = 'After transferring ownership, you will be removed from the workspace.';
   ```

**Expected Results**:
- ✅ Transfer ownership page shows leave context
- ✅ Account Holder can transfer ownership and leave in one flow
- ✅ Warning messages are clear

**Test Criteria**:
- Manual test: Transfer ownership with leave context
- Test: Verify leave happens after transfer
- Test: Verify warning messages are shown

---

### Task 3: Add Eligible Users Check

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add check to ensure there are eligible users (Admin or Member) before allowing Account Holder to leave.

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`

**Implementation Steps**:
1. Add method to check eligible users:
   ```dart
   bool hasEligibleUsersForTransfer() {
     return _workspaceMembers.any((m) => 
       !m.isAccountHolder && m.isActive
     );
   }
   
   List<WorkspaceMember> getEligibleUsersForTransfer() {
     return _workspaceMembers.where((m) => 
       !m.isAccountHolder && m.isActive
     ).toList();
   }
   ```

2. Update `leaveWorkspace` method to use this check:
   ```dart
   Future<void> leaveWorkspace() async {
     final currentUserRole = await getUserWorkspaceRole();
     
     if (currentUserRole?.isAccountHolder ?? false) {
       if (!hasEligibleUsersForTransfer()) {
         SnackbarService().showError(
           title: AppStrings.I.error,
           message: AppStrings.I.cannotLeaveNoEligibleUsers,
         );
         return;
       }
       // ... redirect to transfer ownership ...
     }
   }
   ```

3. Add validation in transfer ownership page:
   - Check eligible users before showing transfer options
   - Show error if no eligible users

**Expected Results**:
- ✅ Eligible users check exists
- ✅ Account Holder cannot leave if no eligible users
- ✅ Error message is clear

**Test Criteria**:
- Test: Try to leave as Account Holder with no eligible users
- Test: Verify error message appears
- Test: Verify cannot proceed

---

### Task 4: Add Last Member Protection

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add check to prevent Account Holder from leaving if they are the last member of the workspace.

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`

**Implementation Steps**:
1. Add method to check if user is last member:
   ```dart
   bool isLastMember(String userId) {
     final activeMembers = _workspaceMembers.where((m) => m.isActive).toList();
     return activeMembers.length == 1 && activeMembers.first.userId == userId;
   }
   ```

2. Update `leaveWorkspace` method:
   ```dart
   Future<void> leaveWorkspace() async {
     final currentUserId = _authController.currentUser?.id;
     if (currentUserId == null) return;
     
     // Check if last member
     if (isLastMember(currentUserId)) {
       SnackbarService().showError(
         title: AppStrings.I.error,
         message: AppStrings.I.cannotLeaveLastMember,
       );
       return;
     }
     
     // ... rest of leave logic ...
   }
   ```

3. Add AppStrings:
   ```dart
   static const String cannotLeaveLastMember = 'You are the only member of this workspace. You cannot leave. Please add at least one member first, or delete the workspace.';
   ```

**Expected Results**:
- ✅ Last member protection exists
- ✅ Account Holder cannot leave if they are the last member
- ✅ Error message is clear

**Test Criteria**:
- Test: Try to leave as last member
- Test: Verify error message appears
- Test: Verify cannot proceed

---

### Task 5: Integrate Transfer Ownership with Leave Workspace

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Integrate transfer ownership flow with leave workspace flow so Account Holder can transfer and leave seamlessly.

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`
- `lib/features/workspace/presentation/pages/transfer_ownership_page.dart`

**Implementation Steps**:
1. Update `transferOwnership` method to support leave after transfer:
   ```dart
   Future<void> transferOwnership(
     String targetUserId, {
     String? confirmationText,
     bool leaveAfterTransfer = false,
   }) async {
     // ... existing transfer code ...
     
     // After successful transfer
     if (leaveAfterTransfer) {
       // Leave workspace
       await removeUserFromWorkspace(_userId);
     }
   }
   ```

2. Update transfer ownership page to handle leave context:
   - Show "Transfer Ownership and Leave" option if `leaveAfterTransfer` is true
   - Show warning about leaving after transfer
   - Handle leave after transfer completion

3. Add navigation from leave warning:
   ```dart
   // In leaveWorkspace method
   await NavigationService().toNamed<void>(
     AppRoutes.transferOwnership,
     arguments: {'leaveAfterTransfer': true},
   );
   ```

**Expected Results**:
- ✅ Transfer ownership and leave are integrated
- ✅ Account Holder can transfer and leave in one flow
- ✅ Flow is seamless

**Test Criteria**:
- Test: Transfer ownership with leave context
- Test: Verify leave happens after transfer
- Test: Verify flow is seamless

---

### Task 6: Add Notification to New Account Holder When Previous Leaves

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Send notification to new Account Holder when previous Account Holder leaves after transferring ownership.

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`
- `lib/core/services/user_management_notification_service.dart` (if exists)

**Implementation Steps**:
1. Update `removeUserFromWorkspace` or `leaveWorkspace` method:
   ```dart
   Future<void> leaveWorkspace() async {
     // ... existing leave code ...
     
     // If leaving Account Holder, notify new Account Holder
     final currentUserRole = await getUserWorkspaceRole();
     if (currentUserRole?.isAccountHolder ?? false) {
       // Get new Account Holder (should have been set during transfer)
       final newAccountHolder = _workspaceMembers.firstWhere(
         (m) => m.isAccountHolder,
       );
       
       // Send notification
       await UserManagementNotificationService().notifyAccountHolderLeft(
         newAccountHolderId: newAccountHolder.userId,
         previousAccountHolderId: _userId,
         workspaceId: _workspaceId,
       );
     }
   }
   ```

2. Add notification method (if notification service exists):
   ```dart
   Future<void> notifyAccountHolderLeft({
     required String newAccountHolderId,
     required String previousAccountHolderId,
     required String workspaceId,
   }) async {
     // Send push notification
     // Send email notification
     // Send in-app notification
   }
   ```

**Expected Results**:
- ✅ New Account Holder is notified when previous Account Holder leaves
- ✅ Notification contains relevant information
- ✅ Notification is sent immediately

**Test Criteria**:
- Test: Transfer ownership and leave
- Test: Verify new Account Holder receives notification
- Test: Verify notification content is correct

---

### Task 7: Add Audit Logging for Leave After Transfer

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add audit logging for Account Holder leaving after transferring ownership (if audit logging exists).

**Files to Modify**:
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`
- `lib/core/services/audit_log_service.dart` (if exists)

**Implementation Steps**:
1. Update `leaveWorkspace` method:
   ```dart
   Future<void> leaveWorkspace() async {
     final currentUserRole = await getUserWorkspaceRole();
     
     // ... existing leave code ...
     
     // Log audit entry if Account Holder
     if (currentUserRole?.isAccountHolder ?? false) {
       await AuditLogService().logAccountHolderLeftAfterTransfer(
         userId: _userId,
         workspaceId: _workspaceId,
         newAccountHolderId: _getNewAccountHolderId(),
       );
     }
   }
   ```

2. Add audit log method (if audit service exists):
   ```dart
   Future<void> logAccountHolderLeftAfterTransfer({
     required String userId,
     required String workspaceId,
     required String newAccountHolderId,
   }) async {
     await _log(
       action: 'account_holder_left_after_transfer',
       userId: userId,
       changedBy: userId,
       workspaceId: workspaceId,
       newValues: {
         'newAccountHolderId': newAccountHolderId,
         'reason': 'Account Holder left after transferring ownership',
       },
     );
   }
   ```

**Expected Results**:
- ✅ Account Holder leaving is logged in audit log
- ✅ Audit log includes new Account Holder information
- ✅ Audit log entries are stored

**Test Criteria**:
- Test: Transfer ownership and leave
- Test: Verify audit log entry is created
- Test: Verify audit log contains correct information

---

### Task 8: Add Workspace Deletion Alternative

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add option for Account Holder to delete workspace instead of transferring ownership (if workspace deletion is implemented).

**Files to Modify**:
- `lib/app/pages/workspace/workspace_settings_page.dart`
- `lib/features/workspace/presentation/controllers/workspace_controller.dart`

**Implementation Steps**:
1. Update leave workspace warning:
   ```dart
   Widget _buildLeaveWorkspaceWarning() {
     return TDCard(
       type: TDCardType.warning,
       child: Column(
         children: [
           Text(AppStrings.mustTransferOwnershipBeforeLeaving),
           SizedBox(height: 16),
           Row(
             children: [
               TDButton(
                 label: AppStrings.I.transferOwnership,
                 onPressed: () => _navigateToTransferOwnership(),
               ),
               SizedBox(width: 8),
               TDButton(
                 label: AppStrings.I.deleteWorkspace,
                 type: TDButtonType.danger,
                 onPressed: () => _showDeleteWorkspaceDialog(),
               ),
             ],
           ),
         ],
       ),
     );
   }
   ```

2. Add delete workspace option (if workspace deletion is implemented)

**Expected Results**:
- ✅ Account Holder can choose to delete workspace
- ✅ Warning about deletion is clear
- ✅ Option is only available to Account Holder

**Test Criteria**:
- Manual test: Verify delete workspace option appears
- Test: Verify deletion works correctly

---

### Task 9: Add Unit Tests for Leave with Transfer

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for Account Holder leaving with transfer ownership flow.

**Files to Create**:
- `test/features/workspace/presentation/controllers/workspace_controller_leave_test.dart`

**Implementation Steps**:
1. Test `leaveWorkspace` method:
   - Test Account Holder cannot leave without transferring
   - Test Account Holder can leave after transferring
   - Test error when no eligible users
   - Test error when last member

2. Test eligible users check:
   - Test with eligible users
   - Test without eligible users

3. Test last member protection:
   - Test with multiple members
   - Test with single member

4. Test transfer and leave integration:
   - Test transfer ownership with leave context
   - Test leave happens after transfer

**Expected Results**:
- ✅ Unit tests cover leave with transfer functionality
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Add Account Holder Leave Protection Check (Critical - Security)
2. **Task 3**: Add Eligible Users Check (Critical - Validation)
3. **Task 4**: Add Last Member Protection (Critical - Validation)
4. **Task 2**: Create Leave Workspace with Transfer Flow (High Priority - Core Feature)
5. **Task 5**: Integrate Transfer Ownership with Leave Workspace (High Priority - Integration)
6. **Task 6**: Add Notification to New Account Holder (Medium Priority - UX)
7. **Task 7**: Add Audit Logging for Leave After Transfer (Medium Priority - Governance)
8. **Task 8**: Add Workspace Deletion Alternative (Low Priority - Feature Enhancement)
9. **Task 9**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Account Holder cannot leave without transferring ownership
- ✅ Account Holder can transfer ownership and then leave
- ✅ Account Holder cannot leave if no eligible users exist
- ✅ Account Holder cannot leave if they are the last member
- ✅ Transfer ownership flow is accessible from leave warning
- ✅ New Account Holder is notified when previous Account Holder leaves
- ✅ Account Holder leaving is logged in audit log (if audit logging exists)
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, GetX)
- ✅ No known bugs or issues

---

## Dependencies

- **Transfer Ownership Feature**: Must be implemented first (see `TRANSFER_OWNERSHIP_TASKS.md` in workspace checklists)
- **WorkspaceController**: Required for workspace operations
- **WorkspaceRepository**: Required for member operations
- **NotificationService**: Required for notifications (if implemented)
- **AuditLogService**: Required for audit logging (if implemented)
- **Firebase Realtime Database**: Required for storing workspace data
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **NavigationService**: Must use NavigationService for navigation
- **SnackbarService**: Must use SnackbarService for notifications

---

## Notes

1. **Account Holder Protection**: Account Holder should not be able to leave workspace without transferring ownership first. This is critical for workspace continuity.

2. **Eligible Users**: Account Holder must transfer ownership to an Admin or Member. If no eligible users exist, Account Holder cannot leave.

3. **Last Member Protection**: Account Holder should not be able to leave if they are the last member of the workspace.

4. **Transfer Ownership First**: The general transfer ownership feature should be implemented first (see workspace checklists). This task focuses on integrating it with the leave workspace flow.

5. **Atomic Operations**: Ideally, transfer ownership and leave workspace could be done atomically, but this is optional. Current flow may require two separate steps.

6. **Workspace Deletion Alternative**: As an alternative to transferring ownership, Account Holder might be able to delete the workspace instead (if workspace deletion is implemented).

7. **Notifications**: When Account Holder leaves after transferring ownership, the new Account Holder should be notified.

8. **Audit Logging**: When audit logging is implemented, both ownership transfer and Account Holder leaving should be logged.

9. **Related Documentation**: General transfer ownership is documented in workspace checklists (`TRANSFER_OWNERSHIP_TEST_CASES.md`, `TRANSFER_OWNERSHIP_TASKS.md`). This document focuses on the specific "transfer when leaving" scenario.

---

## Related Documentation

- `USER_MANAGEMENT_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `TRANSFER_OWNERSHIP_ON_LEAVE_TEST_CASES.md` - Test cases for this feature
- `docs/v1/feature_checklists/workspace/TRANSFER_OWNERSHIP_TEST_CASES.md` - General transfer ownership test cases
- `docs/v1/feature_checklists/workspace/TRANSFER_OWNERSHIP_TASKS.md` - General transfer ownership tasks
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
- `rules/ARCHITECTURE_RULES.md` - Architecture requirements
- `rules/SECURITY_RULES.md` - Security requirements

