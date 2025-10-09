## Sơ đồ ứng dụng (Navigation & Screens)

Sơ đồ được sinh từ cấu hình routes hiện tại trong `lib/app/routes/app_router.dart`.

```mermaid
flowchart TD
  Splash["Splash"] --> |không đăng nhập| Login["Login"]
  Splash --> |đã đăng nhập & cần đổi mật khẩu| ChangePassword["Change Password"]
  Splash --> |đã đăng nhập & chưa setup công ty| CompanySetup["Company Setup"]
  Splash --> |đã đăng nhập & hợp lệ| Dashboard["Dashboard"]

  %% Auth
  subgraph Auth
    Login
    Register["Register (chỉ hiển thị ở chế độ dev)"]
    ChangePassword
  end
  Login --> |dev only| Register
  Login --> CompanySetup
  ChangePassword --> Dashboard

  %% Onboarding
  subgraph Onboarding
    CompanySetup
  end
  CompanySetup --> Dashboard

  %% Khu vực chính (Dashboard và các module)
  subgraph Main
    Dashboard
    Projects["Projects List"]
    ProjectEdit["Project Edit"]
    Tasks["Tasks List"]
    TaskEdit["Task Edit"]
    ReportsCreate["Report Create"]
    ReportsHistory["Report History"]
    ReportsAnalytics["Report Analytics"]
    BackupRestore["Backup & Restore"]
    NotiSettings["Notification Settings"]
  end

  %% Điều hướng từ Dashboard
  Dashboard --> Projects
  Dashboard --> Tasks
  Dashboard --> ReportsCreate
  Dashboard --> ReportsHistory
  Dashboard --> ReportsAnalytics
  Dashboard --> BackupRestore
  Dashboard --> NotiSettings

  %% Điều hướng chi tiết
  Projects --> ProjectEdit
  Tasks --> TaskEdit

  %% Liên kết ngoài (không phải route)
  ReportsAnalytics -. mở ngoài app .-> PowerBI[("Power BI Dashboard (external)")]
```

Ghi chú:
- Màn `Register` chỉ khả dụng khi không phải bản release (`!kReleaseMode`).
- `Report Analytics` có nút mở dashboard Power BI bằng `url_launcher` ở ngoài ứng dụng.
- `Backup & Restore` dùng OneDrive để export/restore dữ liệu.


