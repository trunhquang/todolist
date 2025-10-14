import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/base_controller.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/firebase_database_service.dart';
import '../../../../core/constants/user_roles.dart';
import '../../../../app/routes/app_router.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/company.dart';
import '../../domain/entities/user.dart' as app_user;

class AuthController extends BaseController {
  AuthController({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseDatabaseService? databaseService,
    StorageService? storageService,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _databaseService = databaseService ?? FirebaseDatabaseService.instance,
        _storageService = storageService ?? StorageService(),
        _googleSignIn = googleSignIn ?? GoogleSignIn();
  // Map FirebaseAuthException codes to clear, user-facing messages
  String _authMessageFromCode(String code,
      {String defaultMessage = 'Authentication failed'}) {
    switch (code) {
      case 'invalid-email':
        return AppStrings.viAuthInvalidEmail;
      case 'user-disabled':
        return AppStrings.viAuthUserDisabled;
      case 'user-not-found':
        return AppStrings.viAuthUserNotFound;
      case 'wrong-password':
        return AppStrings.viAuthWrongPassword;
      case 'email-already-in-use':
        return AppStrings.viAuthEmailAlreadyInUse;
      case 'weak-password':
        return AppStrings.viAuthWeakPassword;
      case 'operation-not-allowed':
        return AppStrings.viAuthOperationNotAllowed;
      case 'account-exists-with-different-credential':
        return AppStrings.viAuthAccountExistsWithDifferentCredential;
      case 'invalid-credential':
        return AppStrings.viAuthInvalidCredential;
      case 'network-request-failed':
        return AppStrings.viAuthNetworkRequestFailed;
      case 'too-many-requests':
        return AppStrings.viAuthTooManyRequests;
      case 'popup-closed-by-user':
      case 'sign_in_canceled':
        return AppStrings.viAuthSigninCanceled;
      default:
        return defaultMessage;
    }
  }

  // Current user
  final Rx<app_user.User?> _currentUser = Rx<app_user.User?>(null);

  app_user.User? get currentUser => _currentUser.value;

  // Current company
  final Rx<Company?> _currentCompany = Rx<Company?>(null);

  Company? get currentCompany => _currentCompany.value;

  // Firebase Auth instance
  final firebase_auth.FirebaseAuth _firebaseAuth;

  // Google Sign-In instance
  final GoogleSignIn _googleSignIn;

  // Firebase Database service
  final FirebaseDatabaseService _databaseService;

  // Storage service
  final StorageService _storageService;

  @override
  void onInit() {
    super.onInit();
    _initializeAuth();
  }

  // Initialize authentication
  void _initializeAuth() {
    // Listen to auth state changes
    _firebaseAuth.authStateChanges().listen((firebase_auth.User? user) {
      if (user != null) {
        unawaited( _handleUserSignIn(user));
      } else {
        _handleUserSignOut();
      }
    });
  }

  // Handle user sign in
  Future<void> _handleUserSignIn(firebase_auth.User firebaseUser) async {
    try {
      isLoading = true;

      // Get user data from Firebase Database
      var user = await _databaseService.getUser(firebaseUser.uid);

      if (user == null) {
        // Create new user if doesn't exist
        user = app_user.User(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: firebaseUser.displayName ?? '',
          profileImageUrl: firebaseUser.photoURL,
          role: UserRoles.regularUser,
          companyId: '',
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );

        // Save user to database
        await _databaseService.createUser(user);
      } else {
        // Update last login time
        final updatedUser = user.copyWith(lastLoginAt: DateTime.now());
        await _databaseService.updateUser(updatedUser);
        user = updatedUser;
      }

      _currentUser.value = user;

      // Load user's company if exists
      if (user.companyId.isNotEmpty) {
        final company = await _databaseService.getCompany(user.companyId);
        _currentCompany.value = company;
      }

      // Save user data to local storage
      await _storageService.setUserData('current_user', user.toMap());
      await _storageService.setUserId(user.id);
      final token = await firebaseUser.getIdToken();
      if (token != null) {
        await _storageService.setUserToken(token);
      }

      isLoading = false;
    } on Exception catch (e) {
      isLoading = false;
      handleError(
          UnknownFailure(message: 'Failed to sign in: $e'));
    }
  }

  /// After login, navigate user based on onboarding state
  /// - Resolves potential race: ensure auth state is hydrated before routing
  /// - If user has no company and is Admin (self-registration), force company setup
  /// - Else go to dashboard
  Future<void> handlePostLoginNavigation() async {
    // Prefer authoritative Firebase session over local flag
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      await NavigationService().offAllNamed<void>(AppRouter.login);
      return;
    }

    // Hydrate local state if needed (avoids race with authStateChanges listener)
    if (_currentUser.value == null) {
      await _handleUserSignIn(firebaseUser);
    }

    final user = _currentUser.value;
    if (user == null) {
      // Fallback safety: if still null, send to login
      await NavigationService().offAllNamed<void>(AppRouter.login);
      return;
    }

    // Force password change for invited users
    if (user.mustChangePassword) {
      await NavigationService()
          .offAllNamed<void>(AppRouter.changePassword);
      return;
    }

    final isUserAdmin = user.isAdmin;
    final hasNoCompany = user.companyId.trim().isEmpty;

    if (isUserAdmin && hasNoCompany) {
      await NavigationService()
          .offAllNamed<void>(AppRouter.companySetup);
    } else {
      await NavigationService().offAllNamed<void>(AppRouter.dashboard);
    }
  }

  // Handle user sign out
  void _handleUserSignOut() {
    _currentUser.value = null;
    _currentCompany.value = null;

    // Clear local storage
    // Fire and forget is acceptable here; no need to await
    // ignore: discarded_futures
    _storageService.clearAllData();
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await executeAsync(
      () async {
        try {
          final credential = await _firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          if (credential.user == null) {
            throw const AuthenticationFailure(message: 'Đăng nhập thất bại');
          }
        } on firebase_auth.FirebaseAuthException catch (e) {
          throw AuthenticationFailure(
              message: _authMessageFromCode(e.code,
                  defaultMessage: e.message ?? 'Đăng nhập thất bại'),
              code: e.code);
        }
      },
      successMessage: AppStrings.viAuthLoginSuccess,
    );
    await handlePostLoginNavigation();
  }

  // Sign up with email and password
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    await executeAsync(
      () async {
        try {
          final credential = await _firebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          if (credential.user == null) {
            throw const AuthenticationFailure(
                message: 'Tạo tài khoản thất bại');
          }

          // Update display name
          await credential.user!.updateDisplayName(name);

          // Create user document in Firebase Database
          final user = app_user.User(
            id: credential.user!.uid,
            email: email,
            name: name,
            // Self-registration must be Admin
            role: UserRoles.admin,
            companyId: '',
            createdAt: DateTime.now(),
            lastLoginAt: DateTime.now(),
          );

          await _databaseService.createUser(user);

          // Auto-create a personal workspace (company) for the new user
          final personalCompany = Company(
            id: '',
            name: AppStrings.personalWorkspaceNameFor(name),
            description: AppStrings.personalWorkspaceDescription,
            createdBy: user.id,
            createdAt: DateTime.now(),
          );

          final createdCompanyId = await _databaseService.createCompany(personalCompany);

          // Associate user with the newly created personal company
          await _databaseService.addUserToCompany(
            userId: user.id,
            companyId: createdCompanyId,
          );

          // Update user with companyId so post-login navigation goes to dashboard
          final userWithCompany = user.copyWith(companyId: createdCompanyId);
          await _databaseService.updateUser(userWithCompany);

          // Save to local storage for immediate context
          await _storageService.setCompanyId(createdCompanyId);
          await _storageService.setUserData('current_user', userWithCompany.toMap());
        } on firebase_auth.FirebaseAuthException catch (e) {
          throw AuthenticationFailure(
              message: _authMessageFromCode(e.code,
                  defaultMessage: e.message ?? 'Tạo tài khoản thất bại'),
              code: e.code);
        }
      },
      successMessage: AppStrings.viAuthSignupSuccess,
    );
    await handlePostLoginNavigation();
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    await executeAsync(
      () async {
        try {
          final googleUser = await _googleSignIn.signIn();
          if (googleUser == null) {
            throw const AuthenticationFailure(
                message: 'Quá trình đăng nhập Google đã bị hủy');
          }
          final googleAuth = await googleUser.authentication;
          final credential = firebase_auth.GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          final userCredential =
              await _firebaseAuth.signInWithCredential(credential);
          if (userCredential.user == null) {
            throw const AuthenticationFailure(
                message: 'Đăng nhập Google thất bại');
          }
        } on firebase_auth.FirebaseAuthException catch (e) {
          throw AuthenticationFailure(
              message: _authMessageFromCode(e.code,
                  defaultMessage: e.message ?? 'Đăng nhập Google thất bại'),
              code: e.code);
        }
      },
      successMessage: AppStrings.viAuthGoogleSigninSuccess,
    );
    await handlePostLoginNavigation();
  }

  // Sign in with Apple (iOS/macOS)
  Future<void> signInWithApple() async {
    await executeAsync(
      () async {
        try {
          final appleCredential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
          );

          final oauthCredential =
              firebase_auth.OAuthProvider('apple.com').credential(
            idToken: appleCredential.identityToken,
            accessToken: appleCredential.authorizationCode,
          );

          final userCredential =
              await _firebaseAuth.signInWithCredential(oauthCredential);

          if (userCredential.user == null) {
            throw const AuthenticationFailure(
                message: 'Đăng nhập Apple thất bại');
          }

          final given = appleCredential.givenName;
          final family = appleCredential.familyName;
          if ((given != null || family != null) &&
              (userCredential.user!.displayName == null ||
                  userCredential.user!.displayName!.isEmpty)) {
            final composedName = [given, family]
                .where((e) => e != null && e.trim().isNotEmpty)
                .join(' ');
            if (composedName.isNotEmpty) {
              await userCredential.user!.updateDisplayName(composedName);
            }
          }
        } on firebase_auth.FirebaseAuthException catch (e) {
          throw AuthenticationFailure(
              message: _authMessageFromCode(e.code,
                  defaultMessage: e.message ?? 'Đăng nhập Apple thất bại'),
              code: e.code);
        }
      },
      successMessage: AppStrings.viAuthAppleSigninSuccess,
    );
    await handlePostLoginNavigation();
  }

  // Sign out
  Future<void> signOut() async {
    await executeAsync(
      () async {
        try {
          await _firebaseAuth.signOut();
          await _googleSignIn.signOut();
        } on firebase_auth.FirebaseAuthException catch (e) {
          throw AuthenticationFailure(
              message: _authMessageFromCode(e.code,
                  defaultMessage: e.message ?? 'Đăng xuất thất bại'),
              code: e.code);
        }
      },
      successMessage: AppStrings.viAuthLogoutSuccess,
    );
    await navigateOffAll<void>(AppRouter.login);
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await executeAsync(
      () async {
        try {
          await _firebaseAuth.sendPasswordResetEmail(email: email);
        } on firebase_auth.FirebaseAuthException catch (e) {
          throw AuthenticationFailure(
              message: _authMessageFromCode(e.code,
                  defaultMessage:
                      e.message ?? 'Gửi email đặt lại mật khẩu thất bại'),
              code: e.code);
        }
      },
      successMessage: AppStrings.viAuthPasswordResetEmailSent,
    );
  }

  // Change password for currently signed-in user and clear first-login flag
  Future<void> changePassword(String newPassword) async {
    await executeAsync(
      () async {
        final user = _firebaseAuth.currentUser;
        if (user == null) {
          throw const AuthenticationFailure(message: 'No user signed in');
        }

        // Update password in Firebase Auth (may require recent login)
        await user.updatePassword(newPassword);

        // Clear mustChangePassword and persist to database
        if (_currentUser.value != null) {
          final updatedUser = _currentUser.value!.copyWith(mustChangePassword: false);
          await _databaseService.updateUser(updatedUser);
          _currentUser.value = updatedUser;

          // Persist to local storage
          await _storageService.setUserData('current_user', updatedUser.toMap());
        }
      },
      successMessage: 'Đổi mật khẩu thành công',
    );
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? name,
    String? profileImageUrl,
  }) async {
    if (_currentUser.value == null) return;

    await executeAsync(
      () async {
        final user = _firebaseAuth.currentUser;
        if (user == null) {
          throw const AuthenticationFailure(message: 'No user signed in');
        }

        if (name != null) {
          await user.updateDisplayName(name);
        }

        if (profileImageUrl != null) {
          await user.updatePhotoURL(profileImageUrl);
        }

        // Update local user data
        final updatedUser = _currentUser.value!.copyWith(
          name: name,
          profileImageUrl: profileImageUrl,
        );
        _currentUser.value = updatedUser;

        // Save to local storage
        await _storageService
            .setUserData('current_user', updatedUser.toMap());
      },
      successMessage: 'Profile updated successfully',
    );
  }

  // Create company
  Future<void> createCompany({
    required String name,
    String? description,
    String? departmentName,
  }) async {
    if (_currentUser.value == null) return;

    await executeAsync(
      () async {
        // Create company in Firebase Database
        final company = Company(
          id: '',
          // Will be set by database service
          name: name,
          description: description,
          createdBy: _currentUser.value!.id,
          createdAt: DateTime.now(),
        );

        final companyId = await _databaseService.createCompany(company);
        final createdCompany = company.copyWith(id: companyId);

        // Create default department if provided
        String? departmentId;
        if (departmentName != null && departmentName.isNotEmpty) {
          departmentId = await _databaseService.createDepartment(
            companyId: companyId,
            name: departmentName,
            createdBy: _currentUser.value!.id,
          );
        }

        // Add user to company
        await _databaseService.addUserToCompany(
          userId: _currentUser.value!.id,
          companyId: companyId,
          departmentId: departmentId,
        );

        // Update user's company and department
        final updatedUser = _currentUser.value!.copyWith(
          companyId: companyId,
          departmentId: departmentId,
          role: 'company_admin', // Creator becomes company admin
        );
        await _databaseService.updateUser(updatedUser);

        _currentUser.value = updatedUser;
        _currentCompany.value = createdCompany;

        // Save to local storage
        await _storageService.setCompanyId(companyId);
        await _storageService
            .setUserData('current_company', createdCompany.toMap());
        await _storageService
            .setUserData('current_user', updatedUser.toMap());
      },
      successMessage: 'Company created successfully',
    );
  }

  // Join company
  Future<void> joinCompany(String companyId) async {
    if (_currentUser.value == null) return;

    await executeAsync(
      () async {
        await _storageService.setCompanyId(companyId);
      },
      successMessage: 'Joined company successfully',
    );
  }

  // Check if user has company
  bool get hasCompany => _currentCompany.value != null;

  // Check if user is admin
  bool get isAdmin => _currentUser.value?.isAdmin ?? false;

  // Check if user is department manager
  bool get isDepartmentManager =>
      _currentUser.value?.isDepartmentManager ?? false;

  // Check if user is team lead
  bool get isTeamLead => _currentUser.value?.isTeamLead ?? false;

  // Check if user is regular user
  bool get isRegularUser => _currentUser.value?.isRegularUser ?? false;

  // Legacy support
  bool get isCompanyAdmin => _currentUser.value?.isCompanyAdmin ?? false;

  bool get isDepartmentAdmin => _currentUser.value?.isDepartmentAdmin ?? false;

  // Permission checking methods
  bool hasPermission(String permission) {
    final user = _currentUser.value;
    if (user == null) return false;
    return UserRoles.hasPermission(user.role, permission);
  }

  bool canManageRole(String targetRole) {
    final user = _currentUser.value;
    if (user == null) return false;
    return UserRoles.canManageRole(user.role, targetRole);
  }

  bool hasHigherAuthorityThan(String targetRole) {
    final user = _currentUser.value;
    if (user == null) return false;
    return UserRoles.hasHigherAuthority(user.role, targetRole);
  }

  List<String> getCurrentUserPermissions() {
    final user = _currentUser.value;
    if (user == null) return [];
    return UserRoles.getPermissions(user.role);
  }

  // Get user display name
  String get userDisplayName => _currentUser.value?.displayName ?? '';

  // Get user initials
  String get userInitials => _currentUser.value?.initials ?? '';

  // Get company display name
  String get companyDisplayName => _currentCompany.value?.displayName ?? '';

  // Get company initials
  String get companyInitials => _currentCompany.value?.initials ?? '';
}
