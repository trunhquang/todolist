# 🎯 Best Practices Summary

## Do's ✅
- **ALWAYS check rules/ directory before starting development**
- **ALWAYS check docs/ directory to understand requirements**
- Follow Clean Architecture strictly
- Use GetX patterns consistently
- Write comprehensive tests
- Handle errors gracefully
- Use proper naming conventions
- Implement proper lifecycle management
- Keep controllers focused and small
- Use dependency injection properly
- Document public APIs
- Follow responsive design principles
- **Break large widgets into smaller components**
- **Use TD prefix for all custom widgets**
- **Use SnackbarService for all notifications**
- **Use NavigationService for all navigation**
- **Use AppStrings for all text content**
- **Use AppSpacing for consistent spacing**
- **NEVER hardcode strings in UI components**
- **ALWAYS use AppStrings for all user-facing text**
- **Keep files under 400 lines**
- **Keep widgets under 100 lines**
- **Organize .md files in correct directories (docs/, process/, rules/)**
- **Update documentation when making changes**

## Don'ts ❌
- **NEVER start coding without checking rules/ and docs/ directories**
- **NEVER skip reading DEVELOPMENT_RULES.md before development**
- **NEVER ignore technical specifications in docs/**
- Mix different state management approaches
- Skip error handling
- Use hardcoded values
- Create large, monolithic controllers
- Ignore memory management
- Skip tests for critical functionality
- Use unclear naming
- Create tight coupling between features
- Ignore performance implications
- Skip code reviews
- **Create widgets larger than 100 lines**
- **Create files larger than 400 lines**
- **Use Material widgets directly (Card, Button, Text)**
- **Use Get.snackbar() or Get.to/Get.back directly**
- **Hardcode strings in UI**
- **Hardcode spacing values (EdgeInsets.all(16))**
- **Use string literals instead of AppStrings**
- **Put user-facing text directly in Text() widgets**
- **Create monolithic UI components**
- **Mix documentation types in wrong directories**
- **Leave documentation outdated after changes**

---

**📁 File liên quan:**
- [Development Workflow](DEVELOPMENT_WORKFLOW.md)
- [Code Review Checklist](CODE_REVIEW_CHECKLIST.md)
- [All Rules Files](README.md)
