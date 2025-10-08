import 'package:flutter_test/flutter_test.dart';
import 'package:todolist/features/tasks/domain/entities/task.dart';
import 'package:todolist/features/tasks/domain/entities/project.dart';
import 'package:todolist/features/tasks/domain/repositories/recurring_task_repository.dart';
import 'package:todolist/features/tasks/domain/usecases/generate_recurring_tasks.dart';

void main() {
  group('Recurring Task Generation Tests', () {
    test('should calculate daily instances correctly', () {
      final startDate = DateTime(2025, 1, 1);
      final endDate = DateTime(2025, 1, 8); // 7 days later
      final interval = 1; // Every day
      
      final useCase = GenerateRecurringTasks(_MockRepository());
      final result = useCase.calculateDailyInstances(startDate, endDate, interval);
      
      expect(result, equals(7)); // Should generate 7 instances
    });

    test('should calculate weekly instances correctly', () {
      final startDate = DateTime(2025, 1, 1);
      final endDate = DateTime(2025, 1, 22); // 3 weeks later
      final interval = 1; // Every week
      
      final useCase = GenerateRecurringTasks(_MockRepository());
      final result = useCase.calculateWeeklyInstances(startDate, endDate, interval);
      
      expect(result, equals(3)); // Should generate 3 instances
    });

    test('should calculate monthly instances correctly', () {
      final startDate = DateTime(2025, 1, 1);
      final endDate = DateTime(2025, 4, 1); // 3 months later
      final interval = 1; // Every month
      
      final useCase = GenerateRecurringTasks(_MockRepository());
      final result = useCase.calculateMonthlyInstances(startDate, endDate, interval);
      
      expect(result, equals(3)); // Should generate 3 instances
    });

    test('should create task instance with correct parent reference', () {
      final parentTask = TaskEntity(
        id: 'parent_123',
        title: 'Daily Standup',
        taskType: 'daily',
        priority: 'medium',
        status: 'pending',
        assigner: 'user_123',
        departmentId: 'dept_123',
        hasDeadline: true,
        deadline: DateTime(2025, 1, 1, 9, 0),
        recurring: const RecurringConfig(
          isRecurring: true,
          frequency: 'daily',
          interval: 1,
        ),
        createdAt: DateTime(2025, 1, 1),
      );

      final useCase = GenerateRecurringTasks(_MockRepository());
      final instance = useCase.createTaskInstance(
        parentTask: parentTask,
        instanceDate: DateTime(2025, 1, 2),
      );

      expect(instance.parentTaskId, equals('parent_123'));
      expect(instance.title, equals('Daily Standup'));
      expect(instance.taskType, equals('daily'));
      expect(instance.priority, equals('medium'));
      expect(instance.status, equals('pending'));
      expect(instance.recurring.isRecurring, isFalse); // Instances should not be recurring
      expect(instance.createdAt, equals(DateTime(2025, 1, 2)));
    });

    test('should calculate next instance date for daily tasks', () {
      final parentTask = TaskEntity(
        id: 'parent_123',
        title: 'Daily Task',
        taskType: 'daily',
        priority: 'medium',
        status: 'pending',
        assigner: 'user_123',
        departmentId: 'dept_123',
        hasDeadline: false,
        recurring: const RecurringConfig(
          isRecurring: true,
          frequency: 'daily',
          interval: 1,
        ),
        createdAt: DateTime(2025, 1, 1),
      );

      final useCase = GenerateRecurringTasks(_MockRepository());
      final nextDate = useCase.calculateNextInstanceDate(
        parentTask: parentTask,
        lastGenerated: DateTime(2025, 1, 1),
        instanceIndex: 0,
      );

      expect(nextDate, equals(DateTime(2025, 1, 2)));
    });

    test('should calculate next instance date for weekly tasks', () {
      final parentTask = TaskEntity(
        id: 'parent_123',
        title: 'Weekly Task',
        taskType: 'weekly',
        priority: 'medium',
        status: 'pending',
        assigner: 'user_123',
        departmentId: 'dept_123',
        hasDeadline: false,
        recurring: const RecurringConfig(
          isRecurring: true,
          frequency: 'weekly',
          interval: 1,
        ),
        createdAt: DateTime(2025, 1, 1),
      );

      final useCase = GenerateRecurringTasks(_MockRepository());
      final nextDate = useCase.calculateNextInstanceDate(
        parentTask: parentTask,
        lastGenerated: DateTime(2025, 1, 1),
        instanceIndex: 0,
      );

      expect(nextDate, equals(DateTime(2025, 1, 8))); // 7 days later
    });

    test('should calculate next instance date for monthly tasks', () {
      final parentTask = TaskEntity(
        id: 'parent_123',
        title: 'Monthly Task',
        taskType: 'monthly',
        priority: 'medium',
        status: 'pending',
        assigner: 'user_123',
        departmentId: 'dept_123',
        hasDeadline: false,
        recurring: const RecurringConfig(
          isRecurring: true,
          frequency: 'monthly',
          interval: 1,
        ),
        createdAt: DateTime(2025, 1, 1),
      );

      final useCase = GenerateRecurringTasks(_MockRepository());
      final nextDate = useCase.calculateNextInstanceDate(
        parentTask: parentTask,
        lastGenerated: DateTime(2025, 1, 1),
        instanceIndex: 0,
      );

      expect(nextDate, equals(DateTime(2025, 2, 1))); // 1 month later
    });
  });
}

/// Mock repository for testing
class _MockRepository implements RecurringTaskRepository {
  @override
  Future<List<TaskEntity>> getRecurringTasksForGeneration({
    required String companyId,
  }) async {
    return [];
  }

  @override
  Future<Project?> getProject({
    required String companyId,
    required String projectId,
  }) async {
    return null;
  }

  @override
  Future<String> createRecurringTaskInstance({
    required String companyId,
    required TaskEntity task,
  }) async {
    return 'generated_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<void> updateLastGenerationTime({
    required String companyId,
    required String taskId,
    required DateTime lastGenerated,
  }) async {
    // Mock implementation
  }

  @override
  Future<DateTime?> getLastGenerationTime({
    required String companyId,
    required String taskId,
  }) async {
    return null;
  }
}
