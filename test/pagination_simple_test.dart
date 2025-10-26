import 'package:flutter_test/flutter_test.dart';
import 'package:todolist/core/services/pagination_service.dart';

void main() {
  group('Pagination Simple Tests', () {
    test('should validate page size correctly', () {
      // Test default page size
      expect(PaginationService.defaultPageSize, equals(20));
      expect(PaginationService.minPageSize, equals(5));
      expect(PaginationService.maxPageSize, equals(100));
    });

    test('should create paginated result correctly', () {
      final data = ['item1', 'item2', 'item3'];
      final result = PaginatedResult<String>(
        data: data,
        page: 1,
        pageSize: 10,
        hasNextPage: true,
        hasPreviousPage: false,
        totalCount: 25,
        cacheKey: 'test',
      );

      expect(result.data.length, equals(3));
      expect(result.page, equals(1));
      expect(result.pageSize, equals(10));
      expect(result.hasNextPage, isTrue);
      expect(result.hasPreviousPage, isFalse);
      expect(result.totalCount, equals(25));
      expect(result.cacheKey, equals('test'));
      expect(result.hasError, isFalse);
    });

    test('should handle error correctly', () {
      final result = PaginatedResult<String>(
        data: [],
        page: 1,
        pageSize: 10,
        hasNextPage: false,
        hasPreviousPage: false,
        totalCount: 0,
        cacheKey: 'test',
        error: 'Test error',
      );

      expect(result.hasError, isTrue);
      expect(result.error, equals('Test error'));
    });

    test('should calculate total pages correctly', () {
      final result = PaginatedResult<String>(
        data: ['item1', 'item2'],
        page: 1,
        pageSize: 10,
        hasNextPage: false,
        hasPreviousPage: false,
        totalCount: 25,
        cacheKey: 'test',
      );

      expect(result.totalPages, equals(3)); // ceil(25/10) = 3
    });

    test('should identify first and last pages correctly', () {
      final firstPage = PaginatedResult<String>(
        data: ['item1'],
        page: 1,
        pageSize: 10,
        hasNextPage: true,
        hasPreviousPage: false,
        totalCount: 25,
        cacheKey: 'test',
      );

      final lastPage = PaginatedResult<String>(
        data: ['item25'],
        page: 3,
        pageSize: 10,
        hasNextPage: false,
        hasPreviousPage: true,
        totalCount: 25,
        cacheKey: 'test',
      );

      expect(firstPage.isFirstPage, isTrue);
      expect(firstPage.isLastPage, isFalse);
      expect(lastPage.isFirstPage, isFalse);
      expect(lastPage.isLastPage, isTrue);
    });

    test('should serialize and deserialize correctly', () {
      final original = PaginatedResult<String>(
        data: ['item1', 'item2'],
        page: 2,
        pageSize: 5,
        hasNextPage: true,
        hasPreviousPage: true,
        totalCount: 15,
        cacheKey: 'test_cache',
      );

      final map = original.toMap();
      final restored = PaginatedResult<String>.fromMap(map);

      expect(restored.data, equals(original.data));
      expect(restored.page, equals(original.page));
      expect(restored.pageSize, equals(original.pageSize));
      expect(restored.hasNextPage, equals(original.hasNextPage));
      expect(restored.hasPreviousPage, equals(original.hasPreviousPage));
      expect(restored.totalCount, equals(original.totalCount));
      expect(restored.cacheKey, equals(original.cacheKey));
      expect(restored.error, equals(original.error));
    });

    test('should handle copyWith correctly', () {
      final original = PaginatedResult<String>(
        data: ['item1'],
        page: 1,
        pageSize: 10,
        hasNextPage: true,
        hasPreviousPage: false,
        totalCount: 25,
        cacheKey: 'test',
      );

      final modified = original.copyWith(
        data: ['item1', 'item2'],
        page: 2,
        hasNextPage: false,
        hasPreviousPage: true,
      );

      expect(modified.data, equals(['item1', 'item2']));
      expect(modified.page, equals(2));
      expect(modified.pageSize, equals(10)); // Unchanged
      expect(modified.hasNextPage, isFalse);
      expect(modified.hasPreviousPage, isTrue);
      expect(modified.totalCount, equals(25)); // Unchanged
      expect(modified.cacheKey, equals('test')); // Unchanged
    });
  });
}
