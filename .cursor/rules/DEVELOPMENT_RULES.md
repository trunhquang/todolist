# 📋 Development Rules & Guidelines

# Enforcement Instruction
Any AI assistant or developer working on this project **must read and apply all rules in this document before implementing any feature** described in `development_blueprint.md`.  
If any conflict arises between a feature description and these rules, **these rules take priority**.



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
- **NEVER use deprecated `withOpacity()` method — always use `withValues(alpha: value)` to avoid precision loss**
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

### 🧹 Linting & Static Analysis — Enforcement
- Không hardcode strings — dùng `AppStrings`
- Không dùng `print()` — dùng logging service/`SnackbarService`
- Luôn sắp xếp imports, loại bỏ unused imports
- Luôn `await` các lệnh điều hướng và chỉ định generics rõ ràng khi cần
- Không dùng trực tiếp `Get.*` trong UI/controller — dùng `NavigationService` và `SnackbarService`
- Tránh raw types (ví dụ `Map`, `List` không có type arguments)
- Tránh bỏ qua `Future` (không discard futures)

Ví dụ đúng/sai:

```dart
// ❌ Sai: hardcode string, dùng trực tiếp Get.toNamed, không await
onPressed: () {
  Get.toNamed('/tasks');
  Get.snackbar('Done', 'Created');
},

// ✅ Đúng: dùng AppStrings + NavigationService + await + generics rõ ràng
onPressed: () async {
  await NavigationService().toNamed<void>(AppRoutes.tasks);
  SnackbarService().showSuccess(title: AppStrings.I.success, message: AppStrings.I.taskCreated);
}
```

```dart
// ❌ Sai: raw type và bỏ qua Future
final data = <String, dynamic>{};
someAsyncCall();

// ✅ Đúng: có type arguments và luôn await/handle
final Map<String, dynamic> payload = <String, dynamic>{};
await someAsyncCall();
```

### ✅ Linting & Static Analysis
- Xem chi tiết tại: [CODING_STANDARDS.md](CODING_STANDARDS.md), [GETX_RULES.md](GETX_RULES.md), [STRING_MANAGEMENT_RULES.md](STRING_MANAGEMENT_RULES.md)
- Nguyên tắc cốt lõi:
  - Không hardcode strings — dùng `AppStrings`
  - Dùng `NavigationService` thay `Get.*` cho điều hướng
  - Không dùng `print()` trong production; dùng logging/`SnackbarService`
  - Sắp xếp imports, thêm doc comments tối thiểu, loại bỏ unused imports
  - Luôn `await` các lệnh điều hướng và dùng generics rõ ràng khi cần

### 📱 UI/UX
- TD prefix for custom widgets
- AppStrings for all text
- AppSpacing for all spacing
- Responsive design

### 🧭 Navigation Rules (GetX)
- Chỉ sử dụng `NavigationService` để điều hướng; không gọi `Get.to`, `Get.back`, `Get.toNamed` trực tiếp trong UI/controllers.
- Luôn `await` các lời gọi điều hướng để tránh race conditions sau đăng nhập hoặc khi đóng overlay.
- Thêm type arguments khi cần (ví dụ `toNamed<void>` hoặc `back<void>()`) để tránh lỗi type inference.

Ví dụ:

```dart
// ✅ Điều hướng có await và type rõ ràng
await NavigationService().toNamed<void>(AppRoutes.projectList, arguments: {'filter': 'active'});

// ✅ Back với type rõ ràng
NavigationService().back<void>();
```

### 🔔 Snackbar & Overlay Rules
- Dùng `SnackbarService` thay vì `Get.snackbar`.
- Không tự quản lý overlay stack trong UI; sử dụng `NavigationService` helpers nếu cần đóng đồng loạt.

```dart
// ✅ Dùng SnackbarService
SnackbarService().showInfo(title: AppStrings.I.info, message: AppStrings.I.savedSuccessfully);
```

### 🧪 Testing
- Unit tests for controllers
- Repository tests
- Widget tests
- Minimum 80% coverage

---

## 🧭 Git Commit & Push Rules

Tuân thủ nghiêm ngặt quy tắc commit/push để giữ lịch sử git sạch và có thể truy vết.

### ✅ Commit Rules (bắt buộc)
- Dùng Conventional Commits: `type(scope): short description`
  - type: `feat`, `fix`, `refactor`, `docs`, `chore`, `test`, `perf`, `build`, `ci`, `style`
  - scope: tên feature/module (ví dụ: `tasks`, `auth`, `navigation`)
  - description: ngắn gọn, mệnh lệnh, tiếng Anh (hoặc đồng nhất theo team)
- Ví dụ:
  - `feat(tasks): add recurring config to TaskEntity`
  - `fix(auth): handle Google sign-in error state`
  - `docs(rules): add commit/push guidelines`
- Commit nhỏ, có ý nghĩa, tránh commit "tạp".
- Không commit secrets, file build, hay thay đổi cấu hình cục bộ.
- Tham khảo chi tiết: `rules/COMMIT_RULES.md`.

### ✅ Pre-commit Checklist
```bash
# Đảm bảo code qua lint/format/test trước khi commit
flutter format lib test
flutter analyze
./scripts/test.sh
```

### ✅ Pre-push Checklist
- Pull/rebase từ nhánh đích (thường là `dev`) trước khi push
- Resolve conflicts và chạy lại lint/test
- Đảm bảo commit messages đúng format Conventional Commits
- Push lên branch theo quy ước: `feature/<name>`, `fix/<name>`, `chore/<name>`

Ví dụ quy trình an toàn:
```bash
git fetch origin
git checkout dev && git pull --rebase
git checkout -
git rebase dev
flutter analyze && ./scripts/test.sh
git push -u origin <your-branch>
```

### 🚫 Tránh
- Push trực tiếp lên `main`/`master`
- Squash bừa bãi làm mất lịch sử có ý nghĩa (trừ khi PR policy quy định)
- Commit/push khi chưa chạy `flutter analyze` và test

---

## 🔄 Cập nhật gần đây:
- ✅ Tổ chức lại cấu trúc thư mục: `docs/`, `process/`, `rules/`
- ✅ Di chuyển file README.md chính về root directory
- ✅ Cập nhật quy tắc tổ chức file .md
- ✅ Áp dụng quy tắc commit messages: xem `rules/COMMIT_RULES.md`
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