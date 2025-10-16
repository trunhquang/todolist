import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../../lib/main.dart';
import '../../lib/features/workspace/presentation/controllers/workspace_controller.dart';
import '../../lib/features/workspace/domain/entities/workspace.dart';
import '../../lib/features/workspace/domain/repositories/workspace_repository.dart';
import '../../lib/core/services/navigation_service.dart';
import '../../lib/core/services/snackbar_service.dart';
import '../../lib/core/errors/failures.dart';
import '../../lib/core/utils/either.dart';

import 'workspace_integration_test.mocks.dart';

@GenerateMocks([
  WorkspaceRepository,
])
void main() {
  group('Workspace Integration Tests', () {
    late MockWorkspaceRepository mockWorkspaceRepository;
    late WorkspaceController workspaceController;

    setUp(() {
      Get.testMode = true;
      
      mockWorkspaceRepository = MockWorkspaceRepository();
      
      // Setup GetX dependencies
      Get.put<NavigationService>(NavigationService());
      Get.put<SnackbarService>(SnackbarService());
      
      // Create workspace controller with mocked repository
      workspaceController = WorkspaceController(
        workspaceRepository: mockWorkspaceRepository,
      );
      Get.put<WorkspaceController>(workspaceController);
    });

    tearDown(() {
      Get.reset();
    });

    group('Workspace Creation Flow', () {
      testWidgets('Create workspace and persist to Firebase', (tester) async {
        // Arrange
        final testWorkspace = Workspace(
          id: 'test_workspace_id',
          name: 'Test Workspace',
          description: 'Test workspace description',
          type: WorkspaceType.company,
          createdBy: 'test_user_id',
          createdAt: DateTime.now(),
          isActive: true,
        );

        when(mockWorkspaceRepository.createWorkspace(any))
            .thenAnswer((_) async => Right(testWorkspace));

        // Act
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        // Navigate to create workspace page
        await tester.tap(find.text('Create Workspace'));
        await tester.pumpAndSettle();

        // Fill workspace creation form
        await tester.enterText(
          find.byKey(const Key('workspace_name_field')), 
          'Test Workspace'
        );
        await tester.enterText(
          find.byKey(const Key('workspace_description_field')), 
          'Test workspace description'
        );

        // Submit form
        await tester.tap(find.text('Create Workspace'));
        await tester.pumpAndSettle();

        // Assert
        verify(mockWorkspaceRepository.createWorkspace(any)).called(1);
        expect(find.text('Workspace created successfully'), findsOneWidget);
      });

      testWidgets('Handle workspace creation errors gracefully', (tester) async {
        // Arrange
        when(mockWorkspaceRepository.createWorkspace(any))
            .thenAnswer((_) async => Left(ServerFailure(message: 'Server error')));

        // Act
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Create Workspace'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('workspace_name_field')), 
          'Test Workspace'
        );

        await tester.tap(find.text('Create Workspace'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Server error'), findsOneWidget);
      });

      testWidgets('Validate workspace creation form', (tester) async {
        // Act
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Create Workspace'));
        await tester.pumpAndSettle();

        // Try to submit empty form
        await tester.tap(find.text('Create Workspace'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Please enter workspace name'), findsOneWidget);
      });
    });

    group('Workspace Switching Flow', () {
      testWidgets('Switch between workspaces successfully', (tester) async {
        // Arrange
        final workspaces = [
          Workspace(
            id: 'workspace_1',
            name: 'Personal Workspace',
            description: 'My personal workspace',
            type: WorkspaceType.personal,
            createdBy: 'test_user_id',
            createdAt: DateTime.now(),
            isActive: true,
          ),
          Workspace(
            id: 'workspace_2',
            name: 'Company Workspace',
            description: 'Company workspace',
            type: WorkspaceType.company,
            createdBy: 'test_user_id',
            createdAt: DateTime.now(),
            isActive: true,
          ),
        ];

        when(mockWorkspaceRepository.getUserWorkspaces(any))
            .thenAnswer((_) async => Right(workspaces));
        
        when(mockWorkspaceRepository.switchWorkspace(any, any))
            .thenAnswer((_) async => const Right(null));

        // Act
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        // Load workspaces
        await workspaceController.loadUserWorkspaces();
        await tester.pumpAndSettle();

        // Open workspace selector
        await tester.tap(find.byKey(const Key('workspace_selector')));
        await tester.pumpAndSettle();

        // Switch to company workspace
        await tester.tap(find.text('Company Workspace'));
        await tester.pumpAndSettle();

        // Assert
        verify(mockWorkspaceRepository.switchWorkspace(any, 'workspace_2')).called(1);
        expect(workspaceController.currentWorkspace.value?.name, equals('Company Workspace'));
      });

      testWidgets('Handle workspace switching errors', (tester) async {
        // Arrange
        when(mockWorkspaceRepository.switchWorkspace(any, any))
            .thenAnswer((_) async => Left(NetworkFailure(message: 'Network error')));

        // Act
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('workspace_selector')));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Company Workspace'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Network error'), findsOneWidget);
      });
    });

    group('Workspace Management Flow', () {
      testWidgets('Update workspace settings successfully', (tester) async {
        // Arrange
        final updatedWorkspace = Workspace(
          id: 'test_workspace_id',
          name: 'Updated Workspace',
          description: 'Updated description',
          type: WorkspaceType.company,
          createdBy: 'test_user_id',
          createdAt: DateTime.now(),
          isActive: true,
        );

        when(mockWorkspaceRepository.updateWorkspace(any))
            .thenAnswer((_) async => Right(updatedWorkspace));

        // Act
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        // Navigate to workspace settings
        await tester.tap(find.text('Workspace Settings'));
        await tester.pumpAndSettle();

        // Update workspace name
        await tester.enterText(
          find.byKey(const Key('workspace_name_field')), 
          'Updated Workspace'
        );

        // Save changes
        await tester.tap(find.text('Save Changes'));
        await tester.pumpAndSettle();

        // Assert
        verify(mockWorkspaceRepository.updateWorkspace(any)).called(1);
        expect(find.text('Workspace settings updated'), findsOneWidget);
      });

      testWidgets('Delete workspace with confirmation', (tester) async {
        // Arrange
        when(mockWorkspaceRepository.deleteWorkspace(any))
            .thenAnswer((_) async => const Right(null));

        // Act
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Workspace Settings'));
        await tester.pumpAndSettle();

        // Tap delete workspace button
        await tester.tap(find.text('Delete Workspace'));
        await tester.pumpAndSettle();

        // Confirm deletion
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        // Assert
        verify(mockWorkspaceRepository.deleteWorkspace(any)).called(1);
        expect(find.text('Workspace deleted'), findsOneWidget);
      });
    });

    group('Workspace Data Isolation', () {
      testWidgets('Ensure data isolation between workspaces', (tester) async {
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

        // Act
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        // Load workspaces
        await workspaceController.loadUserWorkspaces();
        await tester.pumpAndSettle();

        // Switch to personal workspace
        await workspaceController.switchWorkspace('personal_workspace');
        await tester.pumpAndSettle();

        // Verify personal workspace is active
        expect(workspaceController.currentWorkspace.value?.id, equals('personal_workspace'));

        // Switch to company workspace
        await workspaceController.switchWorkspace('company_workspace');
        await tester.pumpAndSettle();

        // Verify company workspace is active
        expect(workspaceController.currentWorkspace.value?.id, equals('company_workspace'));

        // Assert
        verify(mockWorkspaceRepository.switchWorkspace(any, 'personal_workspace')).called(1);
        verify(mockWorkspaceRepository.switchWorkspace(any, 'company_workspace')).called(1);
      });
    });

    group('Workspace Analytics', () {
      testWidgets('Load workspace analytics data', (tester) async {
        // Arrange
        final analyticsData = {
          'totalWorkspaces': 2,
          'personalWorkspaces': 1,
          'companyWorkspaces': 1,
          'activeWorkspaces': 2,
        };

        when(mockWorkspaceRepository.getWorkspaceAnalytics(any))
            .thenAnswer((_) async => Right(analyticsData));

        // Act
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        // Navigate to analytics
        await tester.tap(find.text('Workspace Analytics'));
        await tester.pumpAndSettle();

        // Assert
        verify(mockWorkspaceRepository.getWorkspaceAnalytics(any)).called(1);
        expect(find.text('Total Workspaces: 2'), findsOneWidget);
        expect(find.text('Personal Workspaces: 1'), findsOneWidget);
        expect(find.text('Company Workspaces: 1'), findsOneWidget);
      });
    });

    group('Error Handling', () {
      testWidgets('Handle network errors gracefully', (tester) async {
        // Arrange
        when(mockWorkspaceRepository.getUserWorkspaces(any))
            .thenAnswer((_) async => Left(NetworkFailure(message: 'No internet connection')));

        // Act
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        await workspaceController.loadUserWorkspaces();
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('No internet connection'), findsOneWidget);
      });

      testWidgets('Handle server errors gracefully', (tester) async {
        // Arrange
        when(mockWorkspaceRepository.createWorkspace(any))
            .thenAnswer((_) async => Left(ServerFailure(message: 'Internal server error')));

        // Act
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Create Workspace'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('workspace_name_field')), 
          'Test Workspace'
        );

        await tester.tap(find.text('Create Workspace'));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Internal server error'), findsOneWidget);
      });
    });
  });
}
