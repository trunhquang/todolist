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

## 2. Project Documentation Structure (UPDATED)
```
📁 Project Root/
├── README.md                    # 📚 Main project documentation index
├── docs/                        # 📖 All project documentation
│   ├── README.md               # 📋 Documentation navigation
│   ├── DEVELOPMENT_BLUEPRINT.md # 🏗️ Project architecture
│   ├── TECHNICAL_SPECIFICATIONS.md # 📋 Technical requirements
│   ├── DESIGN_SYSTEM.md        # 🎨 UI/UX guidelines
│   ├── FIREBASE_SETUP.md       # 🔥 Firebase configuration
│   ├── improvements/           # 📈 Project improvements & enhancements
│   │   ├── README.md          # 📋 Improvements navigation
│   │   ├── IMPROVEMENTS_SUMMARY.md # 🚀 Comprehensive improvements
│   │   └── RULES_UPDATE_SUMMARY.md # 📋 Rule updates for Cursor AI
│   ├── testing/                # 🧪 Testing strategy & documentation
│   │   └── README.md          # 📋 Testing patterns & examples
│   ├── v1/                     # 📖 Version-specific documentation
│   │   ├── DEVELOPMENT_BLUEPRINT_V1.md
│   │   └── phases/            # Phase-specific guides
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

**Quy tắc tổ chức file .md (UPDATED):**
- **Documentation files** → `docs/` directory
- **Project improvements** → `docs/improvements/` directory
- **Testing documentation** → `docs/testing/` directory
- **Version-specific docs** → `docs/v1/` directory
- **Process & progress files** → `process/` directory  
- **Rules & guidelines** → `rules/` directory
- **Main README.md** → Root directory (project overview)
- **NEVER place .md files in root** → Always organize into appropriate folders

## 3. Documentation Organization Rules (NEW)

### ❌ NEVER DO THESE:
- **NEVER place .md files in root project directory**
- **NEVER create documentation without proper folder structure**
- **NEVER mix different types of documentation in same folder**
- **NEVER create documentation without README.md navigation**

### ✅ ALWAYS DO THESE:
- **ALWAYS organize documentation into logical folders**
- **ALWAYS create README.md for each folder with navigation**
- **ALWAYS use consistent naming conventions**
- **ALWAYS update main docs/README.md when adding new folders**

### 📁 Folder Organization Rules:
```bash
# ✅ CORRECT: Organized structure
docs/
├── improvements/           # Project improvements & enhancements
├── testing/               # Testing strategy & documentation  
├── v1/                   # Version-specific documentation
├── api/                  # API documentation (future)
├── deployment/           # Deployment guides (future)
└── troubleshooting/      # Common issues (future)

# ❌ WRONG: Scattered files
IMPROVEMENTS_SUMMARY.md   # Should be in docs/improvements/
RULES_UPDATE_SUMMARY.md   # Should be in docs/improvements/
TESTING_GUIDE.md          # Should be in docs/testing/
```

### 📝 README.md Requirements:
Each folder MUST have a README.md with:
- **Overview**: Purpose and contents of the folder
- **Navigation**: Links to all files in the folder
- **Related Documentation**: Links to related folders/files
- **Usage Examples**: How to use the documentation

### 🔄 Documentation Maintenance:
- **Regular Updates**: Keep documentation current with code changes
- **Cross-References**: Link related documents for easy navigation
- **Consistent Structure**: Follow established patterns
- **Version Control**: Track documentation changes

## 4. API Documentation
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
