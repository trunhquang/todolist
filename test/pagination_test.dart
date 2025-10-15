import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todolist/core/services/pagination_service.dart';
import 'package:todolist/core/services/storage_service.dart';

import 'pagination_test.mocks.dart';

@GenerateMocks([StorageService])
void main() {
  group('Pagination Service Tests', () {
    late PaginationService service;
    late MockStorageService mockStorageService;

    setUp(() async {
      // Setup GetX dependencies with mock
      mockStorageService = MockStorageService();
      
      // Stub StorageService methods
      when(mockStorageService.getUserData(any)).thenReturn(null);
      when(mockStorageService.setUserData(any, any)).thenAnswer((_) async => true);
      when(mockStorageService.clear()).thenAnswer((_) async => true);
      
      Get.put<StorageService>(mockStorageService);
      service = PaginationService();
      // Initialize the service to call onInit()
      await service.onInit();
    });

    tearDown(() {
      Get.reset();
    });

    test('should validate page size correctly', () async {
      // Test default page size
      final result1 = await service.getPaginatedResults<String>(
        cacheKey: 'test',
        fetchFunction: (limit, offset) async => List.generate(limit, (i) => 'item_${offset + i}'),
        pageSize: null,
        useCache: false, // Disable caching to avoid StorageService issues
      );
      expect(result1.pageSize, equals(PaginationService.defaultPageSize));

      // Test minimum page size
      final result2 = await service.getPaginatedResults<String>(
        cacheKey: 'test',
        fetchFunction: (limit, offset) async => List.generate(limit, (i) => 'item_${offset + i}'),
        useCache: false, // Disable caching to avoid StorageService issues
        pageSize: 1, // Below minimum
      );
      expect(result2.pageSize, equals(PaginationService.minPageSize));

      // Test maximum page size
      final result3 = await service.getPaginatedResults<String>(
        cacheKey: 'test',
        fetchFunction: (limit, offset) async => List.generate(limit, (i) => 'item_${offset + i}'),
        useCache: false, // Disable caching to avoid StorageService issues
        pageSize: 200, // Above maximum
      );
      expect(result3.pageSize, equals(PaginationService.maxPageSize));
    });

    test('should paginate results correctly', () async {
      final allData = List.generate(50, (i) => 'item_$i');

      // Test first page
      final page1 = await service.getPaginatedResults<String>(
        cacheKey: 'test_pagination',
        fetchFunction: (limit, offset) async {
          final endIndex = (offset + limit).clamp(0, allData.length);
          return allData.sublist(offset, endIndex);
        },
        page: 1,
        pageSize: 10,
      );

      expect(page1.data.length, equals(10));
      expect(page1.data.first, equals('item_0'));
      expect(page1.data.last, equals('item_9'));
      expect(page1.page, equals(1));
      expect(page1.hasNextPage, isTrue);
      expect(page1.hasPreviousPage, isFalse);

      // Test second page
      final page2 = await service.getPaginatedResults<String>(
        cacheKey: 'test_pagination',
        fetchFunction: (limit, offset) async {
          final endIndex = (offset + limit).clamp(0, allData.length);
          return allData.sublist(offset, endIndex);
        },
        page: 2,
        pageSize: 10,
      );

      expect(page2.data.length, equals(10));
      expect(page2.data.first, equals('item_10'));
      expect(page2.data.last, equals('item_19'));
      expect(page2.page, equals(2));
      expect(page2.hasNextPage, isTrue);
      expect(page2.hasPreviousPage, isTrue);

      // Test last page
      final page5 = await service.getPaginatedResults<String>(
        cacheKey: 'test_pagination',
        fetchFunction: (limit, offset) async {
          final endIndex = (offset + limit).clamp(0, allData.length);
          return allData.sublist(offset, endIndex);
        },
        page: 5,
        pageSize: 10,
      );

      expect(page5.data.length, equals(10));
      expect(page5.data.first, equals('item_40'));
      expect(page5.data.last, equals('item_49'));
      expect(page5.page, equals(5));
      expect(page5.hasNextPage, isTrue); // We got full page, so there might be more
      expect(page5.hasPreviousPage, isTrue);
    });

    test('should handle empty results', () async {
      final result = await service.getPaginatedResults<String>(
        cacheKey: 'test_empty',
        fetchFunction: (limit, offset) async => [],
        page: 1,
        pageSize: 10,
      );

      expect(result.data.length, equals(0));
      expect(result.hasNextPage, isFalse);
      expect(result.hasPreviousPage, isFalse);
    });

    test('should handle fetch function errors', () async {
      final result = await service.getPaginatedResults<String>(
        cacheKey: 'test_error',
        fetchFunction: (limit, offset) async {
          throw Exception('Fetch failed');
        },
        page: 1,
        pageSize: 10,
      );

      expect(result.hasError, isTrue);
      expect(result.error, contains('Failed to fetch paginated results'));
      expect(result.data.length, equals(0));
    });

    test('should navigate between pages correctly', () async {
      final allData = List.generate(30, (i) => 'item_$i');

      // Get first page
      final page1 = await service.getPaginatedResults<String>(
        cacheKey: 'test_navigation',
        fetchFunction: (limit, offset) async {
          final endIndex = (offset + limit).clamp(0, allData.length);
          return allData.sublist(offset, endIndex);
        },
        page: 1,
        pageSize: 10,
      );

      // Get next page
      final page2 = await service.getNextPage<String>(
        cacheKey: 'test_navigation',
        fetchFunction: (limit, offset) async {
          final endIndex = (offset + limit).clamp(0, allData.length);
          return allData.sublist(offset, endIndex);
        },
        currentResult: page1,
      );

      expect(page2.page, equals(2));
      expect(page2.data.first, equals('item_10'));

      // Get previous page
      final backToPage1 = await service.getPreviousPage<String>(
        cacheKey: 'test_navigation',
        fetchFunction: (limit, offset) async {
          final endIndex = (offset + limit).clamp(0, allData.length);
          return allData.sublist(offset, endIndex);
        },
        currentResult: page2,
      );

      expect(backToPage1.page, equals(1));
      expect(backToPage1.data.first, equals('item_0'));
    });

    test('should handle boundary conditions', () async {
      final allData = List.generate(5, (i) => 'item_$i');

      // Test page beyond available data
      final result = await service.getPaginatedResults<String>(
        cacheKey: 'test_boundary',
        fetchFunction: (limit, offset) async {
          final endIndex = (offset + limit).clamp(0, allData.length);
          if (offset >= allData.length) return [];
          return allData.sublist(offset, endIndex);
        },
        page: 2,
        pageSize: 10,
      );

      expect(result.data.length, equals(0));
      expect(result.hasNextPage, isFalse);
      expect(result.hasPreviousPage, isTrue);
    });

    test('should calculate total pages correctly', () async {
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

    test('should identify first and last pages correctly', () async {
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
  });
}
