# Account Lock/Unlock Management - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Account Lock/Unlock Management** feature. Currently, this feature is **PARTIAL** - `User.isActive` field exists, but no controller/service UI to toggle lock/unlock, and no enforcement paths observed (locked users can still log in).

## Current Status: ⚠️ PARTIAL

### What Exists:
- ✅ `User.isActive` field exists in User entity
- ✅ `isActive` is displayed in Profile page (shows "Active" or "Inactive")
- ✅ `isActive` is serialized in `toMap` and `fromMap` methods

### What's Missing/Broken:
- ⚠️ No controller/service to toggle lock/unlock
- ⚠️ No UI for account lock/unlock management
- ⛔ No enforcement in login flow (locked users can still log in)
- ⛔ No enforcement in data access (locked users can still access data)
- ⛔ No permission checks for lock/unlock operations
- ⛔ No self-lock prevention
- ⛔ No Account Holder protection

---

## Task List

### Task 1: Add Lock/Unlock Methods to AuthController

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add methods to `AuthController` for locking and unlocking user accounts.

**Files to Modify**:
- `lib/features/auth/presentation/controllers/auth_controller.dart`

**Implementation Steps**:
1. Add `lockUserAccount` method:
   ```dart
   Future<void> lockUserAccount(String userId, {String? reason}) async {
     // Permission check
     final canManageUsers = await hasPermission('manage_users');
     if (!canManageUsers) {
       SnackbarService().showError(
         title: AppStrings.I.error,
         message: AppStrings.I.permissionDenied,
       );
       return;
     }
     
     // Prevent self-lock
     if (userId == _currentUser.value?.id) {
       SnackbarService().showError(
         title: AppStrings.I.error,
         message: AppStrings.I.cannotLockOwnAccount,
       );
       return;
     }
     
     // Get user to check if Account Holder
     final user = await _databaseService.getUser(userId);
     if (user == null) {
       SnackbarService().showError(
         title: AppStrings.I.error,
         message: AppStrings.I.userNotFound,
       );
       return;
     }
     
     // Prevent locking Account Holder (if role check exists)
     // TODO: Add Account Holder check when role is bridged
     
     await _executeAsync(() async {
       final updatedUser = user.copyWith(
         isActive: false,
       );
       
       await _databaseService.updateUser(updatedUser);
       
       // Log audit (if audit logging exists)
       // TODO: Add audit logging
       
       SnackbarService().showSuccess(
         title: AppStrings.I.success,
         message: AppStrings.I.accountLockedSuccessfully,
       );
     });
   }
   ```

2. Add `unlockUserAccount` method:
   ```dart
   Future<void> unlockUserAccount(String userId) async {
     // Similar permission and validation checks
     // Set isActive to true
   }
   ```

3. Add permission check helper:
   ```dart
   Future<bool> canManageUserAccounts() async {
     return await hasPermission('manage_users') || isAdmin;
   }
   ```

**Expected Results**:
- ✅ Lock/unlock methods exist in AuthController
- ✅ Permission checks are enforced
- ✅ Self-lock is prevented
- ✅ Success/error handling works

**Test Criteria**:
- Unit test: Test lock/unlock methods
- Test: Verify permission checks work
- Test: Verify self-lock prevention works

---

### Task 2: Add Lock/Unlock Methods to FirebaseDatabaseService

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Ensure `FirebaseDatabaseService.updateUser` properly handles `isActive` field updates.

**Files to Modify**:
- `lib/core/services/firebase_database_service.dart`

**Implementation Steps**:
1. Review `updateUser` method:
   ```dart
   Future<void> updateUser(User user) async {
     try {
       await _usersRef.child(user.id).update({
         'name': user.name,
         'profileImageUrl': user.profileImageUrl,
         'isActive': user.isActive,
         // ... other fields
       });
     } catch (e) {
       throw DatabaseFailure(message: 'Failed to update user: $e');
     }
   }
   ```

2. Ensure `isActive` field is included in update
3. Add optional lock reason field (if implemented):
   ```dart
   Future<void> updateUser(User user, {String? lockReason, DateTime? lockedAt}) async {
     final updates = {
       'name': user.name,
       'profileImageUrl': user.profileImageUrl,
       'isActive': user.isActive,
     };
     
     if (lockReason != null) {
       updates['lockReason'] = lockReason;
     }
     
     if (lockedAt != null) {
       updates['lockedAt'] = lockedAt.millisecondsSinceEpoch;
     }
     
     await _usersRef.child(user.id).update(updates);
   }
   ```

**Expected Results**:
- ✅ `isActive` field is updated in Firebase
- ✅ Lock reason is stored (if implemented)
- ✅ Lock date is stored (if implemented)

**Test Criteria**:
- Integration test: Test with Firebase
- Test: Verify `isActive` is updated correctly

---

### Task 3: Add Login Enforcement for Locked Accounts

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add enforcement in login flow to prevent locked users from logging in.

**Files to Modify**:
- `lib/features/auth/presentation/controllers/auth_controller.dart`

**Implementation Steps**:
1. Update `_handleUserSignIn` method:
   ```dart
   Future<void> _handleUserSignIn(firebase_auth.User firebaseUser) async {
     try {
       isLoading = true;
       
       // Get user data from Firebase Database
       var user = await _databaseService.getUser(firebaseUser.uid);
       
       if (user == null) {
         // Create new user if doesn't exist
         // ... existing logic ...
       } else {
         // Check if account is locked
         if (!user.isActive) {
           isLoading = false;
           await _firebaseAuth.signOut();
           SnackbarService().showError(
             title: AppStrings.I.error,
             message: AppStrings.I.accountLocked,
           );
           await NavigationService().offAllNamed<void>(AppRouter.login);
           return;
         }
         
         // Update last login time
         // ... existing logic ...
       }
       
       // ... rest of login flow ...
     } catch (e) {
       // Handle error
     }
   }
   ```

2. Add check before setting current user
3. Ensure user is signed out if account is locked
4. Show appropriate error message

**Expected Results**:
- ✅ Locked users cannot log in
- ✅ Error message is clear
- ✅ User is redirected to login screen
- ✅ No user data is loaded for locked accounts

**Test Criteria**:
- Test: Lock user, verify login is blocked
- Test: Unlock user, verify login works
- Test: Verify error message is shown

---

### Task 4: Add Data Access Enforcement for Locked Accounts

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add enforcement to prevent locked users from accessing data even if already logged in.

**Files to Modify**:
- `lib/features/auth/presentation/controllers/auth_controller.dart`
- `lib/core/services/firebase_database_service.dart` (optional - add checks in queries)

**Implementation Steps**:
1. Add periodic check in AuthController:
   ```dart
   void _setupAccountStatusListener() {
     // Check account status periodically
     Timer.periodic(Duration(minutes: 1), (timer) async {
       if (_currentUser.value != null) {
         final user = await _databaseService.getUser(_currentUser.value!.id);
         if (user != null && !user.isActive) {
           // Account was locked, sign out
           await signOut();
           SnackbarService().showError(
             title: AppStrings.I.error,
             message: AppStrings.I.accountLocked,
           );
           await NavigationService().offAllNamed<void>(AppRouter.login);
           timer.cancel();
         }
       }
     });
   }
   ```

2. Add check before data operations:
   ```dart
   Future<T> _checkAccountStatus<T>(Future<T> Function() operation) async {
     if (_currentUser.value != null && !_currentUser.value!.isActive) {
       await signOut();
       throw AuthenticationFailure(message: AppStrings.I.accountLocked);
     }
     return await operation();
   }
   ```

3. Wrap data operations with status check (optional - can be done at service level)

**Expected Results**:
- ✅ Locked users are logged out automatically
- ✅ Data access is blocked for locked users
- ✅ User is redirected to login screen

**Test Criteria**:
- Test: Lock user while logged in, verify logout
- Test: Verify data access is blocked
- Test: Verify periodic check works

---

### Task 5: Add Lock/Unlock UI to User Management Page

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add UI for locking/unlocking user accounts in User Management page.

**Files to Modify**:
- `lib/app/pages/users/user_management_page.dart`
- `lib/app/pages/users/controllers/user_management_controller.dart`

**Implementation Steps**:
1. Add lock/unlock methods to `UserManagementController`:
   ```dart
   Future<void> lockUserAccount(String userId, {String? reason}) async {
     final authController = Get.find<AuthController>();
     await authController.lockUserAccount(userId, reason: reason);
     await refreshData();
   }
   
   Future<void> unlockUserAccount(String userId) async {
     final authController = Get.find<AuthController>();
     await authController.unlockUserAccount(userId);
     await refreshData();
   }
   ```

2. Add lock/unlock options to member card:
   ```dart
   PopupMenuButton<String>(
     onSelected: (action) {
       if (action == 'lock') {
         _showLockAccountDialog(context, member, controller);
       } else if (action == 'unlock') {
         _showUnlockAccountDialog(context, member, controller);
       }
     },
     itemBuilder: (context) => [
       if (member.isActive)
         PopupMenuItem(
           value: 'lock',
           child: Row(
             children: [
               Icon(Icons.lock, size: 20),
               SizedBox(width: 8),
               Text(AppStrings.lockAccount),
             ],
           ),
         )
       else
         PopupMenuItem(
           value: 'unlock',
           child: Row(
             children: [
               Icon(Icons.lock_open, size: 20),
               SizedBox(width: 8),
               Text(AppStrings.unlockAccount),
             ],
           ),
         ),
     ],
   ),
   ```

3. Add lock confirmation dialog:
   ```dart
   void _showLockAccountDialog(BuildContext context, WorkspaceMember member, UserManagementController controller) {
     showDialog(
       context: context,
       builder: (context) => AlertDialog(
         title: Text(AppStrings.lockAccount),
         content: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             Text(AppStrings.lockAccountConfirmation),
             SizedBox(height: 16),
             // Optional: Add reason field
             TDTextField(
               controller: _lockReasonController,
               label: AppStrings.I.reason,
               hint: AppStrings.I.enterLockReason,
               maxLines: 3,
             ),
           ],
         ),
         actions: [
           TextButton(
             onPressed: () => Navigator.of(context).pop(),
             child: Text(AppStrings.cancel),
           ),
           TDButton(
             text: AppStrings.I.lock,
             onPressed: () async {
               await controller.lockUserAccount(
                 member.userId,
                 reason: _lockReasonController.text.trim().isEmpty 
                     ? null 
                     : _lockReasonController.text.trim(),
               );
               Navigator.of(context).pop();
             },
           ),
         ],
       ),
     );
   }
   ```

4. Add unlock confirmation dialog (simpler, no reason needed)

5. Show account status in member card:
   - Display "Active" or "Locked" badge
   - Use color coding (green for active, red for locked)

**Expected Results**:
- ✅ Lock/unlock UI exists
- ✅ Confirmation dialogs are shown
- ✅ Account status is displayed
- ✅ UI follows project rules (TD widgets, AppStrings)

**Test Criteria**:
- Manual test: Lock/unlock account, verify UI works
- Test: Verify permission checks work
- Test: Verify status display works

---

### Task 6: Add Account Status Badge/Indicator

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add visual indicators for account status throughout the app.

**Files to Modify**:
- `lib/app/pages/users/user_management_page.dart`
- `lib/app/pages/profile/profile_page.dart`
- `lib/features/workspace/presentation/widgets/member_card.dart` (if exists)

**Implementation Steps**:
1. Create status badge widget:
   ```dart
   Widget _buildAccountStatusBadge(bool isActive) {
     return Container(
       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
       decoration: BoxDecoration(
         color: isActive ? Colors.green : Colors.red,
         borderRadius: BorderRadius.circular(12),
       ),
       child: Text(
         isActive ? AppStrings.I.active : AppStrings.I.locked,
         style: TextStyle(
           color: Colors.white,
           fontSize: 12,
           fontWeight: FontWeight.w600,
         ),
       ),
     );
   }
   ```

2. Add badge to member cards
3. Add badge to profile page
4. Use consistent styling across app

**Expected Results**:
- ✅ Account status is clearly visible
- ✅ Status badges are consistent
- ✅ Color coding is clear

**Test Criteria**:
- Manual test: Verify badges are displayed
- Test: Verify status updates in real-time

---

### Task 7: Add Account Holder Protection

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Prevent Account Holder accounts from being locked.

**Files to Modify**:
- `lib/features/auth/presentation/controllers/auth_controller.dart`
- `lib/app/pages/users/user_management_page.dart`

**Implementation Steps**:
1. Add Account Holder check in `lockUserAccount`:
   ```dart
   // Check if user is Account Holder
   // This requires checking workspace membership
   final workspaceController = Get.find<WorkspaceController>();
   final currentWorkspace = workspaceController.currentWorkspace.value;
   if (currentWorkspace != null) {
     final member = await workspaceController.getWorkspaceMember(userId);
     if (member != null && member.isAccountHolder) {
       SnackbarService().showError(
         title: AppStrings.I.error,
         message: AppStrings.I.cannotLockAccountHolder,
       );
       return;
     }
   }
   ```

2. Hide lock option for Account Holder in UI:
   ```dart
   if (member.isAccountHolder) {
     // Don't show lock option
     return;
   }
   ```

3. Add validation in unlock (shouldn't be needed, but good to have)

**Expected Results**:
- ✅ Account Holder accounts cannot be locked
- ✅ Lock option is hidden for Account Holder
- ✅ Error message is clear if attempted

**Test Criteria**:
- Test: Try to lock Account Holder, verify prevention
- Test: Verify lock option is hidden for Account Holder

---

### Task 8: Add Lock Reason Field (Optional)

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add optional reason field when locking account.

**Files to Modify**:
- `lib/features/auth/domain/entities/user.dart`
- `lib/features/auth/presentation/controllers/auth_controller.dart`
- `lib/app/pages/users/user_management_page.dart`

**Implementation Steps**:
1. Add `lockReason` and `lockedAt` fields to User entity:
   ```dart
   final String? lockReason;
   final DateTime? lockedAt;
   ```

2. Update serialization methods
3. Add reason field to lock dialog
4. Save reason when locking account

**Expected Results**:
- ✅ Lock reason can be provided
- ✅ Reason is stored in Firebase
- ✅ Reason is displayed in account details

**Test Criteria**:
- Test: Lock account with reason, verify storage
- Test: View account details, verify reason is displayed

**Note**: This is optional but recommended for audit purposes.

---

### Task 9: Add Filter by Account Status

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add filter to show only active or locked users.

**Files to Modify**:
- `lib/app/pages/users/user_management_page.dart`
- `lib/app/pages/users/controllers/user_management_controller.dart`

**Implementation Steps**:
1. Add filter state to controller:
   ```dart
   final RxString _statusFilter = 'all'.obs; // 'all', 'active', 'locked'
   String get statusFilter => _statusFilter.value;
   
   void setStatusFilter(String filter) {
     _statusFilter.value = filter;
     refreshData();
   }
   ```

2. Filter members by status:
   ```dart
   List<WorkspaceMember> get filteredMembers {
     final members = workspaceMembers;
     if (_statusFilter.value == 'all') return members;
     if (_statusFilter.value == 'active') {
       return members.where((m) => m.isActive).toList();
     }
     if (_statusFilter.value == 'locked') {
       return members.where((m) => !m.isActive).toList();
     }
     return members;
   }
   ```

3. Add filter UI (dropdown or chips)

**Expected Results**:
- ✅ Users can be filtered by status
- ✅ Filter works correctly
- ✅ Filter UI is clear

**Test Criteria**:
- Manual test: Filter by status, verify results
- Test: Verify filter works with other filters

---

### Task 10: Add AppStrings for Account Lock/Unlock

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add AppStrings constants for account lock/unlock messages.

**Files to Modify**:
- `lib/core/constants/app_strings.dart`

**Implementation Steps**:
1. Add lock/unlock strings:
   ```dart
   static const String lockAccount = 'Lock Account';
   static const String unlockAccount = 'Unlock Account';
   static const String accountLocked = 'Your account has been locked. Please contact your administrator.';
   static const String accountLockedSuccessfully = 'Account locked successfully';
   static const String accountUnlockedSuccessfully = 'Account unlocked successfully';
   static const String lockAccountConfirmation = 'Are you sure you want to lock this account?';
   static const String unlockAccountConfirmation = 'Are you sure you want to unlock this account?';
   static const String cannotLockOwnAccount = 'You cannot lock your own account';
   static const String cannotLockAccountHolder = 'Account Holder account cannot be locked';
   static const String enterLockReason = 'Enter reason for locking account';
   static const String reason = 'Reason';
   static const String locked = 'Locked';
   static const String active = 'Active';
   static const String inactive = 'Inactive';
   // ... other strings
   ```

2. Ensure all user-facing text uses AppStrings

**Expected Results**:
- ✅ All lock/unlock strings are in AppStrings
- ✅ No hardcoded strings in UI

**Test Criteria**:
- Test: Verify all strings use AppStrings
- Test: Verify no hardcoded strings

---

### Task 11: Add Unit Tests for Account Lock/Unlock

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for account lock/unlock functionality.

**Files to Create/Modify**:
- `test/features/auth/presentation/controllers/auth_controller_test.dart`
- `test/core/services/firebase_database_service_test.dart`

**Implementation Steps**:
1. Test `lockUserAccount`:
   - Test successful lock
   - Test permission check
   - Test self-lock prevention
   - Test Account Holder protection
   - Test error handling

2. Test `unlockUserAccount`:
   - Test successful unlock
   - Test permission check
   - Test error handling

3. Test login enforcement:
   - Test locked user cannot log in
   - Test unlocked user can log in
   - Test error message

4. Test data access enforcement:
   - Test locked user is logged out
   - Test data access is blocked

**Expected Results**:
- ✅ Unit tests cover lock/unlock functionality
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Add Lock/Unlock Methods to AuthController (Critical - Core Feature)
2. **Task 2**: Add Lock/Unlock Methods to FirebaseDatabaseService (Critical - Data Layer)
3. **Task 3**: Add Login Enforcement for Locked Accounts (High Priority - Security)
4. **Task 4**: Add Data Access Enforcement for Locked Accounts (High Priority - Security)
5. **Task 5**: Add Lock/Unlock UI to User Management Page (High Priority - UI)
6. **Task 7**: Add Account Holder Protection (High Priority - Security)
7. **Task 6**: Add Account Status Badge/Indicator (Medium Priority - UX)
8. **Task 10**: Add AppStrings (Medium Priority - Code Quality)
9. **Task 8**: Add Lock Reason Field (Low Priority - Feature Enhancement)
10. **Task 9**: Add Filter by Account Status (Low Priority - UX Enhancement)
11. **Task 11**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ Lock/unlock methods exist in AuthController
- ✅ Permission checks are enforced
- ✅ Self-lock is prevented
- ✅ Account Holder protection works
- ✅ Login enforcement works (locked users cannot log in)
- ✅ Data access enforcement works (locked users are logged out)
- ✅ Lock/unlock UI exists
- ✅ Account status is displayed correctly
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, GetX)
- ✅ No known bugs or issues

---

## Dependencies

- **AuthController**: Must support lock/unlock operations
- **FirebaseDatabaseService**: Must update `isActive` field
- **WorkspaceController**: Required for Account Holder check
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **NavigationService**: Must use NavigationService for navigation
- **SnackbarService**: Must use SnackbarService for notifications

---

## Notes

1. **Enforcement Priority**: Login enforcement is critical - locked users should not be able to log in. This should be implemented first.

2. **Self-Lock Prevention**: Users should not be able to lock their own accounts to prevent accidental self-lockout.

3. **Account Holder Protection**: Account Holder accounts should not be lockable to prevent workspace lockout. If Account Holder needs to be locked, ownership transfer should happen first.

4. **Data Access Enforcement**: If a user is locked while logged in, they should be logged out immediately. Periodic checks can help catch this.

5. **Permission**: Only Account Holder/Admin should be able to lock/unlock accounts. This should be checked both in controller and UI.

6. **Audit Logging**: Lock/unlock operations should be logged for compliance (if audit logging is implemented).

7. **Notifications**: Locked users should be notified (if notification system exists).

8. **Reason Field**: Optional but recommended for audit purposes. Helps track why accounts were locked.

9. **Temporary Lock**: Optional feature for temporary suspensions with auto-unlock.

10. **Bulk Operations**: Optional feature for locking multiple accounts at once.

---

## Related Documentation

- `USER_MANAGEMENT_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `ACCOUNT_LOCK_UNLOCK_TEST_CASES.md` - Test cases for this feature
- `docs/v1/feature_checklists/workspace/WORKSPACE_USER_MANAGEMENT_TEST_CASES.md` - Related user management tests
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
- `rules/ARCHITECTURE_RULES.md` - Architecture requirements
- `rules/SECURITY_RULES.md` - Security requirements

