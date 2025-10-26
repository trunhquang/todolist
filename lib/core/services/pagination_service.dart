import 'package:get/get.dart';

import 'storage_service.dart';

/// Service for handling pagination and query limits
class PaginationService extends GetxService {
  static PaginationService get instance => Get.find<PaginationService>();
  
  late StorageService _storageService;

  // Default pagination settings
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const int minPageSize = 5;

  @override
  Future<void> onInit() async {
    super.onInit();
    _storageService = Get.find<StorageService>();
  }

  /// Get paginated results with cursor-based pagination (server-side pagination)
  Future<PaginatedResult<T>> getPaginatedResultsWithCursor<T>({
    required String cacheKey,
    required Future<PaginatedResult<T>> Function(String? cursor, int limit) fetchFunction,
    String? cursor,
    int? pageSize,
    bool useCache = true,
  }) async {
    try {
      final size = _validatePageSize(pageSize);

      // Check cache first
      if (useCache) {
        final cached = _getCachedResults<T>(cacheKey, 1, size);
        if (cached != null) {
          return cached;
        }
      }

      // Fetch from source using cursor
      final result = await fetchFunction(cursor, size);
      
      // Cache the result
      if (useCache) {
        _cacheResults(cacheKey, result.page, size, result);
      }

      return result;
    } catch (e) {
      throw Exception('Failed to get paginated results: $e');
    }
  }

  /// Get paginated results with caching (client-side pagination)
  Future<PaginatedResult<T>> getPaginatedResults<T>({
    required String cacheKey,
    required Future<List<T>> Function(int limit, int offset) fetchFunction,
    int page = 1,
    int? pageSize,
    bool useCache = true,
  }) async {
    try {
      final size = _validatePageSize(pageSize);
      final offset = (page - 1) * size;

      // Check cache first
      if (useCache) {
        try {
          final cached = _getCachedResults<T>(cacheKey, page, size);
          if (cached != null) {
            return cached;
          }
        } catch (e) {
          // If cache fails, continue without cache
          print('Cache error, continuing without cache: $e');
        }
      }

      // Fetch from source
      final results = await fetchFunction(size, offset);
      
      // Create paginated result
      final paginatedResult = PaginatedResult<T>(
        data: results,
        page: page,
        pageSize: size,
        hasNextPage: results.length >= size, // If we got full page, there might be more
        hasPreviousPage: page > 1,
        totalCount: results.length, // This would be improved with total count from server
        cacheKey: cacheKey,
      );

      // Cache the result
      if (useCache) {
        try {
          _cacheResults(cacheKey, page, size, paginatedResult);
        } catch (e) {
          // If cache fails, continue without cache
          print('Cache error, continuing without cache: $e');
        }
      }

      return paginatedResult;
    } catch (e) {
      return PaginatedResult<T>(
        data: [],
        page: page,
        pageSize: pageSize ?? defaultPageSize,
        hasNextPage: false,
        hasPreviousPage: page > 1,
        totalCount: 0,
        cacheKey: cacheKey,
        error: 'Failed to fetch paginated results: $e',
      );
    }
  }

  /// Get next page of results
  Future<PaginatedResult<T>> getNextPage<T>({
    required String cacheKey,
    required Future<List<T>> Function(int limit, int offset) fetchFunction,
    required PaginatedResult<T> currentResult,
    bool useCache = true,
  }) async {
    if (!currentResult.hasNextPage) {
      return currentResult;
    }

    return getPaginatedResults<T>(
      cacheKey: cacheKey,
      fetchFunction: fetchFunction,
      page: currentResult.page + 1,
      pageSize: currentResult.pageSize,
      useCache: useCache,
    );
  }

  /// Get previous page of results
  Future<PaginatedResult<T>> getPreviousPage<T>({
    required String cacheKey,
    required Future<List<T>> Function(int limit, int offset) fetchFunction,
    required PaginatedResult<T> currentResult,
    bool useCache = true,
  }) async {
    if (!currentResult.hasPreviousPage) {
      return currentResult;
    }

    return getPaginatedResults<T>(
      cacheKey: cacheKey,
      fetchFunction: fetchFunction,
      page: currentResult.page - 1,
      pageSize: currentResult.pageSize,
      useCache: useCache,
    );
  }

  /// Refresh current page
  Future<PaginatedResult<T>> refreshPage<T>({
    required String cacheKey,
    required Future<List<T>> Function(int limit, int offset) fetchFunction,
    required PaginatedResult<T> currentResult,
  }) async {
    // Clear cache for this page
    _clearCacheForPage(cacheKey, currentResult.page, currentResult.pageSize);

    return getPaginatedResults<T>(
      cacheKey: cacheKey,
      fetchFunction: fetchFunction,
      page: currentResult.page,
      pageSize: currentResult.pageSize,
      useCache: false, // Force fresh fetch
    );
  }

  /// Clear all cache for a specific key
  void clearCache(String cacheKey) {
    try {
      final keys = _storageService.getUserData<List<String>>('pagination_keys_$cacheKey') ?? [];
      for (final key in keys) {
        _storageService.removeUserData(key);
      }
      _storageService.removeUserData('pagination_keys_$cacheKey');
    } catch (e) {
      print('Failed to clear pagination cache: $e');
    }
  }

  /// Get cached results
  PaginatedResult<T>? _getCachedResults<T>(String cacheKey, int page, int pageSize) {
    try {
      final cacheKeyStr = 'pagination_${cacheKey}_${page}_$pageSize';
      final cached = _storageService.getUserData<Map<String, dynamic>>(cacheKeyStr);
      
      if (cached != null) {
        return PaginatedResult<T>.fromMap(cached);
      }
    } catch (e) {
      print('Failed to get cached results: $e');
    }
    return null;
  }

  /// Cache results
  void _cacheResults<T>(String cacheKey, int page, int pageSize, PaginatedResult<T> result) {
    try {
      final cacheKeyStr = 'pagination_${cacheKey}_${page}_$pageSize';
      _storageService.setUserData(cacheKeyStr, result.toMap());
      
      // Track cache keys for cleanup
      final keys = _storageService.getUserData<List<String>>('pagination_keys_$cacheKey') ?? [];
      if (!keys.contains(cacheKeyStr)) {
        keys.add(cacheKeyStr);
        _storageService.setUserData('pagination_keys_$cacheKey', keys);
      }
    } catch (e) {
      print('Failed to cache results: $e');
    }
  }

  /// Clear cache for specific page
  void _clearCacheForPage(String cacheKey, int page, int pageSize) {
    try {
      final cacheKeyStr = 'pagination_${cacheKey}_${page}_$pageSize';
      _storageService.removeUserData(cacheKeyStr);
    } catch (e) {
      print('Failed to clear cache for page: $e');
    }
  }

  /// Validate page size
  int _validatePageSize(int? pageSize) {
    if (pageSize == null) return defaultPageSize;
    if (pageSize < minPageSize) return minPageSize;
    if (pageSize > maxPageSize) return maxPageSize;
    return pageSize;
  }

  /// Get user's preferred page size
  int getUserPreferredPageSize() {
    return _storageService.getUserData<int>('preferred_page_size') ?? defaultPageSize;
  }

  /// Set user's preferred page size
  Future<void> setUserPreferredPageSize(int pageSize) async {
    final validatedSize = _validatePageSize(pageSize);
    await _storageService.setUserData('preferred_page_size', validatedSize);
  }
}

/// Paginated result container
class PaginatedResult<T> {

  PaginatedResult({
    required this.data,
    required this.page,
    required this.pageSize,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.totalCount,
    required this.cacheKey,
    this.error,
  });

  factory PaginatedResult.fromMap(Map<String, dynamic> map) {
    return PaginatedResult<T>(
      data: (map['data'] as List<dynamic>?)?.cast<T>() ?? [],
      page: (map['page'] as int?) ?? 1,
      pageSize: (map['pageSize'] as int?) ?? PaginationService.defaultPageSize,
      hasNextPage: (map['hasNextPage'] as bool?) ?? false,
      hasPreviousPage: (map['hasPreviousPage'] as bool?) ?? false,
      totalCount: (map['totalCount'] as int?) ?? 0,
      cacheKey: (map['cacheKey'] as String?) ?? '',
      error: map['error'] as String?,
    );
  }
  final List<T> data;
  final int page;
  final int pageSize;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final int totalCount;
  final String cacheKey;
  final String? error;

  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'page': page,
      'pageSize': pageSize,
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
      'totalCount': totalCount,
      'cacheKey': cacheKey,
      'error': error,
    };
  }

  /// Check if there's an error
  bool get hasError => error != null;

  /// Get total pages (estimated)
  int get totalPages => (totalCount / pageSize).ceil();

  /// Check if this is the first page
  bool get isFirstPage => page == 1;

  /// Check if this is the last page
  bool get isLastPage => !hasNextPage;

  /// Create a copy with updated values
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
