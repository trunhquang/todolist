# Cursor Rules for Multi-Workspace Todo List Application

This directory contains the rules and guidelines that Cursor AI should follow when working on this project.

## 📋 Available Rules

### Core Development Rules
- **DEVELOPMENT_RULES.md** - Main development guidelines
- **TESTING_RULES.md** - Testing standards and requirements
- **CODING_STANDARDS.md** - Code quality and style guidelines
- **ARCHITECTURE_RULES.md** - Architecture patterns and principles

### Testing Framework
- **TEST_CASE_PRINCIPLES.md** - Testing principles and best practices
- **TEST_CASE_TEMPLATES.md** - Standardized test templates
- **MOCKING_GUIDE.md** - Comprehensive mocking guidelines
- **CURSOR_TESTING_GUIDE.md** - AI assistant testing instructions

### UI/UX Guidelines
- **UI_UX_RULES.md** - User interface and experience guidelines
- **DESIGN_SYSTEM.md** - Design system and component standards

### Security & Performance
- **SECURITY_RULES.md** - Security best practices
- **PERFORMANCE_RULES.md** - Performance optimization guidelines

## 🎯 How to Use

1. **Read the rules first** before starting any development
2. **Follow the established patterns** and guidelines
3. **Use the provided templates** for consistency
4. **Apply the testing framework** for all new features
5. **Maintain code quality** according to the standards

## 📚 Quick Reference

### For Testing:
- Always use test fixtures from `test/fixtures/`
- Follow AAA pattern (Arrange, Act, Assert)
- Use descriptive test names: `should_{behavior}_when_{condition}`
- Mock external dependencies only
- Test happy path, errors, and edge cases

### For Development:
- Use AppStrings for all user-facing text
- Use TD prefix for custom widgets
- Use NavigationService and SnackbarService
- Follow Clean Architecture patterns
- Use GetX for state management

### For Code Quality:
- Maximum 100 lines per widget
- Maximum 400 lines per file
- Use proper error handling
- Follow naming conventions
- Write comprehensive tests

---

**Remember**: These rules ensure consistent, maintainable, and high-quality code across the entire application.
