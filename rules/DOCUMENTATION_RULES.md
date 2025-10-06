# 📚 Documentation Rules

## 1. Code Documentation
```dart
/// Controller for managing task-related operations
/// 
/// This controller handles:
/// - Creating new tasks
/// - Loading existing tasks
/// - Updating task status
/// - Deleting tasks
class TaskController extends GetxController {
  /// Creates a new task with the given parameters
  /// 
  /// [task] The task to be created
  /// 
  /// Throws [TaskCreationException] if task creation fails
  Future<void> createTask(Task task) async {
    // Implementation
  }
}
```

## 2. Project Documentation Structure
```
📁 Project Root/
├── README.md                    # 📚 Main project documentation index
├── docs/                        # 📖 All project documentation
│   ├── README.md               # 📋 Documentation navigation
│   ├── DEVELOPMENT_BLUEPRINT.md # 🏗️ Project architecture
│   ├── TECHNICAL_SPECIFICATIONS.md # 📋 Technical requirements
│   ├── DESIGN_SYSTEM.md        # 🎨 UI/UX guidelines
│   ├── FIREBASE_SETUP.md       # 🔥 Firebase configuration
│   └── [other documentation files...]
├── process/                     # 📊 Project process & progress
│   ├── README.md               # 📋 Process overview
│   ├── PROJECT_PROGRESS.md     # 📈 Project progress tracking
│   ├── SPRINT_TRACKING.md      # 🏃 Sprint management
│   ├── TECHNICAL_DEBT.md       # 🐛 Technical debt tracking
│   └── [other process files...]
└── rules/                       # 📜 Development rules & guidelines
    ├── README.md               # 📋 Rules overview
    └── DEVELOPMENT_RULES.md    # 📋 This file
```

**Quy tắc tổ chức file .md:**
- **Documentation files** → `docs/` directory
- **Process & progress files** → `process/` directory  
- **Rules & guidelines** → `rules/` directory
- **Main README.md** → Root directory (project overview)

## 3. API Documentation
- **README.md** for each feature
- **API documentation** for public methods
- **Architecture diagrams** for complex features
- **Migration guides** for breaking changes

## 4. Commit Messages
```
✅ ĐÚNG:
feat: add task creation functionality
fix: resolve memory leak in task controller
docs: update API documentation
refactor: extract task validation logic

❌ SAI:
update code
fix bug
changes
```

---

**📁 File liên quan:**
- [File Organization Rules](FILE_ORGANIZATION_RULES.md)
- [Development Workflow](DEVELOPMENT_WORKFLOW.md)
- [Code Review Checklist](CODE_REVIEW_CHECKLIST.md)
