import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import '../errors/failures.dart';
import 'pagination_service.dart' as pagination;

/// Enhanced pagination service specifically for Firebase Realtime Database
/// Implements true server-side pagination using Firebase cursors
class FirebasePaginationService extends GetxService {
  static FirebasePaginationService get instance => Get.find<FirebasePaginationService>();
  
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  /// Get paginated results with true server-side pagination
  Future<pagination.PaginatedResult<T>> getPaginatedResults<T>({
    required DatabaseReference ref,
    required T Function(Map<String, dynamic>) fromMap,
    required String idField,
    int page = 1,
    int pageSize = 20,
    String? lastItemId,
    String? orderBy,
    bool ascending = false,
    Map<String, dynamic>? filters,
    String? cacheKey,
  }) async {
    try {
      Query query = ref;

      // Apply ordering (required for pagination)
      if (orderBy != null) {
        query = query.orderByChild(orderBy);
      } else {
        query = query.orderByKey();
      }

      // Apply pagination cursor
      if (lastItemId != null) {
        if (ascending) {
          query = query.startAfter(lastItemId);
        } else {
          query = query.endBefore(lastItemId);
        }
      }

      // Apply limit (server-side pagination)
      if (ascending) {
        query = query.limitToFirst(pageSize + 1); // +1 to check if there's a next page
      } else {
        query = query.limitToLast(pageSize + 1); // +1 to check if there's a next page
      }

      final snapshot = await query.get();
      final items = <T>[];

      if (snapshot.exists) {
        final data = snapshot.value! as Map<dynamic, dynamic>;
        final entries = data.entries.toList();
        
        // Sort entries by key if needed (Firebase maintains order)
        if (!ascending) {
          entries.sort((a, b) => (b.key as String).compareTo(a.key as String));
        }

        // Process only the requested page size
        final entriesToProcess = entries.take(pageSize).toList();
        
        for (final entry in entriesToProcess) {
          try {
            final itemData = Map<String, dynamic>.from(entry.value as Map);
            itemData[idField] = entry.key;
            final item = fromMap(itemData);
            
            // Apply client-side filters if needed (for complex filters)
            if (filters == null || _matchesFilters(itemData, filters)) {
              items.add(item);
            }
          } catch (e) {
            // Skip invalid entries
            continue;
          }
        }
      }

        // Determine if there are more pages
        final hasNextPage = snapshot.exists && 
            (snapshot.value! as Map<dynamic, dynamic>).length > pageSize;
        final hasPreviousPage = page > 1;

              return pagination.PaginatedResult<T>(
        data: items,
        page: page,
        pageSize: pageSize,
        hasNextPage: hasNextPage,
        hasPreviousPage: hasPreviousPage,
        totalCount: 0, // Firebase doesn't provide total count efficiently
        cacheKey: cacheKey ?? _buildCacheKey(ref.path, page, pageSize, filters),
      );
    } catch (e) {
      throw ServerFailure(message: 'Failed to fetch paginated results: $e');
    }
  }

  /// Get paginated results with compound queries (multiple filters)
  Future<pagination.PaginatedResult<T>> getPaginatedResultsWithFilters<T>({
    required DatabaseReference ref,
    required T Function(Map<String, dynamic>) fromMap,
    required String idField,
    int page = 1,
    int pageSize = 20,
    String? lastItemId,
    String? orderBy,
    bool ascending = false,
    Map<String, dynamic>? filters,
    String? cacheKey,
  }) async {
    try {
      // For complex filters, we need to use a different approach
      // Firebase Realtime Database doesn't support compound queries efficiently
      // So we'll use the primary filter and apply others client-side
      
      Query query = ref;
      String? primaryFilterKey;
      dynamic primaryFilterValue;

      // Find the most selective filter to use as primary
      if (filters != null && filters.isNotEmpty) {
        primaryFilterKey = filters.keys.first;
        primaryFilterValue = filters[primaryFilterKey];
        
        query = query.orderByChild(primaryFilterKey).equalTo(primaryFilterValue);
      } else if (orderBy != null) {
        query = query.orderByChild(orderBy);
      } else {
        query = query.orderByKey();
      }

      // Apply pagination cursor
      if (lastItemId != null) {
        if (ascending) {
          query = query.startAfter(lastItemId);
        } else {
          query = query.endBefore(lastItemId);
        }
      }

      // Apply limit (server-side pagination)
      if (ascending) {
        query = query.limitToFirst(pageSize * 2); // Get more to account for filtering
      } else {
        query = query.limitToLast(pageSize * 2); // Get more to account for filtering
      }

      final snapshot = await query.get();
      final items = <T>[];

      if (snapshot.exists) {
        final data = snapshot.value! as Map<dynamic, dynamic>;
        final entries = data.entries.toList();
        
        // Sort entries by key if needed
        if (!ascending) {
          entries.sort((a, b) => (b.key as String).compareTo(a.key as String));
        }

        // Process entries and apply all filters
        for (final entry in entries) {
          if (items.length >= pageSize) break;
          
          try {
            final itemData = Map<String, dynamic>.from(entry.value as Map);
            itemData[idField] = entry.key;
            
            // Apply all filters
            if (filters == null || _matchesFilters(itemData, filters)) {
              final item = fromMap(itemData);
              items.add(item);
            }
          } catch (e) {
            // Skip invalid entries
            continue;
          }
        }
      }

        // Determine if there are more pages
        final hasNextPage = snapshot.exists && 
            (snapshot.value! as Map<dynamic, dynamic>).length >= pageSize * 2;
        final hasPreviousPage = page > 1;

              return pagination.PaginatedResult<T>(
        data: items,
        page: page,
        pageSize: pageSize,
        hasNextPage: hasNextPage,
        hasPreviousPage: hasPreviousPage,
        totalCount: 0,
        cacheKey: cacheKey ?? _buildCacheKey(ref.path, page, pageSize, filters),
      );
    } catch (e) {
      throw ServerFailure(message: 'Failed to fetch paginated results with filters: $e');
    }
  }

  /// Helper method to apply client-side filters
  bool _matchesFilters(Map<String, dynamic> itemData, Map<String, dynamic> filters) {
    for (final entry in filters.entries) {
      final key = entry.key;
      final value = entry.value;
      
      if (itemData[key] != value) {
        return false;
      }
    }
    return true;
  }

  /// Build cache key for pagination results
  String _buildCacheKey(String path, int page, int pageSize, Map<String, dynamic>? filters) {
    final filterString = filters?.entries
        .map((e) => '${e.key}:${e.value}')
        .join(',') ?? '';
    return 'firebase_pagination:$path:page:$page:size:$pageSize:filters:$filterString';
  }

  /// Get next page cursor
  String? getNextPageCursor<T>(pagination.PaginatedResult<T> currentResult) {
    if (!currentResult.hasNextPage || currentResult.data.isEmpty) {
      return null;
    }
    
    // Return the ID of the last item in current page
    // This will be used as the cursor for the next page
    final lastItem = currentResult.data.last;
    
    // This is a simplified approach - in real implementation,
    // you'd need to extract the actual ID field from the item
    return lastItem.toString();
  }

  /// Get previous page cursor
  String? getPreviousPageCursor<T>(pagination.PaginatedResult<T> currentResult) {
    if (!currentResult.hasPreviousPage || currentResult.data.isEmpty) {
      return null;
    }
    
    // Return the ID of the first item in current page
    final firstItem = currentResult.data.first;
    return firstItem.toString();
  }
}
