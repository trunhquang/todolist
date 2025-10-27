import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

/// Service to manage user credentials securely
class CredentialService {
  factory CredentialService() => _instance ??= CredentialService._();
  CredentialService._();

  static CredentialService? _instance;

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static const String _emailKey = 'saved_user_email';
  static const String _passwordKey = 'saved_user_password';
  static const String _isLoggedInKey = 'is_user_logged_in';

  /// Save user credentials after successful login
  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    try {
      await Future.wait([
        _secureStorage.write(key: _emailKey, value: email),
        _secureStorage.write(key: _passwordKey, value: password),
        _secureStorage.write(key: _isLoggedInKey, value: 'true'),
      ]);
    } catch (e) {
      throw Exception('Failed to save credentials: $e');
    }
  }

  /// Get saved user credentials
  Future<Map<String, String?>> getCredentials() async {
    try {
      final email = await _secureStorage.read(key: _emailKey);
      final password = await _secureStorage.read(key: _passwordKey);
      return {
        'email': email,
        'password': password,
      };
    } catch (e) {
      return {'email': null, 'password': null};
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final isLoggedIn = await _secureStorage.read(key: _isLoggedInKey);
      return isLoggedIn == 'true';
    } catch (e) {
      return false;
    }
  }

  /// Clear saved credentials
  Future<void> clearCredentials() async {
    try {
      await Future.wait([
        _secureStorage.delete(key: _emailKey),
        _secureStorage.delete(key: _passwordKey),
        _secureStorage.delete(key: _isLoggedInKey),
      ]);
    } catch (e) {
      throw Exception('Failed to clear credentials: $e');
    }
  }

  /// Restore user session using saved credentials
  Future<bool> restoreUserSession() async {
    try {
      final credentials = await getCredentials();
      final email = credentials['email'];
      final password = credentials['password'];

      if (email == null || password == null) {
        return false;
      }

      // Check if user is already logged in
      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (currentUser != null && currentUser.email == email) {
        return true;
      }

      // Sign in with saved credentials
      final credential = await firebase_auth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user != null;
    } catch (e) {
      // If restore fails, clear credentials
      await clearCredentials();
      return false;
    }
  }

  /// Sign out and clear credentials
  Future<void> signOut() async {
    try {
      await firebase_auth.FirebaseAuth.instance.signOut();
      await clearCredentials();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }
}
