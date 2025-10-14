# 📁 File Organization Rules

## 🎯 Mục đích

File này định nghĩa các quy tắc tổ chức file và thư mục trong dự án Multi-Workspace Todo List Application.

## 📋 Core Rules

### 1. **Reports Directory Rule** 📊
**CRITICAL**: Tất cả các file reports (báo cáo) phải được đặt trong thư mục `reports/` ở root directory.

#### ✅ **DO's**
- Đặt tất cả reports trong `reports/` directory
- Sử dụng naming convention: `[COMPONENT]_[TYPE]_REPORT.md`
- Cập nhật `reports/README.md` khi thêm reports mới
- Sử dụng emoji và markdown formatting cho dễ đọc

#### ❌ **DON'Ts**
- **NEVER** đặt reports ở root directory
- **NEVER** đặt reports trong các thư mục khác
- **NEVER** sử dụng tên file không rõ ràng
- **NEVER** quên cập nhật README khi thêm reports mới

#### **Examples**
```
✅ CORRECT:
reports/
├── AUTH_CONTROLLER_TEST_REPORT.md
├── RULES_COMPLIANCE_FINAL_REPORT.md
├── AUTH_CONTROLLER_FIXES_SUMMARY.md
└── README.md

❌ WRONG:
AUTH_CONTROLLER_TEST_REPORT.md  # In root directory
docs/AUTH_CONTROLLER_TEST_REPORT.md  # In wrong directory
```

### 2. **Feature-Based Structure** 🏗️
```
✅ CORRECT:
lib/features/[feature_name]/
├── data/
├── domain/
└── presentation/

❌ WRONG:
lib/controllers/
lib/models/
lib/views/
```

### 3. **Test Organization** 🧪
```
✅ CORRECT:
test/
├── unit/
│   └── controllers/
├── integration/
├── fixtures/
└── [feature_name]_test.dart

❌ WRONG:
test/
├── auth_test.dart
├── user_test.dart
└── company_test.dart
```

### 4. **Documentation Structure** 📚
```
✅ CORRECT:
docs/
├── v1/
│   ├── DEVELOPMENT_BLUEPRINT_V1.md
│   └── phases/
├── TECHNICAL_SPECIFICATIONS.md
└── README.md

reports/
├── [COMPONENT]_[TYPE]_REPORT.md
└── README.md

rules/
├── DEVELOPMENT_RULES.md
├── ARCHITECTURE_RULES.md
└── [RULE_TYPE]_RULES.md
```

## 🔄 Maintenance Rules

### **When Creating New Reports**
1. ✅ Đặt file trong thư mục `reports/`
2. ✅ Cập nhật danh sách trong `reports/README.md`
3. ✅ Sử dụng consistent naming convention
4. ✅ Include proper documentation và status

### **When Creating New Features**
1. ✅ Follow Clean Architecture: `data/domain/presentation`
2. ✅ Đặt trong `lib/features/[feature_name]/`
3. ✅ Tạo tests tương ứng trong `test/`
4. ✅ Cập nhật documentation nếu cần

### **When Creating New Rules**
1. ✅ Đặt trong thư mục `rules/`
2. ✅ Sử dụng naming: `[RULE_TYPE]_RULES.md`
3. ✅ Cập nhật `rules/README.md`
4. ✅ Link từ `DEVELOPMENT_RULES.md`

## 📊 Current Structure

### **Reports Directory** (as of 2024-10-14)
```
reports/
├── AUTH_CONTROLLER_TEST_REPORT.md
├── AUTH_CONTROLLER_FIXES_SUMMARY.md
├── RULES_COMPLIANCE_FINAL_REPORT.md
├── RULES_COMPLIANCE_REPORT.md
└── README.md
```

### **Rules Directory**
```
rules/
├── DEVELOPMENT_RULES.md
├── ARCHITECTURE_RULES.md
├── CODING_STANDARDS.md
├── TESTING_RULES.md
├── FILE_ORGANIZATION_RULES.md (this file)
└── [other rule files...]
```

## 🎯 Enforcement

### **Pre-Development Checklist**
Trước khi tạo bất kỳ file nào, **BẮT BUỘC** phải:
1. ✅ Kiểm tra quy tắc tổ chức file
2. ✅ Đặt file đúng thư mục
3. ✅ Sử dụng naming convention đúng
4. ✅ Cập nhật documentation liên quan

### **Code Review Checklist**
Khi review code, **BẮT BUỘC** phải kiểm tra:
1. ✅ File được đặt đúng thư mục
2. ✅ Naming convention đúng
3. ✅ Documentation được cập nhật
4. ✅ Không có file orphaned

---

**📝 Note**: Quy tắc này được tạo ra để đảm bảo tính nhất quán và dễ dàng maintain codebase. Tất cả team members phải tuân thủ nghiêm ngặt.

**Last Updated**: 2024-10-14
**Maintained by**: Development Team