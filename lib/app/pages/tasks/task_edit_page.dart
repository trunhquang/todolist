import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/firebase_database_service.dart';
import '../../../core/services/offline_queue_service.dart';
import '../../../features/tasks/domain/entities/task.dart';
import '../../../features/tasks/domain/entities/project.dart';
import '../../../features/auth/domain/entities/user.dart' as app_user;
import '../../../core/constants/user_roles.dart';

import '../../theme/app_colors.dart';
import '../../widgets/td_text_field.dart';
import '../../widgets/td_button.dart';
import '../../../core/utils/validators.dart';

class TaskEditPage extends StatefulWidget {
  const TaskEditPage({super.key});

  @override
  State<TaskEditPage> createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _type = 'daily';
  String _priority = 'medium';
  String _status = 'pending';
  bool _hasDeadline = false;
  DateTime? _deadline;
  bool _isRecurring = false;
  String _frequency = 'daily';
  int _interval = 1;
  DateTime? _endDate;
  bool _linkToProject = false; // for daily/weekly/monthly
  Project? _selectedProject;
  TaskEntity? _editing;
  String? _selectedAssigneeId;

  @override
  void initState() {
    super.initState();
    final arg = Get.arguments;
    if (arg is TaskEntity) {
      _editing = arg;
      _titleController.text = arg.title;
      _descriptionController.text = arg.description ?? '';
      _type = arg.taskType;
      _priority = arg.priority;
      _status = arg.status;
      _hasDeadline = arg.hasDeadline;
      _deadline = arg.deadline;
      _isRecurring = arg.recurring.isRecurring;
      _frequency = arg.recurring.frequency ?? 'daily';
      _interval = arg.recurring.interval ?? 1;
      _endDate = arg.recurring.endDate;
      _linkToProject = arg.projectId != null && arg.taskType != 'project';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_editing == null ? 'Task' : 'Edit Task'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            TDTextField(
              controller: _titleController,
              label: 'Title',
              validator: Validators.taskTitle,
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<app_user.User>>(
              future: _loadUsers(),
              builder: (context, snapshot) {
                final users = snapshot.data ?? <app_user.User>[];
                return DropdownButtonFormField<String>(
                  initialValue: _selectedAssigneeId,
                  items: [
                    const DropdownMenuItem(child: Text('Unassigned')),
                    ...users.map((u) => DropdownMenuItem(
                          value: u.id,
                          child: Text(u.name.isNotEmpty ? u.name : u.email),
                        )),
                  ],
                  onChanged: _canAssignTasks()
                      ? (v) => setState(() => _selectedAssigneeId = v)
                      : null,
                  decoration: const InputDecoration(labelText: 'Assignee'),
                );
              },
            ),
            const SizedBox(height: 12),
            TDTextField(
              controller: _descriptionController,
              label: 'Description',
              maxLines: 4,
              validator: Validators.taskDescription,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _type,
                    items: const [
                      DropdownMenuItem(value: 'daily', child: Text('Daily')),
                      DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                      DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                      DropdownMenuItem(value: 'project', child: Text('Project')),
                    ],
                    onChanged: (v) => setState(() {
                      _type = v ?? 'daily';
                      if (_type == 'project') {
                        _linkToProject = true;
                      }
                    }),
                    decoration: const InputDecoration(labelText: 'Type'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _priority,
                    items: const [
                      DropdownMenuItem(value: 'low', child: Text('Low')),
                      DropdownMenuItem(value: 'medium', child: Text('Medium')),
                      DropdownMenuItem(value: 'high', child: Text('High')),
                      DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
                    ],
                    onChanged: (v) => setState(() => _priority = v ?? 'medium'),
                    decoration: const InputDecoration(labelText: 'Priority'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_type != 'project')
              SwitchListTile(
                value: _linkToProject,
                title: const Text('Link to project'),
                onChanged: _canChangeProjectLinkage()
                    ? (v) => setState(() => _linkToProject = v)
                    : null,
              ),
            if (_type == 'project' || _linkToProject)
              FutureBuilder<List<Project>>(
                future: _loadProjects(),
                builder: (context, snapshot) {
                  final projects = snapshot.data ?? <Project>[];
                  return DropdownButtonFormField<Project>(
                    initialValue: _selectedProject,
                    items: projects
                        .map((p) => DropdownMenuItem<Project>(
                              value: p,
                              child: Text(p.title),
                            ))
                        .toList(),
                    onChanged: _canChangeProjectLinkage()
                        ? (v) => setState(() => _selectedProject = v)
                        : null,
                    decoration: const InputDecoration(labelText: 'Project'),
                    validator: (_) {
                      if (_type == 'project' && _selectedProject == null) {
                        return 'Project is required';
                      }
                      if (_linkToProject && _selectedProject == null) {
                        return 'Project is required when linking';
                      }
                      return null;
                    },
                  );
                },
              ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _status,
              items: const [
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
                DropdownMenuItem(value: 'completed', child: Text('Completed')),
                DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
              ],
              onChanged: _canUpdateStatusForCurrentContext()
                  ? (v) => setState(() => _status = v ?? 'pending')
                  : null,
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _hasDeadline,
              title: const Text('Has deadline'),
              onChanged: (v) => setState(() {
                _hasDeadline = v;
                if (!v) _deadline = null;
              }),
            ),
            if (_hasDeadline)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _deadline ?? now,
                          firstDate: DateTime(now.year, now.month, now.day),
                          lastDate: now.add(const Duration(days: 3650)),
                        );
                        if (picked != null) setState(() => _deadline = picked);
                      },
                      child: Text(_deadline == null ? 'Pick deadline' : _deadline!.toIso8601String().split('T').first),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _deadline = null),
                  )
                ],
              ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _isRecurring,
              title: const Text('Recurring task'),
              onChanged: (v) => setState(() => _isRecurring = v),
            ),
            if (_isRecurring)
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _frequency,
                          items: const [
                            DropdownMenuItem(value: 'daily', child: Text('Daily')),
                            DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                            DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                          ],
                          onChanged: (v) => setState(() => _frequency = v ?? 'daily'),
                          decoration: const InputDecoration(labelText: 'Frequency'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          initialValue: '1',
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Interval'),
                          onChanged: (v) => _interval = int.tryParse(v) ?? 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final now = DateTime.now();
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _endDate ?? now,
                              firstDate: DateTime(now.year, now.month, now.day),
                              lastDate: now.add(const Duration(days: 3650)),
                            );
                            if (picked != null) setState(() => _endDate = picked);
                          },
                          child: Text(_endDate == null ? 'Pick end date' : _endDate!.toIso8601String().split('T').first),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _endDate = null),
                      )
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TDButton(
                    text: 'Save',
                    onPressed: () async {
                if (_formKey.currentState?.validate() != true) return;
                if (_hasDeadline && _deadline != null) {
                  final today = DateTime.now();
                  final startOfToday = DateTime(today.year, today.month, today.day);
                  if (_deadline!.isBefore(startOfToday)) {
                    Get.snackbar('Invalid deadline', 'Deadline must be today or later');
                    return;
                  }
                }
                if (_isRecurring) {
                  if (_interval < 1) {
                    Get.snackbar('Invalid interval', 'Interval must be at least 1');
                    return;
                  }
                  if (_endDate != null) {
                    final today = DateTime.now();
                    final startOfToday = DateTime(today.year, today.month, today.day);
                    if (_endDate!.isBefore(startOfToday)) {
                      Get.snackbar('Invalid end date', 'End date must be today or later');
                      return;
                    }
                  }
                }
                if (_type == 'project' && _selectedProject == null) {
                  Get.snackbar('Project required', 'Please select a project');
                  return;
                }
                if (_linkToProject && _selectedProject == null) {
                  Get.snackbar('Project required', 'Please select a project');
                  return;
                }

                final storage = StorageService();
                final companyId = storage.getCompanyId() ?? '';
                final userId = storage.getUserId() ?? '';
                final departmentId = storage.getDepartmentId() ?? '';
                if (companyId.isEmpty || userId.isEmpty) {
                  Get.snackbar('Missing info', 'Company or user not set');
                  return;
                }

                // If user cannot update status in this context, preserve original status when editing
                if (!_canUpdateStatusForCurrentContext() && _editing != null) {
                  _status = _editing!.status;
                }

                // Regular user editing existing task cannot change project linkage
                var effectiveProjectId = (_type == 'project' || _linkToProject) ? _selectedProject?.id : null;
                if (_editing != null && !_canChangeProjectLinkage()) {
                  effectiveProjectId = _editing!.projectId;
                }

                final entity = TaskEntity(
                  id: '',
                  title: _titleController.text.trim(),
                  description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
                  taskType: _type,
                  priority: _priority,
                  status: _status,
                  assignee: _selectedAssigneeId,
                  assigner: userId,
                  departmentId: departmentId,
                  projectId: effectiveProjectId,
                  hasDeadline: _hasDeadline,
                  deadline: _hasDeadline ? _deadline : null,
                  recurring: RecurringConfig(
                    isRecurring: _isRecurring,
                    frequency: _isRecurring ? _frequency : null,
                    interval: _isRecurring ? _interval : null,
                    endDate: _isRecurring ? _endDate : null,
                  ),
                  createdAt: DateTime.now(),
                );

                      if (_editing == null) {
                        await OfflineQueueService.instance.createTask(companyId: companyId, task: entity);
                      } else {
                        final updated = entity.copyWith(id: _editing!.id);
                        await OfflineQueueService.instance.updateTask(companyId: companyId, task: updated);
                      }

                      NavigationService().back<void>();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                if (_editing != null && _canDeleteTasks())
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      final storage = StorageService();
                      final companyId = storage.getCompanyId() ?? '';
                      if (companyId.isEmpty) return;
                      await OfflineQueueService.instance.deleteTask(companyId: companyId, taskId: _editing!.id);
                      NavigationService().back<void>();
                    },
                  ),
              ],
            ),
            ],
          ),
        ),
      ),
    );
  }
  
  bool _canDeleteTasks() {
    final storage = StorageService();
    final role = storage.getUserRole() ?? '';
    return UserRoles.hasPermission(role, UserRoles.deleteTasks);
  }

  bool _canUpdateStatusForCurrentContext() {
    final storage = StorageService();
    final role = storage.getUserRole() ?? '';
    // If role has general permission, allow
    if (UserRoles.hasPermission(role, UserRoles.updateTaskStatus)) {
      // For regular users, restrict to own assigned task when editing
      if (role == UserRoles.regularUser) {
        if (_editing == null) return true; // creating new task: allow choosing initial status
        final currentUserId = storage.getUserId() ?? '';
        return _editing!.assignee == currentUserId;
      }
      return true;
    }
    return false;
  }
  
  Future<List<Project>> _loadProjects() async {
    final storage = StorageService();
    final companyId = storage.getCompanyId() ?? '';
    if (companyId.isEmpty) return <Project>[];
    return FirebaseDatabaseService.instance.listProjects(companyId: companyId);
  }

  Future<List<app_user.User>> _loadUsers() async {
    final storage = StorageService();
    final companyId = storage.getCompanyId() ?? '';
    if (companyId.isEmpty) return <app_user.User>[];
    return FirebaseDatabaseService.instance.listUsersByCompany(companyId);
  }

  bool _canAssignTasks() {
    final storage = StorageService();
    final role = storage.getUserRole() ?? '';
    return UserRoles.hasPermission(role, UserRoles.assignTasks);
  }

  bool _canChangeProjectLinkage() {
    final storage = StorageService();
    final role = storage.getUserRole() ?? '';
    // Disallow regular users from changing project linkage when editing
    if (role == UserRoles.regularUser && _editing != null) {
      return false;
    }
    return true;
  }
}


