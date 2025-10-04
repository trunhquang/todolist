import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:get/get.dart';

import '../../../../core/controllers/base_controller.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/company.dart';
import '../../domain/entities/user.dart' as app_user;

class AuthController extends BaseController {
  // Current user
  final Rx<app_user.User?> _currentUser = Rx<app_user.User?>(null);
  app_user.User? get currentUser => _currentUser.value;

  // Current company
  final Rx<Company?> _currentCompany = Rx<Company?>(null);
  Company? get currentCompany => _currentCompany.value;

  // Authentication state
  final RxBool _isAuthenticated = false.obs;
  bool get isAuthenticated => _isAuthenticated.value;

  // Firebase Auth instance
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;

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
        _handleUserSignIn(user);
      } else {
        _handleUserSignOut();
      }
    });
  }

  // Handle user sign in
  void _handleUserSignIn(firebase_auth.User firebaseUser) async {
    try {
      setLoading(true);
      
      // TODO: Get user data from Firebase Database
      // For now, create a mock user
      final user = app_user.User(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        name: firebaseUser.displayName ?? '',
        profileImageUrl: firebaseUser.photoURL,
        role: 'user', // TODO: Get from database
        companyId: '', // TODO: Get from database
        departmentId: null, // TODO: Get from database
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );

      _currentUser.value = user;
      _isAuthenticated.value = true;

      // Save user data to local storage
      await StorageService.instance.setUserData('current_user', user.toMap());
      await StorageService.instance.setUserId(user.id);
      final token = await firebaseUser.getIdToken();
      if (token != null) {
        await StorageService.instance.setUserToken(token);
      }

      setLoading(false);
    } catch (e) {
      setLoading(false);
      handleError(UnknownFailure(message: 'Failed to sign in: ${e.toString()}'));
    }
  }

  // Handle user sign out
  void _handleUserSignOut() {
    _currentUser.value = null;
    _currentCompany.value = null;
    _isAuthenticated.value = false;
    
    // Clear local storage
    StorageService.instance.clearAllData();
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await executeAsync(
      () async {
        final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        
        if (credential.user == null) {
          throw const AuthenticationFailure(message: 'Sign in failed');
        }
      },
      successMessage: 'Signed in successfully',
    );
  }

  // Sign up with email and password
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    await executeAsync(
      () async {
        final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        
        if (credential.user == null) {
          throw const AuthenticationFailure(message: 'Sign up failed');
        }

        // Update display name
        await credential.user!.updateDisplayName(name);
        
        // TODO: Create user document in Firebase Database
      },
      successMessage: 'Account created successfully',
    );
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    await executeAsync(
      () async {
        // TODO: Implement Google Sign-In
        throw const NotImplementedFailure(message: 'Google Sign-In not implemented yet');
      },
      successMessage: 'Signed in with Google successfully',
    );
  }

  // Sign out
  Future<void> signOut() async {
    await executeAsync(
      () async {
        await _firebaseAuth.signOut();
      },
      successMessage: 'Signed out successfully',
    );
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await executeAsync(
      () async {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      },
      successMessage: 'Password reset email sent',
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
        await StorageService.instance.setUserData('current_user', updatedUser.toMap());
      },
      successMessage: 'Profile updated successfully',
    );
  }

  // Create company
  Future<void> createCompany({
    required String name,
    String? description,
  }) async {
    if (_currentUser.value == null) return;

    await executeAsync(
      () async {
        // TODO: Create company in Firebase Database
        final company = Company(
          id: '', // TODO: Generate ID
          name: name,
          description: description,
          createdBy: _currentUser.value!.id,
          createdAt: DateTime.now(),
        );

        _currentCompany.value = company;

        // Save to local storage
        await StorageService.instance.setCompanyId(company.id);
        await StorageService.instance.setUserData('current_company', company.toMap());
      },
      successMessage: 'Company created successfully',
    );
  }

  // Join company
  Future<void> joinCompany(String companyId) async {
    if (_currentUser.value == null) return;

    await executeAsync(
      () async {
        // TODO: Join company in Firebase Database
        await StorageService.instance.setCompanyId(companyId);
      },
      successMessage: 'Joined company successfully',
    );
  }

  // Check if user has company
  bool get hasCompany => _currentCompany.value != null;

  // Check if user is company admin
  bool get isCompanyAdmin => _currentUser.value?.isCompanyAdmin ?? false;

  // Check if user is department admin
  bool get isDepartmentAdmin => _currentUser.value?.isDepartmentAdmin ?? false;

  // Check if user is regular user
  bool get isRegularUser => _currentUser.value?.isRegularUser ?? false;

  // Get user display name
  String get userDisplayName => _currentUser.value?.displayName ?? '';

  // Get user initials
  String get userInitials => _currentUser.value?.initials ?? '';

  // Get company display name
  String get companyDisplayName => _currentCompany.value?.displayName ?? '';

  // Get company initials
  String get companyInitials => _currentCompany.value?.initials ?? '';
}
