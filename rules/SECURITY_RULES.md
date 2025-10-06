# 🔒 Security Rules

## 1. Data Validation
```dart
✅ ĐÚNG:
class TaskValidator {
  static String? validateTitle(String? title) {
    if (title == null || title.isEmpty) {
      return 'Title is required';
    }
    if (title.length < 3) {
      return 'Title must be at least 3 characters';
    }
    return null;
  }
}

❌ SAI:
// No validation
```

## 2. Input Sanitization
```dart
✅ ĐÚNG:
String sanitizeInput(String input) {
  return input.trim().replaceAll(RegExp(r'[<>"\']'), '');
}

❌ SAI:
// Direct use of user input without sanitization
```

## 3. Error Messages
```dart
✅ ĐÚNG:
// Generic error messages for security
'An error occurred. Please try again.'

❌ SAI:
// Detailed error messages that might expose system info
'Database connection failed at 192.168.1.1:5432'
```

---

**📁 File liên quan:**
- [Coding Standards](CODING_STANDARDS.md)
- [Testing Rules](TESTING_RULES.md)
- [Performance Rules](PERFORMANCE_RULES.md)
