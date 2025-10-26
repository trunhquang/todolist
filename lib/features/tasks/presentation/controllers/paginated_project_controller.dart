import 'package:get/get.dart';

import '../../../../core/services/pagination_service.dart' as pagination;
import '../../../../core/services/firebase_database_service.dart';
import '../../../../core/services/firebase_database_service_enhanced.dart' as enhanced;
import '../../../../core/services/storage_service.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/task_enums.dart';
import '../../domain/entities/project.dart';

/// Controller for paginated project management
class PaginatedProjectController extends GetxController {
  final pagination.PaginationService _paginationService;
  final FirebaseDatabaseService _databaseService;
  final StorageService _storageService;

  PaginatedProjectController({
    pagination.PaginationService? paginationService,
    FirebaseDatabaseService? databaseService,
    StorageService? storageService,
  }) : _paginationService = paginationService ?? Get.find<pagination.PaginationService>(),
       _databaseService = databaseService ?? Get.find<FirebaseDatabaseService>(),
       _storageService = storageService ?? Get.find<StorageService>();

  // Private observables
  final _currentResult = Rxn<pagination.PaginatedResult<Project>>();
  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _error = RxnString();

  // Public getters
  pagination.PaginatedResult<Project>? get currentResult => _currentResult.value;
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  String? get error => _error.value;
  List<Project> get projects => _currentResult.value?.data ?? [];
  bool get hasNextPage => _currentResult.value?.hasNextPage ?? false;
  bool get hasPreviousPage => _currentResult.value?.hasPreviousPage ?? false;
  int get currentPage => _currentResult.value?.page ?? 1;
  int get pageSize => _currentResult.value?.pageSize ?? pagination.PaginationService.defaultPageSize;

  @override
  void onInit() {
    super.onInit();
    _loadFirstPage();
  }

  /// Load first page of projects
  Future<void> _loadFirstPage() async {
    await loadProjects(
      page: 1,
      pageSize: _paginationService.getUserPreferredPageSize(),
    );
  }

  /// Load projects with pagination
  Future<void> loadProjects({
    int page = 1,
    int? pageSize,
    String? departmentId,
    String? status,
    bool useCache = true,
  }) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      final workspaceId = _storageService.getWorkspaceId();
      if (workspaceId == null || workspaceId.isEmpty) {
        _error.value = AppStrings.noworkspaceIdFound;
        return;
      }

      final cacheKey = _buildCacheKey(
        departmentId: departmentId,
        status: status,
      );

      final result = await _paginationService.getPaginatedResults<Project>(
        cacheKey: cacheKey,
        fetchFunction: (limit, offset) => _fetchProjects(
          workspaceId: workspaceId,
          limit: limit,
          offset: offset,
          departmentId: departmentId,
          status: status,
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
      _error.value = '${AppStrings.failedToLoadProjects}: $e';
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
      final nextResult = await _paginationService.getNextPage<Project>(
        cacheKey: current.cacheKey,
        fetchFunction: (limit, offset) => _fetchProjects(
          workspaceId: _storageService.getWorkspaceId()!,
          limit: limit,
          offset: offset,
          departmentId: _extractFilterFromCacheKey(current.cacheKey, 'departmentId'),
          status: _extractFilterFromCacheKey(current.cacheKey, 'status'),
        ),
        currentResult: current,
      );

      // Append new data to existing data
      final combinedData = [...current.data, ...nextResult.data];
      _currentResult.value = pagination.PaginatedResult<Project>(
        data: combinedData,
        page: nextResult.page,
        pageSize: nextResult.pageSize,
        hasNextPage: nextResult.hasNextPage,
        hasPreviousPage: nextResult.hasPreviousPage,
        totalCount: nextResult.totalCount,
        cacheKey: nextResult.cacheKey,
        error: nextResult.error,
      );
      
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
      final prevResult = await _paginationService.getPreviousPage<Project>(
        cacheKey: current.cacheKey,
        fetchFunction: (limit, offset) => _fetchProjects(
          workspaceId: _storageService.getWorkspaceId()!,
          limit: limit,
          offset: offset,
          departmentId: _extractFilterFromCacheKey(current.cacheKey, 'departmentId'),
          status: _extractFilterFromCacheKey(current.cacheKey, 'status'),
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
      final refreshedResult = await _paginationService.refreshPage<Project>(
        cacheKey: current.cacheKey,
        fetchFunction: (limit, offset) => _fetchProjects(
          workspaceId: _storageService.getWorkspaceId()!,
          limit: limit,
          offset: offset,
          departmentId: _extractFilterFromCacheKey(current.cacheKey, 'departmentId'),
          status: _extractFilterFromCacheKey(current.cacheKey, 'status'),
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

  /// Fetch projects from database with server-side pagination
  Future<List<Project>> _fetchProjects({
    required String workspaceId,
    required int limit,
    required int offset,
    String? departmentId,
    String? status,
  }) async {
    // Use server-side pagination for better performance
    final page = (offset ~/ limit) + 1;
    final lastProjectId = offset > 0 ? 'last-project-id-$offset' : null; // This would be the actual last project ID in real implementation
    
    try {
      // Try to use enhanced service if available
      if (_databaseService is enhanced.FirebaseDatabaseServiceEnhanced) {
        final enhancedService = _databaseService as enhanced.FirebaseDatabaseServiceEnhanced;
        final result = await enhancedService.getPaginatedProjects(
          workspaceId: workspaceId,
          page: page,
          pageSize: limit,
          lastProjectId: lastProjectId,
          status: status != null ? ProjectStatus.fromString(status) : null,
        );
        return result.data;
      } else {
        // Fallback to client-side pagination for backward compatibility
        final allProjects = await _databaseService.listProjects(
          workspaceId: workspaceId,
          departmentId: departmentId,
          status: status,
        );

        // Apply client-side pagination
        final startIndex = offset;
        final endIndex = (startIndex + limit).clamp(0, allProjects.length);
        
        if (startIndex >= allProjects.length) {
          return [];
        }

        return allProjects.sublist(startIndex, endIndex);
      }
    } catch (e) {
      // Fallback to client-side pagination on error
      final allProjects = await _databaseService.listProjects(
        workspaceId: workspaceId,
        departmentId: departmentId,
        status: status,
      );

      // Apply client-side pagination
      final startIndex = offset;
      final endIndex = (startIndex + limit).clamp(0, allProjects.length);
      
      if (startIndex >= allProjects.length) {
        return [];
      }

      return allProjects.sublist(startIndex, endIndex);
    }
  }

  /// Build cache key from filters
  String _buildCacheKey({
    String? departmentId,
    String? status,
  }) {
    final filters = <String>[];
    if (departmentId != null) filters.add('departmentId:$departmentId');
    if (status != null) filters.add('status:$status');
    
    return 'projects_${filters.join('_')}';
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
extension PaginatedResultProjectExtension<T> on pagination.PaginatedResult<T> {
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
