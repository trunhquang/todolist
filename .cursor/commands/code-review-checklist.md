# Code Review Checklist

## Overview
Comprehensive checklist for conducting thorough code reviews to ensure quality, security, and maintainability.

## Review Categories

### Functionality
- [ ] Code does what it's supposed to do
- [ ] Edge cases are handled
- [ ] Error handling is appropriate
- [ ] No obvious bugs or logic errors

### Code Quality
- [ ] Code is readable and well-structured
- [ ] Functions are small and focused
- [ ] Variable names are descriptive
- [ ] No code duplication
- [ ] Follows project conventions

### Security
- [ ] No obvious security vulnerabilities
- [ ] Input validation is present
- [ ] Sensitive data is handled properly
- [ ] No hardcoded secrets

### Compilation & Dependencies
- [ ] All imports are correct and files exist
- [ ] No ambiguous imports (use aliases when needed)
- [ ] All required dependencies are properly injected
- [ ] Constructor parameters match actual class definitions
- [ ] Type annotations are explicit and correct
- [ ] No undefined classes, methods, or properties
- [ ] Extension methods are properly defined and used
- [ ] Generic types are correctly specified

### GetX & State Management
- [ ] Controllers extend BaseController or GetxController properly
- [ ] Observable variables use correct Rx types (RxList, RxBool, Rx<T>)
- [ ] No StatefulWidget usage (use StatelessWidget with GetX controllers)
- [ ] Proper use of Obx() for reactive UI updates
- [ ] Dependency injection is handled correctly with Get.find()
- [ ] Controller lifecycle methods (onInit, onClose) are properly implemented

### Firebase & Services
- [ ] Firebase service calls use correct method signatures
- [ ] Pagination services use proper cursor-based pagination
- [ ] StorageService is properly initialized and used
- [ ] Error handling follows Failure pattern
- [ ] Service dependencies are correctly injected

### Testing
- [ ] Test fixtures use correct entity constructors
- [ ] Mock services have all required methods stubbed
- [ ] Test expectations match actual implementation
- [ ] No hardcoded test values that don't match entity definitions
- [ ] Proper use of test fixtures instead of manual object creation

### Project-Specific Rules
- [ ] Uses AppStrings for all user-facing text
- [ ] Uses enums from task_enums.dart for status/priority/type values
- [ ] Uses custom TD widgets instead of Material widgets
- [ ] Uses SnackbarService for notifications
- [ ] Uses NavigationService for navigation
- [ ] Follows Clean Architecture patterns
- [ ] Uses server-side pagination for large datasets
- [ ] No hardcoded string values for business logic