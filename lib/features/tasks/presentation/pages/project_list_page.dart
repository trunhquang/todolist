import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/app/widgets/td_app_bar.dart';
import 'package:todolist/app/widgets/td_button.dart';
import 'package:todolist/app/widgets/td_empty_state.dart';
import 'package:todolist/app/widgets/td_loading_indicator.dart';
import 'package:todolist/app/widgets/td_text_field.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/services/navigation_service.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/tasks/presentation/controllers/project_controller.dart';
import 'package:todolist/features/tasks/presentation/widgets/project_progress_card.dart';

/// ProjectListPage for Sprint 6 project management with workspace context
/// 
/// This page provides:
/// - Project list with workspace filtering
/// - Project creation functionality
/// - Project progress tracking
/// - Project management operations
class ProjectListPage extends StatelessWidget {
  const ProjectListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectController>(
      builder: (controller) => Scaffold(
        appBar: TDAppBar(
          title: AppStrings.projects,
          actions: [
            TDButton(
              text: AppStrings.createProject,
              onPressed: () => _showCreateProjectDialog(context),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading) {
            return const Center(
              child: TDLoadingIndicator(),
            );
          }

          if (controller.projects.isEmpty) {
            return TDEmptyState(
              title: AppStrings.noProjectsFound,
              icon: Icons.folder_open,
              actionText: AppStrings.createProject,
              onAction: () => _showCreateProjectDialog(context),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refreshProjects,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.projects.length,
              itemBuilder: (context, index) {
                final project = controller.projects[index];
                final progress = controller.getProjectProgress(project.id);
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ProjectProgressCard(
                    project: project,
                    progress: progress,
                    onTap: () => _onProjectTap(project),
                    onEdit: () => _onProjectEdit(project),
                    onDelete: () => _onProjectDelete(controller, project),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  /// Show create project dialog
  void _showCreateProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _CreateProjectDialog(),
    );
  }

  /// Handle project tap
  void _onProjectTap(Project project) {
    // TODO: Navigate to project details page
    // This should show project details with task list
    print('Project tapped: ${project.title}');
  }

  /// Handle project edit
  void _onProjectEdit(Project project) {
    // TODO: Navigate to project edit page
    // This should open project edit form
    print('Edit project: ${project.title}');
  }

  /// Handle project delete
  void _onProjectDelete(ProjectController controller, Project project) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.confirmDelete),
        content: Text('Are you sure you want to delete "${project.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.deleteProject(project.id);
            },
            child: Text(
              AppStrings.delete,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

/// Create project dialog
class _CreateProjectDialog extends StatefulWidget {
  @override
  _CreateProjectDialogState createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends State<_CreateProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDeadline;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(
          maxWidth: 500,
          maxHeight: 600,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.createProject,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title field
                      TDTextField(
                        controller: _titleController,
                        label: AppStrings.projectTitle,
                        hint: AppStrings.enterProjectTitle,
                        validator: _validateTitle,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Description field
                      TDTextField(
                        controller: _descriptionController,
                        label: AppStrings.projectDescription,
                        hint: AppStrings.enterProjectDescription,
                        maxLines: 3,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Deadline field
                      _buildDeadlineField(),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TDButton(
                    text: AppStrings.cancel,
                    onPressed: () => Navigator.of(context).pop(),
                    variant: TDButtonVariant.outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TDButton(
                    text: AppStrings.create,
                    onPressed: _onCreateProject,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build deadline field
  Widget _buildDeadlineField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.projectDeadline,
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

  /// Create project
  Future<void> _onCreateProject() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final controller = Get.find<ProjectController>();
    
    await controller.createProject(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty 
          ? null 
          : _descriptionController.text.trim(),
      deadline: _selectedDeadline,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
