# 📋 Development Rules & Guidelines

## 🎯 Mục đích
File này định nghĩa các quy tắc và hướng dẫn phát triển để đảm bảo:
- **Tính nhất quán** trong codebase
- **Dễ dàng refactor** và maintain
- **Chất lượng code** cao
- **Team collaboration** hiệu quả

---

## 📚 Rules Navigation

### 🚀 Core Development Rules
- **[Development Workflow](DEVELOPMENT_WORKFLOW.md)** - Quy trình phát triển và checklist
- **[Architecture Rules](ARCHITECTURE_RULES.md)** - Quy tắc kiến trúc Clean Architecture
- **[Coding Standards](CODING_STANDARDS.md)** - Tiêu chuẩn coding và naming conventions
- **[GetX Specific Rules](GETX_RULES.md)** - Quy tắc sử dụng GetX framework

### 🧪 Quality & Testing
- **[Testing Rules](TESTING_RULES.md)** - Quy tắc viết test và test structure
- **[Code Review Checklist](CODE_REVIEW_CHECKLIST.md)** - Checklist cho code review
- **[Refactoring Guidelines](REFACTORING_GUIDELINES.md)** - Hướng dẫn refactor an toàn

### 📱 UI/UX & Implementation
- **[UI/UX Rules](UI_UX_RULES.md)** - Quy tắc UI/UX và widget composition
- **[String Management Rules](STRING_MANAGEMENT_RULES.md)** - Quản lý strings tập trung
- **[Implementation Examples](IMPLEMENTATION_EXAMPLES.md)** - Ví dụ implementation cụ thể

### 🔧 Technical Rules
- **[Security Rules](SECURITY_RULES.md)** - Quy tắc bảo mật và validation
- **[Performance Rules](PERFORMANCE_RULES.md)** - Quy tắc tối ưu performance
- **[Deployment Rules](DEPLOYMENT_RULES.md)** - Quy tắc deployment và environment

### 📁 Organization & Documentation
- **[File Organization Rules](FILE_ORGANIZATION_RULES.md)** - Quy tắc tổ chức file và thư mục
- **[Documentation Rules](DOCUMENTATION_RULES.md)** - Quy tắc viết documentation
- **[Best Practices Summary](BEST_PRACTICES_SUMMARY.md)** - Tóm tắt best practices

---

## 🚀 Quick Start

### 1. 📜 Pre-Development Checklist
Trước khi bắt đầu develop bất kỳ feature nào, **BẮT BUỘC** phải thực hiện:

1. **Đọc [Development Workflow](DEVELOPMENT_WORKFLOW.md)** - Hiểu quy trình phát triển
2. **Đọc [Architecture Rules](ARCHITECTURE_RULES.md)** - Hiểu kiến trúc dự án
3. **Đọc [Coding Standards](CODING_STANDARDS.md)** - Hiểu coding standards
4. **Đọc [Best Practices Summary](BEST_PRACTICES_SUMMARY.md)** - Nắm best practices

### 2. 📖 Documentation Check
```
✅ BẮT BUỘC: Đọc tài liệu liên quan trong thư mục docs/
├── docs/README.md                    # 📋 Navigation tài liệu
├── docs/DEVELOPMENT_BLUEPRINT.md     # 🏗️ Kiến trúc dự án
├── docs/TECHNICAL_SPECIFICATIONS.md  # 📋 Yêu cầu kỹ thuật
├── docs/DESIGN_SYSTEM.md             # 🎨 Hệ thống thiết kế
└── [other relevant docs...]          # 📚 Tài liệu khác
```

### 3. 🏗️ Development Workflow
```
1. 📜 Read Rules → 2. 📖 Read Docs → 3. 🏗️ Plan Architecture → 4. 💻 Code → 5. ✅ Test → 6. 📝 Update Docs
```

---

## 🎯 Essential Rules Summary

### ✅ Must Do's
- **ALWAYS check rules/ directory before starting development**
- **ALWAYS check docs/ directory to understand requirements**
- **Use AppStrings for all user-facing text**
- **Use TD prefix for all custom widgets**
- **Use SnackbarService for all notifications**
- **Use NavigationService for all navigation**
- **Keep files under 400 lines**
- **Keep widgets under 100 lines**

### ❌ Must Don'ts
- **NEVER start coding without checking rules/ and docs/ directories**
- **NEVER hardcode strings in ANY layer (UI, Controllers, Services, Repositories, DataSources)** — luôn dùng `AppStrings` (hoặc localization layer)
- **NEVER use Material widgets directly**
- **NEVER use Get.snackbar() or Get.to/Get.back directly — always use `SnackbarService` and `NavigationService`**
- **NEVER create widgets larger than 100 lines**
- **NEVER create files larger than 400 lines**

---

## 📋 Quick Reference

### 🏗️ Architecture
- Clean Architecture: `data/domain/presentation`
- Feature-based structure
- GetX patterns

### 📝 Coding
- camelCase naming
- Private observables with public getters
- Proper error handling
- Dependency injection

### ✅ Linting & Static Analysis
- Use `package:` imports for files in `lib/`
- Sort imports and directive sections alphabetically
- Add minimal doc comments for public classes, methods, and fields
- Avoid printing in production code; use `SnackbarService` or proper logging
- Remove all unused imports (fix warnings like "Unused import: ..."); prefer IDE auto-organize imports
- Avoid long lines (> 80 chars) unless unavoidable; prefer wrapping
- Prefer explicit generic types for navigation via `NavigationService` (`NavigationService.instance.offAllNamed<void>(…)`, `toNamed<void>(…)`, `back<void>(…)`)
- Always `await` navigation futures; do not discard returned `Future`
- Centralize all route paths in `lib/app/routes/app_router.dart` and NEVER hardcode strings like '/login', '/dashboard'; always use `AppRouter.*`
 - No hardcoded user-facing text ngoài `lib/core/constants/app_strings.dart`; tất cả thông điệp/label/error phải dùng `AppStrings.*`
- Async functions should return `Future` (not `void`) unless used as callbacks
- Use `on <ExceptionType>` in `catch` clauses when possible
- Do not return `dynamic` where a concrete type is expected; cast JSON to `Map<String, dynamic>` / `List<Map<String, dynamic>>`

### 📱 UI/UX
- TD prefix for custom widgets
- AppStrings for all text
- AppSpacing for all spacing
- Responsive design

### 🧪 Testing
- Unit tests for controllers
- Repository tests
- Widget tests
- Minimum 80% coverage

---

## 🔄 Cập nhật gần đây:
- ✅ Tổ chức lại cấu trúc thư mục: `docs/`, `process/`, `rules/`
- ✅ Di chuyển file README.md chính về root directory
- ✅ Cập nhật quy tắc tổ chức file .md
\- ✅ Áp dụng quy tắc commit messages: xem `rules/COMMIT_RULES.md`
- ✅ Thêm File Organization Rules section
- ✅ Thêm Development Workflow section với Pre-Development Checklist
- ✅ Bắt buộc check rules/ và docs/ trước khi bắt đầu develop
- ✅ Tạo AppStrings file để quản lý strings tập trung
- ✅ Thêm String Management Rules section
- ✅ Bắt buộc sử dụng AppStrings thay vì hardcode strings
- ✅ **Tách DEVELOPMENT_RULES.md thành nhiều file nhỏ để dễ quản lý**
- ✅ Bổ sung Linting & Static Analysis Rules (GetX generics, await navigation, package imports, doc comments, no print, JSON casting)

---

**📝 Lưu ý**: File này là **index chính** cho tất cả development rules. Để xem chi tiết từng quy tắc, hãy click vào các link tương ứng ở trên. Tất cả team members phải tuân thủ các quy tắc này để đảm bảo tính nhất quán và chất lượng code.