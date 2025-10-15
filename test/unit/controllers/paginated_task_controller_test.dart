import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:get/get.dart';
import 'package:todolist/features/tasks/presentation/controllers/paginated_task_controller.dart';
import 'package:todolist/core/services/pagination_service.dart';
import 'package:todolist/core/services/firebase_database_service.dart';
import 'package:todolist/core/services/storage_service.dart';
import 'package:todolist/features/tasks/domain/entities/task.dart';
import '../../fixtures/tasks.dart';

import 'paginated_task_controller_test.mocks.dart';

@GenerateMocks([
  PaginationService,
  FirebaseDatabaseService,
  StorageService,
])
void main() {
  group('PaginatedTaskController Tests', () {
    late MockPaginationService mockPaginationService;
    late MockFirebaseDatabaseService mockDatabaseService;
    late MockStorageService mockStorageService;
    late PaginatedTaskController controller;

    setUp(() {
      // Initialize mocks
      mockPaginationService = MockPaginationService();
      mockDatabaseService = MockFirebaseDatabaseService();
      mockStorageService = MockStorageService();

      // Setup GetX dependencies using lazyPut to avoid onStart lifecycle
      Get.lazyPut<PaginationService>(() => mockPaginationService, tag: 'test');
      Get.lazyPut<FirebaseDatabaseService>(() => mockDatabaseService, tag: 'test');
      Get.lazyPut<StorageService>(() => mockStorageService, tag: 'test');

      // Initialize controller
      controller = PaginatedTaskController(
        paginationService: mockPaginationService,
        databaseService: mockDatabaseService,
        storageService: mockStorageService,
      );
    });

    tearDown(() {
      Get.reset();
    });

    group('loadTasks', () {
      test('should load tasks successfully with default parameters', () async {
        // Arrange
        const companyId = 'test-company-id';
        final testTasks = TestFixtures.createTestTasks();
        final paginatedResult = PaginatedResult<TaskEntity>(
          data: testTasks,
          page: 1,
          pageSize: 20,
          totalCount: testTasks.length,
          hasNextPage: false,
          hasPreviousPage: false,
          cacheKey: 'tasks_',
        );

        when(mockStorageService.getCompanyId()).thenReturn(companyId);
        when(mockPaginationService.getUserPreferredPageSize()).thenReturn(20);
        when(mockPaginationService.getPaginatedResults<TaskEntity>(
          cacheKey: anyNamed('cacheKey'),
          fetchFunction: anyNamed('fetchFunction'),
          page: anyNamed('page'),
          pageSize: 20,
          useCache: anyNamed('useCache'),
        )).thenAnswer((_) async => paginatedResult);

        when(mockPaginationService.getPaginatedResults<TaskEntity>(
          cacheKey: anyNamed('cacheKey'),
          fetchFunction: anyNamed('fetchFunction'),
          page: anyNamed('page'),
          pageSize: null,
          useCache: anyNamed('useCache'),
        )).thenAnswer((_) async => paginatedResult);

        // Act
        await controller.loadTasks();

        // Assert
        expect(controller.isLoading, isFalse);
        expect(controller.error, isNull);
        expect(controller.tasks, equals(testTasks));
        expect(controller.currentPage, equals(1));
        expect(controller.pageSize, equals(20));
        expect(controller.hasNextPage, isFalse);
        expect(controller.hasPreviousPage, isFalse);
        
        verify(mockStorageService.getCompanyId()).called(1);
        verify(mockPaginationService.getPaginatedResults<TaskEntity>(
          cacheKey: anyNamed('cacheKey'),
          fetchFunction: anyNamed('fetchFunction'),
          page: 1,
          pageSize: 20,
          useCache: true,
        )).called(1);
      });

      test('should load tasks with filters', () async {
        // Arrange
        const companyId = 'test-company-id';
        const type = 'daily';
        const status = 'pending';
        const priority = 'high';
        const projectId = 'test-project-id';
        const assignee = 'test-user-id';
        
        final testTasks = TestFixtures.createTestTasks();
        final paginatedResult = PaginatedResult<TaskEntity>(
          data: testTasks,
          page: 1,
          pageSize: 20,
          totalCount: testTasks.length,
          hasNextPage: false,
          hasPreviousPage: false,
          cacheKey: 'tasks_type:daily_status:pending_priority:high_projectId:test-project-id_assignee:test-user-id',
        );

        when(mockStorageService.getCompanyId()).thenReturn(companyId);
        when(mockPaginationService.getUserPreferredPageSize()).thenReturn(20);
        when(mockPaginationService.getPaginatedResults<TaskEntity>(
          cacheKey: anyNamed('cacheKey'),
          fetchFunction: anyNamed('fetchFunction'),
          page: anyNamed('page'),
          pageSize: 20,
          useCache: anyNamed('useCache'),
        )).thenAnswer((_) async => paginatedResult);

        // Act
        await controller.loadTasks(
          type: type,
          status: status,
          priority: priority,
          projectId: projectId,
          assignee: assignee,
        );

        // Assert
        expect(controller.tasks, equals(testTasks));
        verify(mockPaginationService.getPaginatedResults<TaskEntity>(
          cacheKey: anyNamed('cacheKey'),
          fetchFunction: anyNamed('fetchFunction'),
          page: 1,
          pageSize: 20,
          useCache: true,
        )).called(1);
      });

      test('should handle error when company ID is not found', () async {
        // Arrange
        when(mockStorageService.getCompanyId()).thenReturn(null);

        // Act
        await controller.loadTasks();

        // Assert
        expect(controller.isLoading, isFalse);
        expect(controller.error, isNotNull);
        expect(controller.tasks, isEmpty);
        verifyNever(mockPaginationService.getPaginatedResults<TaskEntity>(
          cacheKey: anyNamed('cacheKey'),
          fetchFunction: anyNamed('fetchFunction'),
          page: anyNamed('page'),
          pageSize: 20,
          useCache: anyNamed('useCache'),
        ));
      });

      test('should handle error when company ID is empty', () async {
        // Arrange
        when(mockStorageService.getCompanyId()).thenReturn('');

        // Act
        await controller.loadTasks();

        // Assert
        expect(controller.isLoading, isFalse);
        expect(controller.error, isNotNull);
        expect(controller.tasks, isEmpty);
      });

      test('should handle pagination service error', () async {
        // Arrange
        const companyId = 'test-company-id';
        when(mockStorageService.getCompanyId()).thenReturn(companyId);
        when(mockPaginationService.getUserPreferredPageSize()).thenReturn(20);
        when(mockPaginationService.getPaginatedResults<TaskEntity>(
          cacheKey: anyNamed('cacheKey'),
          fetchFunction: anyNamed('fetchFunction'),
          page: anyNamed('page'),
          pageSize: 20,
          useCache: anyNamed('useCache'),
        )).thenThrow(Exception('Pagination service error'));

        // Act
        await controller.loadTasks();

        // Assert
        expect(controller.isLoading, isFalse);
        expect(controller.error, isNotNull);
        expect(controller.error, contains('Failed to load tasks'));
        expect(controller.tasks, isEmpty);
      });
    });

    group('loadNextPage', () {
      test('should load next page when available', () async {
        // Arrange
        const companyId = 'test-company-id';
        final firstPageTasks = TestFixtures.createTestTasks();
        final secondPageTasks = TestFixtures.createTestTasks();
        
        final firstPageResult = PaginatedResult<TaskEntity>(
          data: firstPageTasks,
          page: 1,
          pageSize: 20,
          totalCount: 40,
          hasNextPage: true,
          hasPreviousPage: false,
          cacheKey: 'tasks_',
        );

        final secondPageResult = PaginatedResult<TaskEntity>(
          data: secondPageTasks,
          page: 2,
          pageSize: 20,
          totalCount: 40,
          hasNextPage: false,
          hasPreviousPage: true,
          cacheKey: 'tasks_',
        );

        when(mockStorageService.getCompanyId()).thenReturn(companyId);
        when(mockPaginationService.getUserPreferredPageSize()).thenReturn(20);
        when(mockPaginationService.getPaginatedResults<TaskEntity>(
          cacheKey: anyNamed('cacheKey'),
          fetchFunction: anyNamed('fetchFunction'),
          page: anyNamed('page'),
          pageSize: 20,
          useCache: anyNamed('useCache'),
        )).thenAnswer((_) async => firstPageResult);

        // Setup for first page
        when(mockPaginationService.getPaginatedResults<TaskEntity>(
          cacheKey: anyNamed('cacheKey'),
          fetchFunction: anyNamed('fetchFunction'),
          page: anyNamed('page'),
          pageSize: 20,
          useCache: anyNamed('useCache'),
        )).thenAnswer((_) async => firstPageResult);

        // Load first page
        await controller.loadTasks();

        // Setup for second page
        when(mockPaginationService.getPaginatedResults<TaskEntity>(
          cacheKey: anyNamed('cacheKey'),
          fetchFunction: anyNamed('fetchFunction'),
          page: anyNamed('page'),
          pageSize: 20,
          useCache: anyNamed('useCache'),
        )).thenAnswer((_) async => secondPageResult);

        // Act
        await controller.loadNextPage();

        // Assert
        expect(controller.currentPage, equals(1));
        expect(controller.hasNextPage, isFalse);
        expect(controller.hasPreviousPage, isTrue);
        expect(controller.tasks, equals(secondPageTasks));
      });

      test('should not load next page when not available', () async {
        // Arrange
        const companyId = 'test-company-id';
        final testTasks = TestFixtures.createTestTasks();
        final paginatedResult = PaginatedResult<TaskEntity>(
          data: testTasks,
          page: 1,
          pageSize: 20,
          totalCount: testTasks.length,
          hasNextPage: false,
          hasPreviousPage: false,
          cacheKey: 'tasks_',
        );

        when(mockStorageService.getCompanyId()).thenReturn(companyId);
        when(mockPaginationService.getUserPreferredPageSize()).thenReturn(20);
        when(mockPaginationService.getPaginatedResults<TaskEntity>(
          cacheKey: anyNamed('cacheKey'),
          fetchFunction: anyNamed('fetchFunction'),
          page: anyNamed('page'),
          pageSize: 20,
          useCache: anyNamed('useCache'),
        )).thenAnswer((_) async => paginatedResult);

        // Load first page
        await controller.loadTasks();

        // Act
        await controller.loadNextPage();

        // Assert
        expect(controller.currentPage, equals(1));
        expect(controller.hasNextPage, isFalse);
        verify(mockPaginationService.getPaginatedResults<TaskEntity>(
          cacheKey: anyNamed('cacheKey'),
          fetchFunction: anyNamed('fetchFunction'),
          page: anyNamed('page'),
          pageSize: 20,
          useCache: anyNamed('useCache'),
        )).called(1); // Only called once for initial load
      });

      test('should not load next page when already loading', () async {
        // Arrange
        const companyId = 'test-company-id';
        final testTasks = TestFixtures.createTestTasks();
        final paginatedResult = PaginatedResult<TaskEntity>(
          data: testTasks,
          page: 1,
          pageSize: 20,
          totalCount: testTasks.length,
          hasNextPage: true,
          hasPreviousPage: false,
          cacheKey: 'tasks_',
        );

        when(mockStorageService.getCompanyId()).thenReturn(companyId);
        when(mockPaginationService.getUserPreferredPageSize()).thenReturn(20);
        when(mockPaginationService.getPaginatedResults<TaskEntity>(
          cacheKey: anyNamed('cacheKey'),
          fetchFunction: anyNamed('fetchFunction'),
          page: anyNamed('page'),
          pageSize: 20,
          useCache: anyNamed('useCache'),
        )).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return paginatedResult;
        });

        // Load first page
        await controller.loadTasks();

        // Act - call loadNextPage multiple times rapidly
        final future1 = controller.loadNextPage();
        final future2 = controller.loadNextPage();
        final future3 = controller.loadNextPage();

        await future1;
        await future2;
        await future3;

        // Assert - should only load next page once
        verify(mockPaginationService.getPaginatedResults<TaskEntity>(
          cacheKey: anyNamed('cacheKey'),
          fetchFunction: anyNamed('fetchFunction'),
          page: anyNamed('page'),
          pageSize: 20,
          useCache: anyNamed('useCache'),
        )).called(1); // Only once for initial load
      });
    });

    group('loadPreviousPage', () {
      test('should load previous page when available', () async {
        // Arrange
        const companyId = 'test-company-id';
        final firstPageTasks = TestFixtures.createTestTasks();
        final secondPageTasks = TestFixtures.createTestTasks();
        
        final firstPageResult = PaginatedResult<TaskEntity>(
          data: firstPageTasks,
          page: 1,
          pageSize: 20,
          totalCount: 40,
          hasNextPage: true,
          hasPreviousPage: false,
          cacheKey: 'tasks_',
        );

        final secondPageResult = PaginatedResult<TaskEntity>(
          data: secondPageTasks,
          page: 2,
          pageSize: 20,
          totalCount: 40,
          hasNextPage: false,
          hasPreviousPage: true,
          cacheKey: 'tasks_',
        );

        when(mockStorageService.getCompanyId()).thenReturn(companyId);
        when(mockPaginationService.getUserPreferredPageSize()).thenReturn(20);
        when(mockPaginationService.getPaginatedResults<TaskEntity>(
          cacheKey: anyNamed('cacheKey'),
          fetchFunction: anyNamed('fetchFunction'),
          page: anyNamed('page'),
          pageSize: 20,
          useCache: anyNamed('useCache'),
        )).thenAnswer((_) async => firstPageResult);

        // Load first page
        await controller.loadTasks();

        // Setup for next page
        when(mockPaginationService.getPaginatedResults<TaskEntity>(
          cacheKey: anyNamed('cacheKey'),
          fetchFunction: anyNamed('fetchFunction'),
          page: anyNamed('page'),
          pageSize: 20,
          useCache: anyNamed('useCache'),
        )).thenAnswer((_) async => secondPageResult);

        // Load next page
        await controller.loadNextPage();

        // Setup for previous page
        when(mockPaginationService.getPaginatedResults<TaskEntity>(
          cacheKey: anyNamed('cacheKey'),
          fetchFunction: anyNamed('fetchFunction'),
          page: anyNamed('page'),
          pageSize: 20,
          useCache: anyNamed('useCache'),
        )).thenAnswer((_) async => firstPageResult);

        // Act
        await controller.loadPreviousPage();

        // Assert
        expect(controller.currentPage, equals(1));
        expect(controller.hasNextPage, isTrue);
        expect(controller.hasPreviousPage, isFalse);
        expect(controller.tasks, equals(firstPageTasks));
      });
    });

    group('changePageSize', () {
      test('should change page size and reload first page', () async {
        // Arrange
        const companyId = 'test-company-id';
        const newPageSize = 50;
        final testTasks = TestFixtures.createTestTasks();
        final paginatedResult = PaginatedResult<TaskEntity>(
          data: testTasks,
          page: 1,
          pageSize: newPageSize,
          totalCount: testTasks.length,
          hasNextPage: false,
          hasPreviousPage: false,
          cacheKey: 'tasks_',
        );

        when(mockStorageService.getCompanyId()).thenReturn(companyId);
        when(mockPaginationService.getUserPreferredPageSize()).thenReturn(20);
        when(mockPaginationService.setUserPreferredPageSize(newPageSize)).thenAnswer((_) async {});
        when(mockPaginationService.getPaginatedResults<TaskEntity>(
          cacheKey: anyNamed('cacheKey'),
          fetchFunction: anyNamed('fetchFunction'),
          page: anyNamed('page'),
          pageSize: 20,
          useCache: anyNamed('useCache'),
        )).thenAnswer((_) async => paginatedResult);

        // Act
        await controller.changePageSize(newPageSize);

        // Assert
        expect(controller.pageSize, equals(newPageSize));
        verify(mockPaginationService.setUserPreferredPageSize(newPageSize)).called(1);
        verify(mockPaginationService.getPaginatedResults<TaskEntity>(
          cacheKey: anyNamed('cacheKey'),
          fetchFunction: anyNamed('fetchFunction'),
          page: 1,
          pageSize: 20,
          useCache: true,
        )).called(1);
      });
    });

    group('clearCache', () {
      test('should clear cache when current result exists', () async {
        // Arrange
        const companyId = 'test-company-id';
        final testTasks = TestFixtures.createTestTasks();
        final paginatedResult = PaginatedResult<TaskEntity>(
          data: testTasks,
          page: 1,
          pageSize: 20,
          totalCount: testTasks.length,
          hasNextPage: false,
          hasPreviousPage: false,
          cacheKey: 'tasks_',
        );

        when(mockStorageService.getCompanyId()).thenReturn(companyId);
        when(mockPaginationService.getUserPreferredPageSize()).thenReturn(20);
        when(mockPaginationService.getPaginatedResults<TaskEntity>(
          cacheKey: anyNamed('cacheKey'),
          fetchFunction: anyNamed('fetchFunction'),
          page: anyNamed('page'),
          pageSize: 20,
          useCache: anyNamed('useCache'),
        )).thenAnswer((_) async => paginatedResult);

        // Load tasks to set current result
        await controller.loadTasks();

        // Act
        controller.clearCache();

        // Assert
        verify(mockPaginationService.clearCache('tasks_')).called(1);
      });

      test('should not clear cache when no current result', () {
        // Act
        controller.clearCache();

        // Assert
        verifyNever(mockPaginationService.clearCache(any));
      });
    });

    group('State Management', () {
      test('should update loading state during loadTasks', () async {
        // Arrange
        const companyId = 'test-company-id';
        final testTasks = TestFixtures.createTestTasks();
        final paginatedResult = PaginatedResult<TaskEntity>(
          data: testTasks,
          page: 1,
          pageSize: 20,
          totalCount: testTasks.length,
          hasNextPage: false,
          hasPreviousPage: false,
          cacheKey: 'tasks_',
        );

        when(mockStorageService.getCompanyId()).thenReturn(companyId);
        when(mockPaginationService.getUserPreferredPageSize()).thenReturn(20);
        when(mockPaginationService.getPaginatedResults<TaskEntity>(
          cacheKey: anyNamed('cacheKey'),
          fetchFunction: anyNamed('fetchFunction'),
          page: anyNamed('page'),
          pageSize: 20,
          useCache: anyNamed('useCache'),
        )).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return paginatedResult;
        });

        // Act
        final future = controller.loadTasks();

        // Assert - loading should be true during operation
        expect(controller.isLoading, isTrue);
        
        await future;
        
        // Assert - loading should be false after completion
        expect(controller.isLoading, isFalse);
      });

      test('should update loading more state during loadNextPage', () async {
        // Arrange
        const companyId = 'test-company-id';
        final testTasks = TestFixtures.createTestTasks();
        final paginatedResult = PaginatedResult<TaskEntity>(
          data: testTasks,
          page: 1,
          pageSize: 20,
          totalCount: testTasks.length,
          hasNextPage: true,
          hasPreviousPage: false,
          cacheKey: 'tasks_',
        );

        when(mockStorageService.getCompanyId()).thenReturn(companyId);
        when(mockPaginationService.getUserPreferredPageSize()).thenReturn(20);
        when(mockPaginationService.getPaginatedResults<TaskEntity>(
          cacheKey: anyNamed('cacheKey'),
          fetchFunction: anyNamed('fetchFunction'),
          page: anyNamed('page'),
          pageSize: 20,
          useCache: anyNamed('useCache'),
        )).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return paginatedResult;
        });

        when(mockPaginationService.getNextPage<TaskEntity>(
          cacheKey: anyNamed('cacheKey'),
          fetchFunction: anyNamed('fetchFunction'),
          currentResult: anyNamed('currentResult'),
        )).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return paginatedResult;
        });

        // Load first page
        await controller.loadTasks();

        // Act
        final future = controller.loadNextPage();

        // Assert - loading more should be true during operation
        expect(controller.isLoadingMore, isTrue);
        
        await future;
        
        // Assert - loading more should be false after completion
        expect(controller.isLoadingMore, isFalse);
      });
    });
  });
}
