# Task CRUD & Details (Title, Description, Status Enum, Priority Enum, Type, Deadline, Tags, Checklist, Attachments; Creator/Assignee/Updater; Comments/Activity) - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Task CRUD & Details** feature. Currently, this feature is **PARTIAL** - basic CRUD exists but enum enforcement, tags, checklist, attachments, updater tracking, and comments/activity log are missing.

## Current Status: ⚠️ PARTIAL

### What Exists:
- ✅ `TaskEntity` with title, description, status, priority, taskType, deadline, assignee, assigner, projectId, recurring, hasDeadline
- ✅ `task_enums.dart` with TaskStatus, TaskPriority, TaskType, TaskFrequency enums
- ✅ Basic CRUD operations (create, edit, delete)
- ✅ Task list UI (`task_list_page.dart`, `task_card.dart`)
- ✅ Task create/edit form (`create_task_form.dart`, `task_edit_page.dart`)
- ✅ `ActivityLog` entity exists (but for conflict resolution, not task activity)

### What's Missing/Broken:
- ⛔ Enum enforcement - status/priority/type are strings, not enums (even though `task_enums.dart` exists)
- ⛔ Tags field - no tags support in TaskEntity
- ⛔ Checklist field - no checklist support in TaskEntity
- ⛔ Attachments field - no attachments support in TaskEntity
- ⛔ Updater tracking - no `updatedBy` or `updater` field in TaskEntity
- ⛔ Comments - no comment entity or UI
- ⛔ Task activity log - no task-specific activity log (ActivityLog exists but for conflict resolution)

---

## Task List

### Task 1: Update TaskEntity to Use Enums

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update `TaskEntity` to use enums from `task_enums.dart` instead of strings for status, priority, and taskType.

**Files to Modify**:
- `lib/features/tasks/domain/entities/task.dart`

**Implementation Steps**:
1. Import enums:
   ```dart
   import 'package:todolist/core/constants/task_enums.dart';
   ```

2. Update TaskEntity fields:
   ```dart
   class TaskEntity {
     // ... existing fields ...
     final TaskStatus status; // Changed from String to TaskStatus
     final TaskPriority priority; // Changed from String to TaskPriority
     final TaskType taskType; // Changed from String to TaskType
     
     const TaskEntity({
       // ... existing parameters ...
       required this.status,
       required this.priority,
       required this.taskType,
     });
   }
   ```

3. Update `fromMap` factory to convert strings to enums:
   ```dart
   factory TaskEntity.fromMap(Map<dynamic, dynamic> map) {
     return TaskEntity(
       // ... existing fields ...
       status: TaskStatus.fromString((map['status'] as String?) ?? 'pending'),
       priority: TaskPriority.fromString((map['priority'] as String?) ?? 'medium'),
       taskType: TaskType.fromString((map['taskType'] as String?) ?? 'daily'),
     );
   }
   ```

4. Update `toMap` method to convert enums to strings:
   ```dart
   Map<String, dynamic> toMap() {
     return <String, dynamic>{
       // ... existing fields ...
       'status': status.value,
       'priority': priority.value,
       'taskType': taskType.value,
     };
   }
   ```

5. Update `copyWith` method to use enums

**Expected Results**:
- ✅ TaskEntity uses enums for status/priority/type
- ✅ Type safety is enforced
- ✅ Entity is serializable

**Test Criteria**:
- Unit test: Test entity creation with enums
- Test: Verify enum conversion in toMap/fromMap
- Test: Verify type safety

---

### Task 2: Update Task Controllers to Use Enums

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update task controllers to use enums instead of strings.

**Files to Modify**:
- `lib/features/tasks/presentation/controllers/task_controller.dart`
- `lib/features/tasks/presentation/controllers/paginated_task_controller.dart`
- Other task controllers

**Implementation Steps**:
1. Import enums:
   ```dart
   import 'package:todolist/core/constants/task_enums.dart';
   ```

2. Update controller methods to use enums:
   ```dart
   Future<void> createTask({
     required String title,
     required TaskStatus status, // Changed from String
     required TaskPriority priority, // Changed from String
     required TaskType taskType, // Changed from String
     // ... other parameters
   }) async {
     // Use enums directly
   }
   ```

3. Update status/priority/type comparisons to use enums:
   ```dart
   // Before: if (task.status == 'pending')
   // After:
   if (task.status == TaskStatus.pending)
   ```

4. Update filters to use enums:
   ```dart
   Future<List<TaskEntity>> getTasks({
     TaskStatus? status, // Changed from String?
     TaskPriority? priority, // Changed from String?
     TaskType? taskType, // Changed from String?
   }) async {
     // Use enums in queries
   }
   ```

**Expected Results**:
- ✅ Controllers use enums
- ✅ Type safety is enforced
- ✅ All comparisons use enums

**Test Criteria**:
- Unit test: Test controller methods with enums
- Test: Verify enum comparisons work
- Test: Verify filters work with enums

---

### Task 3: Update Task UI to Use Enums

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Update task UI components to use enums and display enum values correctly.

**Files to Modify**:
- `lib/app/pages/tasks/task_edit_page.dart`
- `lib/features/tasks/presentation/widgets/create_task_form.dart`
- `lib/features/tasks/presentation/widgets/task_card.dart`
- Other task UI components

**Implementation Steps**:
1. Import enums:
   ```dart
   import 'package:todolist/core/constants/task_enums.dart';
   ```

2. Update status dropdown to use enum:
   ```dart
   DropdownButton<TaskStatus>(
     value: _selectedStatus,
     items: TaskStatus.values.map((status) {
       return DropdownMenuItem<TaskStatus>(
         value: status,
         child: Text(status.displayText), // Use displayText from enum
       );
     }).toList(),
     onChanged: (value) {
       setState(() {
         _selectedStatus = value;
       });
     },
   )
   ```

3. Update priority dropdown to use enum (similar to status)

4. Update type dropdown to use enum (similar to status)

5. Update task card to display enum values:
   ```dart
   Text(task.status.displayText) // Use displayText from enum
   ```

6. Use AppStrings for enum display text (if needed):
   - Map enum values to AppStrings constants

**Expected Results**:
- ✅ UI uses enums
- ✅ Enum values are displayed correctly
- ✅ Dropdowns show enum options
- ✅ All text uses AppStrings

**Test Criteria**:
- Manual test: Create/edit task with enums
- Test: Verify dropdowns show enum options
- Test: Verify enum values are displayed correctly

---

### Task 4: Add Tags Field to TaskEntity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add tags field to `TaskEntity` to support task tagging.

**Files to Modify**:
- `lib/features/tasks/domain/entities/task.dart`

**Implementation Steps**:
1. Add tags field to `TaskEntity`:
   ```dart
   class TaskEntity {
     // ... existing fields ...
     final List<String>? tags; // Add tags field
     
     const TaskEntity({
       // ... existing parameters ...
       this.tags,
     });
   }
   ```

2. Update `fromMap` factory:
   ```dart
   factory TaskEntity.fromMap(Map<dynamic, dynamic> map) {
     return TaskEntity(
       // ... existing fields ...
       tags: map['tags'] != null
           ? List<String>.from(map['tags'] as List)
           : null,
     );
   }
   ```

3. Update `toMap` method:
   ```dart
   Map<String, dynamic> toMap() {
     return <String, dynamic>{
       // ... existing fields ...
       'tags': tags,
     };
   }
   ```

4. Update `copyWith` method to include tags

**Expected Results**:
- ✅ Tags field is added to TaskEntity
- ✅ Entity supports tags
- ✅ Entity is serializable

**Test Criteria**:
- Unit test: Test entity creation with tags
- Test: Verify tags are included in toMap/fromMap

---

### Task 5: Create Tag Input Widget

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI widget for adding/removing tags.

**Files to Create**:
- `lib/app/widgets/tag_input_widget.dart` (new file)

**Implementation Steps**:
1. Create `TagInputWidget`:
   ```dart
   class TagInputWidget extends StatelessWidget {
     final List<String> tags;
     final Function(List<String>) onTagsChanged;
     
     @override
     Widget build(BuildContext context) {
       return Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           _buildTagInput(),
           _buildTagsList(),
         ],
       );
     }
   }
   ```

2. Add tag input field:
   - Text field for entering tags
   - "Add" button or Enter key to add tag
   - Validation (no duplicates, max length, etc.)

3. Add tags display:
   - Chips or badges for each tag
   - Remove button (X) on each tag
   - Tag color (optional)

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Tag input widget exists
- ✅ Tags can be added/removed
- ✅ Tags are displayed correctly
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test tag input widget
- Manual test: Add/remove tags

---

### Task 6: Add Tags to Task Edit UI

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add tag input widget to task edit/create form.

**Files to Modify**:
- `lib/app/pages/tasks/task_edit_page.dart`
- `lib/features/tasks/presentation/widgets/create_task_form.dart`

**Implementation Steps**:
1. Add tag input section to task form:
   ```dart
   TagInputWidget(
     tags: _tags,
     onTagsChanged: (tags) {
       setState(() {
         _tags = tags;
       });
     },
   )
   ```

2. Initialize tags from task (when editing):
   ```dart
   _tags = task.tags ?? [];
   ```

3. Save tags when task is saved:
   ```dart
   final entity = TaskEntity(
     // ... existing fields ...
     tags: _tags.isNotEmpty ? _tags : null,
   );
   ```

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Tags can be added in task edit form
- ✅ Tags are saved with task
- ✅ Tags are loaded when editing task
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Add tags to task
- Test: Verify tags are saved
- Test: Verify tags are loaded when editing

---

### Task 7: Create ChecklistItem Entity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create `ChecklistItem` entity for task checklist items.

**Files to Create**:
- `lib/features/tasks/domain/entities/checklist_item.dart` (new file)

**Implementation Steps**:
1. Create `ChecklistItem` entity:
   ```dart
   class ChecklistItem {
     final String id;
     final String text;
     final bool isCompleted;
     final int order; // For ordering items
     
     const ChecklistItem({
       required this.id,
       required this.text,
       required this.isCompleted,
       required this.order,
     });
     
     factory ChecklistItem.fromMap(Map<dynamic, dynamic> map) {
       return ChecklistItem(
         id: (map['id'] as String?) ?? '',
         text: (map['text'] as String?) ?? '',
         isCompleted: (map['isCompleted'] as bool?) ?? false,
         order: (map['order'] as int?) ?? 0,
       );
     }
     
     Map<String, dynamic> toMap() {
       return <String, dynamic>{
         'id': id,
         'text': text,
         'isCompleted': isCompleted,
         'order': order,
       };
     }
   }
   ```

2. Add `copyWith` method

**Expected Results**:
- ✅ ChecklistItem entity exists
- ✅ Entity is serializable
- ✅ Entity supports ordering

**Test Criteria**:
- Unit test: Test ChecklistItem creation
- Test: Verify serialization

---

### Task 8: Add Checklist Field to TaskEntity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add checklist field to `TaskEntity`.

**Files to Modify**:
- `lib/features/tasks/domain/entities/task.dart`

**Implementation Steps**:
1. Import ChecklistItem:
   ```dart
   import 'package:todolist/features/tasks/domain/entities/checklist_item.dart';
   ```

2. Add checklist field:
   ```dart
   class TaskEntity {
     // ... existing fields ...
     final List<ChecklistItem>? checklist; // Add checklist field
     
     const TaskEntity({
       // ... existing parameters ...
       this.checklist,
     });
   }
   ```

3. Update `fromMap` factory:
   ```dart
   factory TaskEntity.fromMap(Map<dynamic, dynamic> map) {
     return TaskEntity(
       // ... existing fields ...
       checklist: map['checklist'] != null
           ? (map['checklist'] as List).map((item) {
               return ChecklistItem.fromMap(item as Map<dynamic, dynamic>);
             }).toList()
           : null,
     );
   }
   ```

4. Update `toMap` method:
   ```dart
   Map<String, dynamic> toMap() {
     return <String, dynamic>{
       // ... existing fields ...
       'checklist': checklist?.map((item) => item.toMap()).toList(),
     };
   }
   ```

5. Update `copyWith` method to include checklist

**Expected Results**:
- ✅ Checklist field is added to TaskEntity
- ✅ Entity supports checklist
- ✅ Entity is serializable

**Test Criteria**:
- Unit test: Test entity creation with checklist
- Test: Verify checklist is included in toMap/fromMap

---

### Task 9: Create Checklist Widget

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI widget for managing task checklist.

**Files to Create**:
- `lib/app/widgets/task_checklist_widget.dart` (new file)

**Implementation Steps**:
1. Create `TaskChecklistWidget`:
   ```dart
   class TaskChecklistWidget extends StatelessWidget {
     final List<ChecklistItem> items;
     final Function(List<ChecklistItem>) onItemsChanged;
     
     @override
     Widget build(BuildContext context) {
       return Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           _buildProgressIndicator(),
           _buildAddItemButton(),
           _buildItemsList(),
         ],
       );
     }
   }
   ```

2. Add progress indicator:
   - Show completed/total count (e.g., "3/5 completed")
   - Progress bar (optional)

3. Add item list:
   - Checkbox for each item
   - Item text (editable)
   - Delete button for each item
   - Reorder support (drag and drop or up/down arrows)

4. Add "Add Item" button:
   - Opens input field
   - Adds new item to list

5. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Checklist widget exists
- ✅ Items can be added/removed/edited
- ✅ Items can be checked/unchecked
- ✅ Progress is tracked
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test checklist widget
- Manual test: Add/remove/check items

---

### Task 10: Add Checklist to Task Edit UI

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add checklist widget to task edit/create form.

**Files to Modify**:
- `lib/app/pages/tasks/task_edit_page.dart`
- `lib/features/tasks/presentation/widgets/create_task_form.dart`

**Implementation Steps**:
1. Add checklist widget to task form:
   ```dart
   TaskChecklistWidget(
     items: _checklistItems,
     onItemsChanged: (items) {
       setState(() {
         _checklistItems = items;
       });
     },
   )
   ```

2. Initialize checklist from task (when editing):
   ```dart
   _checklistItems = task.checklist ?? [];
   ```

3. Save checklist when task is saved:
   ```dart
   final entity = TaskEntity(
     // ... existing fields ...
     checklist: _checklistItems.isNotEmpty ? _checklistItems : null,
   );
   ```

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Checklist can be managed in task edit form
- ✅ Checklist is saved with task
- ✅ Checklist is loaded when editing task
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Add checklist items to task
- Test: Verify checklist is saved
- Test: Verify checklist is loaded when editing

---

### Task 11: Create Attachment Entity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create `Attachment` entity for task attachments.

**Files to Create**:
- `lib/features/tasks/domain/entities/attachment.dart` (new file)

**Implementation Steps**:
1. Create `Attachment` entity:
   ```dart
   class Attachment {
     final String id;
     final String fileName;
     final String fileUrl; // Firebase Storage URL
     final String fileType; // e.g., 'image/jpeg', 'application/pdf'
     final int fileSize; // In bytes
     final String uploadedBy; // User ID
     final DateTime uploadedAt;
     
     const Attachment({
       required this.id,
       required this.fileName,
       required this.fileUrl,
       required this.fileType,
       required this.fileSize,
       required this.uploadedBy,
       required this.uploadedAt,
     });
     
     factory Attachment.fromMap(Map<dynamic, dynamic> map) {
       return Attachment(
         id: (map['id'] as String?) ?? '',
         fileName: (map['fileName'] as String?) ?? '',
         fileUrl: (map['fileUrl'] as String?) ?? '',
         fileType: (map['fileType'] as String?) ?? '',
         fileSize: (map['fileSize'] as int?) ?? 0,
         uploadedBy: (map['uploadedBy'] as String?) ?? '',
         uploadedAt: map['uploadedAt'] != null
             ? DateTime.fromMillisecondsSinceEpoch(map['uploadedAt'] as int)
             : DateTime.now(),
       );
     }
     
     Map<String, dynamic> toMap() {
       return <String, dynamic>{
         'id': id,
         'fileName': fileName,
         'fileUrl': fileUrl,
         'fileType': fileType,
         'fileSize': fileSize,
         'uploadedBy': uploadedBy,
         'uploadedAt': uploadedAt.millisecondsSinceEpoch,
       };
     }
   }
   ```

2. Add `copyWith` method

**Expected Results**:
- ✅ Attachment entity exists
- ✅ Entity is serializable
- ✅ Entity supports file metadata

**Test Criteria**:
- Unit test: Test Attachment creation
- Test: Verify serialization

---

### Task 12: Add Attachments Field to TaskEntity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Add attachments field to `TaskEntity`.

**Files to Modify**:
- `lib/features/tasks/domain/entities/task.dart`

**Implementation Steps**:
1. Import Attachment:
   ```dart
   import 'package:todolist/features/tasks/domain/entities/attachment.dart';
   ```

2. Add attachments field:
   ```dart
   class TaskEntity {
     // ... existing fields ...
     final List<Attachment>? attachments; // Add attachments field
     
     const TaskEntity({
       // ... existing parameters ...
       this.attachments,
     });
   }
   ```

3. Update `fromMap` factory (similar to checklist)

4. Update `toMap` method (similar to checklist)

5. Update `copyWith` method to include attachments

**Expected Results**:
- ✅ Attachments field is added to TaskEntity
- ✅ Entity supports attachments
- ✅ Entity is serializable

**Test Criteria**:
- Unit test: Test entity creation with attachments
- Test: Verify attachments are included in toMap/fromMap

---

### Task 13: Create File Upload Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service for uploading files to Firebase Storage.

**Files to Create**:
- `lib/core/services/file_upload_service.dart` (new file)

**Implementation Steps**:
1. Create `FileUploadService`:
   ```dart
   class FileUploadService {
     final FirebaseStorage _storage = FirebaseStorage.instance;
     
     Future<String> uploadFile({
       required File file,
       required String workspaceId,
       required String taskId,
       required String userId,
     }) async {
       // 1. Generate unique file name
       // 2. Create storage path: workspaces/{workspaceId}/tasks/{taskId}/{fileName}
       // 3. Upload file to Firebase Storage
       // 4. Get download URL
       // 5. Return URL
     }
     
     Future<void> deleteFile(String fileUrl) async {
       // Delete file from Firebase Storage
     }
     
     Future<FileInfo> getFileInfo(String fileUrl) async {
       // Get file metadata (size, type, etc.)
     }
   }
   ```

2. Add file validation:
   - Max file size
   - Allowed file types
   - File name sanitization

3. Add progress tracking (optional):
   - Upload progress callback

**Expected Results**:
- ✅ File upload service exists
- ✅ Files are uploaded to Firebase Storage
- ✅ File URLs are returned
- ✅ File validation works

**Test Criteria**:
- Unit test: Test file upload
- Integration test: Test with Firebase Storage
- Test: Verify file validation

---

### Task 14: Create Attachments Widget

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI widget for managing task attachments.

**Files to Create**:
- `lib/app/widgets/task_attachments_widget.dart` (new file)

**Implementation Steps**:
1. Create `TaskAttachmentsWidget`:
   ```dart
   class TaskAttachmentsWidget extends StatelessWidget {
     final List<Attachment> attachments;
     final Function(List<Attachment>) onAttachmentsChanged;
     
     @override
     Widget build(BuildContext context) {
       return Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           _buildAddAttachmentButton(),
           _buildAttachmentsList(),
         ],
       );
     }
   }
   ```

2. Add "Add Attachment" button:
   - Opens file picker
   - Shows upload progress
   - Handles upload errors

3. Add attachments list:
   - Attachment cards with:
     - File name
     - File type icon
     - File size
     - Upload date
     - View button
     - Delete button

4. Add file viewer:
   - Open images in image viewer
   - Open documents in document viewer
   - Download files

5. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Attachments widget exists
- ✅ Files can be uploaded
- ✅ Attachments can be viewed/deleted
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test attachments widget
- Manual test: Upload/view/delete attachments

---

### Task 15: Add Attachments to Task Edit UI

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add attachments widget to task edit/create form.

**Files to Modify**:
- `lib/app/pages/tasks/task_edit_page.dart`
- `lib/features/tasks/presentation/widgets/create_task_form.dart`

**Implementation Steps**:
1. Add attachments widget to task form (similar to checklist)

2. Initialize attachments from task (when editing)

3. Save attachments when task is saved

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Attachments can be managed in task edit form
- ✅ Attachments are saved with task
- ✅ Attachments are loaded when editing task
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Add attachments to task
- Test: Verify attachments are saved
- Test: Verify attachments are loaded when editing

---

### Task 16: Add Updater Field to TaskEntity

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add `updatedBy` field to `TaskEntity` to track who last updated the task.

**Files to Modify**:
- `lib/features/tasks/domain/entities/task.dart`

**Implementation Steps**:
1. Add `updatedBy` field:
   ```dart
   class TaskEntity {
     // ... existing fields ...
     final String? updatedBy; // Add updater field
     
     const TaskEntity({
       // ... existing parameters ...
       this.updatedBy,
     });
   }
   ```

2. Update `fromMap` factory:
   ```dart
   factory TaskEntity.fromMap(Map<dynamic, dynamic> map) {
     return TaskEntity(
       // ... existing fields ...
       updatedBy: map['updatedBy'] as String?,
     );
   }
   ```

3. Update `toMap` method:
   ```dart
   Map<String, dynamic> toMap() {
     return <String, dynamic>{
       // ... existing fields ...
       'updatedBy': updatedBy,
     };
   }
   ```

4. Update `copyWith` method to include updatedBy

**Expected Results**:
- ✅ UpdatedBy field is added to TaskEntity
- ✅ Entity supports updater tracking
- ✅ Entity is serializable

**Test Criteria**:
- Unit test: Test entity creation with updatedBy
- Test: Verify updatedBy is included in toMap/fromMap

---

### Task 17: Update Task Controllers to Track Updater

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Update task controllers to set `updatedBy` when task is updated.

**Files to Modify**:
- `lib/features/tasks/presentation/controllers/task_controller.dart`
- Other task controllers

**Implementation Steps**:
1. Update `updateTask` method:
   ```dart
   Future<void> updateTask(TaskEntity task) async {
     final currentUser = _authController.currentUser;
     if (currentUser == null) return;
     
     final updatedTask = task.copyWith(
       updatedBy: currentUser.id, // Set updater
       updatedAt: DateTime.now(),
     );
     
     await _taskRepository.updateTask(updatedTask);
   }
   ```

2. Ensure `updatedBy` is set for all update operations:
   - Status changes
   - Priority changes
   - Assignee changes
   - Description updates
   - Any other field updates

**Expected Results**:
- ✅ Updater is tracked on all updates
- ✅ UpdatedBy is set correctly
- ✅ UpdatedAt is set correctly

**Test Criteria**:
- Unit test: Test updater tracking
- Test: Verify updatedBy is set on updates

---

### Task 18: Display Updater in Task UI

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Display updater information in task detail view.

**Files to Modify**:
- `lib/app/pages/tasks/task_detail_page.dart`
- `lib/features/tasks/presentation/widgets/task_card.dart`

**Implementation Steps**:
1. Add updater display to task detail:
   ```dart
   if (task.updatedBy != null)
     Text('Last updated by: ${_getUserName(task.updatedBy)}')
   ```

2. Add updater display to task card (optional):
   - Show "Updated by [User]" if task was updated

3. Use AppStrings for labels

**Expected Results**:
- ✅ Updater is displayed in task detail
- ✅ Updater name is shown correctly
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Verify updater is displayed
- Test: Verify updater name is correct

---

### Task 19: Create Comment Entity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create `Comment` entity for task comments.

**Files to Create**:
- `lib/features/tasks/domain/entities/comment.dart` (new file)

**Implementation Steps**:
1. Create `Comment` entity:
   ```dart
   class Comment {
     final String id;
     final String taskId;
     final String workspaceId;
     final String text;
     final String authorId;
     final DateTime createdAt;
     final DateTime? updatedAt;
     final String? editedBy; // If comment was edited
     
     const Comment({
       required this.id,
       required this.taskId,
       required this.workspaceId,
       required this.text,
       required this.authorId,
       required this.createdAt,
       this.updatedAt,
       this.editedBy,
     });
     
     factory Comment.fromMap(Map<dynamic, dynamic> map) {
       return Comment(
         id: (map['id'] as String?) ?? '',
         taskId: (map['taskId'] as String?) ?? '',
         workspaceId: (map['workspaceId'] as String?) ?? '',
         text: (map['text'] as String?) ?? '',
         authorId: (map['authorId'] as String?) ?? '',
         createdAt: map['createdAt'] != null
             ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
             : DateTime.now(),
         updatedAt: map['updatedAt'] != null
             ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
             : null,
         editedBy: map['editedBy'] as String?,
       );
     }
     
     Map<String, dynamic> toMap() {
       return <String, dynamic>{
         'id': id,
         'taskId': taskId,
         'workspaceId': workspaceId,
         'text': text,
         'authorId': authorId,
         'createdAt': createdAt.millisecondsSinceEpoch,
         'updatedAt': updatedAt?.millisecondsSinceEpoch,
         'editedBy': editedBy,
       };
     }
   }
   ```

2. Add `copyWith` method

**Expected Results**:
- ✅ Comment entity exists
- ✅ Entity is serializable
- ✅ Entity supports editing

**Test Criteria**:
- Unit test: Test Comment creation
- Test: Verify serialization

---

### Task 20: Create Comment Repository

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create repository for managing task comments.

**Files to Create**:
- `lib/features/tasks/domain/repositories/comment_repository.dart` (new file)
- `lib/features/tasks/data/repositories/comment_repository_impl.dart` (new file)

**Implementation Steps**:
1. Create `CommentRepository` interface:
   ```dart
   abstract class CommentRepository {
     Future<List<Comment>> getComments({
       required String workspaceId,
       required String taskId,
     });
     
     Future<Comment> createComment({
       required String workspaceId,
       required String taskId,
       required Comment comment,
     });
     
     Future<Comment> updateComment({
       required String workspaceId,
       required String taskId,
       required Comment comment,
     });
     
     Future<void> deleteComment({
       required String workspaceId,
       required String taskId,
       required String commentId,
     });
   }
   ```

2. Implement in `CommentRepositoryImpl`:
   - Use `FirebaseDatabaseService` to store/retrieve comments
   - Store in path: `workspaces/{workspaceId}/tasks/{taskId}/comments/{commentId}`

**Expected Results**:
- ✅ Comment repository exists
- ✅ All CRUD operations work correctly

**Test Criteria**:
- Unit test: Test repository methods
- Integration test: Test with Firebase

---

### Task 21: Create Comment Use Cases

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use cases for comment operations.

**Files to Create**:
- `lib/features/tasks/domain/usecases/create_comment.dart` (new file)
- `lib/features/tasks/domain/usecases/update_comment.dart` (new file)
- `lib/features/tasks/domain/usecases/delete_comment.dart` (new file)
- `lib/features/tasks/domain/usecases/get_comments.dart` (new file)

**Implementation Steps**:
1. Create use cases similar to task use cases:
   - `CreateComment`
   - `UpdateComment`
   - `DeleteComment`
   - `GetComments`

2. Add validation:
   - Comment text must not be empty
   - User must have permission to comment
   - User can only edit/delete own comments (unless admin)

**Expected Results**:
- ✅ Use cases exist
- ✅ Validation works correctly
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test use cases
- Test: Verify validation works

---

### Task 22: Create Comment Controller

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create GetX controller for managing comments.

**Files to Create**:
- `lib/features/tasks/presentation/controllers/comment_controller.dart` (new file)

**Implementation Steps**:
1. Create `CommentController`:
   ```dart
   class CommentController extends GetxController {
     final CommentRepository _commentRepository;
     final CreateComment _createComment;
     final UpdateComment _updateComment;
     final DeleteComment _deleteComment;
     final GetComments _getComments;
     
     final RxList<Comment> _comments = <Comment>[].obs;
     final RxBool _isLoading = false.obs;
     
     List<Comment> get comments => _comments.toList();
     bool get isLoading => _isLoading.value;
     
     Future<void> loadComments(String taskId) async {
       // Load comments for task
     }
     
     Future<void> addComment(String taskId, String text) async {
       // Create comment with permission check
     }
     
     Future<void> updateComment(Comment comment) async {
       // Update comment with permission check
     }
     
     Future<void> deleteComment(String commentId) async {
       // Delete comment with permission check
     }
   }
   ```

2. Add permission checks to all methods

3. Add error handling

**Expected Results**:
- ✅ Comment controller exists
- ✅ Permission checks are enforced
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test controller methods
- Test: Verify permission checks

---

### Task 23: Create Comments Widget

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI widget for displaying and managing comments.

**Files to Create**:
- `lib/app/widgets/task_comments_widget.dart` (new file)

**Implementation Steps**:
1. Create `TaskCommentsWidget`:
   ```dart
   class TaskCommentsWidget extends StatelessWidget {
     final String taskId;
     
     @override
     Widget build(BuildContext context) {
       return GetBuilder<CommentController>(
         builder: (controller) => Column(
           children: [
             _buildCommentsList(controller),
             _buildCommentInput(controller),
           ],
         ),
       );
     }
   }
   ```

2. Add comments list:
   - Comment cards with:
     - Author name/avatar
     - Comment text
     - Timestamp
     - Edit button (if user is author)
     - Delete button (if user is author or admin)
   - Order comments by timestamp

3. Add comment input:
   - Text field for entering comment
   - "Post" or "Add Comment" button
   - Character limit (optional)

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Comments widget exists
- ✅ Comments can be added/edited/deleted
- ✅ Comments are displayed correctly
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test comments widget
- Manual test: Add/edit/delete comments

---

### Task 24: Add Comments to Task Detail UI

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add comments widget to task detail page.

**Files to Modify**:
- `lib/app/pages/tasks/task_detail_page.dart`

**Implementation Steps**:
1. Add comments widget to task detail:
   ```dart
   TaskCommentsWidget(taskId: task.id)
   ```

2. Initialize comment controller for task

3. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Comments are displayed in task detail
- ✅ Comments can be added from task detail
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: View/add comments in task detail
- Test: Verify comments are loaded

---

### Task 25: Create Task Activity Log Service

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create service for logging task activities (separate from conflict resolution ActivityLog).

**Files to Create**:
- `lib/core/services/task_activity_log_service.dart` (new file)

**Implementation Steps**:
1. Create `TaskActivityLogService`:
   ```dart
   class TaskActivityLogService {
     final FirebaseDatabaseService _databaseService;
     
     Future<void> logActivity({
       required String workspaceId,
       required String taskId,
       required String action, // 'created', 'updated', 'status_changed', etc.
       required String userId,
       Map<String, dynamic>? details, // Change details
     }) async {
       // 1. Create activity log entry
       // 2. Save to Firebase: workspaces/{workspaceId}/tasks/{taskId}/activity/{activityId}
       // 3. Return success
     }
     
     Future<List<TaskActivity>> getActivityLog({
       required String workspaceId,
       required String taskId,
     }) async {
       // Get activity log for task
     }
   }
   ```

2. Create `TaskActivity` entity:
   ```dart
   class TaskActivity {
     final String id;
     final String taskId;
     final String action;
     final String userId;
     final DateTime timestamp;
     final Map<String, dynamic>? details;
   }
   ```

3. Log activities for:
   - Task created
   - Task updated
   - Status changed
   - Priority changed
   - Assignee changed
   - Description updated
   - Tags added/removed
   - Checklist item added/completed
   - Attachment added/removed
   - Comment added

**Expected Results**:
- ✅ Activity log service exists
- ✅ Activities are logged for all changes
- ✅ Activity log can be retrieved

**Test Criteria**:
- Unit test: Test activity logging
- Test: Verify activities are logged correctly

---

### Task 26: Integrate Activity Logging with Task Operations

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Integrate activity logging with all task operations.

**Files to Modify**:
- `lib/features/tasks/presentation/controllers/task_controller.dart`
- Other task controllers

**Implementation Steps**:
1. Inject `TaskActivityLogService` into controllers

2. Log activity for each operation:
   ```dart
   Future<void> createTask(...) async {
     // Create task
     await _activityLogService.logActivity(
       workspaceId: workspaceId,
       taskId: task.id,
       action: 'created',
       userId: currentUser.id,
     );
   }
   
   Future<void> updateTaskStatus(...) async {
     // Update status
     await _activityLogService.logActivity(
       workspaceId: workspaceId,
       taskId: task.id,
       action: 'status_changed',
       userId: currentUser.id,
       details: {
         'from': oldStatus.value,
         'to': newStatus.value,
       },
     );
   }
   ```

3. Log activities for all changes:
   - Status changes
   - Priority changes
   - Assignee changes
   - Description updates
   - Tag changes
   - Checklist changes
   - Attachment changes

**Expected Results**:
- ✅ Activities are logged for all operations
- ✅ Activity details are accurate
- ✅ Activity logging doesn't slow down operations

**Test Criteria**:
- Test: Verify activities are logged
- Test: Verify activity details are correct

---

### Task 27: Create Task Activity Log Widget

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI widget for displaying task activity log.

**Files to Create**:
- `lib/app/widgets/task_activity_log_widget.dart` (new file)

**Implementation Steps**:
1. Create `TaskActivityLogWidget`:
   ```dart
   class TaskActivityLogWidget extends StatelessWidget {
     final String taskId;
     
     @override
     Widget build(BuildContext context) {
       return GetBuilder<TaskActivityController>(
         builder: (controller) => Column(
           children: [
             _buildActivityList(controller),
           ],
         ),
       );
     }
   }
   ```

2. Add activity list:
   - Activity items with:
     - Action icon/indicator
     - Action description (e.g., "Status changed from 'Pending' to 'In Progress'")
     - User name
     - Timestamp
   - Order activities by timestamp (newest first or oldest first)

3. Format activity descriptions:
   - "Task created by [User]"
   - "Status changed from '[Old]' to '[New]' by [User]"
   - "Assigned to [User] by [User]"
   - "Priority changed from '[Old]' to '[New]' by [User]"
   - etc.

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Activity log widget exists
- ✅ Activities are displayed correctly
- ✅ Activity descriptions are formatted nicely
- ✅ UI follows project rules

**Test Criteria**:
- Widget test: Test activity log widget
- Manual test: View activity log

---

### Task 28: Add Activity Log to Task Detail UI

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add activity log widget to task detail page.

**Files to Modify**:
- `lib/app/pages/tasks/task_detail_page.dart`

**Implementation Steps**:
1. Add activity log widget to task detail:
   ```dart
   TaskActivityLogWidget(taskId: task.id)
   ```

2. Add "Activity" tab or section

3. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Activity log is displayed in task detail
- ✅ All task activities are shown
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: View activity log in task detail
- Test: Verify activities are loaded

---

### Task 29: Add Tag Filter to Task List

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add tag filter to task list (requires tags feature to be implemented first).

**Files to Modify**:
- `lib/app/pages/tasks/task_list_page.dart`
- `lib/features/tasks/presentation/controllers/task_controller.dart`

**Implementation Steps**:
1. Add tag filter dropdown to task list UI

2. Update controller to filter by tags:
   ```dart
   Future<List<TaskEntity>> getTasks({
     List<String>? tags, // Add tag filter
   }) async {
     // Filter tasks by tags
   }
   ```

3. Update Firebase query to filter by tags (if supported)

**Expected Results**:
- ✅ Tag filter exists
- ✅ Tasks can be filtered by tags
- ✅ Filter works correctly

**Test Criteria**:
- Manual test: Filter tasks by tags
- Test: Verify filter works

---

### Task 30: Add Unit Tests

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for all new features.

**Files to Create**:
- `test/features/tasks/domain/entities/task_test.dart` (update)
- `test/features/tasks/domain/entities/checklist_item_test.dart`
- `test/features/tasks/domain/entities/attachment_test.dart`
- `test/features/tasks/domain/entities/comment_test.dart`
- `test/features/tasks/presentation/controllers/task_controller_test.dart` (update)
- `test/features/tasks/presentation/controllers/comment_controller_test.dart`
- Other test files

**Implementation Steps**:
1. Test enum usage in TaskEntity
2. Test tags functionality
3. Test checklist functionality
4. Test attachments functionality
5. Test updater tracking
6. Test comments functionality
7. Test activity logging

**Expected Results**:
- ✅ Unit tests cover all features
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Update TaskEntity to Use Enums (Critical - Foundation)
2. **Task 2**: Update Task Controllers to Use Enums (High Priority - Business Logic)
3. **Task 3**: Update Task UI to Use Enums (High Priority - UI)
4. **Task 4**: Add Tags Field to TaskEntity (High Priority - Foundation)
5. **Task 5**: Create Tag Input Widget (Medium Priority - UI)
6. **Task 6**: Add Tags to Task Edit UI (Medium Priority - UI)
7. **Task 7**: Create ChecklistItem Entity (High Priority - Foundation)
8. **Task 8**: Add Checklist Field to TaskEntity (High Priority - Foundation)
9. **Task 9**: Create Checklist Widget (Medium Priority - UI)
10. **Task 10**: Add Checklist to Task Edit UI (Medium Priority - UI)
11. **Task 11**: Create Attachment Entity (High Priority - Foundation)
12. **Task 12**: Add Attachments Field to TaskEntity (High Priority - Foundation)
13. **Task 13**: Create File Upload Service (High Priority - Service)
14. **Task 14**: Create Attachments Widget (Medium Priority - UI)
15. **Task 15**: Add Attachments to Task Edit UI (Medium Priority - UI)
16. **Task 16**: Add Updater Field to TaskEntity (Medium Priority - Foundation)
17. **Task 17**: Update Task Controllers to Track Updater (Medium Priority - Business Logic)
18. **Task 18**: Display Updater in Task UI (Low Priority - UI)
19. **Task 19**: Create Comment Entity (High Priority - Foundation)
20. **Task 20**: Create Comment Repository (High Priority - Data Layer)
21. **Task 21**: Create Comment Use Cases (High Priority - Business Logic)
22. **Task 22**: Create Comment Controller (High Priority - Controller Layer)
23. **Task 23**: Create Comments Widget (Medium Priority - UI)
24. **Task 24**: Add Comments to Task Detail UI (Medium Priority - UI)
25. **Task 25**: Create Task Activity Log Service (High Priority - Service)
26. **Task 26**: Integrate Activity Logging with Task Operations (Medium Priority - Integration)
27. **Task 27**: Create Task Activity Log Widget (Medium Priority - UI)
28. **Task 28**: Add Activity Log to Task Detail UI (Low Priority - UI)
29. **Task 29**: Add Tag Filter to Task List (Low Priority - Enhancement)
30. **Task 30**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ TaskEntity uses enums for status/priority/type
- ✅ Tags field exists and works
- ✅ Checklist field exists and works
- ✅ Attachments field exists and works
- ✅ Updater tracking exists and works
- ✅ Comments functionality exists and works
- ✅ Activity log exists and works
- ✅ All UI follows project rules (TD widgets, AppStrings, GetX)
- ✅ Unit tests have minimum 80% coverage
- ✅ No known bugs or issues

---

## Dependencies

- **TaskEntity**: Base entity for all changes
- **task_enums.dart**: Must use enums from this file
- **Firebase Realtime Database**: Required for storing tasks, comments, activity logs
- **Firebase Storage**: Required for storing attachments
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **NavigationService**: Must use NavigationService for navigation
- **SnackbarService**: Must use SnackbarService for notifications

---

## Notes

1. **Enum Enforcement**: `task_enums.dart` already exists with `TaskStatus`, `TaskPriority`, and `TaskType` enums. Need to update `TaskEntity` and all related code to use these enums instead of strings.

2. **Tags**: Simple string array for now. Can be enhanced later with tag colors, categories, etc.

3. **Checklist**: Each item has text, completion status, and order. Progress is calculated as completed/total.

4. **Attachments**: Files are stored in Firebase Storage. Attachment metadata (name, size, type, URL) is stored in task entity.

5. **Updater Tracking**: Track who last updated the task. This is separate from creator (assigner) and assignee.

6. **Comments**: Comments are stored separately from tasks (in comments collection). Each comment has author, text, timestamp, and supports editing.

7. **Activity Log**: Task-specific activity log (separate from conflict resolution ActivityLog). Logs all changes to tasks with user and timestamp.

8. **Migration**: When implementing enums, existing tasks with string status/priority/type need to be migrated to enum values. This can be done during fromMap conversion.

---

## Related Documentation

- `TASKS_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `TASK_CRUD_DETAILS_TEST_CASES.md` - Test cases for this feature
- `docs/v1/feature_checklists/tasks/tasks.md` - Task requirements
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
