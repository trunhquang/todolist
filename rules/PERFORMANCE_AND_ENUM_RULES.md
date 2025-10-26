# ⚡ Performance & Enum Rules

## 🚀 PERFORMANCE OPTIMIZATION RULES

### ❌ NEVER DO THESE:
- **NEVER implement client-side pagination for large datasets**
- **NEVER load entire datasets into memory for filtering/sorting**
- **NEVER use inefficient Firebase queries without proper indexing**
- **NEVER ignore memory usage in list operations**
- **NEVER use StatefulWidget for complex state management**

### ✅ ALWAYS DO THESE:
- **ALWAYS use server-side pagination with `FirebaseDatabaseServiceEnhanced`**
- **ALWAYS implement proper Firebase query optimization**
- **ALWAYS use GetX controllers for state management**
- **ALWAYS implement proper caching strategies**
- **ALWAYS monitor and optimize memory usage**

## 📊 PAGINATION IMPLEMENTATION RULES

### Server-Side Pagination (MANDATORY)
```dart
// ✅ CORRECT: Use enhanced service with server-side pagination
final result = await enhancedService.getPaginatedTasks(
  workspaceId: workspaceId,
  page: page,
  pageSize: limit,
  lastTaskId: lastTaskId,
  status: TaskStatus.pending,
  priority: TaskPriority.high,
);

// ❌ WRONG: Client-side pagination (inefficient)
final allTasks = await _databaseService.listTasks(workspaceId: workspaceId);
return allTasks.sublist(startIndex, endIndex);
```

### Firebase Query Optimization
```dart
// ✅ CORRECT: Optimized Firebase queries
Query query = tasksRef.orderByChild('status').equalTo(status.value);
query = query.orderByChild(orderBy);
query = query.limitToFirst(pageSize);
if (lastTaskId != null) {
  query = query.startAt(null, lastTaskId);
}

// ❌ WRONG: Inefficient queries
Query query = tasksRef; // No filtering, loads everything
```

## 🏷️ ENUM USAGE RULES

### ❌ NEVER DO THESE:
- **NEVER use hardcoded strings for status, priority, type values**
- **NEVER use magic strings in business logic**
- **NEVER ignore type safety for enum values**
- **NEVER use string comparison for enum validation**

### ✅ ALWAYS DO THESE:
- **ALWAYS use enums from `task_enums.dart`**
- **ALWAYS use enum methods for string conversion**
- **ALWAYS validate enum values with proper fallbacks**
- **ALWAYS use type-safe enum comparisons**

## 📝 ENUM IMPLEMENTATION EXAMPLES

### Task Status Usage
```dart
// ✅ CORRECT: Using enums
enum TaskStatus {
  pending('pending'),
  inProgress('in_progress'),
  completed('completed'),
  cancelled('cancelled'),
  onHold('on_hold');

  const TaskStatus(this.value);
  final String value;

  static TaskStatus fromString(String value) {
    return TaskStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => TaskStatus.pending,
    );
  }
}

// Usage in code
final status = TaskStatus.fromString('pending');
final displayText = status.displayText;

// ❌ WRONG: Using hardcoded strings
final status = 'pending';
if (status == 'pending') { ... }
```

### Task Priority Usage
```dart
// ✅ CORRECT: Using enums
enum TaskPriority {
  low('low'),
  medium('medium'),
  high('high'),
  urgent('urgent');

  const TaskPriority(this.value);
  final String value;

  static TaskPriority fromString(String value) {
    return TaskPriority.values.firstWhere(
      (priority) => priority.value == value,
      orElse: () => TaskPriority.medium,
    );
  }
}

// Usage in controllers
final priority = TaskPriority.fromString(priorityString);
final task = TaskEntity(
  priority: priority.value,
  // ... other fields
);
```

### Task Type Usage
```dart
// ✅ CORRECT: Using enums
enum TaskType {
  daily('daily'),
  project('project');

  const TaskType(this.value);
  final String value;

  static TaskType fromString(String value) {
    return TaskType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => TaskType.daily,
    );
  }
}

// Usage in UI
DropdownMenuItem<TaskType>(
  value: TaskType.daily,
  child: Text(TaskType.daily.displayText),
)
```

## 🔧 PERFORMANCE MONITORING RULES

### Memory Usage Monitoring
```dart
// ✅ CORRECT: Monitor memory usage
class PaginatedController extends GetxController {
  final _memoryUsage = 0.obs;
  
  void _monitorMemoryUsage() {
    // Monitor memory usage during operations
    final usage = ProcessInfo.currentRss;
    _memoryUsage.value = usage;
  }
}
```

### Query Performance Monitoring
```dart
// ✅ CORRECT: Monitor query performance
Future<List<TaskEntity>> _fetchTasksOptimized() async {
  final stopwatch = Stopwatch()..start();
  
  try {
    final result = await enhancedService.getPaginatedTasks(...);
    stopwatch.stop();
    
    // Log performance metrics
    if (stopwatch.elapsedMilliseconds > 1000) {
      // Log slow query warning
    }
    
    return result.data;
  } catch (e) {
    stopwatch.stop();
    // Handle error
    rethrow;
  }
}
```

## 📋 PERFORMANCE CHECKLIST

### Before Implementing Pagination:
- [ ] Use `FirebaseDatabaseServiceEnhanced` for server-side pagination
- [ ] Implement proper Firebase query optimization
- [ ] Add performance monitoring and logging
- [ ] Test with large datasets (1000+ items)
- [ ] Monitor memory usage during operations
- [ ] Implement proper error handling and fallbacks

### Before Using Enums:
- [ ] Import enums from `task_enums.dart`
- [ ] Use enum methods for string conversion
- [ ] Implement proper validation with fallbacks
- [ ] Use type-safe comparisons
- [ ] Add comprehensive tests for enum usage
- [ ] Document enum usage in code comments

## 🚨 PERFORMANCE WARNINGS

### Red Flags to Watch For:
- **Memory usage > 100MB** for list operations
- **Query response time > 2 seconds** for pagination
- **Client-side filtering** of large datasets
- **Multiple Firebase queries** in sequence
- **No caching** for frequently accessed data
- **String-based comparisons** instead of enums

### Performance Targets:
- **Memory usage**: < 50MB for typical operations
- **Query response time**: < 500ms for pagination
- **UI responsiveness**: < 16ms for smooth 60fps
- **Data loading**: < 1 second for initial page load
- **Cache hit rate**: > 80% for frequently accessed data

## 📚 REFERENCE IMPLEMENTATIONS

### Enhanced Firebase Service Usage:
```dart
// Use enhanced service for all pagination
final enhancedService = FirebaseDatabaseServiceEnhanced.instance;
final result = await enhancedService.getPaginatedTasks(
  workspaceId: workspaceId,
  page: page,
  pageSize: pageSize,
  status: TaskStatus.pending,
  priority: TaskPriority.high,
  type: TaskType.daily,
);
```

### Enum Validation in Controllers:
```dart
// Validate enum values in controllers
void updateTaskStatus(String statusString) {
  final status = TaskStatus.fromString(statusString);
  if (status == null) {
    handleError(ValidationFailure('Invalid status: $statusString'));
    return;
  }
  
  // Proceed with valid enum value
  _updateTaskWithStatus(status);
}
```

---

**Remember**: Performance and type safety are critical for user experience. Always prioritize server-side pagination and enum usage over convenience shortcuts.
