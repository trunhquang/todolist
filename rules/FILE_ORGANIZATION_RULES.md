# 📁 File Organization Rules

## 1. Directory Structure
```
✅ ĐÚNG:
lib/
├── app/                    # App-level configuration
├── core/                   # Shared utilities & services
├── features/               # Feature-based modules
│   └── auth/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── shared/                 # Shared components

docs/                       # 📖 Documentation
├── README.md              # Documentation index
├── DEVELOPMENT_BLUEPRINT.md
├── TECHNICAL_SPECIFICATIONS.md
└── [other docs...]

process/                    # 📊 Process & Progress
├── README.md              # Process overview
├── PROJECT_PROGRESS.md
├── SPRINT_TRACKING.md
└── [other process files...]

rules/                      # 📜 Rules & Guidelines
├── README.md              # Rules overview
└── DEVELOPMENT_RULES.md   # This file
```

## 2. Markdown File Organization
**Quy tắc phân loại file .md:**

- **Documentation files** → `docs/` directory
  - Technical specifications
  - Setup guides
  - Architecture documentation
  - API documentation

- **Process files** → `process/` directory
  - Project progress tracking
  - Sprint management
  - Technical debt tracking
  - Implementation summaries

- **Rules files** → `rules/` directory
  - Development rules
  - Coding standards
  - Best practices
  - Guidelines

- **Main README.md** → Root directory
  - Project overview
  - Quick start guide
  - Documentation index

## 3. File Naming Conventions
```
✅ ĐÚNG:
- DEVELOPMENT_RULES.md
- TECHNICAL_SPECIFICATIONS.md
- PROJECT_PROGRESS.md
- SPRINT_TRACKING.md

❌ SAI:
- development-rules.md
- technical_specs.md
- progress.md
- sprint.md
```

---

**📁 File liên quan:**
- [Architecture Rules](ARCHITECTURE_RULES.md)
- [Documentation Rules](DOCUMENTATION_RULES.md)
- [Development Workflow](DEVELOPMENT_WORKFLOW.md)
