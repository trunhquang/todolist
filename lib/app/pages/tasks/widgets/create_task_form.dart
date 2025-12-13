import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/app/widgets/td_button.dart';
import 'package:todolist/app/widgets/td_card.dart';
import 'package:todolist/app/widgets/td_text_field.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/constants/task_enums.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';

import '../../../../features/tasks/domain/entities/task.dart';
import '../../../../features/workspace/domain/entities/workspace_member.dart';
import '../../../../features/workspace/presentation/controllers/workspace_controller.dart';
import '../controllers/task_controller.dart';

/// CreateTaskForm widget for Sprint 5 task creation with workspace context
///
/// This widget provides:
/// - Task creation form with workspace context
/// - Assignee selection from workspace members
/// - Project selection from workspace projects
/// - Priority and type selection
/// - Deadline selection
class CreateTaskForm extends StatefulWidget {
  const CreateTaskForm({
    this.initialProject,
    this.initialTask,
    this.onTaskCreated,
    super.key,
  });

  final Project? initialProject;
  final TaskEntity? initialTask;
  final VoidCallback? onTaskCreated;

  @override
  State<CreateTaskForm> createState() => _CreateTaskFormState();
}

class _CreateTaskFormState extends State<CreateTaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  WorkspaceMember? _selectedAssignee;
  Project? _selectedProject;
  TaskPriority _selectedPriority = TaskPriority.medium;
  TaskStatus _selectedStatus = TaskStatus.pending;
  TaskType _selectedType = TaskType.daily;
  DateTime? _selectedDeadline;

  bool _isProjectLocked = false;
  RxBool _isLinkToProject = false.obs;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _isProjectLocked = widget.initialProject != null;
    _isLinkToProject.value = widget.initialProject != null;
    initTaskData();
  }

  void initTaskData() {
    final task = widget.initialTask;
    _selectedProject = widget.initialProject;
    if (task != null) {
      _titleController.text = task.title;
      _descriptionController.text = task.description ?? '';

      // Convert String to enum using fromString() methods
      _selectedPriority = TaskPriority.fromString(task.priority);
      _selectedStatus = TaskStatus.fromString(task.status);
      _selectedType = TaskType.fromString(task.taskType);
      _selectedDeadline = task.deadline;

      // Convert assignee userId (String) to User object
      if (task.assignee != null && task.assignee!.isNotEmpty) {
        try {
          final controller = Get.find<WorkspaceController>();
          final matchingUsers = controller.workspaceMembers
              .where((user) => user.userId == task.assignee)
              .toList();
          _selectedAssignee =
              matchingUsers.isNotEmpty ? matchingUsers.first : null;
        } catch (e) {
          // User not found in workspace members, leave as null
          _selectedAssignee = null;
        }
      }

      // Convert projectId (String) to Project object
      // Only set project from task if initialProject is not already set
      if (_selectedProject == null &&
          task.projectId != null &&
          task.projectId!.isNotEmpty) {
        try {
          final controller = Get.find<TaskController>();
          _selectedProject = controller.getProject(task.projectId!);
          if (_selectedProject != null) {
            _isLinkToProject.value = true;
          }
        } catch (e) {
          // Project not found, leave as null
          _selectedProject = null;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<TaskController>();
    return TDCard(
      margin: EdgeInsets.zero,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title field
            TDTextField(
              key: const Key('task_title_field'),
              controller: _titleController,
              label: AppStrings.taskTitle,
              hint: AppStrings.enterTaskTitle,
              validator: _validateTitle,
            ),

            const SizedBox(height: 16),

            // Description field
            TDTextField(
              key: const Key('task_description_field'),
              controller: _descriptionController,
              label: AppStrings.taskDescription,
              hint: AppStrings.enterTaskDescription,
              maxLines: 3,
            ),

            const SizedBox(height: 16),

            // Assignee dropdown
            _buildAssigneeDropdown(controller),

            const SizedBox(height: 16),
            if (!_isProjectLocked)
              Column(
                children: [
                  const SizedBox(height: 12),
                  SwitchListTile(
                    value: _isLinkToProject.value,
                    title: const Text('Link to project'),
                    onChanged: (v) =>
                        setState(() => _isLinkToProject.value = v),
                  ),
                ],
              ),
            Obx(() {
              _selectedProject = Get.find<WorkspaceController>()
                  .projects
                  .firstWhereOrNull((p) => p.id == _selectedProject?.id);
              return !_isLinkToProject.value
                  ? const SizedBox.shrink()
                  : DropdownButtonFormField<Project>(
                      initialValue: _selectedProject,
                      items: Get.find<WorkspaceController>()
                          .projects
                          .map((p) => DropdownMenuItem<Project>(
                                value: p,
                                child: Text(p.title),
                              ))
                          .toList(),
                      onChanged: !_isProjectLocked
                          ? (v) => setState(() => _selectedProject = v)
                          : null,
                      decoration: const InputDecoration(labelText: 'Project'),
                    );
            }),
            const SizedBox(height: 12),
            _buildStatusDropdown(),
            const SizedBox(height: 12),
            // Priority and Type row
            Row(
              children: [
                Expanded(
                  child: _buildPriorityDropdown(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTypeDropdown(),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Deadline field
            _buildDeadlineField(),

            const SizedBox(height: 24),

            // Create button
            Obx(() {
              var isLoading = controller.isLoading;
              return TDButton(
                text: widget.initialTask == null
                    ? AppStrings.createTask
                    : AppStrings.updateTask,
                onPressed: isLoading ? null : _onCreateTask,
                isLoading: isLoading,
                width: double.infinity,
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Build assignee dropdown
  Widget _buildAssigneeDropdown(TaskController controller) {
    var workspaceController = Get.find<WorkspaceController>();
    var users = workspaceController.workspaceMembers;
    var availableUsers = users;
    //     ? users
    //         .where((user) => _selectedProject!.memberIds.contains(user.userId))
    //         .toList()
    //     : users;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.taskAssignee,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<WorkspaceMember>(
          initialValue: _selectedAssignee,
          isExpanded: true,
          // Make dropdown expand to fill available space
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          hint: const Text(AppStrings.selectAssignee),
          items: availableUsers.map((user) {
            return DropdownMenuItem<WorkspaceMember>(
              value: user,
              child: Text(user.name),
            );
          }).toList(),
          onChanged: (WorkspaceMember? user) {
            setState(() {
              _selectedAssignee = user;
            });
          },
        ),
      ],
    );
  }

  /// Build priority dropdown
  Widget _buildPriorityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.taskPriority,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<TaskPriority>(
          initialValue: _selectedPriority,
          isExpanded: true,
          // Make dropdown expand to fill available space
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          items: TaskPriority.values.map((priority) {
            return DropdownMenuItem<TaskPriority>(
              value: priority,
              child: Text(priority.displayText),
            );
          }).toList(),
          onChanged: (TaskPriority? priority) {
            setState(() {
              _selectedPriority = priority!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.taskStatus,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<TaskStatus>(
          initialValue: _selectedStatus,
          isExpanded: true,
          // Make dropdown expand to fill available space
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          items: TaskStatus.values.map((status) {
            return DropdownMenuItem<TaskStatus>(
              value: status,
              child: Text(status.displayText),
            );
          }).toList(),
          onChanged: (TaskStatus? status) {
            setState(() {
              _selectedStatus = status!;
            });
          },
        ),
      ],
    );
  }

  /// Build type dropdown
  Widget _buildTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.taskCategory,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<TaskType>(
          initialValue: _selectedType,
          isExpanded: true,
          // Make dropdown expand to fill available space
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          items: TaskType.values.map((type) {
            return DropdownMenuItem<TaskType>(
              value: type,
              child: Text(type.displayText),
            );
          }).toList(),
          onChanged: (TaskType? type) {
            setState(() {
              _selectedType = type!;
            });
          },
        ),
      ],
    );
  }

  /// Build deadline field
  Widget _buildDeadlineField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.taskDueDate,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDeadline,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDeadline != null
                        ? '${_selectedDeadline!.day}/${_selectedDeadline!.month}/${_selectedDeadline!.year}'
                        : AppStrings.selectDate,
                    style: TextStyle(
                      color: _selectedDeadline != null
                          ? Colors.black
                          : Colors.grey[600],
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Validate title field
  String? _validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (value.length < 3) {
      return AppStrings.minLength.replaceAll('{min}', '3');
    }
    return null;
  }

  /// Select deadline
  Future<void> _selectDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDeadline) {
      setState(() {
        _selectedDeadline = picked;
      });
    }
  }

  /// Create task
  Future<void> _onCreateTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final controller = Get.find<TaskController>();
    final taskTitle = _titleController.text.trim();

    await controller.createTask(
        title: taskTitle,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        assigneeId: _selectedAssignee?.userId,
        projectId: _selectedProject?.id,
        priority: _selectedPriority,
        taskType: _selectedType,
        status: _selectedStatus,
        deadline: _selectedDeadline,
        initialTask: widget.initialTask);

    // Check if task was created successfully by verifying:
    // 1. No error message (or error message is empty)
    // 2. Task count increased or task with same title exists
    final hasError = controller.errorMessage.isNotEmpty;

    if (!hasError) {
      widget.onTaskCreated?.call();
    }
  }
}
