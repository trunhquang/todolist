import 'package:get/get.dart';

import '../../../../core/services/pagination_service.dart';
import '../../../../core/services/firebase_database_service.dart';
import '../../../../core/services/firebase_database_service_enhanced.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/task_enums.dart';
import '../../domain/entities/task.dart';

/// Controller for paginated task management
class PaginatedTaskController extends GetxController {
  final PaginationService _paginationService;
  final FirebaseDatabaseService _databaseService;
  final StorageService _storageService;

  PaginatedTaskController({
    PaginationService? paginationService,
    FirebaseDatabaseService? databaseService,
    StorageService? storageService,
  }) : _paginationService = paginationService ?? Get.find<PaginationService>(),
       _databaseService = databaseService ?? Get.find<FirebaseDatabaseService>(),
       _storageService = storageService ?? Get.find<StorageService>();

  // Private observables
  final _currentResult = Rxn<PaginatedResult<TaskEntity>>();
  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _error = RxnString();

  // Public getters
  PaginatedResult<TaskEntity>? get currentResult => _currentResult.value;
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  String? get error => _error.value;
  List<TaskEntity> get tasks => _currentResult.value?.data ?? [];
  bool get hasNextPage => _currentResult.value?.hasNextPage ?? false;
  bool get hasPreviousPage => _currentResult.value?.hasPreviousPage ?? false;
  int get currentPage => _currentResult.value?.page ?? 1;
  int get pageSize => _currentResult.value?.pageSize ?? PaginationService.defaultPageSize;

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

  /// Load tasks with pagination
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

      final companyId = _storageService.getCompanyId();
      if (companyId == null || companyId.isEmpty) {
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
          companyId: companyId,
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

  /// Load next page
  Future<void> loadNextPage() async {
    if (!hasNextPage || isLoadingMore) return;

    try {
      _isLoadingMore.value = true;
      _error.value = null;

      final current = _currentResult.value!;
      final nextResult = await _paginationService.getNextPage<TaskEntity>(
        cacheKey: current.cacheKey,
        fetchFunction: (limit, offset) => _fetchTasks(
          companyId: _storageService.getCompanyId()!,
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
          companyId: _storageService.getCompanyId()!,
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
          companyId: _storageService.getCompanyId()!,
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
    required String companyId,
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
      if (_databaseService is FirebaseDatabaseServiceEnhanced) {
        final enhancedService = _databaseService as FirebaseDatabaseServiceEnhanced;
        final result = await enhancedService.getPaginatedTasks(
          companyId: companyId,
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
          companyId: companyId,
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
        companyId: companyId,
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
extension PaginatedResultExtension<T> on PaginatedResult<T> {
  PaginatedResult<T> copyWith({
    List<T>? data,
    int? page,
    int? pageSize,
    bool? hasNextPage,
    bool? hasPreviousPage,
    int? totalCount,
    String? cacheKey,
    String? error,
  }) {
    return PaginatedResult<T>(
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
