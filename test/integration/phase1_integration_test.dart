import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../../lib/main.dart';
import '../../lib/features/auth/presentation/controllers/auth_controller.dart';
import '../../lib/features/workspace/presentation/controllers/workspace_controller.dart';
import '../../lib/features/workspace/domain/entities/workspace.dart';
import '../../lib/features/workspace/domain/repositories/workspace_repository.dart';
import '../../lib/core/services/navigation_service.dart';
import '../../lib/core/services/snackbar_service.dart';
import '../../lib/core/errors/failures.dart';
import '../../lib/core/utils/either.dart';
import '../../lib/app/routes/app_router.dart';

import 'phase1_integration_test.mocks.dart';

@GenerateMocks([
  WorkspaceRepository,
])
void main() {
  group('Phase 1 End-to-End Integration Tests', () {
    late MockWorkspaceRepository mockWorkspaceRepository;
    late AuthController authController;
    late WorkspaceController workspaceController;

    setUp(() {
      Get.testMode = true;
      
      mockWorkspaceRepository = MockWorkspaceRepository();
      
      // Setup GetX dependencies
      Get.put<NavigationService>(NavigationService());
      Get.put<SnackbarService>(SnackbarService());
      
      // Create controllers with mocked dependencies
      authController = AuthController();
      workspaceController = WorkspaceController(
        workspaceRepository: mockWorkspaceRepository,
      );
      
      Get.put<AuthController>(authController);
      Get.put<WorkspaceController>(workspaceController);
    });

    tearDown(() {
      Get.reset();
    });

    group('Complete User Onboarding Flow', () {
      testWidgets('Full user registration to workspace creation flow', (tester) async {
        // Arrange
        final personalWorkspace = Workspace(
          id: 'personal_workspace_id',
          name: 'Test User\'s Personal Workspace',
          description: 'Personal workspace for Test User',
          type: WorkspaceType.personal,
          createdBy: 'test_user_id',
          createdAt: DateTime.now(),
          isActive: true,
        );

        final companyWorkspace = Workspace(
          id: 'company_workspace_id',
          name: 'Test Company',
          description: 'Test company workspace',
          type: WorkspaceType.company,
          createdBy: 'test_user_id',
          createdAt: DateTime.now(),
          isActive: true,
        );

        when(mockWorkspaceRepository.createWorkspace(any))
            .thenAnswer((_) async => Right(personalWorkspace));
        
        when(mockWorkspaceRepository.getUserWorkspaces(any))
            .thenAnswer((_) async => Right([personalWorkspace, companyWorkspace]));

        // Act - Start the app
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        // Step 1: User Registration
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('email_field')), 
          'test@example.com'
        );
        await tester.enterText(
          find.byKey(const Key('password_field')), 
          'password123'
        );
        await tester.enterText(
          find.byKey(const Key('name_field')), 
          'Test User'
        );

        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        // Verify personal workspace is created
        verify(mockWorkspaceRepository.createWorkspace(any)).called(1);

        // Step 2: Company Setup
        expect(find.byKey(const Key('company_setup_page')), findsOneWidget);

        await tester.enterText(
          find.byKey(const Key('company_name_field')), 
          'Test Company'
        );
        await tester.enterText(
          find.byKey(const Key('company_description_field')), 
          'Test company description'
        );

        await tester.tap(find.text('Create Company'));
        await tester.pumpAndSettle();

        // Step 3: Dashboard Access
        expect(find.byKey(const Key('dashboard_page')), findsOneWidget);

        // Step 4: Workspace Management
        await tester.tap(find.text('Workspace Management'));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('workspace_management_page')), findsOneWidget);

        // Step 5: Create Additional Workspace
        await tester.tap(find.text('Create Workspace'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('workspace_name_field')), 
          'Project Workspace'
        );
        await tester.enterText(
          find.byKey(const Key('workspace_description_field')), 
          'Workspace for project management'
        );

        await tester.tap(find.text('Create Workspace'));
        await tester.pumpAndSettle();

        // Verify workspace creation
        verify(mockWorkspaceRepository.createWorkspace(any)).called(2);

        // Step 6: Workspace Switching
        await tester.tap(find.byKey(const Key('workspace_selector')));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Project Workspace'));
        await tester.pumpAndSettle();

        // Verify workspace switching
        verify(mockWorkspaceRepository.switchWorkspace(any, any)).called(1);

        // Assert - Complete flow successful
        expect(find.text('Welcome to Project Workspace'), findsOneWidget);
      });

      testWidgets('Handle onboarding errors gracefully', (tester) async {
        // Arrange
        when(mockWorkspaceRepository.createWorkspace(any))
            .thenAnswer((_) async => Left(ServerFailure(message: 'Server error')));

        // Act
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('email_field')), 
          'test@example.com'
        );
        await tester.enterText(
          find.byKey(const Key('password_field')), 
          'password123'
        );
        await tester.enterText(
          find.byKey(const Key('name_field')), 
          'Test User'
        );

        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        // Assert - Error handling
        expect(find.text('Server error'), findsOneWidget);
        expect(find.byKey(const Key('company_setup_page')), findsNothing);
      });
    });

    group('Authentication State Persistence', () {
      testWidgets('Maintain authentication state across app restarts', (tester) async {
        // Arrange
        final existingWorkspace = Workspace(
          id: 'existing_workspace_id',
          name: 'Existing Workspace',
          type: WorkspaceType.personal,
          createdBy: 'existing_user_id',
          createdAt: DateTime.now(),
          isActive: true,
        );

        when(mockWorkspaceRepository.getUserWorkspaces(any))
            .thenAnswer((_) async => Right([existingWorkspace]));

        // Simulate existing authenticated user
        authController.setAuthenticatedUser('existing_user_id', 'existing@example.com', 'Existing User');

        // Act
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        // Assert - User should be on dashboard, not login
        expect(find.byKey(const Key('dashboard_page')), findsOneWidget);
        expect(find.byKey(const Key('login_page')), findsNothing);

        // Verify workspace is loaded
        verify(mockWorkspaceRepository.getUserWorkspaces(any)).called(1);
      });

      testWidgets('Handle authentication state changes', (tester) async {
        // Act
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        // Initially on login page
        expect(find.byKey(const Key('login_page')), findsOneWidget);

        // Simulate successful login
        authController.setAuthenticatedUser('user_id', 'user@example.com', 'User');

        await tester.pumpAndSettle();

        // Should navigate to dashboard
        expect(find.byKey(const Key('dashboard_page')), findsOneWidget);

        // Simulate logout
        authController.signOut();
        await tester.pumpAndSettle();

        // Should navigate back to login
        expect(find.byKey(const Key('login_page')), findsOneWidget);
      });
    });

    group('Workspace Data Isolation', () {
      testWidgets('Ensure proper data isolation between workspaces', (tester) async {
        // Arrange
        final personalWorkspace = Workspace(
          id: 'personal_workspace',
          name: 'Personal Workspace',
          type: WorkspaceType.personal,
          createdBy: 'test_user_id',
          createdAt: DateTime.now(),
          isActive: true,
        );

        final companyWorkspace = Workspace(
          id: 'company_workspace',
          name: 'Company Workspace',
          type: WorkspaceType.company,
          createdBy: 'test_user_id',
          createdAt: DateTime.now(),
          isActive: true,
        );

        when(mockWorkspaceRepository.getUserWorkspaces(any))
            .thenAnswer((_) async => Right([personalWorkspace, companyWorkspace]));

        when(mockWorkspaceRepository.switchWorkspace(any, any))
            .thenAnswer((_) async => const Right(null));

        // Act
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        // Simulate authenticated user
        authController.setAuthenticatedUser('test_user_id', 'test@example.com', 'Test User');
        await tester.pumpAndSettle();

        // Load workspaces
        await workspaceController.loadUserWorkspaces();
        await tester.pumpAndSettle();

        // Switch to personal workspace
        await workspaceController.switchWorkspace('personal_workspace');
        await tester.pumpAndSettle();

        // Verify personal workspace context
        expect(workspaceController.currentWorkspace.value?.id, equals('personal_workspace'));
        expect(workspaceController.currentWorkspace.value?.type, equals(WorkspaceType.personal));

        // Switch to company workspace
        await workspaceController.switchWorkspace('company_workspace');
        await tester.pumpAndSettle();

        // Verify company workspace context
        expect(workspaceController.currentWorkspace.value?.id, equals('company_workspace'));
        expect(workspaceController.currentWorkspace.value?.type, equals(WorkspaceType.company));

        // Assert - Proper isolation
        verify(mockWorkspaceRepository.switchWorkspace(any, 'personal_workspace')).called(1);
        verify(mockWorkspaceRepository.switchWorkspace(any, 'company_workspace')).called(1);
      });
    });

    group('Cross-Feature Integration', () {
      testWidgets('Integration between authentication and workspace features', (tester) async {
        // Arrange
        final workspace = Workspace(
          id: 'integration_workspace',
          name: 'Integration Workspace',
          type: WorkspaceType.company,
          createdBy: 'integration_user_id',
          createdAt: DateTime.now(),
          isActive: true,
        );

        when(mockWorkspaceRepository.getUserWorkspaces(any))
            .thenAnswer((_) async => Right([workspace]));

        when(mockWorkspaceRepository.createWorkspace(any))
            .thenAnswer((_) async => Right(workspace));

        // Act
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        // Login
        await tester.tap(find.text('Login'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('email_field')), 
          'integration@example.com'
        );
        await tester.enterText(
          find.byKey(const Key('password_field')), 
          'password123'
        );

        await tester.tap(find.text('Login'));
        await tester.pumpAndSettle();

        // Verify authentication
        expect(authController.currentUser, isNotNull);
        expect(authController.currentUser?.email, equals('integration@example.com'));

        // Verify workspace loading
        verify(mockWorkspaceRepository.getUserWorkspaces(any)).called(1);

        // Create new workspace
        await tester.tap(find.text('Create Workspace'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('workspace_name_field')), 
          'New Integration Workspace'
        );

        await tester.tap(find.text('Create Workspace'));
        await tester.pumpAndSettle();

        // Verify workspace creation with authenticated user
        verify(mockWorkspaceRepository.createWorkspace(any)).called(1);

        // Assert - Features work together
        expect(find.text('Workspace created successfully'), findsOneWidget);
      });
    });

    group('Error Recovery', () {
      testWidgets('Recover from network errors during onboarding', (tester) async {
        // Arrange - First call fails, second succeeds
        when(mockWorkspaceRepository.createWorkspace(any))
            .thenAnswer((_) async => Left(NetworkFailure(message: 'Network error')))
            .thenAnswer((_) async => Right(Workspace(
              id: 'recovery_workspace',
              name: 'Recovery Workspace',
              type: WorkspaceType.personal,
              createdBy: 'test_user_id',
              createdAt: DateTime.now(),
              isActive: true,
            )));

        // Act
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('email_field')), 
          'recovery@example.com'
        );
        await tester.enterText(
          find.byKey(const Key('password_field')), 
          'password123'
        );
        await tester.enterText(
          find.byKey(const Key('name_field')), 
          'Recovery User'
        );

        // First attempt - should fail
        await tester.tap(find.text('Register'));
        await tester.pumpAndSettle();

        expect(find.text('Network error'), findsOneWidget);

        // Retry - should succeed
        await tester.tap(find.text('Retry'));
        await tester.pumpAndSettle();

        // Assert - Recovery successful
        expect(find.byKey(const Key('company_setup_page')), findsOneWidget);
        verify(mockWorkspaceRepository.createWorkspace(any)).called(2);
      });
    });

    group('Performance and Scalability', () {
      testWidgets('Handle multiple workspace operations efficiently', (tester) async {
        // Arrange
        final workspaces = List.generate(10, (index) => Workspace(
          id: 'workspace_$index',
          name: 'Workspace $index',
          type: WorkspaceType.company,
          createdBy: 'test_user_id',
          createdAt: DateTime.now(),
          isActive: true,
        ));

        when(mockWorkspaceRepository.getUserWorkspaces(any))
            .thenAnswer((_) async => Right(workspaces));

        when(mockWorkspaceRepository.switchWorkspace(any, any))
            .thenAnswer((_) async => const Right(null));

        // Act
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        // Simulate authenticated user
        authController.setAuthenticatedUser('test_user_id', 'test@example.com', 'Test User');
        await tester.pumpAndSettle();

        // Load many workspaces
        await workspaceController.loadUserWorkspaces();
        await tester.pumpAndSettle();

        // Switch between multiple workspaces quickly
        for (int i = 0; i < 5; i++) {
          await workspaceController.switchWorkspace('workspace_$i');
          await tester.pump();
        }

        // Assert - Performance maintained
        verify(mockWorkspaceRepository.getUserWorkspaces(any)).called(1);
        verify(mockWorkspaceRepository.switchWorkspace(any, any)).called(5);
        
        // UI should still be responsive
        expect(find.byKey(const Key('workspace_selector')), findsOneWidget);
      });
    });
  });
}
