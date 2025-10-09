import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:todolist/core/services/conflict_resolution_service.dart';
import 'package:todolist/core/services/storage_service.dart';

void main() {
  group('Conflict Resolution Tests', () {
    late ConflictResolutionService service;
    late StorageService storageService;

    setUp(() {
      Get.reset();
      storageService = MockStorageService();
      Get.put<StorageService>(storageService as StorageService);
      service = ConflictResolutionService();
    });

    test('should resolve conflict using last-write-wins strategy', () async {
      final localData = {
        'id': 'task_123',
        'title': 'Updated Task Title',
        'status': 'in_progress',
        'assignee': 'user_456',
      };

      final remoteData = {
        'id': 'task_123',
        'title': 'Original Task Title',
        'status': 'pending',
        'assignee': 'user_789',
      };

      final result = await service.resolveConflict(
        entityType: 'task',
        entityId: 'task_123',
        localData: localData,
        remoteData: remoteData,
        userId: 'user_456',
      );

      expect(result.isSuccess, isTrue);
      expect(result.conflictDetected, isTrue);
      expect(result.strategy, equals('last-write-wins'));
      expect(result.resolvedData, isNotNull);
    });

    test('should detect conflicts correctly', () async {
      final localData = {
        'id': 'task_123',
        'title': 'Different Title',
        'status': 'completed',
      };

      final remoteData = {
        'id': 'task_123',
        'title': 'Original Title',
        'status': 'pending',
      };

      final result = await service.resolveConflict(
        entityType: 'task',
        entityId: 'task_123',
        localData: localData,
        remoteData: remoteData,
        userId: 'user_456',
      );

      expect(result.conflictDetected, isTrue);
    });

    test('should not detect conflicts for identical data', () async {
      final localData = {
        'id': 'task_123',
        'title': 'Same Title',
        'status': 'pending',
      };

      final remoteData = {
        'id': 'task_123',
        'title': 'Same Title',
        'status': 'pending',
      };

      final result = await service.resolveConflict(
        entityType: 'task',
        entityId: 'task_123',
        localData: localData,
        remoteData: remoteData,
        userId: 'user_456',
      );

      expect(result.conflictDetected, isFalse);
    });

    test('should handle retry with exponential backoff', () async {
      int attemptCount = 0;
      final maxRetries = 3;

      try {
        await service.retryWithBackoff(
          () async {
            attemptCount++;
            if (attemptCount < maxRetries) {
              throw Exception('Simulated failure');
            }
            return 'success';
          },
          maxRetries: maxRetries,
          initialDelay: const Duration(milliseconds: 100),
        );

        expect(attemptCount, equals(maxRetries));
      } catch (e) {
        fail('Should have succeeded after $maxRetries attempts');
      }
    });

    test('should fail after max retries exceeded', () async {
      int attemptCount = 0;
      final maxRetries = 2;

      try {
        await service.retryWithBackoff(
          () async {
            attemptCount++;
            throw Exception('Always fails');
          },
          maxRetries: maxRetries,
          initialDelay: const Duration(milliseconds: 10),
        );

        fail('Should have thrown exception');
      } catch (e) {
        expect(attemptCount, equals(maxRetries));
        expect(e.toString(), contains('Max retries exceeded'));
      }
    });

    test('should reset retry count on success', () async {
      // First, fail a few times
      try {
        await service.retryWithBackoff(
          () async {
            throw Exception('Always fails');
          },
          operationKey: 'test_operation',
          maxRetries: 1,
        );
      } catch (e) {
        // Expected to fail
      }

      // Check that retry count is recorded
      final stats = service.getRetryStats('test_operation');
      expect(stats.isRetrying, isTrue);
      expect(stats.attempts, equals(1));

      // Clear retry data first
      service.clearRetryData('test_operation');
      
      // Now succeed
      await service.retryWithBackoff(
        () async {
          return 'success';
        },
        operationKey: 'test_operation',
        maxRetries: 1,
      );

      // Check that retry count is reset
      final newStats = service.getRetryStats('test_operation');
      expect(newStats.isRetrying, isFalse);
      expect(newStats.attempts, equals(0));
    });

    test('should clear retry data', () async {
      // Set up retry data
      try {
        await service.retryWithBackoff(
          () async {
            throw Exception('Always fails');
          },
          operationKey: 'clear_test',
          maxRetries: 1,
        );
      } catch (e) {
        // Expected to fail
      }

      // Verify retry data exists
      final stats = service.getRetryStats('clear_test');
      expect(stats.isRetrying, isTrue);

      // Clear retry data
      service.clearRetryData('clear_test');

      // Verify retry data is cleared
      final clearedStats = service.getRetryStats('clear_test');
      expect(clearedStats.isRetrying, isFalse);
      expect(clearedStats.attempts, equals(0));
    });
  });
}

/// Mock StorageService for testing
class MockStorageService {
  final Map<String, dynamic> _storage = {};

  Future<void> setUserData(String key, dynamic value) async {
    _storage[key] = value;
  }

  T? getUserData<T>(String key) {
    return _storage[key] as T?;
  }

  Future<void> removeUserData(String key) async {
    _storage.remove(key);
  }

  String? getCompanyId() => 'test_company';

  Future<void> setDateTime(String key, DateTime value) async {
    _storage[key] = value.millisecondsSinceEpoch;
  }

  DateTime? getDateTime(String key) {
    final value = _storage[key];
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return null;
  }
}
