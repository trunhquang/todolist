# Project Templates (Predefined Task Sets) - Test Cases

## Overview
This document contains step-by-step test cases for testing the **Project Templates (Predefined Task Sets)** feature. This feature is currently **MISSING** - no project template entity/UI exists, and projects cannot be created from templates with predefined tasks.

## Prerequisites
- User must be logged in
- Workspace should exist
- Device should have internet connection (for Firebase sync)

---

## Test Case 1: View Project Templates - Missing Feature

**Objective**: Verify project templates can be viewed (currently missing).

**Preconditions**:
- User is logged in
- Project templates exist (if implemented)
- View templates feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate "Create Project" button
3. Tap "Create Project" button
4. Verify one of the following:
   - **If NOT implemented**: "Create from Template" or "Templates" option is not available (this is expected - feature missing)
   - **If implemented**: "Create from Template" or "Templates" option appears
5. If implemented:
   - Tap "Create from Template" or "Templates" option
   - Verify templates list appears:
     - List of available templates
     - Template name
     - Template description
     - Template category/type (if applicable)
     - Number of predefined tasks
     - Template preview (if available)
     - Template icon/image (if available)
   - Verify templates are organized:
     - By category (e.g., Software Development, Marketing, HR)
     - By popularity (most used first)
     - By date (newest first)
     - Search/filter options
   - Verify template information is displayed:
     - Template name
     - Description
     - Task count
     - Estimated setup time
     - Template creator (if applicable)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: View project templates is NOT available (missing)
- ✅ **When implemented**: Project templates can be viewed
- ✅ Template information is displayed correctly
- ✅ Templates are organized logically

---

## Test Case 2: Create Project from Template - Missing Feature

**Objective**: Verify project can be created from a template with predefined tasks (currently missing).

**Preconditions**:
- User is logged in
- User has `createProject` permission
- Project template exists
- Create from template feature is implemented

**Steps**:
1. Navigate to Project List page
2. Tap "Create Project" button
3. Tap "Create from Template" option
4. Verify one of the following:
   - **If NOT implemented**: Template selection is not available (this is expected - feature missing)
   - **If implemented**: Template selection appears
5. If implemented:
   - Browse templates
   - Select a template (e.g., "Software Development - Sprint Planning")
   - Tap "Use Template" or "Create Project" button
   - Verify project creation form appears:
     - Project name field (pre-filled with template name or editable)
     - Project description field (pre-filled with template description or editable)
     - Deadline field (optional)
     - Template tasks preview (showing predefined tasks)
     - Customize tasks option (if available)
   - Review predefined tasks:
     - Verify tasks are listed
     - Verify task titles are shown
     - Verify task descriptions are shown (if available)
     - Verify task priorities are shown (if available)
     - Verify task assignees are shown (if available)
     - Verify task deadlines are shown (if available)
   - Customize project (if needed):
     - Edit project name
     - Edit project description
     - Adjust task details (if customization is allowed)
   - Tap "Create Project" button
   - Verify loading indicator appears
   - Wait for project creation to complete
   - Verify success message appears: "Project created successfully from template"
   - Verify project is created:
     - Project appears in project list
     - Project has correct name
     - Project has correct description
   - Verify predefined tasks are created:
     - Navigate to project tasks
     - Verify all template tasks are created
     - Verify task details match template:
       - Task titles match
       - Task descriptions match (if applicable)
       - Task priorities match (if applicable)
       - Task statuses are set to "pending" (default)
   - Verify project is saved to Firebase:
     - Check Firebase data
     - Verify project has correct workspaceId
     - Verify tasks are linked to project

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Create project from template is NOT available (missing)
- ✅ **When implemented**: Project can be created from template
- ✅ Predefined tasks are created
- ✅ Project and tasks are saved to Firebase

---

## Test Case 3: Preview Template Tasks - Missing Feature

**Objective**: Verify template tasks can be previewed before creating project (currently missing).

**Preconditions**:
- User is logged in
- Project template exists
- Template preview feature is implemented

**Steps**:
1. Navigate to Project List page
2. Tap "Create Project" button
3. Tap "Create from Template" option
4. Browse templates
5. Locate a template
6. Verify one of the following:
   - **If NOT implemented**: "Preview" option is not available (this is expected - feature missing)
   - **If implemented**: "Preview" button or option exists
7. If implemented:
   - Tap "Preview" button
   - Verify template preview appears:
     - Template information (name, description)
     - List of predefined tasks
     - Task details (title, description, priority, estimated time)
     - Task count
     - Estimated total time
   - Verify task list shows:
     - All tasks in template
     - Task order (if applicable)
     - Task grouping (if applicable)
   - Verify preview actions:
     - "Use Template" button
     - "Cancel" or "Close" button
   - Tap "Use Template":
     - Verify project creation form appears
     - Verify template tasks are pre-filled
   - Tap "Cancel":
     - Verify preview closes
     - Verify returns to template list

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Template preview is NOT available (missing)
- ✅ **When implemented**: Template tasks can be previewed
- ✅ Preview shows all template information
- ✅ Preview actions work correctly

---

## Test Case 4: Customize Template Tasks When Creating Project - Missing Feature

**Objective**: Verify template tasks can be customized when creating project from template (currently missing).

**Preconditions**:
- User is logged in
- User has `createProject` permission
- Project template exists
- Template customization feature is implemented

**Steps**:
1. Navigate to Project List page
2. Tap "Create Project" button
3. Tap "Create from Template" option
4. Select a template
5. Tap "Use Template" button
6. Verify one of the following:
   - **If NOT implemented**: Task customization is not available (this is expected - feature missing)
   - **If implemented**: Task customization options appear
7. If implemented:
   - Verify customization options:
     - "Customize Tasks" button or toggle
     - Task list with edit options
     - Add/remove tasks option
   - Enable task customization:
     - Tap "Customize Tasks" button
     - Verify task list becomes editable
   - Edit a task:
     - Tap on a task
     - Verify task edit form appears
     - Modify task title: "Updated Task Title"
     - Modify task description: "Updated description"
     - Modify task priority (if applicable)
     - Save task changes
     - Verify task is updated in list
   - Remove a task:
     - Tap "Remove" or "Delete" button on a task
     - Verify confirmation dialog appears
     - Confirm removal
     - Verify task is removed from list
   - Add a new task:
     - Tap "Add Task" button
     - Fill in task details
     - Save task
     - Verify task is added to list
   - Reorder tasks (if applicable):
     - Drag and drop tasks
     - Or use up/down arrows
     - Verify task order is updated
   - Create project with customized tasks:
     - Tap "Create Project" button
     - Verify project is created
     - Verify customized tasks are created (not original template tasks)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Task customization is NOT available (missing)
- ✅ **When implemented**: Template tasks can be customized
- ✅ Customized tasks are created (not original template tasks)
- ✅ Customization options work correctly

---

## Test Case 5: Create Custom Project Template - Missing Feature

**Objective**: Verify custom project template can be created from existing project (currently missing).

**Preconditions**:
- User is logged in
- User has `manageProjects` permission (or template creation permission)
- Project exists with tasks
- Create template feature is implemented

**Steps**:
1. Navigate to Project List page
2. Locate a project
3. Tap on project to view details
4. Verify one of the following:
   - **If NOT implemented**: "Create Template" or "Save as Template" option is not available (this is expected - feature missing)
   - **If implemented**: "Create Template" or "Save as Template" option exists
5. If implemented:
   - Tap "Create Template" or "Save as Template" option
   - Verify create template dialog/form appears:
     - Template name field
     - Template description field
     - Template category field (if applicable)
     - Template visibility field (workspace/global)
     - Tasks selection (which tasks to include)
     - Create/Cancel buttons
   - Fill in template details:
     - Enter template name: "My Custom Template"
     - Enter description: "Template for my workflow"
     - Select category (if applicable)
     - Select visibility: "Workspace" or "Global"
     - Select tasks to include (or include all)
   - Tap "Create Template" button
   - Verify loading indicator appears
   - Wait for template creation to complete
   - Verify success message appears: "Template created successfully"
   - Verify template is created:
     - Template appears in templates list
     - Template can be used to create projects
   - Verify template is saved to Firebase:
     - Check Firebase data
     - Verify template has correct workspaceId (if workspace template)
     - Verify template tasks are saved

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Create custom template is NOT available (missing)
- ✅ **When implemented**: Custom template can be created
- ✅ Template appears in templates list
- ✅ Template is saved to Firebase

---

## Test Case 6: Edit Project Template - Missing Feature

**Objective**: Verify project template can be edited (currently missing).

**Preconditions**:
- User is logged in
- User has `manageTemplates` permission (or is template creator)
- Project template exists
- Edit template feature is implemented

**Steps**:
1. Navigate to Project List page
2. Tap "Create Project" button
3. Tap "Create from Template" option
4. Navigate to "My Templates" or "Manage Templates" section
5. Locate a template (preferably one you created)
6. Tap on template or "Edit" button
7. Verify one of the following:
   - **If NOT implemented**: Edit option is not available (this is expected - feature missing)
   - **If implemented**: Edit template dialog/form appears
8. If implemented:
   - Verify edit form is pre-filled:
     - Template name (pre-filled)
     - Template description (pre-filled)
     - Template category (pre-filled)
     - Template tasks (pre-filled)
   - Modify template details:
     - Change template name: "Updated Template Name"
     - Change description: "Updated description"
     - Add/remove tasks
     - Modify task details
   - Tap "Save Template" button
   - Verify loading indicator appears
   - Wait for update to complete
   - Verify success message appears: "Template updated successfully"
   - Verify template is updated:
     - Updated name is displayed
     - Updated description is displayed
     - Updated tasks are saved
   - Verify template is updated in Firebase:
     - Check Firebase data
     - Verify changes are saved

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Edit template is NOT available (missing)
- ✅ **When implemented**: Template can be edited
- ✅ Changes are saved
- ✅ Template is updated in Firebase

---

## Test Case 7: Delete Project Template - Missing Feature

**Objective**: Verify project template can be deleted (currently missing).

**Preconditions**:
- User is logged in
- User has `manageTemplates` permission (or is template creator)
- Project template exists (preferably one you created)
- Delete template feature is implemented

**Steps**:
1. Navigate to Project List page
2. Tap "Create Project" button
3. Tap "Create from Template" option
4. Navigate to "My Templates" or "Manage Templates" section
5. Locate a template
6. Tap "Delete" button or option
7. Verify one of the following:
   - **If NOT implemented**: Delete option is not available (this is expected - feature missing)
   - **If implemented**: Confirmation dialog appears
8. If implemented:
   - Verify confirmation dialog:
     - Warning message about deleting template
     - Template name displayed
     - Warning about projects created from template (if applicable)
     - Cancel button
     - Delete button (red/danger style)
   - Tap "Cancel":
     - Verify dialog closes
     - Verify template is NOT deleted
   - Tap "Delete":
     - Verify loading indicator appears
     - Wait for deletion to complete
     - Verify success message appears: "Template deleted successfully"
     - Verify template is removed from list
     - Verify template is deleted from Firebase:
       - Check Firebase data
       - Verify template is removed
   - Verify existing projects are NOT affected:
     - Projects created from deleted template still exist
     - Tasks in those projects are not affected

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Delete template is NOT available (missing)
- ✅ **When implemented**: Template can be deleted
- ✅ Confirmation dialog appears
- ✅ Existing projects are not affected

---

## Test Case 8: Template Categories/Types - Missing Feature

**Objective**: Verify templates can be organized by categories/types (currently missing).

**Preconditions**:
- User is logged in
- Project templates exist with different categories
- Template categories feature is implemented

**Steps**:
1. Navigate to Project List page
2. Tap "Create Project" button
3. Tap "Create from Template" option
4. Verify one of the following:
   - **If NOT implemented**: Category filter is not available (this is expected - feature missing)
   - **If implemented**: Category filter/selector exists
5. If implemented:
   - Verify categories are displayed:
     - "All Templates" option
     - Category list (e.g., Software Development, Marketing, HR, Sales)
     - Category icons (if applicable)
   - Select a category:
     - Tap on "Software Development" category
     - Verify only templates in that category are shown
     - Verify templates from other categories are hidden
   - Select "All Templates":
     - Verify all templates are shown
   - Verify category information:
     - Each template shows its category
     - Category badge/indicator is displayed
   - Verify category-based organization:
     - Templates are grouped by category
     - Category headers are displayed (if grouped view)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Template categories are NOT available (missing)
- ✅ **When implemented**: Templates can be organized by categories
- ✅ Category filter works correctly
- ✅ Templates are properly categorized

---

## Test Case 9: Template Search - Missing Feature

**Objective**: Verify templates can be searched (currently missing).

**Preconditions**:
- User is logged in
- Multiple project templates exist
- Template search feature is implemented

**Steps**:
1. Navigate to Project List page
2. Tap "Create Project" button
3. Tap "Create from Template" option
4. Verify one of the following:
   - **If NOT implemented**: Search field is not available (this is expected - feature missing)
   - **If implemented**: Search field exists
5. If implemented:
   - Locate search field
   - Enter search query: "Software"
   - Verify search results:
     - Only templates matching "Software" are shown
     - Templates not matching are hidden
     - Search highlights matching text (if applicable)
   - Enter different search query: "Marketing"
   - Verify results update:
     - Only "Marketing" templates are shown
   - Clear search:
     - Clear search field
     - Verify all templates are shown again
   - Verify search works for:
     - Template name
     - Template description
     - Task titles (if applicable)
     - Category names (if applicable)

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Template search is NOT available (missing)
- ✅ **When implemented**: Templates can be searched
- ✅ Search works correctly
- ✅ Search results are accurate

---

## Test Case 10: Workspace vs Global Templates - Missing Feature

**Objective**: Verify templates can be workspace-specific or global (currently missing).

**Preconditions**:
- User is logged in
- User has access to multiple workspaces
- Workspace and global templates exist
- Template visibility feature is implemented

**Steps**:
1. Navigate to Project List page
2. Switch to Workspace A
3. Tap "Create Project" button
4. Tap "Create from Template" option
5. Verify one of the following:
   - **If NOT implemented**: Template visibility options are not available (this is expected - feature missing)
   - **If implemented**: Template visibility is indicated
6. If implemented:
   - Verify templates are shown:
     - Global templates (available in all workspaces)
     - Workspace A templates (only in Workspace A)
   - Verify template visibility indicators:
     - Global templates show "Global" badge
     - Workspace templates show "Workspace" badge
   - Switch to Workspace B:
     - Navigate to templates
     - Verify:
       - Global templates are still visible
       - Workspace A templates are NOT visible
       - Workspace B templates are visible (if any)
   - Create a workspace template:
     - Create template with "Workspace" visibility
     - Verify template is only visible in current workspace
   - Create a global template (if user has permission):
     - Create template with "Global" visibility
     - Verify template is visible in all workspaces

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Template visibility is NOT available (missing)
- ✅ **When implemented**: Templates can be workspace or global
- ✅ Workspace templates are workspace-specific
- ✅ Global templates are available everywhere

---

## Test Case 11: Template Usage Statistics - Missing Feature

**Objective**: Verify template usage statistics are tracked (currently missing).

**Preconditions**:
- User is logged in
- Project templates exist
- Projects have been created from templates
- Usage statistics feature is implemented

**Steps**:
1. Navigate to Project List page
2. Tap "Create Project" button
3. Tap "Create from Template" option
4. Verify one of the following:
   - **If NOT implemented**: Usage statistics are not displayed (this is expected - feature missing)
   - **If implemented**: Usage statistics are displayed
5. If implemented:
   - Verify statistics are shown for each template:
     - Number of times used
     - Last used date
     - Popularity indicator (if applicable)
   - Verify statistics are accurate:
     - Count matches actual usage
     - Last used date is correct
   - Create project from template:
     - Use a template to create project
     - Verify statistics update:
       - Usage count increases
       - Last used date updates

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Usage statistics are NOT available (missing)
- ✅ **When implemented**: Template usage is tracked
- ✅ Statistics are displayed
- ✅ Statistics update correctly

---

## Test Case 12: Default Templates - Missing Feature

**Objective**: Verify default/system templates are available (currently missing).

**Preconditions**:
- User is logged in
- Default templates feature is implemented

**Steps**:
1. Navigate to Project List page
2. Tap "Create Project" button
3. Tap "Create from Template" option
4. Verify one of the following:
   - **If NOT implemented**: Default templates are not available (this is expected - feature missing)
   - **If implemented**: Default templates are available
5. If implemented:
   - Verify default templates section exists:
     - "Default Templates" or "System Templates" section
     - Default templates are listed
   - Verify default templates include:
     - "Empty Project" (no predefined tasks)
     - "Software Development - Sprint Planning"
     - "Marketing Campaign"
     - "HR Onboarding"
     - Other common templates
   - Verify default templates cannot be deleted:
     - Attempt to delete default template
     - Verify delete option is disabled or not available
   - Verify default templates can be used:
     - Select default template
     - Create project from template
     - Verify project is created successfully

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Default templates are NOT available (missing)
- ✅ **When implemented**: Default templates are available
- ✅ Default templates cannot be deleted
- ✅ Default templates can be used

---

## Test Case 13: Template Task Assignment - Missing Feature

**Objective**: Verify template tasks can have default assignees (currently missing).

**Preconditions**:
- User is logged in
- User has `createProject` permission
- Project template exists with tasks that have default assignees
- Template task assignment feature is implemented

**Steps**:
1. Navigate to Project List page
2. Tap "Create Project" button
3. Tap "Create from Template" option
4. Select a template with default assignees
5. Tap "Use Template" button
6. Verify one of the following:
   - **If NOT implemented**: Default assignees are not applied (this is expected - feature missing)
   - **If implemented**: Default assignees are shown/applied
7. If implemented:
   - Verify default assignees are displayed:
     - Task list shows assignee for each task
     - Assignee names are shown
   - Verify assignee options:
     - Can change assignee when creating project
     - Can keep default assignee
     - Can assign to current user
   - Create project with default assignees:
     - Keep default assignees
     - Create project
     - Verify tasks are created with correct assignees
   - Create project with custom assignees:
     - Change assignees for some tasks
     - Create project
     - Verify tasks are created with custom assignees

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Template task assignment is NOT available (missing)
- ✅ **When implemented**: Template tasks can have default assignees
- ✅ Default assignees are applied correctly
- ✅ Assignees can be customized

---

## Test Case 14: Template Task Dependencies - Missing Feature

**Objective**: Verify template tasks can have dependencies (currently missing).

**Preconditions**:
- User is logged in
- User has `createProject` permission
- Project template exists with tasks that have dependencies
- Template task dependencies feature is implemented

**Steps**:
1. Navigate to Project List page
2. Tap "Create Project" button
3. Tap "Create from Template" option
4. Select a template with task dependencies
5. Preview template or use template
6. Verify one of the following:
   - **If NOT implemented**: Task dependencies are not shown (this is expected - feature missing)
   - **If implemented**: Task dependencies are shown/applied
7. If implemented:
   - Verify dependencies are displayed:
     - Task list shows dependency relationships
     - Dependency arrows or indicators are shown
     - Dependent tasks are identified
   - Verify dependency information:
     - Which tasks depend on which
     - Dependency type (blocks, follows, etc.)
   - Create project from template:
     - Use template with dependencies
     - Create project
     - Verify tasks are created with dependencies:
       - Dependent tasks have correct parentTaskId
       - Dependency relationships are preserved

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Template task dependencies are NOT available (missing)
- ✅ **When implemented**: Template tasks can have dependencies
- ✅ Dependencies are preserved when creating project
- ✅ Dependency relationships are correct

---

## Test Case 15: Template Sharing - Missing Feature

**Objective**: Verify templates can be shared with other users/workspaces (currently missing).

**Preconditions**:
- User is logged in
- User has `manageTemplates` permission
- Project template exists
- Template sharing feature is implemented

**Steps**:
1. Navigate to Project List page
2. Tap "Create Project" button
3. Tap "Create from Template" option
4. Navigate to "My Templates" section
5. Locate a template
6. Verify one of the following:
   - **If NOT implemented**: "Share" option is not available (this is expected - feature missing)
   - **If implemented**: "Share" option exists
7. If implemented:
   - Tap "Share" button
   - Verify sharing options:
     - Share with workspace
     - Share with specific users
     - Share globally (if user has permission)
     - Copy template link (if applicable)
   - Share with workspace:
     - Select "Share with Workspace"
     - Confirm sharing
     - Verify template becomes available to all workspace members
   - Share with specific users:
     - Select "Share with Users"
     - Select users
     - Confirm sharing
     - Verify template is available to selected users
   - Verify shared templates are indicated:
     - Shared templates show "Shared" badge
     - Sharing information is displayed

**Expected Results**:
- ⚠️ **CURRENT STATUS**: Template sharing is NOT available (missing)
- ✅ **When implemented**: Templates can be shared
- ✅ Sharing options work correctly
- ✅ Shared templates are properly indicated

---

## Test Summary Checklist

After completing all test cases, verify:

- [ ] Project templates can be viewed (if implemented)
- [ ] Project can be created from template (if implemented)
- [ ] Template tasks can be previewed (if implemented)
- [ ] Template tasks can be customized (if implemented)
- [ ] Custom template can be created (if implemented)
- [ ] Template can be edited (if implemented)
- [ ] Template can be deleted (if implemented)
- [ ] Templates can be organized by categories (if implemented)
- [ ] Templates can be searched (if implemented)
- [ ] Workspace vs global templates work (if implemented)
- [ ] Template usage statistics are tracked (if implemented)
- [ ] Default templates are available (if implemented)
- [ ] Template tasks can have default assignees (if implemented)
- [ ] Template tasks can have dependencies (if implemented)
- [ ] Templates can be shared (if implemented)

---

## Known Issues (Based on Audit Report)

1. **Project Templates Missing**:
   - No project template entity
   - No template UI
   - No template repository
   - **Status**: ⛔ Missing

2. **Predefined Task Sets Missing**:
   - Cannot create projects with predefined tasks
   - No template task definitions
   - **Status**: ⛔ Missing

3. **Template Management Missing**:
   - No CRUD operations for templates
   - No template creation from existing projects
   - **Status**: ⛔ Missing

---

## Notes for Testers

1. **Current Status**: Project templates are completely missing. No entity, no UI, no functionality.

2. **Template Purpose**: Templates are meant to speed up project creation by providing predefined task sets. Users should be able to:
   - Create projects from templates
   - Get predefined tasks automatically
   - Customize templates when creating projects
   - Create custom templates from existing projects

3. **Template Structure**: Templates should include:
   - Template metadata (name, description, category)
   - List of predefined tasks
   - Task details (title, description, priority, assignee, deadline)
   - Task dependencies (if applicable)
   - Template visibility (workspace/global)

4. **Template Categories**: Common categories might include:
   - Software Development
   - Marketing
   - HR
   - Sales
   - Operations
   - Custom categories

5. **Template Visibility**: Templates can be:
   - **Workspace**: Only visible in specific workspace
   - **Global**: Visible in all workspaces
   - **Private**: Only visible to creator

6. **Default Templates**: System should provide default templates for common use cases.

---

## Reporting Issues

When reporting issues, please include:
- Test case number and name
- Device model and OS version
- App version
- Workspace context
- Template context (if applicable)
- Steps to reproduce
- Expected vs actual results
- Screenshots/videos if possible
- Error messages (if any)
- Whether it's a known issue or new bug
- Firebase data (if accessible) showing template data
- Whether templates are working
- Whether predefined tasks are created correctly

