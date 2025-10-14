# 🤖 Cursor Instructions for Multi-Workspace Todo List

## 🎯 Project Overview
This is a Flutter application using **Serverless Edge Hybrid Architecture** with multi-workspace functionality.

## 📋 Key Rules to Follow

### 1. **ALWAYS Read Rules First**
- Check `.cursor/rules/` directory before coding
- Follow `DEVELOPMENT_RULES.md` for core guidelines
- Use `TESTING_RULES.md` for test standards

### 2. **Architecture Requirements**
- **Clean Architecture**: data/domain/presentation layers
- **GetX State Management**: Controllers, Dependency Injection
- **Multi-Workspace System**: Personal + Company workspaces
- **Firebase Integration**: Auth, Realtime DB, FCM

### 3. **Code Standards**
- Use `AppStrings` for all text (NO hardcoded strings)
- Use `TD` prefix for custom widgets
- Use `NavigationService` and `SnackbarService`
- Maximum 100 lines per widget, 400 lines per file

### 4. **Testing Requirements**
- Use test fixtures from `test/fixtures/`
- Follow AAA pattern (Arrange, Act, Assert)
- Mock external dependencies only
- Test happy path, errors, and edge cases

## 🚀 Quick Commands

### When Writing Tests:
```
Use templates from TEST_CASE_TEMPLATES.md
Follow mocking guidelines from MOCKING_GUIDE.md
Apply principles from TEST_CASE_PRINCIPLES.md
```

### When Developing Features:
```
Read DEVELOPMENT_RULES.md first
Follow ARCHITECTURE_RULES.md patterns
Use CODING_STANDARDS.md guidelines
Apply UI_UX_RULES.md for interface
```

## 📁 Important Files
- `.cursorrules` - Main Cursor configuration
- `.cursor/rules/` - All development rules
- `test/fixtures/` - Test data factories
- `lib/core/constants/` - AppStrings, AppSpacing

## 🎯 Success Criteria
Every implementation must:
1. ✅ Follow all rules in `.cursor/rules/`
2. ✅ Use proper architecture patterns
3. ✅ Include comprehensive tests
4. ✅ Use AppStrings for all text
5. ✅ Use custom TD widgets
6. ✅ Support multi-workspace functionality

---

**Remember**: Always read the rules first, then implement following the established patterns!
