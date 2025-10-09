import 'package:get/get.dart';

import '../../../../core/services/pagination_service.dart';
import '../../../../core/services/firebase_database_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/project.dart';

/// Controller for paginated project management
class PaginatedProjectController extends GetxController {
  final PaginationService _paginationService;
  final FirebaseDatabaseService _databaseService;
  final StorageService _storageService;

  PaginatedProjectController({
    PaginationService? paginationService,
    FirebaseDatabaseService? databaseService,
    StorageService? storageService,
  }) : _paginationService = paginationService ?? Get.find<PaginationService>(),
       _databaseService = databaseService ?? Get.find<FirebaseDatabaseService>(),
       _storageService = storageService ?? Get.find<StorageService>();

  // Private observables
  final _currentResult = Rxn<PaginatedResult<Project>>();
  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _error = RxnString();

  // Public getters
  PaginatedResult<Project>? get currentResult => _currentResult.value;
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  String? get error => _error.value;
  List<Project> get projects => _currentResult.value?.data ?? [];
  bool get hasNextPage => _currentResult.value?.hasNextPage ?? false;
  bool get hasPreviousPage => _currentResult.value?.hasPreviousPage ?? false;
  int get currentPage => _currentResult.value?.page ?? 1;
  int get pageSize => _currentResult.value?.pageSize ?? PaginationService.defaultPageSize;

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

      final companyId = _storageService.getCompanyId();
      if (companyId == null || companyId.isEmpty) {
        _error.value = 'No company ID found';
        return;
      }

      final cacheKey = _buildCacheKey(
        departmentId: departmentId,
        status: status,
      );

      final result = await _paginationService.getPaginatedResults<Project>(
        cacheKey: cacheKey,
        fetchFunction: (limit, offset) => _fetchProjects(
          companyId: companyId,
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
      _error.value = 'Failed to load projects: $e';
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
          companyId: _storageService.getCompanyId()!,
          limit: limit,
          offset: offset,
          departmentId: _extractFilterFromCacheKey(current.cacheKey, 'departmentId'),
          status: _extractFilterFromCacheKey(current.cacheKey, 'status'),
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
      final prevResult = await _paginationService.getPreviousPage<Project>(
        cacheKey: current.cacheKey,
        fetchFunction: (limit, offset) => _fetchProjects(
          companyId: _storageService.getCompanyId()!,
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
          companyId: _storageService.getCompanyId()!,
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

  /// Fetch projects from database with pagination
  Future<List<Project>> _fetchProjects({
    required String companyId,
    required int limit,
    required int offset,
    String? departmentId,
    String? status,
  }) async {
    // Get all projects first (this would be optimized with server-side pagination)
    final allProjects = await _databaseService.listProjects(
      companyId: companyId,
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
extension PaginatedResultProjectExtension<T> on PaginatedResult<T> {
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
