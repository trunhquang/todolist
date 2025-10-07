import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../routes/app_router.dart';
import '../../../core/services/navigation_service.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/services/firebase_database_service.dart';
import '../../../features/tasks/domain/entities/task.dart';
import '../../../features/tasks/domain/entities/project.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _type = 'all';
  String _status = 'all';
  String _priority = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tasks'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task),
            onPressed: () async {
              await NavigationService().toNamed<void>(AppRouter.taskEdit);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search tasks',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _type,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All')),
                    DropdownMenuItem(value: 'daily', child: Text('Daily')),
                    DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                    DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                    DropdownMenuItem(value: 'project', child: Text('Project')),
                  ],
                  onChanged: (v) => setState(() => _type = v ?? 'all'),
                ),
                const SizedBox(width: 8),
                FutureBuilder<List<Project>>(
                  future: _loadProjects(),
                  builder: (context, snapshot) {
                    final items = snapshot.data ?? <Project>[];
                    return DropdownButton<String?>(
                      value: _selectedProjectId,
                      hint: const Text('Any project'),
                      items: <DropdownMenuItem<String?>>[
                        const DropdownMenuItem<String?>(child: Text('Any project')),
                        ...items.map((p) => DropdownMenuItem<String?>(value: p.id, child: Text(p.title))),
                      ],
                      onChanged: (v) => setState(() => _selectedProjectId = v),
                    );
                  },
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _status,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Any status')),
                    DropdownMenuItem(value: 'pending', child: Text('Pending')),
                    DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
                    DropdownMenuItem(value: 'completed', child: Text('Completed')),
                    DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                  ],
                  onChanged: (v) => setState(() => _status = v ?? 'all'),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _priority,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Any priority')),
                    DropdownMenuItem(value: 'low', child: Text('Low')),
                    DropdownMenuItem(value: 'medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'high', child: Text('High')),
                    DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
                  ],
                  onChanged: (v) => setState(() => _priority = v ?? 'all'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<TaskEntity>>(
              stream: _watchTasks(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var items = snapshot.data!;
                final q = _searchController.text.trim().toLowerCase();
                if (q.isNotEmpty) {
                  items = items
                      .where((t) => t.title.toLowerCase().contains(q))
                      .toList();
                }
                if (items.isEmpty) {
                  return const Center(child: Text('No tasks'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    final t = items[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t.title, style: AppTextStyles.titleMedium),
                                const SizedBox(height: 4),
                                Text('${t.status} · ${t.taskType} · ${t.priority}', style: AppTextStyles.bodyMedium),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () async {
                              await NavigationService().toNamed<void>(AppRouter.taskEdit, arguments: t);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await NavigationService().toNamed<void>(AppRouter.taskEdit);
        },
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        child: const Icon(Icons.add_task),
      ),
    );
  }

  Stream<List<TaskEntity>> _watchTasks() {
    final storage = StorageService();
    final companyId = storage.getCompanyId() ?? '';
    final type = _type == 'all' ? null : _type;
    final status = _status == 'all' ? null : _status;
    final priority = _priority == 'all' ? null : _priority;
    if (companyId.isEmpty) return const Stream<List<TaskEntity>>.empty();
    return FirebaseDatabaseService.instance.watchTasks(
      companyId: companyId,
      type: type,
      status: status,
      priority: priority,
      projectId: _selectedProjectId,
    );
  }

  String? _selectedProjectId;
  Future<List<Project>> _loadProjects() async {
    final storage = StorageService();
    final companyId = storage.getCompanyId() ?? '';
    if (companyId.isEmpty) return <Project>[];
    return FirebaseDatabaseService.instance.listProjects(companyId: companyId);
  }
}


