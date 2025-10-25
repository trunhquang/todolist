import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/app/widgets/td_button.dart';
import 'package:todolist/app/widgets/td_card.dart';
import 'package:todolist/app/widgets/td_text_field.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/constants/task_enums.dart';
import 'package:todolist/features/auth/domain/entities/user.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/tasks/presentation/controllers/task_controller.dart';

/// CreateTaskForm widget for Sprint 5 task creation with workspace context
/// 
/// This widget provides:
/// - Task creation form with workspace context
/// - Assignee selection from workspace members
/// - Project selection from workspace projects
/// - Priority and type selection
/// - Deadline selection
class CreateTaskForm extends StatefulWidget {
  const CreateTaskForm({Key? key}) : super(key: key);

  @override
  State<CreateTaskForm> createState() => _CreateTaskFormState();
}

class _CreateTaskFormState extends State<CreateTaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  User? _selectedAssignee;
  Project? _selectedProject;
  TaskPriority _selectedPriority = TaskPriority.medium;
  TaskType _selectedType = TaskType.daily;
  DateTime? _selectedDeadline;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
      builder: (controller) => TDCard(
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
              
              // Project dropdown
              _buildProjectDropdown(controller),
              
              const SizedBox(height: 16),
              
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
              TDButton(
                text: AppStrings.createTask,
                onPressed: controller.isLoading ? null : _onCreateTask,
                isLoading: controller.isLoading,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build assignee dropdown
  Widget _buildAssigneeDropdown(TaskController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.taskAssignee,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<User>(
          value: _selectedAssignee,
          isExpanded: true, // Make dropdown expand to fill available space
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          hint: Text(AppStrings.selectAssignee),
          items: controller.workspaceMembers.map((user) {
            return DropdownMenuItem<User>(
              value: user,
              child: Text(user.name),
            );
          }).toList(),
          onChanged: (User? user) {
            setState(() {
              _selectedAssignee = user;
            });
          },
        ),
      ],
    );
  }

  /// Build project dropdown
  Widget _buildProjectDropdown(TaskController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.projects,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<Project>(
          value: _selectedProject,
          isExpanded: true, // Make dropdown expand to fill available space
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          hint: Text('Select Project (Optional)'),
          items: [
            const DropdownMenuItem<Project>(
              value: null,
              child: Text('No Project'),
            ),
            ...controller.workspaceProjects.map((project) {
              return DropdownMenuItem<Project>(
                value: project,
                child: Text(project.title),
              );
            }).toList(),
          ],
          onChanged: (Project? project) {
            setState(() {
              _selectedProject = project;
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
          value: _selectedPriority,
          isExpanded: true, // Make dropdown expand to fill available space
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
          value: _selectedType,
          isExpanded: true, // Make dropdown expand to fill available space
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
    final DateTime? picked = await showDatePicker(
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
    
    await controller.createTask(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty 
          ? null 
          : _descriptionController.text.trim(),
      assigneeId: _selectedAssignee?.id,
      projectId: _selectedProject?.id,
      priority: _selectedPriority,
      taskType: _selectedType,
      deadline: _selectedDeadline,
    );
  }
}
