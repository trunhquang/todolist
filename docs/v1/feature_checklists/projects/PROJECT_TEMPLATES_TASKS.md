# Project Templates (Predefined Task Sets) - Task List & Expected Results

## Overview
This document lists all tasks required to complete the **Project Templates (Predefined Task Sets)** feature. Currently, this feature is **MISSING** - no project template entity/UI exists, and projects cannot be created from templates with predefined tasks.

## Current Status: ⛔ MISSING

### What Exists:
- ✅ `Project` entity exists - projects can be created
- ✅ `TaskEntity` exists - tasks can be created
- ✅ Project repository exists - can manage projects
- ✅ Task repository exists - can manage tasks

### What's Missing/Broken:
- ⛔ No `ProjectTemplate` entity - no template data structure
- ⛔ No template task definitions - no predefined task sets
- ⛔ No template repository - cannot store/retrieve templates
- ⛔ No template CRUD operations - cannot create/edit/delete templates
- ⛔ No template UI - no UI to manage templates
- ⛔ No "create from template" flow - cannot create projects from templates
- ⛔ No template customization - cannot customize templates when creating projects
- ⛔ No template sharing - cannot share templates with other users/workspaces
- ⛔ No default templates - no system-provided templates

---

## Task List

### Task 1: Create ProjectTemplate Entity

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create `ProjectTemplate` entity to represent project templates with predefined tasks.

**Files to Create**:
- `lib/features/tasks/domain/entities/project_template.dart` (new file)

**Implementation Steps**:
1. Create `ProjectTemplate` entity:
   ```dart
   class ProjectTemplate {
     final String id;
     final String? workspaceId; // null for global templates
     final String title;
     final String? description;
     final String? category; // e.g., "Software Development", "Marketing"
     final TemplateVisibility visibility; // workspace, global, private
     final List<TemplateTask> tasks; // Predefined tasks
     final String createdBy;
     final DateTime createdAt;
     final DateTime? updatedAt;
     final int usageCount; // Number of times used
     final DateTime? lastUsedAt;
     final bool isDefault; // System-provided default template
     
     const ProjectTemplate({
       required this.id,
       required this.title,
       required this.visibility,
       required this.tasks,
       required this.createdBy,
       required this.createdAt,
       this.workspaceId,
       this.description,
       this.category,
       this.updatedAt,
       this.usageCount = 0,
       this.lastUsedAt,
       this.isDefault = false,
     });
   }
   ```

2. Create `TemplateTask` class:
   ```dart
   class TemplateTask {
     final String id;
     final String title;
     final String? description;
     final String priority; // low, medium, high, urgent
     final String? assigneeId; // Default assignee (optional)
     final DateTime? deadline; // Relative or absolute deadline
     final String? parentTaskId; // For task dependencies
     final int order; // Task order in template
     final List<String>? tags; // Task tags
     
     const TemplateTask({
       required this.id,
       required this.title,
       required this.priority,
       required this.order,
       this.description,
       this.assigneeId,
       this.deadline,
       this.parentTaskId,
       this.tags,
     });
   }
   ```

3. Create `TemplateVisibility` enum:
   ```dart
   enum TemplateVisibility {
     workspace('workspace'),
     global('global'),
     private('private');
     
     const TemplateVisibility(this.value);
     final String value;
     
     static TemplateVisibility fromString(String value) {
       return TemplateVisibility.values.firstWhere(
         (v) => v.value == value,
         orElse: () => TemplateVisibility.private,
       );
     }
   }
   ```

4. Add `fromMap` and `toMap` methods

5. Add `copyWith` method

**Expected Results**:
- ✅ ProjectTemplate entity exists
- ✅ TemplateTask class exists
- ✅ TemplateVisibility enum exists
- ✅ Entity supports all required fields
- ✅ Entity is serializable

**Test Criteria**:
- Unit test: Test entity creation
- Test: Verify entity serialization
- Test: Verify template task structure

---

### Task 2: Create TemplateRepository

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create repository interface and implementation for template operations.

**Files to Create**:
- `lib/features/tasks/domain/repositories/template_repository.dart` (new file)
- `lib/features/tasks/data/repositories/template_repository_impl.dart` (new file)

**Implementation Steps**:
1. Create `TemplateRepository` interface:
   ```dart
   abstract class TemplateRepository {
     Future<ProjectTemplate?> getTemplate({
       required String templateId,
       String? workspaceId, // For workspace-specific templates
     });
     
     Future<List<ProjectTemplate>> getTemplates({
       String? workspaceId, // Filter by workspace
       String? category, // Filter by category
       bool includeGlobal = true, // Include global templates
     });
     
     Future<List<ProjectTemplate>> getDefaultTemplates();
     
     Future<ProjectTemplate> createTemplate({
       required String? workspaceId,
       required ProjectTemplate template,
     });
     
     Future<ProjectTemplate> updateTemplate({
       required String? workspaceId,
       required ProjectTemplate template,
     });
     
     Future<void> deleteTemplate({
       required String? workspaceId,
       required String templateId,
     });
     
     Future<void> incrementUsageCount({
       required String templateId,
     });
   }
   ```

2. Implement in `TemplateRepositoryImpl`:
   - Use `FirebaseDatabaseService` to store/retrieve templates
   - Store in path: `templates/{templateId}` (global) or `workspaces/{workspaceId}/templates/{templateId}` (workspace)
   - Support filtering by workspace, category, visibility

**Expected Results**:
- ✅ Repository interface exists
- ✅ Repository implementation exists
- ✅ All CRUD operations work correctly
- ✅ Filtering works correctly

**Test Criteria**:
- Unit test: Test repository methods
- Integration test: Test with Firebase
- Test: Verify filtering works

---

### Task 3: Create Create Template Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case to create a project template.

**Files to Create**:
- `lib/features/tasks/domain/usecases/create_template.dart` (new file)

**Implementation Steps**:
1. Create `CreateTemplate` use case:
   ```dart
   class CreateTemplate {
     final TemplateRepository _repository;
     
     CreateTemplate(this._repository);
     
     Future<Either<Failure, ProjectTemplate>> call({
       required String? workspaceId,
       required String title,
       String? description,
       String? category,
       required TemplateVisibility visibility,
       required List<TemplateTask> tasks,
       required String createdBy,
     }) async {
       // 1. Validate template title is not empty
       // 2. Validate tasks list is not empty
       // 3. Validate visibility permissions (global requires admin)
       // 4. Create ProjectTemplate entity
       // 5. Save to repository
       // 6. Return created template
     }
   }
   ```

2. Add validation:
   - Title must not be empty
   - Tasks list must not be empty
   - Visibility permissions (global templates require admin permission)

3. Handle errors appropriately

**Expected Results**:
- ✅ Use case exists
- ✅ Validation works correctly
- ✅ Template is created
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test create template
- Test: Verify validation works
- Test: Verify template is created

---

### Task 4: Create Update Template Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case to update a project template.

**Files to Create**:
- `lib/features/tasks/domain/usecases/update_template.dart` (new file)

**Implementation Steps**:
1. Create `UpdateTemplate` use case similar to `CreateTemplate`

2. Add validation:
   - Template must exist
   - User must have permission (creator or admin)
   - Title must not be empty
   - Tasks list must not be empty
   - Default templates cannot be updated (if applicable)

3. Handle errors appropriately

**Expected Results**:
- ✅ Use case exists
- ✅ Validation works correctly
- ✅ Template is updated
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test update template
- Test: Verify validation works
- Test: Verify template is updated

---

### Task 5: Create Delete Template Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case to delete a project template.

**Files to Create**:
- `lib/features/tasks/domain/usecases/delete_template.dart` (new file)

**Implementation Steps**:
1. Create `DeleteTemplate` use case:
   ```dart
   class DeleteTemplate {
     final TemplateRepository _repository;
     
     DeleteTemplate(this._repository);
     
     Future<Either<Failure, void>> call({
       required String? workspaceId,
       required String templateId,
     }) async {
       // 1. Get template
       // 2. Validate user has permission (creator or admin)
       // 3. Validate template is not default (if applicable)
       // 4. Delete template
       // 5. Return success
     }
   }
   ```

2. Add validation:
   - Template must exist
   - User must have permission (creator or admin)
   - Default templates cannot be deleted

3. Handle errors appropriately

**Expected Results**:
- ✅ Use case exists
- ✅ Template is deleted
- ✅ Default templates cannot be deleted
- ✅ Error handling is robust

**Test Criteria**:
- Unit test: Test delete template
- Test: Verify default templates cannot be deleted
- Test: Verify template is deleted

---

### Task 6: Create Create Project from Template Use Case

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create use case to create a project from a template with predefined tasks.

**Files to Create**:
- `lib/features/tasks/domain/usecases/create_project_from_template.dart` (new file)

**Implementation Steps**:
1. Create `CreateProjectFromTemplate` use case:
   ```dart
   class CreateProjectFromTemplate {
     final TemplateRepository _templateRepository;
     final ProjectRepository _projectRepository;
     final TaskRepository _taskRepository;
     
     CreateProjectFromTemplate(
       this._templateRepository,
       this._projectRepository,
       this._taskRepository,
     );
     
     Future<Either<Failure, Project>> call({
       required String workspaceId,
       required String templateId,
       required String projectTitle,
       String? projectDescription,
       DateTime? projectDeadline,
       String createdBy,
       List<TemplateTask>? customizedTasks, // Optional customization
     }) async {
       // 1. Get template
       // 2. Validate template exists
       // 3. Validate template is accessible (workspace/global)
       // 4. Create project
       // 5. Create tasks from template tasks (or customized tasks)
       // 6. Link tasks to project
       // 7. Increment template usage count
       // 8. Return created project
     }
   }
   ```

2. Add task creation logic:
   - Convert `TemplateTask` to `TaskEntity`
   - Set projectId for all tasks
   - Set assignee if provided in template
   - Set deadline if provided in template
   - Preserve task dependencies (parentTaskId)
   - Preserve task order

3. Handle errors appropriately

**Expected Results**:
- ✅ Use case exists
- ✅ Project is created from template
- ✅ Predefined tasks are created
- ✅ Tasks are linked to project
- ✅ Template usage count is incremented

**Test Criteria**:
- Unit test: Test create project from template
- Test: Verify tasks are created
- Test: Verify usage count is incremented

---

### Task 7: Create Get Templates Use Case

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create use case to get templates with filtering.

**Files to Create**:
- `lib/features/tasks/domain/usecases/get_templates.dart` (new file)

**Implementation Steps**:
1. Create `GetTemplates` use case:
   ```dart
   class GetTemplates {
     final TemplateRepository _repository;
     
     GetTemplates(this._repository);
     
     Future<Either<Failure, List<ProjectTemplate>>> call({
       required String? workspaceId,
       String? category,
       bool includeGlobal = true,
       bool includeDefault = true,
     }) async {
       // 1. Get templates from repository
       // 2. Filter by workspace (if provided)
       // 3. Filter by category (if provided)
       // 4. Include global templates (if enabled)
       // 5. Include default templates (if enabled)
       // 6. Return filtered templates
     }
   }
   ```

2. Add filtering logic:
   - Filter by workspace
   - Filter by category
   - Include/exclude global templates
   - Include/exclude default templates

3. Handle errors appropriately

**Expected Results**:
- ✅ Use case exists
- ✅ Filtering works correctly
- ✅ Templates are returned correctly

**Test Criteria**:
- Unit test: Test get templates
- Test: Verify filtering works
- Test: Verify global templates are included

---

### Task 8: Create TemplateController

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create GetX controller for managing templates.

**Files to Create**:
- `lib/features/tasks/presentation/controllers/template_controller.dart` (new file)

**Implementation Steps**:
1. Create `TemplateController`:
   ```dart
   class TemplateController extends GetxController {
     final TemplateRepository _templateRepository;
     final GetTemplates _getTemplates;
     final CreateTemplate _createTemplate;
     final UpdateTemplate _updateTemplate;
     final DeleteTemplate _deleteTemplate;
     final CreateProjectFromTemplate _createProjectFromTemplate;
     
     final RxList<ProjectTemplate> _templates = <ProjectTemplate>[].obs;
     final RxList<ProjectTemplate> _defaultTemplates = <ProjectTemplate>[].obs;
     final RxString _selectedCategory = ''.obs;
     final RxString _searchQuery = ''.obs;
     final RxBool _isLoading = false.obs;
     
     List<ProjectTemplate> get templates => _templates.toList();
     List<ProjectTemplate> get defaultTemplates => _defaultTemplates.toList();
     bool get isLoading => _isLoading.value;
     
     Future<void> loadTemplates({String? category}) async {
       // Load templates with filtering
     }
     
     Future<void> loadDefaultTemplates() async {
       // Load default templates
     }
     
     Future<void> createTemplate({/* ... */}) async {
       // Create template with permission check
     }
     
     Future<void> updateTemplate(ProjectTemplate template) async {
       // Update template with permission check
     }
     
     Future<void> deleteTemplate(String templateId) async {
       // Delete template with permission check
     }
     
     Future<Project?> createProjectFromTemplate({
       required String templateId,
       required String projectTitle,
       /* ... */
     }) async {
       // Create project from template
     }
     
     List<ProjectTemplate> getFilteredTemplates() {
       // Filter templates by category and search query
     }
   }
   ```

2. Add permission checks to all methods

3. Add error handling

4. Add filtering logic

**Expected Results**:
- ✅ Controller exists
- ✅ Permission checks are enforced
- ✅ Error handling is robust
- ✅ Filtering works correctly

**Test Criteria**:
- Unit test: Test controller methods
- Test: Verify permission checks
- Test: Verify error handling
- Test: Verify filtering

---

### Task 9: Create Template List UI

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create UI for viewing and selecting templates.

**Files to Create**:
- `lib/app/pages/projects/template_list_page.dart` (new file)

**Implementation Steps**:
1. Create `TemplateListPage`:
   ```dart
   class TemplateListPage extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       return GetBuilder<TemplateController>(
         builder: (controller) => Scaffold(
           appBar: TDAppBar(
             title: AppStrings.projectTemplates,
           ),
           body: Column(
             children: [
               _buildSearchBar(controller),
               _buildCategoryFilter(controller),
               _buildTemplatesList(controller),
             ],
           ),
         ),
       );
     }
   }
   ```

2. Add search bar:
   - Search field for template name/description
   - Real-time search filtering

3. Add category filter:
   - Dropdown or chips for categories
   - "All" option

4. Add templates list:
   - Template cards with:
     - Template name
     - Description
     - Category badge
     - Task count
     - Usage count (if applicable)
     - Visibility indicator
     - Preview button
     - Use template button

5. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Template list page exists
- ✅ Search works correctly
- ✅ Category filter works correctly
- ✅ Templates are displayed correctly
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: View templates
- Test: Verify search works
- Test: Verify category filter works

---

### Task 10: Create Template Preview UI

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI for previewing template tasks before creating project.

**Files to Create**:
- `lib/app/pages/projects/template_preview_page.dart` (new file)

**Implementation Steps**:
1. Create `TemplatePreviewPage`:
   ```dart
   class TemplatePreviewPage extends StatelessWidget {
     final ProjectTemplate template;
     
     @override
     Widget build(BuildContext context) {
       return Scaffold(
         appBar: TDAppBar(
           title: AppStrings.templatePreview,
         ),
         body: Column(
           children: [
             _buildTemplateInfo(),
             _buildTasksList(),
             _buildActions(),
           ],
         ),
       );
     }
   }
   ```

2. Add template information section:
   - Template name
   - Description
   - Category
   - Task count
   - Estimated time

3. Add tasks list:
   - List of template tasks
   - Task details (title, description, priority, assignee, deadline)
   - Task dependencies (if applicable)

4. Add action buttons:
   - "Use Template" button
   - "Cancel" button

5. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Template preview page exists
- ✅ Template information is displayed
- ✅ Tasks are displayed correctly
- ✅ Actions work correctly
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Preview template
- Test: Verify template information is displayed
- Test: Verify tasks are displayed

---

### Task 11: Create Create Project from Template UI

**Priority**: High  
**Status**: ⚠️ Not Started

**Description**:
Create UI for creating project from template with customization options.

**Files to Create/Modify**:
- `lib/app/pages/projects/create_project_from_template_page.dart` (new file)
- `lib/app/pages/projects/project_list_page.dart` (modify - add "Create from Template" option)

**Implementation Steps**:
1. Create `CreateProjectFromTemplatePage`:
   ```dart
   class CreateProjectFromTemplatePage extends StatelessWidget {
     final ProjectTemplate template;
     
     @override
     Widget build(BuildContext context) {
       return GetBuilder<TemplateController>(
         builder: (controller) => Scaffold(
           appBar: TDAppBar(
             title: AppStrings.createProjectFromTemplate,
           ),
           body: Column(
             children: [
               _buildProjectForm(),
               _buildTasksSection(controller),
               _buildActions(controller),
             ],
           ),
         ),
       );
     }
   }
   ```

2. Add project form:
   - Project name field (pre-filled with template name or editable)
   - Project description field (pre-filled with template description or editable)
   - Deadline field (optional)

3. Add tasks section:
   - List of template tasks
   - Customize tasks toggle/button
   - Task editing (if customization enabled)
   - Add/remove tasks (if customization enabled)

4. Add action buttons:
   - "Create Project" button
   - "Cancel" button

5. Integrate with `CreateProjectFromTemplate` use case

6. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Create project from template page exists
- ✅ Project form works correctly
- ✅ Tasks can be customized
- ✅ Project is created successfully
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Create project from template
- Test: Verify project is created
- Test: Verify tasks are created
- Test: Verify customization works

---

### Task 12: Create Template Management UI

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create UI for managing templates (create, edit, delete).

**Files to Create**:
- `lib/app/pages/projects/template_management_page.dart` (new file)

**Implementation Steps**:
1. Create `TemplateManagementPage`:
   ```dart
   class TemplateManagementPage extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       return GetBuilder<TemplateController>(
         builder: (controller) => Scaffold(
           appBar: TDAppBar(
             title: AppStrings.manageTemplates,
           ),
           body: Column(
             children: [
               _buildCreateTemplateButton(controller),
               _buildTemplatesList(controller),
             ],
           ),
         ),
       );
     }
   }
   ```

2. Add create template button:
   - "Create Template" button
   - Navigate to create template page

3. Add templates list:
   - List of user's templates
   - Edit button for each template
   - Delete button for each template
   - Usage statistics (if applicable)

4. Add create template page:
   - Template form (name, description, category, visibility)
   - Tasks editor (add/edit/remove tasks)
   - Save/Cancel buttons

5. Add edit template page:
   - Similar to create template page
   - Pre-filled with template data

6. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Template management page exists
- ✅ Templates can be created
- ✅ Templates can be edited
- ✅ Templates can be deleted
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Create template
- Test: Edit template
- Test: Delete template

---

### Task 13: Create Template from Existing Project Use Case

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create use case to create a template from an existing project.

**Files to Create**:
- `lib/features/tasks/domain/usecases/create_template_from_project.dart` (new file)

**Implementation Steps**:
1. Create `CreateTemplateFromProject` use case:
   ```dart
   class CreateTemplateFromProject {
     final TemplateRepository _templateRepository;
     final ProjectRepository _projectRepository;
     final TaskRepository _taskRepository;
     
     CreateTemplateFromProject(
       this._templateRepository,
       this._projectRepository,
       this._taskRepository,
     );
     
     Future<Either<Failure, ProjectTemplate>> call({
       required String workspaceId,
       required String projectId,
       required String templateTitle,
       String? templateDescription,
       String? category,
       required TemplateVisibility visibility,
       required String createdBy,
       List<String>? taskIds, // Optional: specific tasks to include
     }) async {
       // 1. Get project
       // 2. Get project tasks (or specific tasks if taskIds provided)
       // 3. Convert tasks to TemplateTask
       // 4. Create ProjectTemplate entity
       // 5. Save template to repository
       // 6. Return created template
     }
   }
   ```

2. Add task conversion logic:
   - Convert `TaskEntity` to `TemplateTask`
   - Preserve task details (title, description, priority, assignee, deadline)
   - Preserve task dependencies (parentTaskId)
   - Preserve task order

3. Handle errors appropriately

**Expected Results**:
- ✅ Use case exists
- ✅ Template is created from project
- ✅ Tasks are converted correctly
- ✅ Template is saved

**Test Criteria**:
- Unit test: Test create template from project
- Test: Verify tasks are converted
- Test: Verify template is created

---

### Task 14: Add Create Template from Project UI

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Add UI option to create template from existing project.

**Files to Modify**:
- `lib/app/pages/projects/project_detail_page.dart` (modify)
- `lib/features/tasks/presentation/pages/project_detail_page.dart` (modify)

**Implementation Steps**:
1. Add "Create Template" button to project detail page:
   - In project actions menu
   - Or in project settings

2. Create template creation dialog/page:
   - Template name field
   - Template description field
   - Category selector
   - Visibility selector
   - Tasks selection (which tasks to include)
   - Create/Cancel buttons

3. Integrate with `CreateTemplateFromProject` use case

4. Use TD widgets and AppStrings

**Expected Results**:
- ✅ Create template option exists in project detail
- ✅ Template creation dialog/page works
- ✅ Template is created from project
- ✅ UI follows project rules

**Test Criteria**:
- Manual test: Create template from project
- Test: Verify template is created
- Test: Verify tasks are included

---

### Task 15: Add Default Templates

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Create default/system templates for common use cases.

**Files to Create/Modify**:
- `lib/core/constants/default_templates.dart` (new file)
- `lib/features/tasks/data/repositories/template_repository_impl.dart` (modify - add default templates)

**Implementation Steps**:
1. Create default templates:
   ```dart
   class DefaultTemplates {
     static List<ProjectTemplate> getTemplates() {
       return [
         _createEmptyProjectTemplate(),
         _createSoftwareDevelopmentTemplate(),
         _createMarketingCampaignTemplate(),
         _createHROnboardingTemplate(),
         // ... more templates
       ];
     }
     
     static ProjectTemplate _createEmptyProjectTemplate() {
       return ProjectTemplate(
         id: 'default_empty',
         title: 'Empty Project',
         description: 'Start with a blank project',
         visibility: TemplateVisibility.global,
         tasks: [],
         createdBy: 'system',
         createdAt: DateTime.now(),
         isDefault: true,
       );
     }
     
     static ProjectTemplate _createSoftwareDevelopmentTemplate() {
       return ProjectTemplate(
         id: 'default_software_dev',
         title: 'Software Development - Sprint Planning',
         description: 'Template for software development sprint planning',
         category: 'Software Development',
         visibility: TemplateVisibility.global,
         tasks: [
           TemplateTask(
             id: 'task_1',
             title: 'Sprint Planning Meeting',
             description: 'Plan sprint goals and tasks',
             priority: 'high',
             order: 1,
           ),
           TemplateTask(
             id: 'task_2',
             title: 'Create User Stories',
             description: 'Write user stories for sprint',
             priority: 'high',
             order: 2,
           ),
           // ... more tasks
         ],
         createdBy: 'system',
         createdAt: DateTime.now(),
         isDefault: true,
       );
     }
   }
   ```

2. Add default templates to repository:
   - Return default templates when requested
   - Default templates are read-only

3. Create templates for common categories:
   - Software Development
   - Marketing
   - HR
   - Sales
   - Operations

**Expected Results**:
- ✅ Default templates exist
- ✅ Default templates are available
- ✅ Default templates cannot be deleted
- ✅ Default templates are useful

**Test Criteria**:
- Test: Verify default templates are available
- Test: Verify default templates cannot be deleted
- Manual test: Use default templates

---

### Task 16: Add Template Categories

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add support for template categories and category management.

**Files to Create/Modify**:
- `lib/core/constants/template_categories.dart` (new file)
- `lib/app/pages/projects/template_list_page.dart` (modify - add category filter)

**Implementation Steps**:
1. Create template categories:
   ```dart
   class TemplateCategories {
     static const String softwareDevelopment = 'Software Development';
     static const String marketing = 'Marketing';
     static const String hr = 'HR';
     static const String sales = 'Sales';
     static const String operations = 'Operations';
     static const String custom = 'Custom';
     
     static List<String> getAll() {
       return [
         softwareDevelopment,
         marketing,
         hr,
         sales,
         operations,
         custom,
       ];
     }
   }
   ```

2. Add category to AppStrings

3. Add category filter to template list UI

4. Add category selector to template creation/edit UI

**Expected Results**:
- ✅ Template categories exist
- ✅ Categories are displayed in UI
- ✅ Category filter works
- ✅ Categories are in AppStrings

**Test Criteria**:
- Test: Verify categories are available
- Test: Verify category filter works

---

### Task 17: Add Template Sharing

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add support for sharing templates with other users/workspaces.

**Files to Create/Modify**:
- `lib/features/tasks/domain/usecases/share_template.dart` (new file)
- `lib/app/pages/projects/template_management_page.dart` (modify - add share option)

**Implementation Steps**:
1. Create `ShareTemplate` use case:
   ```dart
   class ShareTemplate {
     final TemplateRepository _repository;
     
     ShareTemplate(this._repository);
     
     Future<Either<Failure, void>> call({
       required String templateId,
       required String? workspaceId,
       required TemplateVisibility newVisibility,
       List<String>? userIds, // For private sharing
     }) async {
       // 1. Get template
       // 2. Validate user has permission
       // 3. Update template visibility
       // 4. Save template
       // 5. Return success
     }
   }
   ```

2. Add share UI:
   - Share button in template management
   - Share dialog with options:
     - Share with workspace
     - Share globally (if user has permission)
     - Share with specific users (if applicable)

3. Update template visibility based on sharing

**Expected Results**:
- ✅ Template sharing use case exists
- ✅ Share UI exists
- ✅ Templates can be shared
- ✅ Sharing works correctly

**Test Criteria**:
- Test: Share template with workspace
- Test: Share template globally
- Test: Verify sharing works

---

### Task 18: Add Template Usage Statistics

**Priority**: Low  
**Status**: ⚠️ Not Started

**Description**:
Add tracking and display of template usage statistics.

**Files to Modify**:
- `lib/features/tasks/domain/repositories/template_repository.dart` (modify - add incrementUsageCount)
- `lib/app/pages/projects/template_list_page.dart` (modify - display statistics)

**Implementation Steps**:
1. Add usage tracking:
   - Increment usage count when template is used
   - Update lastUsedAt timestamp

2. Display statistics in UI:
   - Usage count in template card
   - Last used date (if applicable)
   - Popularity indicator (if applicable)

3. Add sorting by popularity:
   - Sort templates by usage count

**Expected Results**:
- ✅ Usage statistics are tracked
- ✅ Statistics are displayed
- ✅ Sorting by popularity works

**Test Criteria**:
- Test: Verify usage count increments
- Test: Verify statistics are displayed

---

### Task 19: Add Unit Tests for Templates

**Priority**: Medium  
**Status**: ⚠️ Not Started

**Description**:
Write comprehensive unit tests for templates functionality.

**Files to Create**:
- `test/features/tasks/domain/entities/project_template_test.dart`
- `test/features/tasks/domain/usecases/create_template_test.dart`
- `test/features/tasks/domain/usecases/create_project_from_template_test.dart`
- `test/features/tasks/presentation/controllers/template_controller_test.dart`

**Implementation Steps**:
1. Test `ProjectTemplate` entity
2. Test use cases (create, update, delete, create from template)
3. Test controller methods
4. Test template task conversion

**Expected Results**:
- ✅ Unit tests cover templates
- ✅ Test coverage meets minimum 80% requirement
- ✅ All tests pass

**Test Criteria**:
- Run `flutter test`
- Verify all tests pass
- Check test coverage report

---

## Implementation Priority Order

1. **Task 1**: Create ProjectTemplate Entity (Critical - Foundation)
2. **Task 2**: Create TemplateRepository (High Priority - Data Layer)
3. **Task 3**: Create Create Template Use Case (High Priority - Business Logic)
4. **Task 4**: Create Update Template Use Case (High Priority - Business Logic)
5. **Task 5**: Create Delete Template Use Case (High Priority - Business Logic)
6. **Task 6**: Create Create Project from Template Use Case (High Priority - Core Feature)
7. **Task 7**: Create Get Templates Use Case (Medium Priority - Business Logic)
8. **Task 8**: Create TemplateController (High Priority - Controller Layer)
9. **Task 9**: Create Template List UI (High Priority - UI)
10. **Task 10**: Create Template Preview UI (Medium Priority - UI)
11. **Task 11**: Create Create Project from Template UI (High Priority - UI)
12. **Task 13**: Create Template from Existing Project Use Case (Medium Priority - Feature Enhancement)
13. **Task 14**: Add Create Template from Project UI (Medium Priority - Feature Enhancement)
14. **Task 15**: Add Default Templates (Medium Priority - Feature Enhancement)
15. **Task 12**: Create Template Management UI (Medium Priority - UI)
16. **Task 16**: Add Template Categories (Low Priority - Enhancement)
17. **Task 17**: Add Template Sharing (Low Priority - Enhancement)
18. **Task 18**: Add Template Usage Statistics (Low Priority - Enhancement)
19. **Task 19**: Add Unit Tests (Medium Priority - Quality Assurance)

---

## Success Criteria

The feature is considered **COMPLETE** when:

- ✅ ProjectTemplate entity exists
- ✅ TemplateRepository exists
- ✅ Use cases exist for template CRUD and creating projects from templates
- ✅ Template list UI exists
- ✅ Projects can be created from templates
- ✅ Predefined tasks are created automatically
- ✅ Templates can be customized when creating projects
- ✅ Custom templates can be created from existing projects
- ✅ Default templates are available
- ✅ Unit tests have minimum 80% coverage
- ✅ All UI follows project rules (TD widgets, AppStrings, GetX)
- ✅ No known bugs or issues

---

## Dependencies

- **Project Entity**: Required for project creation
- **TaskEntity**: Required for task creation
- **TemplateRepository**: Required for template operations
- **Firebase Realtime Database**: Required for storing templates
- **GetX**: Required for state management (project rule)
- **TD Widgets**: Must use TD prefix widgets
- **AppStrings**: All text must use AppStrings constants
- **NavigationService**: Must use NavigationService for navigation
- **SnackbarService**: Must use SnackbarService for notifications

---

## Notes

1. **Template Purpose**: Templates are meant to speed up project creation by providing predefined task sets. This is especially useful for:
   - Common project types (software development, marketing campaigns)
   - Recurring projects (monthly reports, weekly sprints)
   - Standard workflows (onboarding, offboarding)

2. **Template Structure**: Templates should include:
   - Template metadata (name, description, category)
   - List of predefined tasks
   - Task details (title, description, priority, assignee, deadline)
   - Task dependencies (if applicable)
   - Template visibility (workspace/global/private)

3. **Template Visibility**: 
   - **Workspace**: Only visible in specific workspace
   - **Global**: Visible in all workspaces (requires admin permission)
   - **Private**: Only visible to creator

4. **Default Templates**: System should provide default templates for common use cases. These should be:
   - Read-only (cannot be edited or deleted)
   - Always available
   - Well-documented

5. **Template Customization**: When creating project from template, users should be able to:
   - Customize project details (name, description, deadline)
   - Customize tasks (add, remove, edit)
   - Keep or change default assignees
   - Adjust deadlines

6. **Template from Project**: Users should be able to create templates from existing projects. This allows:
   - Reusing successful project structures
   - Sharing workflows with team
   - Standardizing project setups

7. **Template Categories**: Categories help organize templates:
   - Software Development
   - Marketing
   - HR
   - Sales
   - Operations
   - Custom

8. **Template Sharing**: Templates can be shared:
   - Within workspace (workspace templates)
   - Globally (global templates)
   - With specific users (if implemented)

9. **Usage Statistics**: Tracking template usage helps:
   - Identify popular templates
   - Improve default templates
   - Understand user needs

10. **Migration**: When implementing, no migration needed. Templates are new feature.

---

## Related Documentation

- `PROJECTS_IMPLEMENTATION_AUDIT_REPORT.md` - Current implementation status
- `PROJECT_TEMPLATES_TEST_CASES.md` - Test cases for this feature
- `docs/v1/feature_checklists/projects/projects.md` - Project requirements
- `docs/v1/DEVELOPMENT_BLUEPRINT_V1.md` - Overall architecture
