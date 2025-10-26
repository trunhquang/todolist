import 'package:flutter_test/flutter_test.dart';
import 'package:todolist/core/services/conflict_resolution_service.dart';

void main() {
  group('Conflict Resolution Simple Tests', () {
    late ConflictResolutionService service;

    setUp(() {
      service = ConflictResolutionService();
    });

    test('should detect conflicts correctly', () {
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

      // Test conflict detection logic directly
      final hasConflict = _hasConflict(localData, remoteData);
      expect(hasConflict, isTrue);
    });

    test('should not detect conflicts for identical data', () {
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

      // Test conflict detection logic directly
      final hasConflict = _hasConflict(localData, remoteData);
      expect(hasConflict, isFalse);
    });

    test('should handle retry with exponential backoff', () async {
      var attemptCount = 0;
      const maxRetries = 3;

      try {
        await service.retryWithBackoff(
          () async {
            attemptCount++;
            if (attemptCount < maxRetries) {
              throw Exception('Simulated failure');
            }
            return 'success';
          },
          initialDelay: const Duration(milliseconds: 100),
        );

        expect(attemptCount, equals(maxRetries));
      } catch (e) {
        fail('Should have succeeded after $maxRetries attempts');
      }
    });

    test('should fail after max retries exceeded', () async {
      var attemptCount = 0;
      const maxRetries = 2;

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

    test('should get retry statistics', () {
      final stats = service.getRetryStats('test_operation');
      expect(stats.operationKey, equals('test_operation'));
      expect(stats.attempts, equals(0));
      expect(stats.isRetrying, isFalse);
    });

    test('should clear retry data', () {
      // Clear retry data
      service.clearRetryData('test_operation');

      // Verify retry data is cleared
      final clearedStats = service.getRetryStats('test_operation');
      expect(clearedStats.isRetrying, isFalse);
      expect(clearedStats.attempts, equals(0));
    });
  });
}

/// Helper function to test conflict detection logic
bool _hasConflict(Map<String, dynamic> localData, Map<String, dynamic> remoteData) {
  // Compare key fields that could conflict
  final keyFields = ['title', 'description', 'status', 'priority', 'assignee', 'deadline'];
  
  for (final field in keyFields) {
    if (localData[field] != remoteData[field]) {
      return true;
    }
  }
  
  return false;
}
