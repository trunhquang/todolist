import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:get/get.dart';

import 'package:todolist/features/auth/presentation/controllers/auth_controller.dart';
import 'package:todolist/core/services/firebase_database_service.dart';
import 'package:todolist/core/services/storage_service.dart';

// Mock classes
class MockFirebaseAuth extends Mock implements firebase_auth.FirebaseAuth {}
class MockDatabaseService extends Mock implements FirebaseDatabaseService {}
class MockStorageService extends Mock implements StorageService {}

void main() {
  group('AuthController - Forgot Password Basic Tests', () {
    late MockFirebaseAuth mockAuth;
    late MockDatabaseService mockDb;
    late MockStorageService mockStorage;
    late AuthController controller;

    setUp(() {
      Get.testMode = true;
      mockAuth = MockFirebaseAuth();
      mockDb = MockDatabaseService();
      mockStorage = MockStorageService();
      controller = AuthController(
        firebaseAuth: mockAuth,
        databaseService: mockDb,
        storageService: mockStorage,
      );
    });

    tearDown(() {
      Get.reset();
    });

    test('should have sendPasswordResetEmail method', () {
      // Assert
      expect(controller.sendPasswordResetEmail, isA<Function>());
    });

    test('should have resetPassword method', () {
      // Assert
      expect(controller.resetPassword, isA<Function>());
    });

    test('should initialize without errors', () {
      // Assert
      expect(controller, isNotNull);
      expect(controller, isA<AuthController>());
    });
  });
}
