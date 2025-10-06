# 🚀 Development Workflow

## Pre-Development Checklist
Trước khi bắt đầu develop bất kỳ feature nào, **BẮT BUỘC** phải thực hiện các bước sau:

### 1. 📜 Check Rules Directory
```
✅ BẮT BUỘC: Đọc và hiểu các quy tắc trong thư mục rules/
├── rules/README.md              # 📋 Tổng quan về rules
└── rules/DEVELOPMENT_RULES.md   # 📋 Quy tắc phát triển (file này)
```

**Mục đích:**
- Đảm bảo tuân thủ cấu trúc dự án
- Hiểu rõ coding standards và best practices
- Tránh vi phạm các quy tắc đã định

### 2. 📖 Check Documentation Directory
```
✅ BẮT BUỘC: Đọc tài liệu liên quan trong thư mục docs/
├── docs/README.md                    # 📋 Navigation tài liệu
├── docs/DEVELOPMENT_BLUEPRINT.md     # 🏗️ Kiến trúc dự án
├── docs/TECHNICAL_SPECIFICATIONS.md  # 📋 Yêu cầu kỹ thuật
├── docs/DESIGN_SYSTEM.md             # 🎨 Hệ thống thiết kế
└── [other relevant docs...]          # 📚 Tài liệu khác
```

**Mục đích:**
- Hiểu rõ yêu cầu kỹ thuật
- Nắm được kiến trúc và design patterns
- Đảm bảo phát triển đúng hướng

### 3. 📊 Check Process Directory (nếu cần)
```
📋 TÙY CHỌN: Kiểm tra tiến độ và process trong thư mục process/
├── process/README.md              # 📋 Tổng quan process
├── process/PROJECT_PROGRESS.md    # 📈 Tiến độ dự án
├── process/SPRINT_TRACKING.md     # 🏃 Sprint hiện tại
└── process/TECHNICAL_DEBT.md      # 🐛 Technical debt
```

**Mục đích:**
- Hiểu context của feature đang develop
- Tránh duplicate work
- Cập nhật tiến độ nếu cần

## Development Workflow Steps
```
1. 📜 Read Rules → 2. 📖 Read Docs → 3. 🏗️ Plan Architecture → 4. 💻 Code → 5. ✅ Test → 6. 📝 Update Docs
```

**Quy tắc:**
- **KHÔNG** được bỏ qua bước 1 và 2
- **BẮT BUỘC** đọc rules và docs trước khi code
- **CẬP NHẬT** docs nếu có thay đổi architecture

---

**📁 File liên quan:**
- [Architecture Rules](ARCHITECTURE_RULES.md)
- [File Organization Rules](FILE_ORGANIZATION_RULES.md)
- [Code Review Checklist](CODE_REVIEW_CHECKLIST.md)
