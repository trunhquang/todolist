import 'package:get/get.dart';
import 'package:todolist/core/services/firebase_database_service.dart';
import 'package:todolist/core/services/permission_service.dart';
import 'package:todolist/core/services/storage_service.dart';
import 'package:todolist/core/services/workspace_context_service.dart';
import 'package:todolist/features/tasks/data/repositories/project_repository_impl.dart';
import 'package:todolist/features/tasks/domain/repositories/project_repository.dart';
import 'package:todolist/features/tasks/domain/usecases/calculate_project_progress.dart';
import 'package:todolist/features/tasks/domain/usecases/calculate_workspace_projects_summary.dart';
import 'package:todolist/features/tasks/presentation/controllers/project_controller.dart';
import 'package:todolist/features/tasks/presentation/controllers/project_list_page_controller.dart';
import 'package:todolist/features/tasks/presentation/controllers/task_controller.dart';

import '../../../features/auth/presentation/controllers/auth_controller.dart';

class ProjectBindings extends Bindings {
  @override
  void dependencies() {
    // Core services
    Get.lazyPut<PermissionService>(() => PermissionService(), fenix: true);
    Get.lazyPut<WorkspaceContextService>(() => WorkspaceContextService(), fenix: true);

    // Repository & use cases
    Get.lazyPut<ProjectRepository>(
      () => ProjectRepositoryImpl(FirebaseDatabaseService.instance),
      fenix: true,
    );
    Get.lazyPut<CalculateProjectProgress>(
      () => CalculateProjectProgress(Get.find<ProjectRepository>()),
      fenix: true,
    );
    Get.lazyPut<CalculateWorkspaceProjectsSummary>(
      () => CalculateWorkspaceProjectsSummary(Get.find<ProjectRepository>()),
      fenix: true,
    );

    // Controllers
    Get.lazyPut<TaskController>(
      () => TaskController(
        workspaceContext: Get.find<WorkspaceContextService>(),
        permissionService: Get.find<PermissionService>(),
        authController: Get.find<AuthController>(),
      ),
      fenix: true,
    );
    Get.lazyPut<ProjectController>(
      () => ProjectController(
        projectRepository: Get.find<ProjectRepository>(),
        calculateProgress: Get.find<CalculateProjectProgress>(),
        workspaceContext: Get.find<WorkspaceContextService>(),
        permissionService: Get.find<PermissionService>(),
      ),
      fenix: true,
    );
    Get.lazyPut<ProjectListPageController>(
      () => ProjectListPageController(
        databaseService: FirebaseDatabaseService.instance,
        storageService: Get.find<StorageService>(),
        permissionService: Get.find<PermissionService>(),
        calculateSummary: Get.find<CalculateWorkspaceProjectsSummary>(),
      ),
      fenix: true,
    );
  }
}
