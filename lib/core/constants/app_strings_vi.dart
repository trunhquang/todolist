import 'app_strings.dart';

/// Centralized string management for the application (Vietnamese)
/// 
/// This file contains all hardcoded strings used throughout the app in Vietnamese.
/// All UI text, error messages, and labels should be defined here.
/// 
/// Usage:
/// ```dart
/// import 'package:todolist/core/constants/app_strings_vi.dart';
/// 
/// Text(AppStringsVi.welcomeMessage)
/// ```

class AppStringsVi  implements AppStrings{
  // Private constructor to prevent instantiation

  // ============================================================================
  // AUTHENTICATION STRINGS
  // ============================================================================
  
  /// Authentication related strings
  @override
  String get login => 'Đăng nhập';
  @override
  String get register => 'Đăng ký';
  @override
  String get logout => 'Đăng xuất';
  @override
  String get email => 'Email';
  @override
  String get password => 'Mật khẩu';
  @override
  String get confirmPassword => 'Xác nhận mật khẩu';
  @override
  String get confirmYourPassword => 'Xác nhận mật khẩu của bạn';
  @override
  String get pleaseConfirmPassword => 'Vui lòng xác nhận mật khẩu';
  @override
  String get forgotPassword => 'Quên mật khẩu?';
  @override
  String get resetPassword => 'Đặt lại mật khẩu';
  @override
  String get resetPasswordDescription => 'Nhập địa chỉ email của bạn và chúng tôi sẽ gửi liên kết để đặt lại mật khẩu';
  @override
  String get sendResetLink => 'Gửi liên kết đặt lại';
  @override
  String get backToLogin => 'Quay lại đăng nhập';
  @override
  String get checkYourEmail => 'Kiểm tra email của bạn';
  @override
  String get resetLinkSent => 'Liên kết đặt lại đã được gửi đến email của bạn';
  @override
  String get didntReceiveEmail => 'Không nhận được email?';
  @override
  String get resendEmail => 'Gửi lại email';
  @override
  String get enterEmailToReset => 'Nhập email để đặt lại mật khẩu';
  @override
  String get pleaseEnterEmailToReset => 'Vui lòng nhập địa chỉ email để nhận hướng dẫn đặt lại mật khẩu';
  @override
  String get rememberMe => 'Ghi nhớ tôi';
  @override
  String get signInWithGoogle => 'Đăng nhập bằng Google';
  @override
  String get signInWithApple => 'Đăng nhập bằng Apple';
  @override
  String get createAccount => 'Tạo tài khoản';
  @override
  String get createAccountDescription => 'Tạo tài khoản của bạn để bắt đầu';
  @override
  String get fullName => 'Họ và tên';
  @override
  String get enterFullName => 'Nhập họ và tên';
  @override
  String get pleaseEnterFullName => 'Vui lòng nhập họ và tên';
  @override
  String get nameMinLength => 'Tên phải có ít nhất 2 ký tự';
  @override
  String get alreadyHaveAccount => 'Đã có tài khoản?';
  @override
  String get dontHaveAccount => "Chưa có tài khoản?";
  @override
  String get welcomeBack => 'Chào mừng trở lại';
  @override
  String get welcomeMessage => 'Chào mừng đến với Cao Thắng TodoList';
  @override
  String get getStarted => 'Bắt đầu';
  @override
  String get retry => 'Thử lại';
  @override
  String get checkConnection => 'Kiểm tra kết nối';
  @override
  String get requestPermission => 'Yêu cầu quyền';
  @override
  String get fixIssues => 'Sửa lỗi';
  
  // Authentication Error Messages
  @override
  String get invalidEmail => 'Vui lòng nhập địa chỉ email hợp lệ';
  @override
  String get emailNotVerified => 'Vui lòng xác minh email của bạn trước khi đặt lại mật khẩu';
  @override
  String get passwordTooShort => 'Mật khẩu phải có ít nhất 6 ký tự';
  @override
  String get passwordsDoNotMatch => 'Mật khẩu không khớp';
  @override
  String get emailRequired => 'Email là bắt buộc';
  @override
  String get passwordRequired => 'Mật khẩu là bắt buộc';
  @override
  String get loginFailed => 'Đăng nhập thất bại. Vui lòng thử lại.';
  @override
  String get registrationFailed => 'Đăng ký thất bại. Vui lòng thử lại.';
  @override
  String get userNotFound => 'Không tìm thấy tài khoản';
  @override
  String get wrongPassword => 'Mật khẩu sai';
  @override
  String get emailAlreadyInUse => 'Email đã được sử dụng';
  @override
  String get weakPassword => 'Mật khẩu quá yếu';
  @override
  String get invalidCredentials => 'Thông tin đăng nhập không hợp lệ';
  @override
  String get accountDisabled => 'Tài khoản này đã bị vô hiệu hóa';
  @override
  String get tooManyRequests => 'Quá nhiều yêu cầu. Vui lòng thử lại sau.';
  @override
  String get networkError => 'Lỗi mạng. Vui lòng kiểm tra kết nối của bạn.';

  // Authentication Error Messages (VI) - giữ nguyên vì đã là VI
  @override
  String get viAuthInvalidEmail => 'Email không hợp lệ';
  @override
  String get viAuthUserDisabled => 'Tài khoản đã bị vô hiệu hóa';
  @override
  String get viAuthUserNotFound => 'Không tìm thấy tài khoản với email này';
  @override
  String get viAuthWrongPassword => 'Mật khẩu không chính xác';
  @override
  String get viAuthEmailAlreadyInUse => 'Email đã được sử dụng cho tài khoản khác';
  @override
  String get viAuthWeakPassword => 'Mật khẩu quá yếu. Vui lòng chọn mật khẩu mạnh hơn';
  @override
  String get viAuthOperationNotAllowed => 'Phương thức đăng nhập này đang bị vô hiệu hóa';
  @override
  String get viAuthAccountExistsWithDifferentCredential => 'Email đã tồn tại với phương thức đăng nhập khác';
  @override
  String get viAuthInvalidCredential => 'Thông tin đăng nhập không hợp lệ';
  @override
  String get viAuthNetworkRequestFailed => 'Không thể kết nối mạng. Vui lòng kiểm tra lại internet';
  @override
  String get viAuthTooManyRequests => 'Thao tác bị chặn do thử quá nhiều lần. Vui lòng thử lại sau';
  @override
  String get viAuthSigninCanceled => 'Quá trình đăng nhập đã bị hủy';
  @override
  String get viAuthLoginFailed => 'Đăng nhập thất bại';
  @override
  String get viAuthSignupFailed => 'Tạo tài khoản thất bại';
  @override
  String get viAuthGoogleSigninFailed => 'Đăng nhập Google thất bại';
  @override
  String get viAuthAppleSigninFailed => 'Đăng nhập Apple thất bại';
  @override
  String get viAuthLogoutFailed => 'Đăng xuất thất bại';

  // Authentication Success Messages (VI)
  @override
  String get viAuthLoginSuccess => 'Đăng nhập thành công';
  @override
  String get viAuthSignupSuccess => 'Tạo tài khoản thành công';
  @override
  String get viAuthGoogleSigninSuccess => 'Đăng nhập Google thành công';
  @override
  String get viAuthAppleSigninSuccess => 'Đăng nhập Apple thành công';
  @override
  String get viAuthLogoutSuccess => 'Đăng xuất thành công';
  @override
  String get viAuthPasswordResetEmailSent => 'Đã gửi email đặt lại mật khẩu';
  @override
  String get viAuthPasswordResetEmailSentTitle => 'Email đã được gửi';
  @override
  String get viAuthPasswordResetEmailSentMessage => 'Vui lòng kiểm tra email của bạn và làm theo hướng dẫn để đặt lại mật khẩu';
  @override
  String get viAuthPasswordResetFailed => 'Không thể gửi email đặt lại mật khẩu';
  @override
  String get viAuthPasswordResetFailedTitle => 'Gửi email thất bại';
  @override
  String get viAuthPasswordResetFailedMessage => 'Đã xảy ra lỗi khi gửi email. Vui lòng thử lại sau';
  @override
  String get viAuthInvalidEmailForReset => 'Email không hợp lệ';
  @override
  String get viAuthTooManyPasswordResetRequests => 'Bạn đã yêu cầu đặt lại mật khẩu quá nhiều lần. Vui lòng thử lại sau';

  // ============================================================================
  // NAVIGATION STRINGS
  // ============================================================================
  
  /// Navigation related strings
  @override
  String get home => 'Trang chủ';
  @override
  String get tasks => 'Nhiệm vụ';
  @override
  String get profile => 'Hồ sơ';
  @override
  String get settings => 'Cài đặt';
  @override
  String get projects => 'Dự án';
  @override
  String get dashboard => 'Bảng điều khiển';
  @override
  String get reports => 'Báo cáo';
  @override
  String get calendar => 'Lịch';
  @override
  String get notifications => 'Thông báo';
  @override
  String get back => 'Quay lại';
  @override
  String get next => 'Tiếp theo';
  @override
  String get previous => 'Trước đó';
  @override
  String get done => 'Hoàn thành';
  @override
  String get cancel => 'Hủy';
  @override
  String get save => 'Lưu';
  @override
  String get edit => 'Chỉnh sửa';
  @override
  String get delete => 'Xóa';
  @override
  String get add => 'Thêm';
  @override
  String get create => 'Tạo';
  @override
  String get update => 'Cập nhật';
  @override
  String get search => 'Tìm kiếm';
  @override
  String get filter => 'Lọc';
  @override
  String get sort => 'Sắp xếp';
  @override
  String get refresh => 'Làm mới';
  @override
  String get loading => 'Đang tải...';
  @override
  String get searchProjects => 'Tìm kiếm dự án';
  @override
  String get anyStatus => 'Bất kỳ trạng thái nào';
  // duplicate removed

  // Backup/Export
  @override
  String get backup => 'Sao lưu';
  @override
  String get backupToOneDrive => 'Sao lưu lên OneDrive';
  @override
  String get backupComplete => 'Sao lưu hoàn thành';
  @override
  String get backupFailed => 'Sao lưu thất bại';
  @override
  String get exportingDataToOneDrive => 'Đang xuất dữ liệu lên OneDrive...';
  @override
  String get dataExportedToOneDriveSuccessfully => 'Dữ liệu đã được xuất lên OneDrive thành công';
  @override
  String get restore => 'Khôi phục';
  @override
  String get restoreComplete => 'Khôi phục hoàn thành';
  @override
  String get restoreFailed => 'Khôi phục thất bại';
  @override
  String get backupAndRestore => 'Sao lưu & Khôi phục';
  @override
  String get backupAndRestoreSubtitle => 'Xuất và khôi phục bản sao lưu';
  @override
  String get sizeLabel => 'Kích thước';
  @override
  String get manageProjects => 'Quản lý dự án';
  @override
  String get manageTasks => 'Quản lý nhiệm vụ';
  @override
  String get export => 'Xuất';
  @override
  String get exportReports => 'Xuất báo cáo';
  @override
  String get exportingReports => 'Đang xuất báo cáo lên OneDrive...';
  @override
  String get exportComplete => 'Xuất hoàn thành';
  @override
  String get exportFailed => 'Xuất thất bại';
  @override
  String get reportsExported => 'Báo cáo đã được xuất lên OneDrive thành công';
  @override
  String get powerBi => 'Power BI';
  @override
  String get openPowerBiDashboard => 'Mở bảng điều khiển Power BI';
  @override
  String get dataRestoredPreview => 'Dữ liệu đã được khôi phục thành công';
  @override
  String get taskStatistics => 'Thống kê nhiệm vụ';
  @override
  String get overview => 'Tổng quan';
  @override
  String get totalTasks => 'Tổng số nhiệm vụ';
  @override
  String get byStatus => 'Theo trạng thái';
  @override
  String get statusDistribution => 'Phân bố trạng thái nhiệm vụ';
  @override
  String get completionTrend => 'Xu hướng hoàn thành';
  @override
  String get tasksCompletedOverTime => 'Nhiệm vụ hoàn thành theo thời gian';
  @override
  String get taskStatisticsSubtitle => 'Thống kê & hiểu biết về nhiệm vụ';

  // ============================================================================
  // TASK MANAGEMENT STRINGS
  // ============================================================================
  
  /// Task related strings
  @override
  String get task => 'Nhiệm vụ';
  @override
  String get newTask => 'Nhiệm vụ mới';
  @override
  String get addTask => 'Thêm nhiệm vụ';
  @override
  String get editTask => 'Chỉnh sửa nhiệm vụ';
  @override
  String get deleteTask => 'Xóa nhiệm vụ';
  @override
  String get taskTitle => 'Tiêu đề nhiệm vụ';
  @override
  String get taskDescription => 'Mô tả nhiệm vụ';
  @override
  String get taskPriority => 'Ưu tiên';
  @override
  String get taskStatus => 'Trạng thái';
  @override
  String get taskDueDate => 'Ngày đến hạn';
  @override
  String get taskCategory => 'Danh mục';
  @override
  String get taskTags => 'Thẻ';
  @override
  String get taskAssignee => 'Người được giao';
  @override
  String get taskCreated => 'Đã tạo';
  @override
  String get taskUpdated => 'Đã cập nhật';
  @override
  String get taskCompleted => 'Đã hoàn thành';
  
  // Task Status
  @override
  String get statusPending => 'Đang chờ';
  @override
  String get statusInProgress => 'Đang thực hiện';
  @override
  String get statusCompleted => 'Đã hoàn thành';
  @override
  String get statusCancelled => 'Đã hủy';
  @override
  String get statusOnHold => 'Tạm dừng';
  
  // Task Priority
  @override
  String get priorityLow => 'Thấp';
  @override
  String get priorityMedium => 'Trung bình';
  @override
  String get priorityHigh => 'Cao';
  @override
  String get priorityUrgent => 'Khẩn cấp';
  
  // Task Categories
  @override
  String get categoryWork => 'Công việc';
  @override
  String get categoryPersonal => 'Cá nhân';
  @override
  String get categoryShopping => 'Mua sắm';
  @override
  String get categoryHealth => 'Sức khỏe';
  @override
  String get categoryFinance => 'Tài chính';
  @override
  String get categoryEducation => 'Giáo dục';
  @override
  String get categoryTravel => 'Du lịch';
  @override
  String get categoryOther => 'Khác';

  // Task Type Display Text
  @override
  String get taskTypeDaily => 'Hàng ngày';
  @override
  String get taskTypeProject => 'Dự án';

  // Project Status Display Text
  @override
  String get projectStatusActive => 'Hoạt động';
  @override
  String get projectStatusPending => 'Đang chờ';
  @override
  String get projectStatusCompleted => 'Đã hoàn thành';
  @override
  String get projectStatusCancelled => 'Đã hủy';
  @override
  String get projectStatusOnHold => 'Tạm dừng';
  @override
  String get projectMembers => 'Thành viên';
  @override
  String get addMember => 'Thêm thành viên';

  // Task Frequency Display Text
  @override
  String get frequencyDaily => 'Hàng ngày';
  @override
  String get frequencyWeekly => 'Hàng tuần';
  @override
  String get frequencyMonthly => 'Hàng tháng';
  @override
  String get frequencyYearly => 'Hàng năm';

  // Error Messages for Missing Data
  @override
  String get noworkspaceIdFound => 'Không tìm thấy ID công ty';
  @override
  String get failedToLoadTasks => 'Không thể tải nhiệm vụ';
  @override
  String get failedToLoadProjects => 'Không thể tải dự án';
  @override
  String get noReportsFound => 'Không tìm thấy báo cáo';
  @override
  String get noReportsForDate => 'Không có báo cáo nào được gửi cho ngày này';
  @override
  String get createNewReport => 'Tạo báo cáo mới';

  // ============================================================================
  // COMPANY SETUP STRINGS
  // ============================================================================
  
  /// Company setup related strings
  @override
  String get companySetup => 'Thiết lập công ty';
  @override
  String get companySetupDescription => 'Tạo công ty và phòng ban đầu tiên của bạn để bắt đầu';
  @override
  String get companyName => 'Tên công ty';
  @override
  String get companyDescription => 'Mô tả công ty';
  @override
  String get companyAddress => 'Địa chỉ công ty';
  @override
  String get companyPhone => 'Số điện thoại công ty';
  @override
  String get companyEmail => 'Email công ty';
  @override
  String get companyWebsite => 'Website công ty';
  @override
  String get companyLogo => 'Logo công ty';
  @override
  String get setupCompany => 'Thiết lập công ty';
  @override
  String get completeSetup => 'Hoàn thành thiết lập';
  @override
  String get skipForNow => 'Bỏ qua lúc này';
  @override
  String get departmentName => 'Tên phòng ban';
  @override
  String get enterDepartmentName => 'Nhập tên phòng ban của bạn';
  @override
  String get companySetupComplete => 'Thiết lập công ty hoàn thành thành công';
  @override
  String get companySetupFailed => 'Thiết lập công ty thất bại. Vui lòng thử lại.';
  @override
  String get companyNameRequired => 'Tên công ty là bắt buộc';
  @override
  String get companyDescriptionRequired => 'Mô tả công ty là bắt buộc';
  @override
  String get pleaseEnterCompanyName => 'Vui lòng nhập tên công ty của bạn';
  
  // Workspace strings
  @override
  String get personalWorkspaceDefault => 'BU cá nhân';
  @override
  String get workspaceSuffix => 'BU';
  

  @override
  String get pleaseEnterDepartmentName => 'Vui lòng nhập tên phòng ban của bạn';
  @override
  String get companyNameMinLength => 'Tên công ty phải có ít nhất 2 ký tự';
  @override
  String get departmentNameMinLength => 'Tên phòng ban phải có ít nhất 2 ký tự';

  // ============================================================================
  // VALIDATION STRINGS
  // ============================================================================
  
  /// Form validation strings
  @override
  String get fieldRequired => 'Trường này là bắt buộc';
  @override
  String get invalidInput => 'Đầu vào không hợp lệ';
  @override
  String get invalidFormat => 'Định dạng không hợp lệ';
  @override
  String get mustBeNumber => 'Phải là số';
  @override
  String get mustBeEmail => 'Phải là địa chỉ email hợp lệ';
  @override
  String get mustBePhone => 'Phải là số điện thoại hợp lệ';
  @override
  String get mustBeUrl => 'Phải là URL hợp lệ';
  @override
  String get mustBeDate => 'Phải là ngày hợp lệ';
  @override
  String get mustBeTime => 'Phải là thời gian hợp lệ';
  @override
  String get mustBePositive => 'Phải là số dương';
  @override
  String get mustBeInteger => 'Phải là số nguyên';
  @override
  String get mustBeDecimal => 'Phải là số thập phân';

  // ============================================================================
  // SUCCESS MESSAGES
  // ============================================================================
  
  /// Success messages
  @override
  String get success => 'Thành công';
  @override
  String get info => 'Thông tin';
  @override
  String get operationSuccessful => 'Hoạt động hoàn thành thành công';
  @override
  String get dataSaved => 'Dữ liệu đã được lưu thành công';
  @override
  String get dataUpdated => 'Dữ liệu đã được cập nhật thành công';
  @override
  String get dataDeleted => 'Dữ liệu đã được xóa thành công';
  @override
  String get taskDeleted => 'Nhiệm vụ đã được xóa thành công';
  @override
  String get profileUpdated => 'Hồ sơ đã được cập nhật thành công';
  @override
  String get settingsSaved => 'Cài đặt đã được lưu thành công';
  @override
  String get passwordChanged => 'Mật khẩu đã được thay đổi thành công';
  @override
  String get emailSent => 'Email đã được gửi thành công';
  @override
  String get notificationSent => 'Thông báo đã được gửi thành công';

  // ============================================================================
  // ERROR MESSAGES
  // ============================================================================
  
  /// Error messages
  @override
  String get error => 'Lỗi';
  @override
  String get errorOccurred => 'Đã xảy ra lỗi';
  @override
  String get operationFailed => 'Hoạt động thất bại';
  @override
  String get dataNotSaved => 'Dữ liệu không thể được lưu';
  @override
  String get dataNotUpdated => 'Dữ liệu không thể được cập nhật';
  @override
  String get dataNotDeleted => 'Dữ liệu không thể được xóa';
  @override
  String get taskNotCreated => 'Nhiệm vụ không thể được tạo';
  @override
  String get taskNotUpdated => 'Nhiệm vụ không thể được cập nhật';
  @override
  String get taskNotDeleted => 'Nhiệm vụ không thể được xóa';
  @override
  String get profileNotUpdated => 'Hồ sơ không thể được cập nhật';
  @override
  String get settingsNotSaved => 'Cài đặt không thể được lưu';
  @override
  String get passwordNotChanged => 'Mật khẩu không thể được thay đổi';
  @override
  String get emailNotSent => 'Email không thể được gửi';
  @override
  String get notificationNotSent => 'Thông báo không thể được gửi';
  @override
  String get connectionError => 'Lỗi kết nối';
  @override
  String get serverError => 'Lỗi máy chủ';
  @override
  String get timeoutError => 'Yêu cầu hết thời gian';
  @override
  String get unknownError => 'Lỗi không xác định đã xảy ra';
  @override
  String get permissionDenied => 'Quyền bị từ chối';
  @override
  String get fileNotFound => 'Không tìm thấy tệp';
  @override
  String get invalidFile => 'Tệp không hợp lệ';
  @override
  String get fileTooLarge => 'Tệp quá lớn';
  @override
  String get unsupportedFormat => 'Định dạng không được hỗ trợ';

  // ============================================================================
  // PROFILE STRINGS
  // ============================================================================
  
  /// Profile related strings
  @override
  String get editProfile => 'Chỉnh sửa hồ sơ';
  @override
  String get appVersion => 'Phiên bản ứng dụng';
  @override
  String get userID => 'ID người dùng';
  @override
  String get created => 'Đã tạo';
  @override
  String get lastLogin => 'Đăng nhập lần cuối';
  @override
  String get status => 'Trạng thái';
  @override
  String get active => 'Hoạt động';
  @override
  String get inactive => 'Không hoạt động';
  @override
  String get editProfileFeatureComingSoon => 'Tính năng chỉnh sửa hồ sơ sắp ra mắt';
  @override
  String get appVersionNumber => '1.0.0';

  // ============================================================================
  // CONFIRMATION MESSAGES
  // ============================================================================
  
  /// Confirmation messages
  @override
  String get confirm => 'Xác nhận';
  @override
  String get confirmDelete => 'Bạn có chắc chắn muốn xóa mục này không?';
  @override
  String get confirmLogout => 'Bạn có chắc chắn muốn đăng xuất không?';
  @override
  String get confirmCancel => 'Bạn có chắc chắn muốn hủy không?';
  @override
  String get confirmSave => 'Bạn có chắc chắn muốn lưu không?';
  @override
  String get confirmUpdate => 'Bạn có chắc chắn muốn cập nhật không?';
  @override
  String get confirmReset => 'Bạn có chắc chắn muốn đặt lại không?';
  @override
  String get confirmClear => 'Bạn có chắc chắn muốn xóa không?';
  @override
  String get confirmRemove => 'Bạn có chắc chắn muốn xóa không?';
  @override
  String get confirmExit => 'Bạn có chắc chắn muốn thoát không?';
  @override
  String get unsavedChanges => 'Bạn có thay đổi chưa lưu. Bạn có chắc chắn muốn rời đi không?';
  @override
  String get dataWillBeLost => 'Tất cả dữ liệu sẽ bị mất. Bạn có chắc chắn không?';

  // ============================================================================
  // PLACEHOLDER STRINGS
  // ============================================================================
  
  /// Placeholder strings
  @override
  String get enterEmail => 'Nhập email của bạn';
  @override
  String get enterPassword => 'Nhập mật khẩu của bạn';
  @override
  String get enterTaskTitle => 'Nhập tiêu đề nhiệm vụ';
  @override
  String get enterTaskDescription => 'Nhập mô tả nhiệm vụ';
  @override
  String get enterCompanyName => 'Nhập tên công ty';
  @override
  String get enterCompanyDescription => 'Nhập mô tả công ty';
  @override
  String get enterSearchTerm => 'Nhập từ khóa tìm kiếm';
  @override
  String get selectDate => 'Chọn ngày';
  @override
  String get selectTime => 'Chọn thời gian';
  @override
  String get selectCategory => 'Chọn danh mục';
  @override
  String get selectPriority => 'Chọn ưu tiên';
  @override
  String get selectStatus => 'Chọn trạng thái';
  @override
  String get selectAssignee => 'Chọn người được giao';
  @override
  String get noTasksFound => 'Không tìm thấy nhiệm vụ nào';
  @override
  String get createFirstTask => 'Tạo nhiệm vụ đầu tiên của bạn';
  @override
  String get noDataAvailable => 'Không có dữ liệu nào';
  @override
  String get noResultsFound => 'Không tìm thấy kết quả nào';
  @override
  String get noInternetConnection => 'Không có kết nối internet';
  @override
  String get tryAgain => 'Thử lại';
  @override
  String get pullToRefresh => 'Kéo để làm mới';
  @override
  String get swipeToDelete => 'Vuốt để xóa';
  @override
  String get tapToEdit => 'Nhấn để chỉnh sửa';
  @override
  String get longPressForOptions => 'Nhấn giữ để xem tùy chọn';

  // ============================================================================
  // DATE AND TIME STRINGS
  // ============================================================================
  
  /// Date and time related strings
  @override
  String get today => 'Hôm nay';
  @override
  String get yesterday => 'Hôm qua';
  @override
  String get tomorrow => 'Ngày mai';
  @override
  String get thisWeek => 'Tuần này';
  @override
  String get lastWeek => 'Tuần trước';
  @override
  String get nextWeek => 'Tuần sau';
  @override
  String get thisMonth => 'Tháng này';
  @override
  String get lastMonth => 'Tháng trước';
  @override
  String get nextMonth => 'Tháng sau';
  @override
  String get thisYear => 'Năm nay';
  @override
  String get lastYear => 'Năm ngoái';
  @override
  String get nextYear => 'Năm sau';
  @override
  String get overdue => 'Quá hạn';
  @override
  String get dueToday => 'Đến hạn hôm nay';
  @override
  String get dueTomorrow => 'Đến hạn ngày mai';
  @override
  String get dueThisWeek => 'Đến hạn tuần này';
  @override
  String get dueNextWeek => 'Đến hạn tuần sau';
  @override
  String get dueThisMonth => 'Đến hạn tháng này';
  @override
  String get dueNextMonth => 'Đến hạn tháng sau';
  @override
  String get noDueDate => 'Không có ngày đến hạn';
  @override
  String get customDate => 'Ngày tùy chỉnh';
  @override
  String get allTime => 'Tất cả thời gian';
  // Date helpers (formatters)
  static String formatDaysAgo(int days) => '$days ngày trước';

  // ============================================================================
  // SETTINGS STRINGS
  // ============================================================================
  
  /// Settings related strings
  @override
  String get general => 'Tổng quát';
  @override
  String get appearance => 'Giao diện';
  @override
  String get privacy => 'Riêng tư';
  @override
  String get security => 'Bảo mật';
  @override
  String get account => 'Tài khoản';
  @override
  String get about => 'Giới thiệu';
  @override
  String get help => 'Trợ giúp';
  @override
  String get support => 'Hỗ trợ';
  @override
  String get feedback => 'Phản hồi';
  @override
  String get rateApp => 'Đánh giá ứng dụng';
  @override
  String get shareApp => 'Chia sẻ ứng dụng';
  @override
  String get version => 'Phiên bản';
  @override
  String get buildNumber => 'Số bản dựng';
  @override
  String get lastUpdated => 'Cập nhật lần cuối';
  @override
  String get termsOfService => 'Điều khoản dịch vụ';
  @override
  String get privacyPolicy => 'Chính sách bảo mật';
  @override
  String get license => 'Giấy phép';
  @override
  String get credits => 'Công trạng';
  @override
  String get acknowledgments => 'Lời cảm ơn';

  // ============================================================================
  // THEME STRINGS
  // ============================================================================
  
  /// Theme related strings
  @override
  String get lightTheme => 'Chủ đề sáng';
  @override
  String get darkTheme => 'Chủ đề tối';
  @override
  String get systemTheme => 'Chủ đề hệ thống';
  @override
  String get autoTheme => 'Chủ đề tự động';
  @override
  String get theme => 'Chủ đề';
  @override
  String get colorScheme => 'Bảng màu';
  @override
  String get primaryColor => 'Màu chính';
  @override
  String get accentColor => 'Màu nhấn';
  @override
  String get backgroundColor => 'Màu nền';
  @override
  String get textColor => 'Màu văn bản';
  @override
  String get fontSize => 'Kích thước phông chữ';
  @override
  String get fontFamily => 'Họ phông chữ';

  // ============================================================================
  // WORKSPACE STRINGS (Selector UI)
  // ============================================================================
  @override
  String get workspace => 'BU';
  @override
  String get currentWorkspace => 'BU hiện tại';
  @override
  String get selectWorkspace => 'Chọn BU';
  @override
  String get switchWorkspace => 'Chuyển đổi BU';
  @override
  String get noWorkspacesFound => 'Không tìm thấy BU nào';
  @override
  String get personal => 'Cá nhân';
  @override
  String get company => 'Công ty';
  @override
  String get createWorkspace => 'Tạo BU';
  @override
  String get createCompanyWorkspace => 'Tạo BU công ty';
  @override
  String get workspaceName => 'Tên BU';
  @override
  String get workspaceDescription => 'Mô tả BU';
  @override
  String get enterWorkspaceName => 'Nhập tên BU';
  @override
  String get enterWorkspaceDescription => 'Nhập mô tả BU (tùy chọn)';
  @override
  String get pleaseEnterWorkspaceName => 'Vui lòng nhập tên BU';
  @override
  String get workspaceNameMinLength => 'Tên BU phải có ít nhất 2 ký tự';
  @override
  String get workspaceNameAlreadyExists => 'Đã tồn tại BU với tên này. Vui lòng chọn tên khác.';
  @override
  String get workspaceCreatedSuccessfully => 'BU đã được tạo thành công';
  @override
  String get workspaceCreationFailed => 'Tạo BU thất bại';
  @override
  String get workspaceSettings => 'Cài đặt BU';
  @override
  String get manageWorkspace => 'Quản lý BU';
  @override
  String get workspaceMembers => 'Thành viên BU';
  @override
  String get workspaceType => 'Loại BU';
  @override
  String get personalWorkspace => 'BU cá nhân';
  @override
  String get companyWorkspace => 'BU công ty';
  @override
  String get workspaceCreatedAt => 'Được tạo lúc';
  @override
  String get workspaceUpdatedAt => 'Cập nhật lúc';
  @override
  String get workspaceOwner => 'Chủ sở hữu BU';
  @override
  String get editWorkspace => 'Chỉnh sửa BU';
  @override
  String get deleteWorkspace => 'Xóa BU';
  @override
  String get confirmDeleteWorkspace => 'Bạn có chắc chắn muốn xóa BU này không?';
  @override
  String get workspaceDeletedSuccessfully => 'BU đã được xóa thành công';
  @override
  String get workspaceDeletionFailed => 'Xóa BU thất bại';
  @override
  String get updateWorkspace => 'Cập nhật BU';
  @override
  String get workspaceUpdatedSuccessfully => 'BU đã được cập nhật thành công';
  @override
  String get workspaceUpdateFailed => 'Cập nhật BU thất bại';
  @override
  String get workspaceInformation => 'Thông tin BU';
  @override
  String get workspaceLogoUrl => 'URL logo';
  @override
  String get enterLogoUrl => 'Nhập URL logo (tùy chọn)';
  @override
  String get pleaseEnterValidUrl => 'Vui lòng nhập URL hợp lệ';
  @override
  String get dangerZone => 'Khu vực nguy hiểm';
  @override
  String get saveChanges => 'Lưu thay đổi';
  @override
  String get workspaceSettingsUpdated => 'Cài đặt BU đã được cập nhật';
  @override
  String get failedToUpdateSettings => 'Cập nhật cài đặt thất bại';
  @override
  String get deleteWorkspaceConfirmation => 'Bạn có thực sự muốn xóa BU này không?';
  @override
  String get workspaceDeleted => 'BU đã được xóa';
  @override
  String get failedToDeleteWorkspace => 'Xóa BU thất bại';
  @override
  String get createFirstWorkspaceMessage => 'Tạo BU đầu tiên của bạn để bắt đầu';
  @override
  String get createWorkspaceComingSoon => 'Tính năng tạo BU sắp ra mắt';
  @override
  String get personalWorkspaceDescription => 'Dành cho việc sử dụng cá nhân và nhiệm vụ cá nhân';
  @override
  String get companyWorkspaceDescription => 'Dành cho cộng tác nhóm và dự án công ty';

  // Workspace Management Navigation
  @override
  String get workspaceManagement => 'Quản lý BU';
  @override
  String get manageWorkspaceSettings => 'Quản lý cài đặt BU';
  @override
  String get manageWorkspaceMember => 'Quản lý thành viên BU';
  @override
  String get manageTeamMembers => 'Quản lý thành viên nhóm';
  @override
  String get manageUserPermissions => 'Quản lý quyền người dùng';
  @override
  String get workspaceAdminTools => 'Công cụ quản trị BU';
  @override
  String get teamManagement => 'Quản lý nhóm';
  @override
  String get onlyAccountHolderCanDelete => 'Chỉ chủ tài khoản mới có thể xóa BU';
  @override
  String get onlyAccountHolderAndAdminCanEdit => 'Chỉ chủ tài khoản và quản trị viên mới có thể chỉnh sửa BU';
  @override
  String get onlyAccountHolderAndAdminCanInvite => 'Chỉ chủ tài khoản và quản trị viên mới có thể mời người dùng';

  // User management / permissions
  @override
  String get userManagement => 'Quản lý người dùng';
  @override
  String get workspaceMemberInfoRequired => 'Tên và email là bắt buộc cho thành viên BU';
  @override
  String get workspaceMemberInfoMissingPrompt => 'Vui lòng nhập tên và email thành viên để tiếp tục';
  @override
  String get workspaceMemberNameRequired => 'Tên thành viên là bắt buộc';
  @override
  String get workspaceMemberEmailRequired => 'Email thành viên là bắt buộc';
  @override
  String get inviteUser => 'Mời người dùng';
  @override
  String get searchUsers => 'Tìm kiếm người dùng';
  @override
  String get noUsersFound => 'Không tìm thấy người dùng nào';
  @override
  String get inviteUsersToGetStarted => 'Mời người dùng để bắt đầu';
  @override
  String get emailAddress => 'Địa chỉ email';
  @override
  String get enterEmailAddress => 'Nhập địa chỉ email';
  @override
  String get pleaseEnterEmail => 'Vui lòng nhập email';
  @override
  String get pleaseEnterValidEmail => 'Vui lòng nhập email hợp lệ';
  @override
  String get sendInvitation => 'Gửi lời mời';
  @override
  String get invitationSent => 'Lời mời đã được gửi';
  @override
  String get failedToSendInvitation => 'Gửi lời mời thất bại';
  @override
  String get invitationEmailSubject => 'Bạn được mời tham gia BU';
  @override
  String get invitationEmailBody => 'Bạn đã được mời tham gia BU. Hãy theo liên kết để chấp nhận lời mời.';
  @override
  String get invitationNotificationTitle => 'Lời mời BU';
  @override
  String get invitationNotificationMessage => 'Bạn đã được mời tham gia BU. Nhấn để chấp nhận hoặc từ chối.';
  @override
  String get invitationAccepted => 'Lời mời đã được chấp nhận thành công';
  @override
  String get invitationDeclined => 'Lời mời đã bị từ chối';
  @override
  String get noNotifications => 'Không có thông báo';
  @override
  String get accept => 'Chấp nhận';
  @override
  String get decline => 'Từ chối';
  @override
  String get changePassword => 'Thay đổi mật khẩu';
  @override
  String get changePasswordRequired => 'Yêu cầu thay đổi mật khẩu';
  @override
  String get changePasswordDescription => 'Vì lý do bảo mật, bạn phải thay đổi mật khẩu trước khi tiếp tục.';
  @override
  String get newPassword => 'Mật khẩu mới';
  @override
  String get pleaseEnterNewPassword => 'Vui lòng nhập mật khẩu mới';
  @override
  String get userNotAuthenticated => 'Người dùng chưa được xác thực';
  @override
  String get passwordChangedSuccessfully => 'Mật khẩu đã được thay đổi thành công';
  @override
  String get editRole => 'Chỉnh sửa vai trò';
  @override
  String get removeUser => 'Xóa người dùng';
  @override
  String get removeUserConfirmation => 'Xóa người dùng';
  @override
  String get remove => 'Xóa';
  @override
  String get userRemoved => 'Người dùng đã được xóa';
  @override
  String get failedToRemoveUser => 'Xóa người dùng thất bại';
  @override
  String get selectRole => 'Chọn vai trò';
  @override
  String get roleLabel => 'Vai trò';
  @override
  String get userRoleUpdated => 'Vai trò người dùng đã được cập nhật';
  @override
  String get failedToUpdateRole => 'Cập nhật vai trò thất bại';
  // Invitation management (UI labels/status)
  @override
  String get revokeInvitation => 'Thu hồi lời mời';
  @override
  String get invitationRevoked => 'Đã thu hồi';
  @override
  String get invitationWaiting => 'Đang chờ';
  @override
  String get invitationAcceptedStatus => 'Đã chấp nhận';
  @override
  String get invitationDenied => 'Đã từ chối';
  @override
  String get invitedPrefix => 'Đã mời';

  // Permission management
  @override
  String get permissionManagement => 'Quản lý quyền';
  @override
  String get permissions => 'Quyền';
  @override
  String get permissionGranted => 'Quyền đã được cấp';
  @override
  String get permissionRevoked => 'Quyền đã bị thu hồi';
  @override
  String get failedToUpdatePermission => 'Cập nhật quyền thất bại';
  @override
  String get createTaskPermissionDescription => 'Cho phép tạo nhiệm vụ';
  @override
  String get editTaskPermissionDescription => 'Cho phép chỉnh sửa nhiệm vụ';
  @override
  String get deleteTaskPermissionDescription => 'Cho phép xóa nhiệm vụ';
  @override
  String get viewTasksPermissionDescription => 'Cho phép xem nhiệm vụ';
  @override
  String get manageUsersPermissionDescription => 'Cho phép quản lý người dùng';
  @override
  String get manageWorkspacePermissionDescription => 'Cho phép quản lý BU';
  @override
  String get viewAnalyticsPermissionDescription => 'Cho phép xem phân tích';
  @override
  String get managePermissionsPermissionDescription => 'Cho phép quản lý quyền';
  @override
  String get managePermissions => 'Quản lý quyền';
  @override
  String get viewTasks => 'Xem nhiệm vụ';
  @override
  String get manageUsers => 'Quản lý người dùng';
  @override
  String get createTask => 'Tạo nhiệm vụ';
  @override
  String get updateTask => 'Cập nhật nhiệm vụ';

  @override
  String get viewAnalytics => 'Xem phân tích';
  @override
  String get addUsersToManagePermissions => 'Thêm người dùng để quản lý quyền';
  @override
  String get cannotModifyAdminPermissions => 'Không thể sửa đổi quyền cho vai trò Chủ tài khoản và Quản trị viên';
  @override
  String get user => 'Người dùng';

  // Workspace Invitation Strings
  @override
  String get workspaceInvitation => 'Lời mời BU';
  @override
  String get youHaveBeenInvited => 'Bạn đã được mời tham gia';
  @override
  String get byUser => 'bởi';
  @override
  String get acceptInvitation => 'Chấp nhận';
  @override
  String get declineInvitation => 'Từ chối';
  @override
  String get invitationAcceptedMessage => 'Bạn đã được thêm vào BU';
  @override
  String get invitationDeclinedMessage => 'Bạn đã từ chối lời mời';
  @override
  String get invitationAcceptedNotification => 'Người dùng đã chấp nhận lời mời của bạn';
  @override
  String get invitationDeclinedNotification => 'Người dùng đã từ chối lời mời của bạn';
  @override
  String get noPendingInvitations => 'Không có lời mời đang chờ';
  @override
  String get createWorkspaceInstead => 'Tạo BU thay thế';
  @override
  String get language => 'Ngôn ngữ';
  @override
  String get locale => 'Địa phương';
  @override
  String get timezone => 'Múi giờ';
  @override
  String get dateFormat => 'Định dạng ngày';
  @override
  String get timeFormat => 'Định dạng thời gian';
  @override
  String get currency => 'Tiền tệ';
  @override
  String get units => 'Đơn vị';

//tasks
  @override
  String get statisticsTitle => 'Thống kê';

  // ============================================================================
  // PROJECT MANAGEMENT STRINGS
  // ============================================================================
  
  /// Project management related strings
  @override
  String get createProject => 'Tạo dự án';
  @override
  String get noProjectsFound => 'Không tìm thấy dự án nào';
  @override
  String get projectTitle => 'Tiêu đề dự án';
  @override
  String get enterProjectTitle => 'Nhập tiêu đề dự án';
  @override
  String get projectDescription => 'Mô tả dự án';
  @override
  String get enterProjectDescription => 'Nhập mô tả dự án';
  @override
  String get projectDeadline => 'Hạn cuối dự án';
}