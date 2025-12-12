import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/app/routes/app_router.dart';
import 'package:todolist/core/services/navigation_service.dart';
import 'package:todolist/core/services/offline_queue_service.dart';
import 'package:todolist/core/services/permission_service.dart';
import 'package:todolist/core/services/storage_service.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/tasks/domain/entities/project_status.dart';
import 'package:todolist/features/tasks/domain/usecases/calculate_workspace_projects_summary.dart';

import '../../../../features/workspace/presentation/controllers/workspace_controller.dart';

class ProjectListPageController extends GetxController {
  ProjectListPageController({
    StorageService? storageService,
    PermissionService? permissionService,
    CalculateWorkspaceProjectsSummary? calculateSummary,
  })  :_storageService = storageService ?? StorageService(),
        _permissionService =
            permissionService ?? (Get.isRegistered<PermissionService>() ? Get.find<PermissionService>() : PermissionService()),
        _calculateSummary = calculateSummary;

  final StorageService _storageService;
  final PermissionService _permissionService;
  final CalculateWorkspaceProjectsSummary? _calculateSummary;

  final RxBool _isSummaryLoading = false.obs;
  final Rxn<ProjectStatus> _statusFilter = Rxn<ProjectStatus>();
  final RxString _searchQuery = ''.obs;
  final Rxn<WorkspaceProjectsSummary> _summary = Rxn<WorkspaceProjectsSummary>();

  final TextEditingController searchController = TextEditingController();

  List<Project> get filteredProjects {
    final query = _searchQuery.value;
    final controller = Get.find<WorkspaceController>();
    return controller.projects.where((project) {
      final matchesSearch = query.isEmpty || project.title.toLowerCase().contains(query);
      final matchesStatus = _statusFilter.value == null || project.status == _statusFilter.value;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  bool get isSummaryLoading => _isSummaryLoading.value;
  ProjectStatus? get statusFilter => _statusFilter.value;
  WorkspaceProjectsSummary? get summary => _summary.value;

  @override
  void onInit() {
    super.onInit();

    _loadSummary();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void updateSearch(String value) {
    _searchQuery.value = value.trim().toLowerCase();
  }

  Future<void> updateStatus(ProjectStatus? status) async {
    _statusFilter.value = status;
    await _loadSummary();
  }

  Future<void> refreshAll() async {
    await _loadSummary();
  }

  Future<void> onCreateProjectTap() async {
    await NavigationService().toNamed<void>(AppRouter.projectEdit);
    await _loadSummary();
  }

  Future<void> onProjectTap(Project project) async {
    await NavigationService().toNamed<void>(
      AppRouter.projectDetail,
      arguments: project,
    );
    await _loadSummary();
  }

  Future<void> onEditProject(Project project) async {
    await NavigationService().toNamed<void>(
      AppRouter.projectEdit,
      arguments: project,
    );
    await _loadSummary();
  }

  Future<void> deleteProject(Project project) async {
    final workspaceId = _storageService.getWorkspaceId() ?? project.workspaceId;
    if (workspaceId.isEmpty) {
      return;
    }
    await OfflineQueueService.instance.deleteProject(
      workspaceId: workspaceId,
      projectId: project.id,
    );
    await _loadSummary();
  }

  Future<bool> canManageProject(Project project) async {
    final userId = _storageService.getUserId() ?? '';
    if (userId.isEmpty) return false;
    if (project.createdBy == userId) return true;
    return _permissionService.canManageProject(userId, project.workspaceId);
  }

  Future<void> _loadSummary() async {
    if (_calculateSummary == null) return;
    final workspaceId = _storageService.getWorkspaceId() ?? '';
    if (workspaceId.isEmpty) return;

    try {
      _isSummaryLoading.value = true;
      final summaryResult = await _calculateSummary.call(workspaceId: workspaceId);
      _summary.value = summaryResult;
    } catch (_) {
      _summary.value = null;
    } finally {
      _isSummaryLoading.value = false;
    }
  }
}
