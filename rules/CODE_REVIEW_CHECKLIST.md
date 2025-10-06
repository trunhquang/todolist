# 📋 Code Review Checklist

## Before Submitting PR:
- [ ] Code follows naming conventions
- [ ] Controllers extend GetxController properly
- [ ] Observable variables are private with public getters
- [ ] Error handling is implemented
- [ ] Tests are written and passing
- [ ] No hardcoded values
- [ ] Proper dependency injection
- [ ] Memory leaks prevented (onClose implemented)
- [ ] UI is responsive
- [ ] Security validations in place
- [ ] **Widget size limits respected** (max 100 lines per widget, 400 lines per file)
- [ ] **Custom widgets use TD prefix** (TDCard, TDButton, TDText, etc.)
- [ ] **SnackbarService used** for all notifications (no direct Get.snackbar)
- [ ] **NavigationService used** for all navigation (no direct Get.to/Get.back)
- [ ] **AppStrings used** for all text (no hardcoded strings)
- [ ] **AppSpacing used** for all spacing (no hardcoded EdgeInsets)

## Architecture Checklist:
- [ ] Clean Architecture layers respected
- [ ] Feature-based structure followed
- [ ] No direct imports between features
- [ ] Shared code in shared/ folder
- [ ] Proper separation of concerns

## GetX Checklist:
- [ ] Controllers properly registered in bindings
- [ ] Reactive UI with Obx()
- [ ] Proper navigation with GetX
- [ ] Dependency injection with Get.find()
- [ ] Lifecycle methods implemented

---

**📁 File liên quan:**
- [Testing Rules](TESTING_RULES.md)
- [Coding Standards](CODING_STANDARDS.md)
- [Refactoring Guidelines](REFACTORING_GUIDELINES.md)
