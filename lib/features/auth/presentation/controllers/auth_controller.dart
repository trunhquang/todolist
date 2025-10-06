import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/base_controller.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/firebase_database_service.dart';
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
  
  // Google Sign-In instance
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  // Firebase Database service
  final FirebaseDatabaseService _databaseService = FirebaseDatabaseService.instance;

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
      
      // Get user data from Firebase Database
      app_user.User? user = await _databaseService.getUser(firebaseUser.uid);
      
      if (user == null) {
        // Create new user if doesn't exist
        user = app_user.User(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: firebaseUser.displayName ?? '',
          profileImageUrl: firebaseUser.photoURL,
          role: 'user',
          companyId: '',
          departmentId: null,
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
      _isAuthenticated.value = true;

      // Get user's company if exists
      if (user.companyId.isNotEmpty) {
        final company = await _databaseService.getCompany(user.companyId);
        _currentCompany.value = company;
      }

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
        
        // Create user document in Firebase Database
        final user = app_user.User(
          id: credential.user!.uid,
          email: email,
          name: name,
          profileImageUrl: null,
          role: 'user',
          companyId: '',
          departmentId: null,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );
        
        await _databaseService.createUser(user);
      },
      successMessage: 'Account created successfully',
    );
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    await executeAsync(
      () async {
        // Trigger the authentication flow
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        
        if (googleUser == null) {
          throw const AuthenticationFailure(message: 'Google sign-in cancelled');
        }

        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Create a new credential
        final credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the Google credential
        final userCredential = await _firebaseAuth.signInWithCredential(credential);
        
        if (userCredential.user == null) {
          throw const AuthenticationFailure(message: 'Google sign-in failed');
        }
      },
      successMessage: 'Signed in with Google successfully',
    );
  }

  // Sign out
  Future<void> signOut() async {
    await executeAsync(
      () async {
        await _firebaseAuth.signOut();
        await _googleSignIn.signOut();
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
    String? departmentName,
  }) async {
    if (_currentUser.value == null) return;

    await executeAsync(
      () async {
        // Create company in Firebase Database
        final company = Company(
          id: '', // Will be set by database service
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
        await StorageService.instance.setCompanyId(companyId);
        await StorageService.instance.setUserData('current_company', createdCompany.toMap());
        await StorageService.instance.setUserData('current_user', updatedUser.toMap());
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
