# 📋 Multi-Workspace Todo List Application

## 🎯 Project Overview

**Application Name**: Todolist CaoThang  
**Platform**: Flutter (Cross-platform Mobile)  
**Architecture**: Serverless Edge Hybrid (Firebase + OneDrive + Device-hosted Backend)  
**Target Users**: Personal users + Companies with multiple departments and employees  

## 🚀 Quick Start for Cursor AI Development

### 📋 Pre-Development Checklist
Before implementing ANY feature, you MUST complete the pre-development checklist:

1. **📖 Read Essential Documentation**:
   - [Development Blueprint V1](docs/v1/DEVELOPMENT_BLUEPRINT_V1.md)
   - [Cursor Development Context](docs/CURSOR_DEVELOPMENT_CONTEXT.md)
   - [Pre-Development Checklist](docs/CURSOR_PRE_DEVELOPMENT_CHECKLIST.md)

2. **📚 Read Development Rules**:
   - [Development Rules](rules/DEVELOPMENT_RULES.md)
   - [Architecture Rules](rules/ARCHITECTURE_RULES.md)
   - [Coding Standards](rules/CODING_STANDARDS.md)
   - [UI/UX Rules](rules/UI_UX_RULES.md)
   - [Security Rules](rules/SECURITY_RULES.md)
   - [Commit Rules](rules/COMMIT_RULES.md)

3. **🏗️ Understand Architecture**:
   - **V1 - Serverless Edge Hybrid**: Device-hosted backend + Firebase cloud brain + OneDrive backup
   - **Multi-Workspace System**: Personal + Company workspaces with role-based permissions
   - **Clean Architecture**: data/domain/presentation layers with GetX state management

### 🎯 Cursor Configuration Files
- **`.cursorrules`**: Comprehensive development guidelines and rules
- **`.cursorignore`**: Excludes unnecessary files from Cursor's context
- **`docs/CURSOR_DEVELOPMENT_CONTEXT.md`**: Essential context for AI development
- **`docs/CURSOR_PRE_DEVELOPMENT_CHECKLIST.md`**: Mandatory pre-development steps

### 🚨 Critical Rules for Cursor
- **NEVER hardcode strings** - ALWAYS use `AppStrings`
- **NEVER use Material widgets directly** - ALWAYS use custom TD widgets
- **NEVER use Get.snackbar() or Get.to/Get.back** - ALWAYS use `SnackbarService` and `NavigationService`
- **ALWAYS read rules/ and docs/v1/ directories** before coding
- **ALWAYS follow Clean Architecture** and GetX patterns
- **ALWAYS await navigation calls** to avoid race conditions

## 📚 Project Documentation

This folder contains all project documentation, guides, and summaries.

## 🏗️ Architecture & Design

### Core Documentation
- **[DEVELOPMENT_BLUEPRINT.md](DEVELOPMENT_BLUEPRINT.md)** - Overall project architecture and design patterns
- **[DEVELOPMENT_BLUEPRINT_V1.md](docs/v1/DEVELOPMENT_BLUEPRINT_V1.md)** - V1 Serverless Edge Hybrid architecture
- **[TECHNICAL_SPECIFICATIONS.md](TECHNICAL_SPECIFICATIONS.md)** - Technical requirements and specifications
- **[DESIGN_SYSTEM.md](DESIGN_SYSTEM.md)** - UI/UX design system and guidelines
- **[CURSOR_DEVELOPMENT_CONTEXT.md](docs/CURSOR_DEVELOPMENT_CONTEXT.md)** - Essential context for Cursor AI development
- **[CURSOR_PRE_DEVELOPMENT_CHECKLIST.md](docs/CURSOR_PRE_DEVELOPMENT_CHECKLIST.md)** - Mandatory pre-development steps

### Development Guidelines
- **[DEVELOPMENT_RULES.md](rules/DEVELOPMENT_RULES.md)** - Coding standards and best practices
- **[ARCHITECTURE_RULES.md](rules/ARCHITECTURE_RULES.md)** - Clean Architecture guidelines
- **[CODING_STANDARDS.md](rules/CODING_STANDARDS.md)** - Code quality standards
- **[UI_UX_RULES.md](rules/UI_UX_RULES.md)** - UI/UX development rules
- **[SECURITY_RULES.md](rules/SECURITY_RULES.md)** - Security implementation guidelines
- **[COMMIT_RULES.md](rules/COMMIT_RULES.md)** - Git commit message conventions
- **[DEVELOPMENT_ENVIRONMENT.md](DEVELOPMENT_ENVIRONMENT.md)** - Development environment setup
- **[CI_CD_SETUP.md](CI_CD_SETUP.md)** - Continuous integration and deployment setup

## 🔧 Configuration & Setup

### Firebase
- **[FIREBASE_SETUP.md](FIREBASE_SETUP.md)** - Firebase project setup and configuration
- **[FIREBASE_SERVICES_SETUP.md](FIREBASE_SERVICES_SETUP.md)** - Firebase services enablement guide
- **[firebase_setup_guide.md](firebase_setup_guide.md)** - Detailed Firebase setup instructions

### OneDrive Integration
- **[ONEDRIVE_SETUP.md](ONEDRIVE_SETUP.md)** - OneDrive integration setup and configuration

## 🎨 UI/UX & Theming

### Design Updates
- **[COLOR_CHANGES_SUMMARY.md](COLOR_CHANGES_SUMMARY.md)** - Summary of color theme changes
- **[SNACKBAR_SERVICE_GUIDE.md](SNACKBAR_SERVICE_GUIDE.md)** - Centralized notification system guide

## 📊 Project Status

### Phase Documentation
- **[PHASE_0_SUMMARY.md](PHASE_0_SUMMARY.md)** - Phase 0 completion summary
- **[required.md](required.md)** - Project requirements and specifications

## 🚀 Quick Start

### For Cursor AI Development
1. **MANDATORY**: Complete the [Pre-Development Checklist](docs/CURSOR_PRE_DEVELOPMENT_CHECKLIST.md)
2. **MANDATORY**: Read [Cursor Development Context](docs/CURSOR_DEVELOPMENT_CONTEXT.md)
3. **MANDATORY**: Read [Development Blueprint V1](docs/v1/DEVELOPMENT_BLUEPRINT_V1.md)
4. **MANDATORY**: Read [Development Rules](rules/DEVELOPMENT_RULES.md)
5. **MANDATORY**: Read [Architecture Rules](rules/ARCHITECTURE_RULES.md)
6. **MANDATORY**: Read [Coding Standards](rules/CODING_STANDARDS.md)

### For Developers
1. Read [DEVELOPMENT_ENVIRONMENT.md](DEVELOPMENT_ENVIRONMENT.md) for setup
2. Follow [DEVELOPMENT_RULES.md](rules/DEVELOPMENT_RULES.md) for coding standards
3. Check [TECHNICAL_SPECIFICATIONS.md](TECHNICAL_SPECIFICATIONS.md) for requirements

### For Firebase Setup
1. Follow [FIREBASE_SETUP.md](FIREBASE_SETUP.md) for initial setup
2. Use [FIREBASE_SERVICES_SETUP.md](FIREBASE_SERVICES_SETUP.md) to enable services
3. Reference [firebase_setup_guide.md](firebase_setup_guide.md) for detailed steps

### For UI/UX
1. Review [DESIGN_SYSTEM.md](DESIGN_SYSTEM.md) for design guidelines
2. Check [COLOR_CHANGES_SUMMARY.md](COLOR_CHANGES_SUMMARY.md) for theme updates
3. Use [SNACKBAR_SERVICE_GUIDE.md](SNACKBAR_SERVICE_GUIDE.md) for notifications

## 📁 Folder Structure

```
├── .cursorrules                        # Cursor AI development rules
├── .cursorignore                       # Cursor AI ignore patterns
├── README.md                           # This file
├── docs/
│   ├── README.md                       # Documentation index
│   ├── DEVELOPMENT_BLUEPRINT.md        # Project architecture
│   ├── TECHNICAL_SPECIFICATIONS.md     # Technical requirements
│   ├── DESIGN_SYSTEM.md                # UI/UX guidelines
│   ├── DEVELOPMENT_ENVIRONMENT.md      # Dev environment setup
│   ├── CI_CD_SETUP.md                  # CI/CD configuration
│   ├── FIREBASE_SETUP.md               # Firebase setup
│   ├── FIREBASE_SERVICES_SETUP.md      # Firebase services
│   ├── firebase_setup_guide.md         # Detailed Firebase guide
│   ├── ONEDRIVE_SETUP.md               # OneDrive integration
│   ├── COLOR_CHANGES_SUMMARY.md        # Theme changes
│   ├── SNACKBAR_SERVICE_GUIDE.md       # Notification system
│   ├── PHASE_0_SUMMARY.md              # Phase 0 summary
│   ├── required.md                     # Project requirements
│   ├── CURSOR_DEVELOPMENT_CONTEXT.md   # Cursor AI context guide
│   ├── CURSOR_PRE_DEVELOPMENT_CHECKLIST.md # Pre-dev checklist
│   └── v1/
│       ├── DEVELOPMENT_BLUEPRINT_V1.md # V1 architecture
│       └── AUTHENTICATION_AND_COMPANY_SETUP_FLOW.md # Auth flow
├── rules/
│   ├── README.md                       # Rules index
│   ├── DEVELOPMENT_RULES.md            # Main development rules
│   ├── ARCHITECTURE_RULES.md           # Architecture guidelines
│   ├── CODING_STANDARDS.md             # Code quality standards
│   ├── UI_UX_RULES.md                  # UI/UX rules
│   ├── SECURITY_RULES.md               # Security guidelines
│   ├── COMMIT_RULES.md                 # Git commit rules
│   ├── GETX_RULES.md                   # GetX framework rules
│   ├── STRING_MANAGEMENT_RULES.md      # String management
│   ├── TESTING_RULES.md                # Testing guidelines
│   ├── PERFORMANCE_RULES.md            # Performance rules
│   ├── DEPLOYMENT_RULES.md             # Deployment rules
│   ├── DOCUMENTATION_RULES.md          # Documentation rules
│   ├── FILE_ORGANIZATION_RULES.md      # File organization
│   ├── REFACTORING_GUIDELINES.md       # Refactoring guidelines
│   ├── CODE_REVIEW_CHECKLIST.md        # Code review checklist
│   ├── BEST_PRACTICES_SUMMARY.md       # Best practices
│   └── IMPLEMENTATION_EXAMPLES.md      # Implementation examples
└── lib/                                # Source code
    ├── app/                            # App configuration
    ├── core/                           # Core utilities
    └── features/                       # Feature modules
```

## 🔄 Documentation Maintenance

### Update Frequency
- **Technical docs**: Updated with each major change
- **Setup guides**: Updated when configuration changes
- **Design docs**: Updated with UI/UX changes
- **Status docs**: Updated weekly

### Contributing
1. Follow the existing documentation style
2. Update the index when adding new documents
3. Keep documentation current with code changes
4. Use clear, concise language

## 📞 Support

For questions about documentation:
- Check the relevant guide first
- Review the project requirements
- Contact the development team
- Create an issue for missing documentation

---
**Last Updated**: Current Date  
**Maintained By**: Development Team  
**Review Frequency**: Weekly
