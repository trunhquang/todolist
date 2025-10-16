# 📋 Phase 1 Completion Checklist - Multi-Workspace Authentication & User Management

## 🎯 Scope nguồn: docs/v1/phases/PHASE_1_MULTI_WORKSPACE_AUTH.md

Các checklist dưới đây được trích đúng theo Sprint 1 và Sprint 2 trong tài liệu trên (không phóng đại trạng thái, không gộp nhiệm vụ của Sprint 3/4).

---

## ✅ Sprint 1: Multi-Workspace User Registration & Personal Workspace

### Tasks
- [ ] Tạo UI đăng ký (email/password) với validate
- [ ] Tích hợp Firebase Auth cho đăng ký
- [ ] Tạo PersonalWorkspace entity và repository
- [ ] Tự động tạo personal workspace khi đăng ký
- [ ] Tạo UI workspace selector
- [ ] Lưu workspace context vào user preferences
- [ ] Unit tests cho flow đăng ký
- [ ] Unit tests cho tạo personal workspace

### Acceptance Criteria
- [ ] Đăng ký bằng email/password hợp lệ
- [ ] Personal workspace auto-created, user là owner
- [ ] Workspace xuất hiện trong workspace selector
- [ ] Lưu current workspace ID vào user preferences
- [ ] Toàn bộ test pass, coverage ≥ 80%

---

## ✅ Sprint 2: Company Workspace Creation & Management

### Tasks
- [ ] Tạo UI tạo company workspace
- [ ] Implement CompanyWorkspace entity và repository
- [ ] Thêm quản lý workspace settings
- [ ] Implement workspace switching
- [ ] Tạo UI quản lý workspace cho Account Holder
- [ ] Thêm validate và error handling cho workspace
- [ ] Unit tests cho tạo company workspace
- [ ] Unit tests cho workspace switching

### Acceptance Criteria
- [ ] Tạo company workspace với name và description
- [ ] Account Holder chỉnh sửa workspace settings
- [ ] Switch giữa personal và company workspaces
- [ ] Cô lập dữ liệu theo workspace
- [ ] Toàn bộ test pass, coverage ≥ 80%

---

## 🔎 Ghi chú kiểm chứng (không thay thế checklist)
- Đối chiếu trạng thái thực tế phải dựa bằng chứng trong code (lib/) và test/ (kết quả chạy test), không dựa báo cáo cũ.
- Nếu có xung đột với tài liệu khác, ưu tiên `docs/PHASE_1_STATUS_CORRECTION.md` (điều chỉnh trạng thái Phase 1).

---

## 📝 Verification trước khi đánh dấu Hoàn tất Sprint 1/2
- [ ] Code implement đầy đủ các mục trong phần Tasks tương ứng
- [ ] Đáp ứng đủ Acceptance Criteria tương ứng
- [ ] Test liên quan pass và coverage ≥ 80%
- [ ] Không phát sinh lint/blocking build errors
- [ ] Tài liệu cập nhật theo thay đổi cuối cùng
