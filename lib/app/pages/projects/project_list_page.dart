import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../routes/app_router.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/firebase_database_service.dart';
import '../../../core/services/offline_queue_service.dart';
import '../../../features/tasks/domain/entities/project.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({super.key});

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _statusFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Projects'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        actions: [],
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
                      hintText: 'Search projects',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _statusFilter,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Any status')),
                    DropdownMenuItem(value: 'active', child: Text('Active')),
                    DropdownMenuItem(value: 'completed', child: Text('Completed')),
                    DropdownMenuItem(value: 'closed', child: Text('Closed')),
                  ],
                  onChanged: (v) => setState(() => _statusFilter = v ?? 'all'),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Project>>(
              stream: _watchProjects(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var items = snapshot.data!;
                final q = _searchController.text.trim().toLowerCase();
                if (q.isNotEmpty) {
                  items = items
                      .where((p) => p.title.toLowerCase().contains(q))
                      .toList();
                }
                if (_statusFilter != 'all') {
                  items = items.where((p) => p.status == _statusFilter).toList();
                }
                if (items.isEmpty) {
                  return const Center(child: Text('No projects'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    final p = items[index];
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
                                Text(p.title, style: AppTextStyles.titleMedium),
                                const SizedBox(height: 4),
                                Text(p.status, style: AppTextStyles.bodyMedium),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () async {
                              await NavigationService().toNamed<void>(AppRouter.projectEdit, arguments: p);
                              setState(() {});
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              final storage = StorageService();
                              final companyId = storage.getCompanyId() ?? '';
                              if (companyId.isEmpty) return;
                              await OfflineQueueService.instance.deleteProject(companyId: companyId, projectId: p.id);
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
          await NavigationService().toNamed<void>(AppRouter.projectEdit);
          setState(() {});
        },
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        tooltip: 'New Project',
        child: const Icon(Icons.add_task),
      ),
    );
  }

  Stream<List<Project>> _watchProjects() {
    final storage = StorageService();
    final companyId = storage.getCompanyId() ?? '';
    final status = _statusFilter == 'all' ? null : _statusFilter;
    if (companyId.isEmpty) return const Stream<List<Project>>.empty();
    return FirebaseDatabaseService.instance.watchProjects(companyId: companyId, status: status);
  }
}


