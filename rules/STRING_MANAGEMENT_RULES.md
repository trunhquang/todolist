# 📝 String Management Rules

## 1. Centralized String Management
```
✅ ĐÚNG:
import '../../../core/constants/app_strings.dart';';

Text(AppStrings.welcomeMessage)
TDTextField(label: AppStrings.I.email, hint: AppStrings.I.enterEmail)

❌ SAI:
Text('Welcome to TodoList')
TDTextField(label: 'Email', hint: 'Enter your email')
```

**Quy tắc:**
- **TẤT CẢ** user-facing strings phải được định nghĩa trong `AppStrings`
- **KHÔNG** được hardcode strings trong UI components
- **BẮT BUỘC** import `AppStrings` khi sử dụng text

## 2. AppStrings File Structure
```
lib/core/constants/app_strings.dart
├── Authentication Strings
├── Navigation Strings  
├── Task Management Strings
├── Company Setup Strings
├── Validation Strings
├── Success Messages
├── Error Messages
├── Confirmation Messages
├── Placeholder Strings
├── Date and Time Strings
├── Settings Strings
├── Theme Strings
└── Utility Methods
```

## 3. String Naming Conventions
```
✅ ĐÚNG:
static const String welcomeMessage = 'Welcome to TodoList';
static const String enterEmail = 'Enter your email';
static const String invalidEmail = 'Please enter a valid email address';
static const String taskCreated = 'Task created successfully';

❌ SAI:
static const String welcome = 'Welcome to TodoList';
static const String emailHint = 'Enter your email';
static const String emailError = 'Please enter a valid email address';
static const String success = 'Task created successfully';
```

**Quy tắc:**
- Sử dụng **camelCase** cho tên constants
- Tên phải **mô tả rõ ràng** nội dung string
- **Phân loại** strings theo chức năng
- **Tránh** tên generic như `message`, `text`, `label`

## 4. String Usage Examples
```dart
// ✅ ĐÚNG: Sử dụng AppStrings
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.login),
      ),
      body: Column(
        children: [
          Text(AppStrings.welcomeBack),
          TDTextField(
            label: AppStrings.I.email,
            hint: AppStrings.I.enterEmail,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.I.emailRequired;
              }
              if (!GetUtils.isEmail(value)) {
                return AppStrings.I.invalidEmail;
              }
              return null;
            },
          ),
          TDButton(
            text: AppStrings.I.login,
            onPressed: () => _handleLogin(),
          ),
        ],
      ),
    );
  }
}

// ❌ SAI: Hardcode strings
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        children: [
          Text('Welcome Back'),
          TDTextField(
            label: 'Email',
            hint: 'Enter your email',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!GetUtils.isEmail(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          TDButton(
            text: 'Login',
            onPressed: () => _handleLogin(),
          ),
        ],
      ),
    );
  }
}
```

## 5. Adding New Strings
```
1. 📝 Identify the string that needs to be centralized
2. 📂 Find the appropriate section in AppStrings
3. 🏷️ Add the string with a descriptive name
4. 🔄 Replace hardcoded string with AppStrings reference
5. ✅ Test to ensure the string displays correctly
```

**Quy tắc:**
- **Luôn** thêm strings mới vào `AppStrings` trước khi sử dụng
- **Đặt** strings vào đúng section (auth, navigation, task, etc.)
- **Đặt tên** strings theo convention đã định
- **Test** để đảm bảo strings hiển thị đúng

---

**📁 File liên quan:**
- [UI/UX Rules](UI_UX_RULES.md)
- [Coding Standards](CODING_STANDARDS.md)
- [Implementation Examples](IMPLEMENTATION_EXAMPLES.md)
