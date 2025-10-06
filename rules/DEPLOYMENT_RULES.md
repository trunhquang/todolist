# 🚀 Deployment Rules

## 1. Environment Configuration
```dart
✅ ĐÚNG:
class AppConfig {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.example.com',
  );
  
  static const bool isDebug = bool.fromEnvironment('DEBUG', defaultValue: false);
}

❌ SAI:
// Hardcoded URLs
const String baseUrl = 'https://api.example.com';
```

## 2. Build Configuration
```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/
  
  # Environment-specific configurations
  flavors:
    development:
      applicationId: com.company.todolist.dev
    staging:
      applicationId: com.company.todolist.staging
    production:
      applicationId: com.company.todolist
```

## 3. Version Management
```yaml
# pubspec.yaml
version: 1.0.0+1
# Format: version+build_number
# version: major.minor.patch
# build_number: incremental number
```

---

**📁 File liên quan:**
- [Performance Rules](PERFORMANCE_RULES.md)
- [Security Rules](SECURITY_RULES.md)
- [Code Review Checklist](CODE_REVIEW_CHECKLIST.md)
