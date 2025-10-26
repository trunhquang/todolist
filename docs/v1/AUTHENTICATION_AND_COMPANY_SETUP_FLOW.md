# 🔐 Authentication & Company Setup Flow Documentation

## 📋 TỔNG KẾT QUY TRÌNH AUTHENTICATION & COMPANY SETUP

### 🔐 **1. QUY TRÌNH ĐĂNG KÝ (SIGN UP)**

#### **1.1. Đăng ký Email/Password**
```dart
// Tự đăng ký → Role: Admin
user = app_user.User(
  role: UserRoles.admin,  // Tự đăng ký luôn là Admin
  workspaceId: '',          // Chưa có công ty
  mustChangePassword: false
);
```

#### **1.2. Đăng ký Google/Apple**
```dart
// Đăng nhập lần đầu → Role: Regular User
user = app_user.User(
  role: UserRoles.regularUser,  // Mặc định là Regular User
  workspaceId: '',                // Chưa có công ty
  mustChangePassword: false
);
```

### 🔑 **2. QUY TRÌNH ĐĂNG NHẬP (SIGN IN)**

#### **2.1. Luồng xử lý chung**
1. **Firebase Auth** → Xác thực thành công
2. **Load User Data** từ Firebase Database
3. **Load Company Data** nếu có `workspaceId`
4. **Lưu vào Local Storage**
5. **Navigation** dựa trên trạng thái

#### **2.2. Post-Login Navigation Logic**
```dart
Future<void> handlePostLoginNavigation() async {
  // 1. Kiểm tra Firebase session
  if (firebaseUser == null) → Login Page
  
  // 2. Kiểm tra password change
  if (user.mustChangePassword) → Change Password Page
  
  // 3. Kiểm tra company setup
  if (isUserAdmin && hasNoCompany) → Company Setup Page
  else → Dashboard
}
```

### 🏢 **3. QUY TRÌNH TẠO CÔNG TY (COMPANY SETUP)**

#### **3.1. Điều kiện bắt buộc**
- **Chỉ Admin** mới được tạo công ty
- **User phải chưa có `workspaceId`**

#### **3.2. Quy trình tạo công ty**
```dart
Future<void> createCompany({
  required String name,
  String? description,
  String? departmentName,
}) async {
  // 1. Tạo Company entity
  final company = Company(
    name: name,
    description: description,
    createdBy: currentUser.id,
    createdAt: DateTime.now(),
  );
  
  // 2. Lưu vào Firebase Database
  final workspaceId = await _databaseService.createCompany(company);
  
  // 3. Tạo Department mặc định (nếu có)
  if (departmentName != null) {
    departmentId = await _databaseService.createDepartment(...);
  }
  
  // 4. Cập nhật User
  final updatedUser = currentUser.copyWith(
    workspaceId: workspaceId,
    departmentId: departmentId,
    role: 'company_admin',  // Người tạo trở thành Company Admin
  );
  
  // 5. Lưu vào Local Storage
  await StorageService().setworkspaceId(workspaceId);
}
```

### 👥 **4. HỆ THỐNG ROLE & PERMISSIONS**

#### **4.1. Role Hierarchy**
```
Admin (Level 4)           → Full system access
Department Manager (Level 3) → Department management
Team Lead (Level 2)       → Team management  
Regular User (Level 1)    → Personal tasks only
```

#### **4.2. Role Assignment Rules**
- **Self-registration (Email/Password)**: `Admin`
- **Social login (Google/Apple)**: `Regular User`
- **Company creator**: `Company Admin`
- **Invited users**: Role được assign bởi Admin

### 🔄 **5. QUY TRÌNH MỜI NGƯỜI DÙNG (USER INVITATION)**

#### **5.1. Invitation Flow**
```dart
// User được mời sẽ có:
user = app_user.User(
  invitedByUserId: 'admin_user_id',
  mustChangePassword: true,  // Bắt buộc đổi password
  role: 'assigned_role',     // Role được assign
  workspaceId: 'company_id',   // Đã có company
);
```

#### **5.2. First Login cho Invited User**
1. **Force Password Change** → Change Password Page
2. **Sau khi đổi password** → Dashboard

### 📋 **6. RULES & CONSTRAINTS**

#### **6.1. Company Setup Rules**
- ✅ **Bắt buộc**: Admin phải tạo công ty sau khi đăng ký
- ✅ **Optional**: Tạo department mặc định
- ✅ **Skip option**: Có thể bỏ qua (nhưng không khuyến khích)

#### **6.2. Navigation Rules**
- ✅ **Admin + No Company** → Company Setup
- ✅ **Regular User + No Company** → Dashboard (có thể join company sau)
- ✅ **Any User + Has Company** → Dashboard
- ✅ **Invited User + Must Change Password** → Change Password

#### **6.3. Data Persistence**
- ✅ **Firebase Database**: User, Company, Department data
- ✅ **Local Storage**: Current user, company, token
- ✅ **Auto-sync**: Auth state changes được listen real-time

### 🎯 **7. BUSINESS LOGIC SUMMARY**

1. **Self-registration** → Admin role → **Bắt buộc tạo công ty**
2. **Social login** → Regular User → **Có thể join công ty sau**
3. **Company creation** → Creator becomes Company Admin
4. **User invitation** → Assigned role → **Force password change**
5. **Navigation logic** → Dựa trên role + company status

---

## ⚠️ **8. CURRENT ISSUES & ANALYSIS**

### **8.1. Vấn đề chính**

**Vấn đề hiện tại**: Chỉ Admin mới bị bắt buộc tạo công ty, Regular User có thể vào Dashboard mà không có công ty.

**Code hiện tại**:
```dart
// lib/features/auth/presentation/controllers/auth_controller.dart:181-186
if (isUserAdmin && hasNoCompany) {
  await NavigationService().offAllNamed<void>(AppRouter.companySetup);
} else {
  await NavigationService().offAllNamed<void>(AppRouter.dashboard);
}
```

### **8.2. Phân tích tác động**

#### **Tác động tích cực của logic hiện tại:**
- ✅ **Flexibility**: Regular User có thể sử dụng app mà không cần tạo công ty
- ✅ **User Experience**: Không bắt buộc tất cả user phải tạo công ty
- ✅ **Social Login Friendly**: Google/Apple users có thể dùng app ngay

#### **Tác động tiêu cực:**
- ❌ **Data Isolation**: User không có công ty sẽ không có dữ liệu được tổ chức
- ❌ **Feature Limitation**: Nhiều tính năng cần company context sẽ không hoạt động
- ❌ **Team Collaboration**: Không thể assign tasks, tạo projects, etc.
- ❌ **Reporting**: Không có company-level reports và analytics

### **8.3. Giải pháp đề xuất**

#### **Option 1: Bắt buộc tất cả user tạo công ty**
```dart
// Thay đổi logic navigation
if (hasNoCompany) {
  await NavigationService().offAllNamed<void>(AppRouter.companySetup);
  return;
}
await NavigationService().offAllNamed<void>(AppRouter.dashboard);
```

**Ưu điểm:**
- ✅ Đảm bảo tất cả user đều có company context
- ✅ Tất cả features hoạt động đầy đủ
- ✅ Data được tổ chức tốt hơn

**Nhược điểm:**
- ❌ Tăng friction cho user experience
- ❌ Social login users phải tạo company ngay

#### **Option 2: Hybrid approach - Company Setup với Skip option**
```dart
// Giữ logic hiện tại nhưng cải thiện Company Setup page
if (isUserAdmin && hasNoCompany) {
  await NavigationService().offAllNamed<void>(AppRouter.companySetup);
} else if (hasNoCompany) {
  // Show onboarding với option tạo company hoặc skip
  await NavigationService().offAllNamed<void>(AppRouter.onboarding);
} else {
  await NavigationService().offAllNamed<void>(AppRouter.dashboard);
}
```

**Ưu điểm:**
- ✅ Balance giữa UX và functionality
- ✅ User có choice
- ✅ Có thể educate user về benefits của company

**Nhược điểm:**
- ❌ Phức tạp hơn về logic
- ❌ Cần thêm onboarding flow

#### **Option 3: Default Company cho Regular Users**
```dart
// Tự động tạo "Personal Workspace" cho Regular Users
if (hasNoCompany && !isUserAdmin) {
  await _createDefaultPersonalWorkspace();
}
```

**Ưu điểm:**
- ✅ User không cần manual setup
- ✅ Tất cả features hoạt động
- ✅ Có thể upgrade to real company sau

**Nhược điểm:**
- ❌ Tạo nhiều "fake" companies
- ❌ Data model phức tạp hơn

---

## 📊 **9. RECOMMENDATION**

### **Khuyến nghị: Option 2 - Hybrid Approach**

**Lý do:**
1. **User Experience**: Không bắt buộc tất cả user tạo company ngay
2. **Business Value**: Vẫn encourage user tạo company để unlock full features
3. **Flexibility**: Admin vẫn bắt buộc tạo company (business requirement)
4. **Scalability**: Có thể evolve thành full company setup sau

### **Implementation Plan:**

1. **Phase 1**: Giữ logic hiện tại
2. **Phase 2**: Tạo Onboarding flow cho Regular Users
3. **Phase 3**: Add company benefits education
4. **Phase 4**: Optional: Auto-create personal workspace

---

## 🔍 **10. TESTING SCENARIOS**

### **Test Cases cần verify:**

1. **Admin Registration Flow**
   - ✅ Admin đăng ký → Company Setup bắt buộc
   - ✅ Admin tạo company → Role becomes Company Admin
   - ✅ Admin skip company setup → Vẫn vào Dashboard

2. **Regular User Flow**
   - ✅ Google/Apple login → Dashboard (no company)
   - ✅ Regular User có thể tạo company sau
   - ✅ Regular User join existing company

3. **Invited User Flow**
   - ✅ Invited user → Force password change
   - ✅ After password change → Dashboard
   - ✅ Invited user có company context

4. **Edge Cases**
   - ✅ User có workspaceId nhưng company không tồn tại
   - ✅ Network issues during company creation
   - ✅ Multiple devices login

---

## 📝 **11. NEXT STEPS**

1. **Immediate**: Document current behavior và decision rationale
2. **Short-term**: Implement onboarding flow cho Regular Users
3. **Medium-term**: Add company benefits education
4. **Long-term**: Consider auto-personal workspace creation

---

*Document created: $(date)*
*Last updated: $(date)*
*Status: Under Review*
