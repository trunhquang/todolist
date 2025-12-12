import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../theme/app_colors.dart';
import '../../../routes/app_router.dart';
import '../../../../core/services/navigation_service.dart';

import '../../../../core/services/storage_service.dart';
import '../../../../core/services/firebase_database_service.dart';
import '../../../../features/tasks/domain/entities/task.dart';
import '../../../../features/tasks/domain/entities/project.dart';
import '../controllers/task_controller.dart';
import '../widgets/list_task_widget.dart';

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
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.filter_list),
        //     tooltip: 'Filters',
        //     onPressed: _openFilterSheet,
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FutureBuilder<ProjectProgressResult>(
            //   future: progressFuture,
            //   builder: (context, snapshot) {
            //     if (!snapshot.hasData) {
            //       return const TDLoadingIndicator();
            //     }
            //     return ProjectProgressCard(
            //       project: project,
            //       progress: snapshot.data,
            //     );
            //   },
            // ),
            const SizedBox(height: AppSpacing.md),
            Text(
              AppStrings.tasks,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<List<TaskEntity>>(
                stream: Get.find<TaskController>().watchTasks(),
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
                  return ListTaskWidget(
                    items: items,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await NavigationService().toNamed<void>(AppRouter.taskCreate);
        },
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        tooltip: 'New Task',
        child: const Icon(Icons.add_task),
      ),
    );
  }

  // void _openFilterSheet() {
  //   showModalBottomSheet<void>(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: AppColors.surface,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     builder: (context) {
  //       var tempType = _type;
  //       var tempStatus = _status;
  //       var tempPriority = _priority;
  //       var tempProjectId = _selectedProjectId;
  //       final tempSearch = TextEditingController(text: _searchController.text);
  //
  //       return Padding(
  //         padding: EdgeInsets.only(
  //           bottom: MediaQuery.of(context).viewInsets.bottom,
  //         ),
  //         child: SingleChildScrollView(
  //           padding: const EdgeInsets.all(16),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const Text('Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
  //               const SizedBox(height: 12),
  //               TextField(
  //                 controller: tempSearch,
  //                 decoration: const InputDecoration(
  //                   prefixIcon: Icon(Icons.search),
  //                   hintText: 'Search tasks',
  //                 ),
  //               ),
  //               const SizedBox(height: 12),
  //               Wrap(
  //                 spacing: 12,
  //                 runSpacing: 8,
  //                 children: [
  //                   DropdownButton<String>(
  //                     value: tempType,
  //                     items: const [
  //                       DropdownMenuItem(value: 'all', child: Text('All')),
  //                       DropdownMenuItem(value: 'daily', child: Text('Daily')),
  //                       DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
  //                       DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
  //                       DropdownMenuItem(value: 'project', child: Text('Project')),
  //                     ],
  //                     onChanged: (v) => tempType = v ?? 'all',
  //                   ),
  //                   FutureBuilder<List<Project>>(
  //                     future: _loadProjects(),
  //                     builder: (context, snapshot) {
  //                       final items = snapshot.data ?? <Project>[];
  //                       return DropdownButton<String?>(
  //                         value: tempProjectId,
  //                         hint: const Text('Any project'),
  //                         items: <DropdownMenuItem<String?>>[
  //                           const DropdownMenuItem<String?>(child: Text('Any project')),
  //                           ...items.map((p) => DropdownMenuItem<String?>(value: p.id, child: Text(p.title))),
  //                         ],
  //                         onChanged: (v) => tempProjectId = v,
  //                       );
  //                     },
  //                   ),
  //                   DropdownButton<String>(
  //                     value: tempStatus,
  //                     items: const [
  //                       DropdownMenuItem(value: 'all', child: Text('Any status')),
  //                       DropdownMenuItem(value: 'pending', child: Text('Pending')),
  //                       DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
  //                       DropdownMenuItem(value: 'completed', child: Text('Completed')),
  //                       DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
  //                     ],
  //                     onChanged: (v) => tempStatus = v ?? 'all',
  //                   ),
  //                   DropdownButton<String>(
  //                     value: tempPriority,
  //                     items: const [
  //                       DropdownMenuItem(value: 'all', child: Text('Any priority')),
  //                       DropdownMenuItem(value: 'low', child: Text('Low')),
  //                       DropdownMenuItem(value: 'medium', child: Text('Medium')),
  //                       DropdownMenuItem(value: 'high', child: Text('High')),
  //                       DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
  //                     ],
  //                     onChanged: (v) => tempPriority = v ?? 'all',
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 16),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   TextButton(
  //                     onPressed: () {
  //                       setState(() {
  //                         _searchController.clear();
  //                         _type = 'all';
  //                         _status = 'all';
  //                         _priority = 'all';
  //                         _selectedProjectId = null;
  //                       });
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: const Text('Reset'),
  //                   ),
  //                   const SizedBox(width: 8),
  //                   ElevatedButton.icon(
  //                     onPressed: () {
  //                       setState(() {
  //                         _searchController.text = tempSearch.text;
  //                         _type = tempType;
  //                         _status = tempStatus;
  //                         _priority = tempPriority;
  //                         _selectedProjectId = tempProjectId;
  //                       });
  //                       Navigator.of(context).pop();
  //                     },
  //                     icon: const Icon(Icons.check),
  //                     label: const Text('Apply'),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 12),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  //
  // String? _selectedProjectId;
  // Future<List<Project>> _loadProjects() async {
  //   final storage = StorageService();
  //   final workspaceId = storage.getWorkspaceId() ?? '';
  //   if (workspaceId.isEmpty) return <Project>[];
  //   return FirebaseDatabaseService.instance.listProjects(workspaceId: workspaceId);
  // }
}


