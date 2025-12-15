# Notification Center (In-App Inbox, Read/Unread, Real-Time vs Digest, Quota/Throttle Warnings) - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Notification Center** feature (in-app notification center, read/unread state; real-time vs digest mode; quota/throttle warnings). Currently, this feature is **MISSING** - Not implemented; no in-app inbox, no digest logic, no quota handling.

## Current Status: ⛔ MISSING

### What Exists:
- ✅ `NotificationEntity` exists with `isRead` field
- ✅ Basic notification structure exists
- ✅ `FirebaseDatabaseService.getNotifications()` method exists
- ✅ Navigation TODOs exist but not implemented

### What's Missing/Broken:
- ⛔ No notification center page/UI
- ⛔ No notification center controller
- ⛔ No read/unread state management UI
- ⛔ No real-time updates
- ⛔ No digest mode service
- ⛔ No quota/throttle monitoring
- ⛔ No filtering/search functionality
- ⛔ No pagination for notifications
- ⛔ No delete functionality
- ⛔ No navigation implementation

---

## Task List

### Task 1: Create NotificationCenterController

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create GetX controller for managing notification center state and operations.

**Files to Create**:
- `lib/features/notifications/presentation/controllers/notification_center_controller.dart` (new file)

**Implementation Steps**:
1. Create `NotificationCenterController`:
   ```dart
   class NotificationCenterController extends GetxController {
     final FirebaseDatabaseService _databaseService = Get.find<FirebaseDatabaseService>();
     final StorageService _storageService = Get.find<StorageService>();
     
     final RxList<NotificationEntity> notifications = <NotificationEntity>[].obs;
     final RxInt unreadCount = 0.obs;
     final RxBool isLoading = false.obs;
     final RxString filterStatus = 'all'.obs; // 'all', 'read', 'unread'
     final RxString? filterType = RxString?(null);
     final RxString searchQuery = ''.obs;
     
     @override
     void onInit() {
       super.onInit();
       _setupFirebaseListener();
       loadNotifications();
     }
     
     /// Load notifications from Firebase
     Future<void> loadNotifications() async {
       try {
         isLoading.value = true;
         
         final userId = _storageService.getUserId();
         final workspaceId = _storageService.getWorkspaceId();
         
         if (userId == null || workspaceId == null) return;
         
         final notificationsData = await _databaseService.getNotifications(userId);
         final notificationList = notificationsData
             .map((data) => NotificationEntity.fromMap(data))
             .where((n) => n.data['workspaceId'] == workspaceId) // Filter by workspace
             .toList();
         
         // Sort by date (newest first)
         notificationList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
         
         notifications.value = notificationList;
         _updateUnreadCount();
       } catch (e) {
         SnackbarService().showError(
           title: AppStrings.I.error,
           message: AppStrings.I.failedToLoadNotifications,
         );
       } finally {
         isLoading.value = false;
       }
     }
     
     /// Setup Firebase listener for real-time updates
     void _setupFirebaseListener() {
       final userId = _storageService.getUserId();
       if (userId == null) return;
       
       final ref = _databaseService.database.ref('notifications/$userId');
       ref.onChildAdded.listen((event) {
         final data = Map<String, dynamic>.from(event.snapshot.value as Map);
         final notification = NotificationEntity.fromMap(data);
         
         // Check workspace scope
         final workspaceId = _storageService.getWorkspaceId();
         if (notification.data['workspaceId'] == workspaceId) {
           notifications.insert(0, notification); // Add to top
           _updateUnreadCount();
         }
       });
     }
     
     /// Mark notification as read
     Future<void> markAsRead(String notificationId) async {
       try {
         final userId = _storageService.getUserId();
         if (userId == null) return;
         
         await _databaseService.updateNotificationReadStatus(
           userId: userId,
           notificationId: notificationId,
           isRead: true,
         );
         
         // Update local state
         final index = notifications.indexWhere((n) => n.id == notificationId);
         if (index != -1) {
           notifications[index] = notifications[index].copyWith(isRead: true);
           _updateUnreadCount();
         }
       } catch (e) {
         SnackbarService().showError(
           title: AppStrings.I.error,
           message: AppStrings.I.failedToMarkAsRead,
         );
       }
     }
     
     /// Mark notification as unread
     Future<void> markAsUnread(String notificationId) async {
       try {
         final userId = _storageService.getUserId();
         if (userId == null) return;
         
         await _databaseService.updateNotificationReadStatus(
           userId: userId,
           notificationId: notificationId,
           isRead: false,
         );
         
         // Update local state
         final index = notifications.indexWhere((n) => n.id == notificationId);
         if (index != -1) {
           notifications[index] = notifications[index].copyWith(isRead: false);
           _updateUnreadCount();
         }
       } catch (e) {
         SnackbarService().showError(
           title: AppStrings.I.error,
           message: AppStrings.I.failedToMarkAsUnread,
         );
       }
     }
     
     /// Mark all as read
     Future<void> markAllAsRead() async {
       try {
         final userId = _storageService.getUserId();
         if (userId == null) return;
         
         final unreadNotifications = notifications.where((n) => !n.isRead).toList();
         
         for (final notification in unreadNotifications) {
           await _databaseService.updateNotificationReadStatus(
             userId: userId,
             notificationId: notification.id,
             isRead: true,
           );
         }
         
         // Update local state
         for (var i = 0; i < notifications.length; i++) {
           if (!notifications[i].isRead) {
             notifications[i] = notifications[i].copyWith(isRead: true);
           }
         }
         
         _updateUnreadCount();
       } catch (e) {
         SnackbarService().showError(
           title: AppStrings.I.error,
           message: AppStrings.I.failedToMarkAllAsRead,
         );
       }
     }
     
     /// Delete notification
     Future<void> deleteNotification(String notificationId) async {
       try {
         final userId = _storageService.getUserId();
         if (userId == null) return;
         
         await _databaseService.deleteNotification(
           userId: userId,
           notificationId: notificationId,
         );
         
         // Update local state
         notifications.removeWhere((n) => n.id == notificationId);
         _updateUnreadCount();
       } catch (e) {
         SnackbarService().showError(
           title: AppStrings.I.error,
           message: AppStrings.I.failedToDeleteNotification,
         );
       }
     }
     
     /// Delete all notifications
     Future<void> deleteAllNotifications() async {
       try {
         final userId = _storageService.getUserId();
         if (userId == null) return;
         
         // Show confirmation dialog
         final confirmed = await Get.dialog<bool>(
           TDConfirmDialog(
             title: AppStrings.I.deleteAllNotifications,
             message: AppStrings.I.areYouSureDeleteAllNotifications,
           ),
         );
         
         if (confirmed != true) return;
         
         for (final notification in notifications) {
           await _databaseService.deleteNotification(
             userId: userId,
             notificationId: notification.id,
           );
         }
         
         notifications.clear();
         _updateUnreadCount();
       } catch (e) {
         SnackbarService().showError(
           title: AppStrings.I.error,
           message: AppStrings.I.failedToDeleteAllNotifications,
         );
       }
     }
     
     /// Get filtered notifications
     List<NotificationEntity> get filteredNotifications {
       var filtered = notifications.toList();
       
       // Filter by status
       if (filterStatus.value == 'read') {
         filtered = filtered.where((n) => n.isRead).toList();
       } else if (filterStatus.value == 'unread') {
         filtered = filtered.where((n) => !n.isRead).toList();
       }
       
       // Filter by type
       if (filterType.value != null) {
         filtered = filtered.where((n) => n.type == filterType.value).toList();
       }
       
       // Filter by search query
       if (searchQuery.value.isNotEmpty) {
         final query = searchQuery.value.toLowerCase();
         filtered = filtered.where((n) {
           return n.title.toLowerCase().contains(query) ||
                  n.message.toLowerCase().contains(query) ||
                  n.type.toLowerCase().contains(query);
         }).toList();
       }
       
       return filtered;
     }
     
     void _updateUnreadCount() {
       unreadCount.value = notifications.where((n) => !n.isRead).length;
     }
   }
   ```

**Expected Results**:
- ✅ NotificationCenterController exists
- ✅ Controller manages notification state
- ✅ Read/unread operations work
- ✅ Real-time updates work

**Test Criteria**:
- Unit test: Test controller methods
- Test: Test with Firebase

---

### Task 2: Create NotificationCenterPage

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create UI page for notification center with list, filters, and actions.

**Files to Create**:
- `lib/app/pages/notifications/notification_center_page.dart` (new file)

**Implementation Steps**:
1. Create `NotificationCenterPage`:
   ```dart
   class NotificationCenterPage extends StatelessWidget {
     final NotificationCenterController controller = Get.put(NotificationCenterController());
     
     @override
     Widget build(BuildContext context) {
       return Scaffold(
         backgroundColor: AppColors.background,
         appBar: AppBar(
           title: Text(AppStrings.notifications),
           backgroundColor: AppColors.primary,
           foregroundColor: AppColors.onPrimary,
           actions: [
             // Mark all as read
             Obx(() => controller.unreadCount.value > 0
                 ? IconButton(
                     icon: const Icon(Icons.done_all),
                     onPressed: controller.markAllAsRead,
                     tooltip: AppStrings.I.markAllAsRead,
                   )
                 : const SizedBox.shrink()),
             // Delete all
             IconButton(
               icon: const Icon(Icons.delete_outline),
               onPressed: controller.deleteAllNotifications,
               tooltip: AppStrings.I.deleteAll,
             ),
           ],
         ),
         body: Obx(() {
           if (controller.isLoading.value) {
             return const Center(child: TDLoadingIndicator());
           }
           
           final filtered = controller.filteredNotifications;
           
           if (filtered.isEmpty) {
             return _buildEmptyState();
           }
           
           return Column(
             children: [
               // Search and filters
               _buildSearchAndFilters(),
               
               // Notification list
               Expanded(
                 child: ListView.builder(
                   itemCount: filtered.length,
                   itemBuilder: (context, index) {
                     return _buildNotificationItem(filtered[index]);
                   },
                 ),
               ),
             ],
           );
         }),
       );
     }
     
     Widget _buildSearchAndFilters() {
       return Container(
         padding: const EdgeInsets.all(16),
         child: Column(
           children: [
             // Search bar
             TDTextField(
               hintText: AppStrings.I.searchNotifications,
               prefixIcon: Icons.search,
               onChanged: (value) => controller.searchQuery.value = value,
             ),
             const SizedBox(height: 16),
             // Filters
             Row(
               children: [
                 _buildFilterChip(
                   label: AppStrings.I.all,
                   value: 'all',
                   currentValue: controller.filterStatus.value,
                   onSelected: (value) => controller.filterStatus.value = value,
                 ),
                 const SizedBox(width: 8),
                 _buildFilterChip(
                   label: AppStrings.I.unread,
                   value: 'unread',
                   currentValue: controller.filterStatus.value,
                   onSelected: (value) => controller.filterStatus.value = value,
                 ),
                 const SizedBox(width: 8),
                 _buildFilterChip(
                   label: AppStrings.I.read,
                   value: 'read',
                   currentValue: controller.filterStatus.value,
                   onSelected: (value) => controller.filterStatus.value = value,
                 ),
               ],
             ),
           ],
         ),
       );
     }
     
     Widget _buildNotificationItem(NotificationEntity notification) {
       return TDNotificationItem(
         notification: notification,
         onTap: () => _handleNotificationTap(notification),
         onLongPress: () => _showNotificationMenu(notification),
       );
     }
     
     void _handleNotificationTap(NotificationEntity notification) {
       // Mark as read
       if (!notification.isRead) {
         controller.markAsRead(notification.id);
       }
       
       // Navigate to relevant content
       _navigateToContent(notification);
     }
     
     void _navigateToContent(NotificationEntity notification) {
       final type = notification.type;
       final data = notification.data;
       
       switch (type) {
         case 'task_assigned':
         case 'task_updated':
         case 'task_deleted':
           final taskId = data['taskId'] as String?;
           if (taskId != null) {
             NavigationService().toNamed<void>(AppRoutes.taskDetails, arguments: {'taskId': taskId});
           }
           break;
         case 'project_created':
         case 'project_updated':
           final projectId = data['projectId'] as String?;
           if (projectId != null) {
             NavigationService().toNamed<void>(AppRoutes.projectDetails, arguments: {'projectId': projectId});
           }
           break;
         case 'workspace_member_added':
         case 'workspace_member_removed':
           NavigationService().toNamed<void>(AppRoutes.workspaceMembers);
           break;
         default:
           // No navigation for unknown types
           break;
       }
     }
     
     Widget _buildEmptyState() {
       return Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Icon(Icons.notifications_none, size: 64, color: AppColors.onSurface.withOpacity(0.5)),
             const SizedBox(height: 16),
             Text(
               AppStrings.I.noNotifications,
               style: Theme.of(context).textTheme.titleLarge,
             ),
           ],
         ),
       );
     }
   }
   ```

2. Use TD widgets and AppStrings

**Expected Results**:
- ✅ NotificationCenterPage exists
- ✅ Page displays notifications correctly
- ✅ Filters and search work
- ✅ UI uses TD widgets and AppStrings

**Test Criteria**:
- Test: Page displays correctly
- Test: Filters work
- Test: Search works
- Test: Navigation works

---

### Task 3: Create TDNotificationItem Widget

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create custom widget for displaying notification items in list.

**Files to Create**:
- `lib/app/widgets/td_notification_item.dart` (new file)

**Implementation Steps**:
1. Create `TDNotificationItem` widget:
   ```dart
   class TDNotificationItem extends StatelessWidget {
     final NotificationEntity notification;
     final VoidCallback onTap;
     final VoidCallback? onLongPress;
     
     const TDNotificationItem({
       super.key,
       required this.notification,
       required this.onTap,
       this.onLongPress,
     });
     
     @override
     Widget build(BuildContext context) {
       return Container(
         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
         decoration: BoxDecoration(
           color: notification.isRead 
               ? AppColors.surface 
               : AppColors.primary.withOpacity(0.1),
           borderRadius: BorderRadius.circular(12),
           border: Border.all(
             color: notification.isRead 
                 ? AppColors.outline 
                 : AppColors.primary,
           ),
         ),
         child: ListTile(
           leading: _buildIcon(),
           title: Text(
             notification.title,
             style: Theme.of(context).textTheme.titleMedium?.copyWith(
               fontWeight: notification.isRead 
                   ? FontWeight.normal 
                   : FontWeight.bold,
             ),
           ),
           subtitle: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(notification.message),
               const SizedBox(height: 4),
               Text(
                 _formatTimestamp(notification.createdAt),
                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
                   color: AppColors.onSurface.withOpacity(0.6),
                 ),
               ),
             ],
           ),
           trailing: notification.isRead 
               ? null 
               : Container(
                   width: 8,
                   height: 8,
                   decoration: BoxDecoration(
                     color: AppColors.primary,
                     shape: BoxShape.circle,
                   ),
                 ),
           onTap: onTap,
           onLongPress: onLongPress,
         ),
       );
     }
     
     Widget _buildIcon() {
       IconData icon;
       Color color;
       
       switch (notification.type) {
         case 'task_assigned':
         case 'task_updated':
         case 'task_deleted':
           icon = Icons.task;
           color = AppColors.primary;
           break;
         case 'project_created':
         case 'project_updated':
           icon = Icons.folder;
           color = AppColors.secondary;
           break;
         case 'workspace_member_added':
         case 'workspace_member_removed':
           icon = Icons.people;
           color = AppColors.tertiary;
           break;
         default:
           icon = Icons.notifications;
           color = AppColors.onSurface;
       }
       
       return Icon(icon, color: color);
     }
     
     String _formatTimestamp(DateTime timestamp) {
       final now = DateTime.now();
       final difference = now.difference(timestamp);
       
       if (difference.inDays > 7) {
         return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
       } else if (difference.inDays > 0) {
         return '${difference.inDays} ${AppStrings.daysAgo}';
       } else if (difference.inHours > 0) {
         return '${difference.inHours} ${AppStrings.hoursAgo}';
       } else if (difference.inMinutes > 0) {
         return '${difference.inMinutes} ${AppStrings.minutesAgo}';
       } else {
         return AppStrings.I.justNow;
       }
     }
   }
   ```

2. Use AppStrings for all text

**Expected Results**:
- ✅ TDNotificationItem widget exists
- ✅ Widget displays notification correctly
- ✅ Read/unread state is visually distinct
- ✅ Widget uses AppStrings

**Test Criteria**:
- Widget test: Test widget display
- Test: Test read/unread styling

---

### Task 4: Add Unread Count Badge to App Bar

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add unread notification count badge to notification icon in app bar.

**Files to Modify**:
- `lib/app/pages/home/dashboard_page.dart`
- Other pages with notification icon

**Implementation Steps**:
1. Inject `NotificationCenterController`:
   ```dart
   final NotificationCenterController _notificationController = Get.find<NotificationCenterController>();
   ```

2. Update notification icon with badge:
   ```dart
   Obx(() => Stack(
     children: [
       IconButton(
         icon: const Icon(Icons.notifications_outlined),
         onPressed: () async {
           await NavigationService().toNamed<void>(AppRoutes.notificationCenter);
         },
       ),
       if (_notificationController.unreadCount.value > 0)
         Positioned(
           right: 8,
           top: 8,
           child: Container(
             padding: const EdgeInsets.all(4),
             decoration: BoxDecoration(
               color: AppColors.error,
               shape: BoxShape.circle,
             ),
             constraints: const BoxConstraints(
               minWidth: 16,
               minHeight: 16,
             ),
             child: Text(
               _notificationController.unreadCount.value > 99
                   ? '99+'
                   : '${_notificationController.unreadCount.value}',
               style: const TextStyle(
                 color: Colors.white,
                 fontSize: 10,
                 fontWeight: FontWeight.bold,
               ),
               textAlign: TextAlign.center,
             ),
           ),
         ),
     ],
   ))
   ```

**Expected Results**:
- ✅ Badge is displayed on notification icon
- ✅ Badge shows unread count
- ✅ Badge updates in real-time

**Test Criteria**:
- Test: Badge is displayed
- Test: Badge count is accurate
- Test: Badge updates correctly

---

### Task 5: Add Notification Methods to FirebaseDatabaseService

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add methods to FirebaseDatabaseService for notification operations (update read status, delete).

**Files to Modify**:
- `lib/core/services/firebase_database_service.dart`

**Implementation Steps**:
1. Add notification methods:
   ```dart
   /// Update notification read status
   Future<void> updateNotificationReadStatus({
     required String userId,
     required String notificationId,
     required bool isRead,
   }) async {
     try {
       final ref = _database.ref('notifications/$userId/$notificationId');
       await ref.update({
         'isRead': isRead,
         'readAt': isRead ? DateTime.now().millisecondsSinceEpoch : null,
       });
     } catch (e) {
       throw DatabaseFailure(message: 'Failed to update notification read status: $e');
     }
   }
   
   /// Delete notification
   Future<void> deleteNotification({
     required String userId,
     required String notificationId,
   }) async {
     try {
       final ref = _database.ref('notifications/$userId/$notificationId');
       await ref.remove();
     } catch (e) {
       throw DatabaseFailure(message: 'Failed to delete notification: $e');
     }
   }
   ```

**Expected Results**:
- ✅ Database methods exist
- ✅ Methods work correctly

**Test Criteria**:
- Unit test: Test database methods
- Test: Test with Firebase

---

### Task 6: Create NotificationDigestService

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create service for batching notifications into digest mode.

**Files to Create**:
- `lib/core/services/notification_digest_service.dart` (new file)

**Implementation Steps**:
1. Create `NotificationDigestService`:
   ```dart
   class NotificationDigestService extends GetxService {
     final FirebaseDatabaseService _databaseService = Get.find<FirebaseDatabaseService>();
     final PushNotificationService _pushService = Get.find<PushNotificationService>();
     final NotificationPreferencesService _preferencesService = Get.find<NotificationPreferencesService>();
     
     /// Queue notification for digest
     Future<void> queueForDigest({
       required String userId,
       required String workspaceId,
       required NotificationEntity notification,
     }) async {
       try {
         final ref = _database.ref('notification_digest_queue/$userId/$workspaceId');
         await ref.push().set(notification.toMap());
       } catch (e) {
         Get.log('Failed to queue notification for digest: $e');
       }
     }
     
     /// Process digest queue and send digest
     Future<void> processDigestQueue({
       required String userId,
       required String workspaceId,
     }) async {
       try {
         final preferences = await _preferencesService.getPreferences(
           userId: userId,
           workspaceId: workspaceId,
         );
         
         if (!preferences.digestEnabled) return;
         
         final ref = _database.ref('notification_digest_queue/$userId/$workspaceId');
         final snapshot = await ref.get();
         
         if (!snapshot.exists) return;
         
         final data = snapshot.value as Map<dynamic, dynamic>?;
         if (data == null || data.isEmpty) return;
         
         final queuedNotifications = <NotificationEntity>[];
         for (final entry in data.entries) {
           try {
             final notificationData = Map<String, dynamic>.from(entry.value as Map);
             queuedNotifications.add(NotificationEntity.fromMap(notificationData));
           } catch (e) {
             continue;
           }
         }
         
         if (queuedNotifications.isEmpty) return;
         
         // Create digest notification
         final digest = _createDigestNotification(queuedNotifications);
         
         // Send digest
         await _pushService.sendToUser(
           userId: userId,
           title: digest.title,
           body: digest.message,
           data: digest.data,
           notificationType: 'digest',
         );
         
         // Clear queue
         await ref.remove();
       } catch (e) {
         Get.log('Failed to process digest queue: $e');
       }
     }
     
     NotificationEntity _createDigestNotification(List<NotificationEntity> notifications) {
       final count = notifications.length;
       final byType = <String, int>{};
       
       for (final notification in notifications) {
         byType[notification.type] = (byType[notification.type] ?? 0) + 1;
       }
       
       final typeSummary = byType.entries
           .map((e) => '${e.value} ${e.key}')
           .join(', ');
       
       return NotificationEntity(
         id: DateTime.now().millisecondsSinceEpoch.toString(),
         userId: notifications.first.userId,
         type: 'digest',
         title: AppStrings.I.digestNotificationTitle(count),
         message: AppStrings.I.digestNotificationMessage(typeSummary),
         data: {
           'count': count,
           'notifications': notifications.map((n) => n.toMap()).toList(),
         },
         isRead: false,
         createdAt: DateTime.now(),
       );
     }
   }
   ```

2. Add digest scheduling (use periodic task or timer)

**Expected Results**:
- ✅ NotificationDigestService exists
- ✅ Service batches notifications
- ✅ Service sends digest at intervals

**Test Criteria**:
- Unit test: Test digest service
- Test: Test digest batching

---

### Task 7: Create QuotaThrottleMonitoringService

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create service for monitoring FCM quota and throttle limits.

**Files to Create**:
- `lib/core/services/quota_throttle_monitoring_service.dart` (new file)

**Implementation Steps**:
1. Create `QuotaThrottleMonitoringService`:
   ```dart
   class QuotaThrottleMonitoringService extends GetxService {
     final FirebaseDatabaseService _databaseService = Get.find<FirebaseDatabaseService>();
     
     // FCM limits (approximate)
     static const int dailyQuotaLimit = 10000; // Per workspace
     static const int throttleLimitPerMinute = 100; // Per workspace
     
     /// Track notification send for quota monitoring
     Future<void> trackNotificationSend({
       required String workspaceId,
     }) async {
       try {
         final today = DateTime.now();
         final dateKey = '${today.year}-${today.month}-${today.day}';
         
         final ref = _database.ref('notification_quota/$workspaceId/$dateKey');
         final snapshot = await ref.get();
         
         int currentCount = 0;
         if (snapshot.exists) {
           final data = snapshot.value as Map<dynamic, dynamic>?;
           currentCount = data?['count'] ?? 0;
         }
         
         final newCount = currentCount + 1;
         
         await ref.set({
           'count': newCount,
           'lastUpdated': DateTime.now().millisecondsSinceEpoch,
         });
         
         // Check quota and show warning if needed
         await _checkQuotaAndWarn(workspaceId, newCount);
       } catch (e) {
         Get.log('Failed to track notification send: $e');
       }
     }
     
     /// Check quota and show warnings
     Future<void> _checkQuotaAndWarn(String workspaceId, int currentCount) async {
       final percentage = (currentCount / dailyQuotaLimit) * 100;
       
       if (percentage >= 95) {
         await _showQuotaWarning(workspaceId, currentCount, 'critical');
       } else if (percentage >= 80) {
         await _showQuotaWarning(workspaceId, currentCount, 'warning');
       }
     }
     
     /// Show quota warning
     Future<void> _showQuotaWarning(
       String workspaceId,
       int currentCount,
       String level,
     ) async {
       final remaining = dailyQuotaLimit - currentCount;
       final percentage = (currentCount / dailyQuotaLimit) * 100;
       
       // Save warning to database
       await _databaseService.createQuotaWarning(
         workspaceId: workspaceId,
         level: level,
         currentCount: currentCount,
         limit: dailyQuotaLimit,
         remaining: remaining,
         percentage: percentage,
       );
       
       // Show in-app warning (if user is Admin/Account Holder)
       final userRole = await _getUserRole();
       if (userRole == WorkspaceRole.accountHolder || userRole == WorkspaceRole.admin) {
         SnackbarService().showWarning(
           title: AppStrings.I.quotaWarning,
           message: AppStrings.I.quotaWarningMessage(percentage, remaining),
         );
       }
     }
     
     /// Track notification send rate for throttle monitoring
     Future<void> trackNotificationRate({
       required String workspaceId,
     }) async {
       try {
         final now = DateTime.now();
         final minuteKey = '${now.year}-${now.month}-${now.day}-${now.hour}-${now.minute}';
         
         final ref = _database.ref('notification_throttle/$workspaceId/$minuteKey');
         final snapshot = await ref.get();
         
         int currentCount = 0;
         if (snapshot.exists) {
           final data = snapshot.value as Map<dynamic, dynamic>?;
           currentCount = data?['count'] ?? 0;
         }
         
         final newCount = currentCount + 1;
         
         await ref.set({
           'count': newCount,
           'timestamp': now.millisecondsSinceEpoch,
         });
         
         // Check throttle and show warning if needed
         if (newCount >= throttleLimitPerMinute) {
           await _showThrottleWarning(workspaceId, newCount);
         }
       } catch (e) {
         Get.log('Failed to track notification rate: $e');
       }
     }
     
     /// Show throttle warning
     Future<void> _showThrottleWarning(String workspaceId, int currentRate) async {
       // Save warning to database
       await _databaseService.createThrottleWarning(
         workspaceId: workspaceId,
         currentRate: currentRate,
         limit: throttleLimitPerMinute,
       );
       
       // Show in-app warning (if user is Admin/Account Holder)
       final userRole = await _getUserRole();
       if (userRole == WorkspaceRole.accountHolder || userRole == WorkspaceRole.admin) {
         SnackbarService().showWarning(
           title: AppStrings.I.throttleWarning,
           message: AppStrings.I.throttleWarningMessage(currentRate, throttleLimitPerMinute),
         );
       }
     }
   }
   ```

**Expected Results**:
- ✅ QuotaThrottleMonitoringService exists
- ✅ Service monitors quota and throttle
- ✅ Warnings are shown appropriately

**Test Criteria**:
- Unit test: Test monitoring service
- Test: Test quota warnings
- Test: Test throttle warnings

---

### Task 8: Integrate Digest Mode with Notification Preferences

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add digest mode settings to notification preferences and integrate with digest service.

**Files to Modify**:
- `lib/features/notifications/domain/entities/notification_preferences.dart`
- `lib/app/pages/settings/notification_settings_page.dart`

**Implementation Steps**:
1. Add digest fields to `NotificationPreferences`:
   ```dart
   final bool digestEnabled;
   final String? digestInterval; // 'hourly', 'daily', 'weekly'
   ```

2. Add digest UI to NotificationSettingsPage:
   ```dart
   // Digest Mode Section
   _buildSectionHeader(AppStrings.digestMode),
   const SizedBox(height: 16),
   
   _buildSwitchTile(
     title: AppStrings.I.enableDigestMode,
     subtitle: AppStrings.I.digestModeDescription,
     value: _digestEnabled.value,
     onChanged: (value) => _digestEnabled.value = value,
     icon: Icons.inbox,
   ),
   
   if (_digestEnabled.value) ...[
     const SizedBox(height: 16),
     _buildDigestIntervalSelector(),
   ],
   ```

3. Integrate with digest service

**Expected Results**:
- ✅ Digest mode is in preferences
- ✅ Digest UI is available
- ✅ Digest service respects preferences

**Test Criteria**:
- Test: Digest mode can be enabled/disabled
- Test: Digest interval can be configured
- Test: Digest service works

---

### Task 9: Add Notification Center Route

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add route for notification center page.

**Files to Modify**:
- `lib/app/routes/app_router.dart`

**Implementation Steps**:
1. Add route constant:
   ```dart
   static const String notificationCenter = '/notifications/center';
   ```

2. Add route definition:
   ```dart
   GetPage(
     name: notificationCenter,
     page: () => const NotificationCenterPage(),
   ),
   ```

3. Update navigation calls

**Expected Results**:
- ✅ Route exists
- ✅ Navigation works correctly

**Test Criteria**:
- Test: Route is accessible
- Test: Navigation works

---

### Task 10: Add Unit Tests

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for notification center.

**Files to Create**:
- `test/features/notifications/presentation/controllers/notification_center_controller_test.dart`
- `test/core/services/notification_digest_service_test.dart`
- `test/core/services/quota_throttle_monitoring_service_test.dart`

**Expected Results**:
- ✅ Unit tests cover notification center
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Create NotificationCenterController (Critical - Foundation)
2. **Task 2**: Create NotificationCenterPage (Critical - UI)
3. **Task 3**: Create TDNotificationItem Widget (High Priority - UI Component)
4. **Task 5**: Add Notification Methods to FirebaseDatabaseService (High Priority - Data Layer)
5. **Task 4**: Add Unread Count Badge to App Bar (High Priority - UX)
6. **Task 9**: Add Notification Center Route (High Priority - Navigation)
7. **Task 6**: Create NotificationDigestService (Medium Priority - Feature)
8. **Task 7**: Create QuotaThrottleMonitoringService (Medium Priority - Feature)
9. **Task 8**: Integrate Digest Mode with Notification Preferences (Medium Priority - Integration)
10. **Task 10**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ NotificationCenterController exists
- ✅ NotificationCenterPage exists
- ✅ TDNotificationItem widget exists
- ✅ Read/unread state management works
- ✅ Real-time updates work
- ✅ Unread count badge works
- ✅ Digest mode works
- ✅ Quota/throttle monitoring works
- ✅ Filtering and search work
- ✅ Navigation works
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, SnackbarService, NavigationService)
- ✅ Workspace scoping is enforced
- ✅ No known bugs or issues

---

## Dependencies

- **Firebase Realtime Database**: Required for storing notifications and real-time updates
- **GetX**: Required for state management (project rule)
- **AppStrings**: All text must use AppStrings constants
- **Push Notification Service**: Required for digest sending (from Notification Main Flow tasks)
- **Notification Preferences Service**: Required for digest mode (from Notification Subscription Management tasks)

---

## Notes

1. **Real-Time Updates**: Use Firebase listeners for real-time notification updates in notification center.

2. **Digest Mode**: Digest mode batches notifications and sends them at configured intervals (hourly, daily, weekly).

3. **Quota/Throttle**: FCM has limits on notifications per day (quota) and per minute (throttle). Monitor and warn when approaching limits.

4. **Workspace Scoping**: All notifications should be scoped to workspace for data isolation.

5. **Performance**: Use pagination for large notification lists to ensure good performance.

6. **Navigation**: Implement navigation to relevant content based on notification type and data payload.

---

## Related Documentation

- `NOTIFICATIONS_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `NOTIFICATION_CENTER_TEST_CASES.md` - Test cases for this feature
- `NOTIFICATION_MAIN_FLOW_TASKS.md` - Related push notification tasks
- `NOTIFICATION_SUBSCRIPTION_MANAGEMENT_TASKS.md` - Related notification preferences tasks
- `docs/v1/feature_checklists/notifications/notifications.md` - Notification requirements
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture

