import 'package:get/get.dart';

import '../../../../core/services/pagination_service.dart' as pagination;
import '../../../../core/services/firebase_database_service.dart';
import '../../../../core/services/firebase_database_service_enhanced.dart' as enhanced;
import '../../../../core/services/storage_service.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/task_enums.dart';
import '../../domain/entities/task.dart';

/// Controller for paginated task management
class PaginatedTaskController extends GetxController {
  final pagination.PaginationService _paginationService;
  final FirebaseDatabaseService _databaseService;
  final StorageService _storageService;

  PaginatedTaskController({
    pagination.PaginationService? paginationService,
    FirebaseDatabaseService? databaseService,
    StorageService? storageService,
  }) : _paginationService = paginationService ?? Get.find<pagination.PaginationService>(),
       _databaseService = databaseService ?? Get.find<FirebaseDatabaseService>(),
       _storageService = storageService ?? Get.find<StorageService>();

  // Private observables
  final _currentResult = Rxn<pagination.PaginatedResult<TaskEntity>>();
  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _error = RxnString();

  // Public getters
  pagination.PaginatedResult<TaskEntity>? get currentResult => _currentResult.value;
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  String? get error => _error.value;
  List<TaskEntity> get tasks => _currentResult.value?.data ?? [];
  bool get hasNextPage => _currentResult.value?.hasNextPage ?? false;
  bool get hasPreviousPage => _currentResult.value?.hasPreviousPage ?? false;
  int get currentPage => _currentResult.value?.page ?? 1;
  int get pageSize => _currentResult.value?.pageSize ?? pagination.PaginationService.defaultPageSize;

  @override
  void onInit() {
    super.onInit();
    _loadFirstPage();
  }

  /// Load first page of tasks
  Future<void> _loadFirstPage() async {
    await loadTasks(
      page: 1,
      pageSize: _paginationService.getUserPreferredPageSize(),
    );
  }

  /// Load tasks with cursor-based pagination (server-side)
  Future<void> loadTasksWithCursor({
    String? cursor,
    int? pageSize,
    String? type,
    String? status,
    String? priority,
    String? projectId,
    String? assignee,
    bool useCache = true,
  }) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final workspaceId = _storageService.getWorkspaceId();
      if (workspaceId == null || workspaceId.isEmpty) {
        _error.value = AppStrings.noCompanyIdFound;
        return;
      }

      // Use enhanced service for server-side pagination
      if (_databaseService is enhanced.FirebaseDatabaseServiceEnhanced) {
        final enhancedService = _databaseService as enhanced.FirebaseDatabaseServiceEnhanced;
        
        final result = await enhancedService.getPaginatedTasks(
          workspaceId: workspaceId,
          page: 1, // Cursor-based pagination doesn't use page numbers
          pageSize: pageSize ?? _paginationService.getUserPreferredPageSize(),
          lastTaskId: cursor,
          status: status != null ? TaskStatus.fromString(status) : null,
          priority: priority != null ? TaskPriority.fromString(priority) : null,
          type: type != null ? TaskType.fromString(type) : null,
          projectId: projectId,
          assigneeId: assignee,
        );

        if (cursor == null) {
          // First page - replace current data
          _currentResult.value = result;
        } else {
          // Subsequent pages - append to current data
          final current = _currentResult.value;
          if (current != null) {
            final combinedData = [...current.data, ...result.data];
                _currentResult.value = pagination.PaginatedResult<TaskEntity>(
                  data: combinedData,
                  page: result.page,
                  pageSize: result.pageSize,
                  hasNextPage: result.hasNextPage,
                  hasPreviousPage: result.hasPreviousPage,
                  totalCount: result.totalCount,
                  cacheKey: result.cacheKey,
                );
          } else {
            _currentResult.value = result;
          }
        }

        if (result.hasError) {
          _error.value = result.error;
        }
      } else {
        // Fallback to client-side pagination
        await loadTasks(
          page: 1,
          pageSize: pageSize,
          type: type,
          status: status,
          priority: priority,
          projectId: projectId,
          assignee: assignee,
          useCache: useCache,
        );
      }
    } catch (e) {
      _error.value = 'Failed to load tasks: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  /// Load tasks with pagination (client-side fallback)
  Future<void> loadTasks({
    int page = 1,
    int? pageSize,
    String? type,
    String? status,
    String? priority,
    String? projectId,
    String? assignee,
    bool useCache = true,
  }) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final workspaceId = _storageService.getWorkspaceId();
      if (workspaceId == null || workspaceId.isEmpty) {
        _error.value = AppStrings.noCompanyIdFound;
        return;
      }

      final cacheKey = _buildCacheKey(
        type: type,
        status: status,
        priority: priority,
        projectId: projectId,
        assignee: assignee,
      );

      final result = await _paginationService.getPaginatedResults<TaskEntity>(
        cacheKey: cacheKey,
        fetchFunction: (limit, offset) => _fetchTasks(
          workspaceId: workspaceId,
          limit: limit,
          offset: offset,
          type: type,
          status: status,
          priority: priority,
          projectId: projectId,
          assignee: assignee,
        ),
        page: page,
        pageSize: pageSize,
        useCache: useCache,
      );

      _currentResult.value = result;
      
      if (result.hasError) {
        _error.value = result.error;
      }
    } catch (e) {
      _error.value = '${AppStrings.failedToLoadTasks}: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  /// Load next page with cursor-based pagination
  Future<void> loadNextPageWithCursor() async {
    final current = _currentResult.value;
    if (current == null || !current.hasNextPage || _isLoading.value) {
      return;
    }

    // Get the last task ID as cursor
    final lastTask = current.data.last;
    final cursor = lastTask.id; // Assuming TaskEntity has an id field

    await loadTasksWithCursor(
      cursor: cursor,
      pageSize: current.pageSize,
    );
  }

  /// Load next page (client-side pagination)
  Future<void> loadNextPage() async {
    if (!hasNextPage || isLoadingMore) return;

    try {
      _isLoadingMore.value = true;
      _error.value = null;

      final current = _currentResult.value!;
      final nextResult = await _paginationService.getNextPage<TaskEntity>(
        cacheKey: current.cacheKey,
        fetchFunction: (limit, offset) => _fetchTasks(
          workspaceId: _storageService.getWorkspaceId()!,
          limit: limit,
          offset: offset,
          type: _extractFilterFromCacheKey(current.cacheKey, 'type'),
          status: _extractFilterFromCacheKey(current.cacheKey, 'status'),
          priority: _extractFilterFromCacheKey(current.cacheKey, 'priority'),
          projectId: _extractFilterFromCacheKey(current.cacheKey, 'projectId'),
          assignee: _extractFilterFromCacheKey(current.cacheKey, 'assignee'),
        ),
        currentResult: current,
      );

      // Append new data to existing data
        final combinedData = [...current.data, ...nextResult.data];
        _currentResult.value = nextResult.copyWith(data: combinedData);
      
      if (nextResult.hasError) {
        _error.value = nextResult.error;
      }
    } catch (e) {
      _error.value = 'Failed to load next page: $e';
    } finally {
      _isLoadingMore.value = false;
    }
  }

  /// Load previous page
  Future<void> loadPreviousPage() async {
    if (!hasPreviousPage || isLoading) return;

    try {
      _isLoading.value = true;
      _error.value = null;

      final current = _currentResult.value!;
      final prevResult = await _paginationService.getPreviousPage<TaskEntity>(
        cacheKey: current.cacheKey,
        fetchFunction: (limit, offset) => _fetchTasks(
          workspaceId: _storageService.getWorkspaceId()!,
          limit: limit,
          offset: offset,
          type: _extractFilterFromCacheKey(current.cacheKey, 'type'),
          status: _extractFilterFromCacheKey(current.cacheKey, 'status'),
          priority: _extractFilterFromCacheKey(current.cacheKey, 'priority'),
          projectId: _extractFilterFromCacheKey(current.cacheKey, 'projectId'),
          assignee: _extractFilterFromCacheKey(current.cacheKey, 'assignee'),
        ),
        currentResult: current,
      );

      _currentResult.value = prevResult;
      
      if (prevResult.hasError) {
        _error.value = prevResult.error;
      }
    } catch (e) {
      _error.value = 'Failed to load previous page: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  /// Refresh current page
  Future<void> refresh() async {
    if (_currentResult.value == null) return;

    try {
      _isLoading.value = true;
      _error.value = null;

      final current = _currentResult.value!;
      final refreshedResult = await _paginationService.refreshPage<TaskEntity>(
        cacheKey: current.cacheKey,
        fetchFunction: (limit, offset) => _fetchTasks(
          workspaceId: _storageService.getWorkspaceId()!,
          limit: limit,
          offset: offset,
          type: _extractFilterFromCacheKey(current.cacheKey, 'type'),
          status: _extractFilterFromCacheKey(current.cacheKey, 'status'),
          priority: _extractFilterFromCacheKey(current.cacheKey, 'priority'),
          projectId: _extractFilterFromCacheKey(current.cacheKey, 'projectId'),
          assignee: _extractFilterFromCacheKey(current.cacheKey, 'assignee'),
        ),
        currentResult: current,
      );

      _currentResult.value = refreshedResult;
      
      if (refreshedResult.hasError) {
        _error.value = refreshedResult.error;
      }
    } catch (e) {
      _error.value = 'Failed to refresh: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  /// Change page size
  Future<void> changePageSize(int newPageSize) async {
    await _paginationService.setUserPreferredPageSize(newPageSize);
    await _loadFirstPage();
  }

  /// Clear cache
  void clearCache() {
    if (_currentResult.value != null) {
      _paginationService.clearCache(_currentResult.value!.cacheKey);
    }
  }

  /// Fetch tasks from database with server-side pagination
  Future<List<TaskEntity>> _fetchTasks({
    required String workspaceId,
    required int limit,
    required int offset,
    String? type,
    String? status,
    String? priority,
    String? projectId,
    String? assignee,
  }) async {
    // Use server-side pagination for better performance
    final page = (offset ~/ limit) + 1;
    final lastTaskId = offset > 0 ? 'last-task-id-$offset' : null; // This would be the actual last task ID in real implementation
    
    try {
      // Try to use enhanced service if available
            if (_databaseService is enhanced.FirebaseDatabaseServiceEnhanced) {
              final enhancedService = _databaseService as enhanced.FirebaseDatabaseServiceEnhanced;
        final result = await enhancedService.getPaginatedTasks(
          workspaceId: workspaceId,
          page: page,
          pageSize: limit,
          lastTaskId: lastTaskId,
          status: status != null ? TaskStatus.fromString(status) : null,
          priority: priority != null ? TaskPriority.fromString(priority) : null,
          type: type != null ? TaskType.fromString(type) : null,
          projectId: projectId,
          assigneeId: assignee,
        );
        return result.data;
      } else {
        // Fallback to client-side pagination for backward compatibility
        final allTasks = await _databaseService.listTasks(
          workspaceId: workspaceId,
          type: type,
          status: status,
          priority: priority,
          projectId: projectId,
          assignee: assignee,
        );

        // Apply client-side pagination
        final startIndex = offset;
        final endIndex = (startIndex + limit).clamp(0, allTasks.length);
        
        if (startIndex >= allTasks.length) {
          return [];
        }

        return allTasks.sublist(startIndex, endIndex);
      }
    } catch (e) {
      // Fallback to client-side pagination on error
      final allTasks = await _databaseService.listTasks(
        workspaceId: workspaceId,
        type: type,
        status: status,
        priority: priority,
        projectId: projectId,
        assignee: assignee,
      );

      // Apply client-side pagination
      final startIndex = offset;
      final endIndex = (startIndex + limit).clamp(0, allTasks.length);
      
      if (startIndex >= allTasks.length) {
        return [];
      }

      return allTasks.sublist(startIndex, endIndex);
    }
  }

  /// Build cache key from filters
  String _buildCacheKey({
    String? type,
    String? status,
    String? priority,
    String? projectId,
    String? assignee,
  }) {
    final filters = <String>[];
    if (type != null) filters.add('type:$type');
    if (status != null) filters.add('status:$status');
    if (priority != null) filters.add('priority:$priority');
    if (projectId != null) filters.add('projectId:$projectId');
    if (assignee != null) filters.add('assignee:$assignee');
    
    return 'tasks_${filters.join('_')}';
  }

  /// Extract filter value from cache key
  String? _extractFilterFromCacheKey(String cacheKey, String filterName) {
    final parts = cacheKey.split('_');
    for (final part in parts) {
      if (part.startsWith('$filterName:')) {
        return part.substring('$filterName:'.length);
      }
    }
    return null;
  }
}

/// Extension to add copyWith method to PaginatedResult
extension PaginatedResultExtension<T> on pagination.PaginatedResult<T> {
  pagination.PaginatedResult<T> copyWith({
    List<T>? data,
    int? page,
    int? pageSize,
    bool? hasNextPage,
    bool? hasPreviousPage,
    int? totalCount,
    String? cacheKey,
    String? error,
  }) {
      return pagination.PaginatedResult<T>(
      data: data ?? this.data,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      totalCount: totalCount ?? this.totalCount,
      cacheKey: cacheKey ?? this.cacheKey,
      error: error ?? this.error,
    );
  }
}
