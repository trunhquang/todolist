import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:todolist/core/services/firebase_pagination_service.dart';
import 'package:todolist/core/services/pagination_service.dart';
import 'package:todolist/features/tasks/domain/entities/task.dart';

import 'firebase_pagination_service_test.mocks.dart';

@GenerateMocks([
  DatabaseReference,
  Query,
  DataSnapshot,
  PaginationService,
])
void main() {
  group('FirebasePaginationService', () {
    late FirebasePaginationService paginationService;
    late MockDatabaseReference mockRef;
    late MockQuery mockQuery;
    late MockDataSnapshot mockSnapshot;
    late MockPaginationService mockPaginationService;

    setUp(() {
      Get.testMode = true;
      
      mockRef = MockDatabaseReference();
      mockQuery = MockQuery();
      mockSnapshot = MockDataSnapshot();
      mockPaginationService = MockPaginationService();

      // Stub lifecycle to avoid MissingStubError when GetX starts the service
      when(mockPaginationService.onStart()).thenReturn(null);

      // Setup GetX dependencies (no lifecycle stubs needed)
      Get.put<PaginationService>(mockPaginationService);
      
      paginationService = FirebasePaginationService();
      paginationService.onInit();
    });

    tearDown(() {
      Get.reset();
    });

    group('getPaginatedResults', () {
      test('should return paginated results with server-side pagination', () async {
        // Arrange
        final testData = {
          'task1': {
            'id': 'task1',
            'title': 'Test Task 1',
            'status': 'pending',
            'priority': 'medium',
            'taskType': 'daily',
            'assigner': 'user1',
            'departmentId': 'dept1',
            'hasDeadline': false,
            'recurring': {'isRecurring': false},
            'createdAt': DateTime.now().millisecondsSinceEpoch,
          },
          'task2': {
            'id': 'task2',
            'title': 'Test Task 2',
            'status': 'completed',
            'priority': 'high',
            'taskType': 'project',
            'assigner': 'user1',
            'departmentId': 'dept1',
            'hasDeadline': true,
            'deadline': DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch,
            'recurring': {'isRecurring': false},
            'createdAt': DateTime.now().millisecondsSinceEpoch,
          },
        };

        when(mockRef.orderByChild(any)).thenReturn(mockQuery);
        when(mockRef.orderByKey()).thenReturn(mockQuery);
        when(mockQuery.limitToFirst(any)).thenReturn(mockQuery);
        when(mockQuery.limitToLast(any)).thenReturn(mockQuery);
        when(mockQuery.startAfter(any)).thenReturn(mockQuery);
        when(mockQuery.endBefore(any)).thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockSnapshot);
        when(mockSnapshot.exists).thenReturn(true);
        when(mockSnapshot.value).thenReturn(testData);

        // Act
        final result = await paginationService.getPaginatedResults<TaskEntity>(
          ref: mockRef,
          fromMap: (data) => TaskEntity.fromMap(data),
          idField: 'id',
          page: 1,
          pageSize: 2,
          orderBy: 'createdAt',
          ascending: true,
        );

        // Assert
        expect(result.data, hasLength(2));
        expect(result.page, equals(1));
        expect(result.pageSize, equals(2));
        expect(result.hasNextPage, isFalse);
        expect(result.hasPreviousPage, isFalse);
        expect(result.data.first.title, equals('Test Task 1'));
        expect(result.data.last.title, equals('Test Task 2'));

        // Verify Firebase query was called correctly
        verify(mockRef.orderByChild('createdAt')).called(1);
        verify(mockQuery.limitToFirst(3)).called(1); // pageSize + 1
        verify(mockQuery.get()).called(1);
      });

      test('should handle empty results', () async {
        // Arrange
        when(mockRef.orderByKey()).thenReturn(mockQuery);
        when(mockQuery.limitToFirst(any)).thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockSnapshot);
        when(mockSnapshot.exists).thenReturn(false);

        // Act
        final result = await paginationService.getPaginatedResults<TaskEntity>(
          ref: mockRef,
          fromMap: (data) => TaskEntity.fromMap(data),
          idField: 'id',
          page: 1,
          pageSize: 10,
        );

        // Assert
        expect(result.data, isEmpty);
        expect(result.hasNextPage, isFalse);
        expect(result.hasPreviousPage, isFalse);
      });

      test('should handle pagination cursor correctly', () async {
        // Arrange
        final testData = {
          'task2': {
            'id': 'task2',
            'title': 'Test Task 2',
            'status': 'completed',
            'priority': 'high',
            'taskType': 'project',
            'assigner': 'user1',
            'departmentId': 'dept1',
            'hasDeadline': true,
            'deadline': DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch,
            'recurring': {'isRecurring': false},
            'createdAt': DateTime.now().millisecondsSinceEpoch,
          },
        };

        when(mockRef.orderByChild(any)).thenReturn(mockQuery);
        when(mockQuery.startAfter('task1')).thenReturn(mockQuery);
        when(mockQuery.limitToFirst(any)).thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockSnapshot);
        when(mockSnapshot.exists).thenReturn(true);
        when(mockSnapshot.value).thenReturn(testData);

        // Act
        final result = await paginationService.getPaginatedResults<TaskEntity>(
          ref: mockRef,
          fromMap: (data) => TaskEntity.fromMap(data),
          idField: 'id',
          page: 2,
          pageSize: 1,
          lastItemId: 'task1',
          orderBy: 'createdAt',
          ascending: true,
        );

        // Assert
        expect(result.data, hasLength(1));
        expect(result.data.first.id, equals('task2'));
        verify(mockQuery.startAfter('task1')).called(1);
      });

      test('should apply filters correctly', () async {
        // Arrange
        final testData = {
          'task1': {
            'id': 'task1',
            'title': 'Test Task 1',
            'status': 'pending',
            'priority': 'medium',
            'taskType': 'daily',
            'assigner': 'user1',
            'departmentId': 'dept1',
            'hasDeadline': false,
            'recurring': {'isRecurring': false},
            'createdAt': DateTime.now().millisecondsSinceEpoch,
          },
          'task2': {
            'id': 'task2',
            'title': 'Test Task 2',
            'status': 'completed',
            'priority': 'high',
            'taskType': 'project',
            'assigner': 'user1',
            'departmentId': 'dept1',
            'hasDeadline': true,
            'deadline': DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch,
            'recurring': {'isRecurring': false},
            'createdAt': DateTime.now().millisecondsSinceEpoch,
          },
        };

        when(mockRef.orderByChild(any)).thenReturn(mockQuery);
        when(mockQuery.limitToFirst(any)).thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockSnapshot);
        when(mockSnapshot.exists).thenReturn(true);
        when(mockSnapshot.value).thenReturn(testData);

        // Act
        final result = await paginationService.getPaginatedResults<TaskEntity>(
          ref: mockRef,
          fromMap: (data) => TaskEntity.fromMap(data),
          idField: 'id',
          page: 1,
          pageSize: 10,
          filters: {'status': 'pending'},
        );

        // Assert
        expect(result.data, hasLength(1));
        expect(result.data.first.status, equals('pending'));
      });
    });

    group('getPaginatedResultsWithFilters', () {
      test('should handle complex filters with server-side pagination', () async {
        // Arrange
        final testData = {
          'task1': {
            'id': 'task1',
            'title': 'Test Task 1',
            'status': 'pending',
            'priority': 'medium',
            'taskType': 'daily',
            'assigner': 'user1',
            'departmentId': 'dept1',
            'hasDeadline': false,
            'recurring': {'isRecurring': false},
            'createdAt': DateTime.now().millisecondsSinceEpoch,
          },
          'task2': {
            'id': 'task2',
            'title': 'Test Task 2',
            'status': 'completed',
            'priority': 'high',
            'taskType': 'project',
            'assigner': 'user1',
            'departmentId': 'dept1',
            'hasDeadline': true,
            'deadline': DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch,
            'recurring': {'isRecurring': false},
            'createdAt': DateTime.now().millisecondsSinceEpoch,
          },
        };

        when(mockRef.orderByChild(any)).thenReturn(mockQuery);
        when(mockQuery.equalTo(any)).thenReturn(mockQuery);
        when(mockQuery.limitToFirst(any)).thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockSnapshot);
        when(mockSnapshot.exists).thenReturn(true);
        when(mockSnapshot.value).thenReturn(testData);

        // Act
        final result = await paginationService.getPaginatedResultsWithFilters<TaskEntity>(
          ref: mockRef,
          fromMap: (data) => TaskEntity.fromMap(data),
          idField: 'id',
          page: 1,
          pageSize: 10,
          filters: {'status': 'pending', 'priority': 'medium'},
        );

        // Assert
        expect(result.data, hasLength(1));
        expect(result.data.first.status, equals('pending'));
        expect(result.data.first.priority, equals('medium'));

        // Verify Firebase query was called with primary filter
        verify(mockRef.orderByChild('status')).called(1);
        verify(mockQuery.equalTo('pending')).called(1);
      });
    });

    group('cursor management', () {
      test('should get next page cursor correctly', () {
        // Arrange
        final tasks = [
          TaskEntity(
            id: 'task1',
            title: 'Task 1',
            taskType: 'daily',
            priority: 'medium',
            status: 'pending',
            assigner: 'user1',
            workspaceId: 'workspace1',
            hasDeadline: false,
            recurring: RecurringConfig(isRecurring: false),
            createdAt: DateTime.now(),
          ),
          TaskEntity(
            id: 'task2',
            title: 'Task 2',
            taskType: 'project',
            priority: 'high',
            status: 'completed',
            assigner: 'user1',
            workspaceId: 'workspace1',
            hasDeadline: true,
            deadline: DateTime.now().add(Duration(days: 1)),
            recurring: RecurringConfig(isRecurring: false),
            createdAt: DateTime.now(),
          ),
        ];

        final result = PaginatedResult<TaskEntity>(
          data: tasks,
          page: 1,
          pageSize: 2,
          hasNextPage: true,
          hasPreviousPage: false,
          totalCount: 0,
          cacheKey: 'test-cache-key',
        );

        // Act
        final nextCursor = paginationService.getNextPageCursor(result);

        // Assert
        expect(nextCursor, equals('task2'));
      });

      test('should return null for next cursor when no next page', () {
        // Arrange
        final tasks = [
          TaskEntity(
            id: 'task1',
            title: 'Task 1',
            taskType: 'daily',
            priority: 'medium',
            status: 'pending',
            assigner: 'user1',
            workspaceId: 'workspace1',
            hasDeadline: false,
            recurring: RecurringConfig(isRecurring: false),
            createdAt: DateTime.now(),
          ),
        ];

        final result = PaginatedResult<TaskEntity>(
          data: tasks,
          page: 1,
          pageSize: 2,
          hasNextPage: false,
          hasPreviousPage: false,
          totalCount: 0,
          cacheKey: 'test-cache-key',
        );

        // Act
        final nextCursor = paginationService.getNextPageCursor(result);

        // Assert
        expect(nextCursor, isNull);
      });
    });
  });
}
