import 'package:todolist/features/tasks/domain/entities/task.dart';
import 'package:todolist/core/constants/task_enums.dart';

/// Test fixtures for Task entities
class TestFixtures {
  /// Create a single test task
  static TaskEntity createTestTask({
    String id = 'test-task-id',
    String title = 'Test Task',
    String description = 'Test task description',
    TaskStatus status = TaskStatus.pending,
    TaskPriority priority = TaskPriority.medium,
    TaskType type = TaskType.daily,
    String? projectId,
    String? assigneeId,
    String? createdBy = 'test-user-id',
    String? companyId = 'test-company-id',
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueDate,
    TaskFrequency frequency = TaskFrequency.daily,
    bool isRecurring = false,
    String? parentTaskId,
  }) {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      status: status.value,
      priority: priority.value,
      taskType: type.value,
      projectId: projectId,
      assigneeId: assigneeId,
      createdBy: createdBy!,
      companyId: companyId!,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
      dueDate: dueDate,
      recurring: isRecurring ? TaskRecurring(
        frequency: frequency.value,
        parentTaskId: parentTaskId,
        nextDueDate: dueDate,
      ) : null,
    );
  }

  /// Create a list of test tasks
  static List<TaskEntity> createTestTasks({
    int count = 5,
    TaskStatus status = TaskStatus.pending,
    TaskPriority priority = TaskPriority.medium,
    TaskType type = TaskType.daily,
  }) {
    return List.generate(count, (index) {
      return createTestTask(
        id: 'test-task-$index',
        title: 'Test Task $index',
        description: 'Test task description $index',
        status: status,
        priority: priority,
        type: type,
        createdAt: DateTime.now().subtract(Duration(days: index)),
        updatedAt: DateTime.now().subtract(Duration(hours: index)),
      );
    });
  }

  /// Create test tasks with different statuses
  static List<TaskEntity> createTestTasksWithDifferentStatuses() {
    return [
      createTestTask(
        id: 'task-pending',
        title: 'Pending Task',
        status: TaskStatus.pending,
        priority: TaskPriority.low,
      ),
      createTestTask(
        id: 'task-in-progress',
        title: 'In Progress Task',
        status: TaskStatus.inProgress,
        priority: TaskPriority.medium,
      ),
      createTestTask(
        id: 'task-completed',
        title: 'Completed Task',
        status: TaskStatus.completed,
        priority: TaskPriority.high,
      ),
      createTestTask(
        id: 'task-cancelled',
        title: 'Cancelled Task',
        status: TaskStatus.cancelled,
        priority: TaskPriority.urgent,
      ),
      createTestTask(
        id: 'task-on-hold',
        title: 'On Hold Task',
        status: TaskStatus.onHold,
        priority: TaskPriority.medium,
      ),
    ];
  }

  /// Create test tasks with different priorities
  static List<TaskEntity> createTestTasksWithDifferentPriorities() {
    return [
      createTestTask(
        id: 'task-low-priority',
        title: 'Low Priority Task',
        priority: TaskPriority.low,
        status: TaskStatus.pending,
      ),
      createTestTask(
        id: 'task-medium-priority',
        title: 'Medium Priority Task',
        priority: TaskPriority.medium,
        status: TaskStatus.inProgress,
      ),
      createTestTask(
        id: 'task-high-priority',
        title: 'High Priority Task',
        priority: TaskPriority.high,
        status: TaskStatus.pending,
      ),
      createTestTask(
        id: 'task-urgent-priority',
        title: 'Urgent Priority Task',
        priority: TaskPriority.urgent,
        status: TaskStatus.inProgress,
      ),
    ];
  }

  /// Create test tasks with different types
  static List<TaskEntity> createTestTasksWithDifferentTypes() {
    return [
      createTestTask(
        id: 'task-daily',
        title: 'Daily Task',
        type: TaskType.daily,
        status: TaskStatus.pending,
      ),
      createTestTask(
        id: 'task-project',
        title: 'Project Task',
        type: TaskType.project,
        projectId: 'test-project-id',
        status: TaskStatus.inProgress,
      ),
    ];
  }

  /// Create recurring test tasks
  static List<TaskEntity> createTestRecurringTasks() {
    return [
      createTestTask(
        id: 'task-daily-recurring',
        title: 'Daily Recurring Task',
        type: TaskType.daily,
        isRecurring: true,
        frequency: TaskFrequency.daily,
        status: TaskStatus.pending,
      ),
      createTestTask(
        id: 'task-weekly-recurring',
        title: 'Weekly Recurring Task',
        type: TaskType.daily,
        isRecurring: true,
        frequency: TaskFrequency.weekly,
        status: TaskStatus.pending,
      ),
      createTestTask(
        id: 'task-monthly-recurring',
        title: 'Monthly Recurring Task',
        type: TaskType.daily,
        isRecurring: true,
        frequency: TaskFrequency.monthly,
        status: TaskStatus.pending,
      ),
    ];
  }

  /// Create test tasks with due dates
  static List<TaskEntity> createTestTasksWithDueDates() {
    final now = DateTime.now();
    return [
      createTestTask(
        id: 'task-overdue',
        title: 'Overdue Task',
        dueDate: now.subtract(const Duration(days: 1)),
        status: TaskStatus.pending,
        priority: TaskPriority.high,
      ),
      createTestTask(
        id: 'task-due-today',
        title: 'Due Today Task',
        dueDate: now,
        status: TaskStatus.pending,
        priority: TaskPriority.medium,
      ),
      createTestTask(
        id: 'task-due-tomorrow',
        title: 'Due Tomorrow Task',
        dueDate: now.add(const Duration(days: 1)),
        status: TaskStatus.pending,
        priority: TaskPriority.low,
      ),
      createTestTask(
        id: 'task-due-next-week',
        title: 'Due Next Week Task',
        dueDate: now.add(const Duration(days: 7)),
        status: TaskStatus.pending,
        priority: TaskPriority.low,
      ),
    ];
  }

  /// Create test tasks for a specific project
  static List<TaskEntity> createTestTasksForProject(String projectId) {
    return [
      createTestTask(
        id: 'project-task-1',
        title: 'Project Task 1',
        type: TaskType.project,
        projectId: projectId,
        status: TaskStatus.pending,
        priority: TaskPriority.medium,
      ),
      createTestTask(
        id: 'project-task-2',
        title: 'Project Task 2',
        type: TaskType.project,
        projectId: projectId,
        status: TaskStatus.inProgress,
        priority: TaskPriority.high,
      ),
      createTestTask(
        id: 'project-task-3',
        title: 'Project Task 3',
        type: TaskType.project,
        projectId: projectId,
        status: TaskStatus.completed,
        priority: TaskPriority.low,
      ),
    ];
  }

  /// Create test tasks for a specific assignee
  static List<TaskEntity> createTestTasksForAssignee(String assigneeId) {
    return [
      createTestTask(
        id: 'assignee-task-1',
        title: 'Assignee Task 1',
        assigneeId: assigneeId,
        status: TaskStatus.pending,
        priority: TaskPriority.medium,
      ),
      createTestTask(
        id: 'assignee-task-2',
        title: 'Assignee Task 2',
        assigneeId: assigneeId,
        status: TaskStatus.inProgress,
        priority: TaskPriority.high,
      ),
      createTestTask(
        id: 'assignee-task-3',
        title: 'Assignee Task 3',
        assigneeId: assigneeId,
        status: TaskStatus.completed,
        priority: TaskPriority.low,
      ),
    ];
  }

  /// Create a large number of test tasks for pagination testing
  static List<TaskEntity> createLargeTestTaskList({int count = 100}) {
    return List.generate(count, (index) {
      return createTestTask(
        id: 'test-task-$index',
        title: 'Test Task $index',
        description: 'Test task description $index',
        status: TaskStatus.values[index % TaskStatus.values.length],
        priority: TaskPriority.values[index % TaskPriority.values.length],
        type: TaskType.values[index % TaskType.values.length],
        createdAt: DateTime.now().subtract(Duration(days: index)),
        updatedAt: DateTime.now().subtract(Duration(hours: index)),
      );
    });
  }
}
