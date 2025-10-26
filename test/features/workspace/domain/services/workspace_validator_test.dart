import 'package:flutter_test/flutter_test.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_settings.dart';
import 'package:todolist/features/workspace/domain/services/workspace_validator.dart';

void main() {
  group('WorkspaceValidator Tests', () {
    group('validateWorkspaceName', () {
      test('should return null for valid workspace name', () {
        // Act
        final result = WorkspaceValidator.validateWorkspaceName('Valid Workspace');

        // Assert
        expect(result, isNull);
      });

      test('should return error for null workspace name', () {
        // Act
        final result = WorkspaceValidator.validateWorkspaceName(null);

        // Assert
        expect(result, equals('Workspace name is required'));
      });

      test('should return error for empty workspace name', () {
        // Act
        final result = WorkspaceValidator.validateWorkspaceName('');

        // Assert
        expect(result, equals('Workspace name is required'));
      });

      test('should return error for short workspace name', () {
        // Act
        final result = WorkspaceValidator.validateWorkspaceName('A');

        // Assert
        expect(result, equals('Workspace name must be at least 2 characters'));
      });

      test('should return error for long workspace name', () {
        // Act
        final result = WorkspaceValidator.validateWorkspaceName('A' * 51);

        // Assert
        expect(result, equals('Workspace name must be less than 50 characters'));
      });

      test('should return error for workspace name with invalid characters', () {
        // Act
        final result = WorkspaceValidator.validateWorkspaceName('Invalid<Name>');

        // Assert
        expect(result, equals('Workspace name contains invalid characters'));
      });
    });

    group('validateWorkspaceDescription', () {
      test('should return null for valid description', () {
        // Act
        final result = WorkspaceValidator.validateWorkspaceDescription('Valid description');

        // Assert
        expect(result, isNull);
      });

      test('should return null for null description', () {
        // Act
        final result = WorkspaceValidator.validateWorkspaceDescription(null);

        // Assert
        expect(result, isNull);
      });

      test('should return null for empty description', () {
        // Act
        final result = WorkspaceValidator.validateWorkspaceDescription('');

        // Assert
        expect(result, isNull);
      });

      test('should return error for long description', () {
        // Act
        final result = WorkspaceValidator.validateWorkspaceDescription('A' * 501);

        // Assert
        expect(result, equals('Description must be less than 500 characters'));
      });
    });

    group('validateWorkspaceSettings', () {
      test('should return null for valid settings', () {
        // Arrange
        const settings = WorkspaceSettings(
          
        );

        // Act
        final result = WorkspaceValidator.validateWorkspaceSettings(settings);

        // Assert
        expect(result, isNull);
      });

      test('should return error for invalid timezone', () {
        // Arrange
        const settings = WorkspaceSettings(
          timezone: 'INVALID',
        );

        // Act
        final result = WorkspaceValidator.validateWorkspaceSettings(settings);

        // Assert
        expect(result, equals('Invalid timezone'));
      });

      test('should return error for invalid language', () {
        // Arrange
        const settings = WorkspaceSettings(
          language: 'invalid',
        );

        // Act
        final result = WorkspaceValidator.validateWorkspaceSettings(settings);

        // Assert
        expect(result, equals('Invalid language'));
      });
    });

    group('validateLogoUrl', () {
      test('should return null for valid logo URL', () {
        // Act
        final result = WorkspaceValidator.validateLogoUrl('https://example.com/logo.png');

        // Assert
        expect(result, isNull);
      });

      test('should return null for null logo URL', () {
        // Act
        final result = WorkspaceValidator.validateLogoUrl(null);

        // Assert
        expect(result, isNull);
      });

      test('should return null for empty logo URL', () {
        // Act
        final result = WorkspaceValidator.validateLogoUrl('');

        // Assert
        expect(result, isNull);
      });

      test('should return error for invalid logo URL', () {
        // Act
        final result = WorkspaceValidator.validateLogoUrl('invalid-url');

        // Assert
        expect(result, equals('Invalid logo URL format'));
      });
    });

    group('validateWorkspaceType', () {
      test('should return null for valid workspace types', () {
        // Act & Assert
        expect(WorkspaceValidator.validateWorkspaceType(WorkspaceType.personal), isNull);
        expect(WorkspaceValidator.validateWorkspaceType(WorkspaceType.company), isNull);
      });
    });

    group('validateWorkspace', () {
      test('should return empty list for valid workspace', () {
        // Arrange
        final workspace = Workspace(
          id: 'test-id',
          name: 'Valid Workspace',
          type: WorkspaceType.company,
          createdBy: 'user-id',
          createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
        );

        // Act
        final result = WorkspaceValidator.validateWorkspace(workspace);

        // Assert
        expect(result, isEmpty);
      });

      test('should return errors for invalid workspace', () {
        // Arrange
        final workspace = Workspace(
          id: 'test-id',
          name: 'A', // Too short
          type: WorkspaceType.company,
          createdBy: 'user-id',
          createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
        );

        // Act
        final result = WorkspaceValidator.validateWorkspace(workspace);

        // Assert
        expect(result, isNotEmpty);
        expect(result, contains('Workspace name must be at least 2 characters'));
      });
    });

    group('isWorkspaceNameAvailable', () {
      test('should return true for available name', () {
        // Arrange
        final existingWorkspaces = [
          Workspace(
            id: '1',
            name: 'Existing Workspace',
            type: WorkspaceType.company,
            createdBy: 'user-id',
            createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
          ),
        ];

        // Act
        final result = WorkspaceValidator.isWorkspaceNameAvailable(
          'New Workspace',
          existingWorkspaces,
        );

        // Assert
        expect(result, isTrue);
      });

      test('should return false for unavailable name', () {
        // Arrange
        final existingWorkspaces = [
          Workspace(
            id: '1',
            name: 'Existing Workspace',
            type: WorkspaceType.company,
            createdBy: 'user-id',
            createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
          ),
        ];

        // Act
        final result = WorkspaceValidator.isWorkspaceNameAvailable(
          'Existing Workspace',
          existingWorkspaces,
        );

        // Assert
        expect(result, isFalse);
      });

      test('should be case insensitive', () {
        // Arrange
        final existingWorkspaces = [
          Workspace(
            id: '1',
            name: 'Existing Workspace',
            type: WorkspaceType.company,
            createdBy: 'user-id',
            createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
          ),
        ];

        // Act
        final result = WorkspaceValidator.isWorkspaceNameAvailable(
          'EXISTING WORKSPACE',
          existingWorkspaces,
        );

        // Assert
        expect(result, isFalse);
      });
    });

    group('sanitizeWorkspaceName', () {
      test('should remove invalid characters', () {
        // Act
        final result = WorkspaceValidator.sanitizeWorkspaceName('Invalid<Name>');

        // Assert
        expect(result, equals('InvalidName'));
      });

      test('should trim whitespace', () {
        // Act
        final result = WorkspaceValidator.sanitizeWorkspaceName('  Valid Name  ');

        // Assert
        expect(result, equals('Valid Name'));
      });
    });

    group('generateWorkspaceSlug', () {
      test('should generate valid slug from name', () {
        // Act
        final result = WorkspaceValidator.generateWorkspaceSlug('My Test Workspace');

        // Assert
        expect(result, equals('my-test-workspace'));
      });

      test('should handle special characters', () {
        // Act
        final result = WorkspaceValidator.generateWorkspaceSlug('My@Test#Workspace!');

        // Assert
        expect(result, equals('mytestworkspace'));
      });

      test('should handle multiple spaces', () {
        // Act
        final result = WorkspaceValidator.generateWorkspaceSlug('My   Test   Workspace');

        // Assert
        expect(result, equals('my-test-workspace'));
      });
    });

    group('validateWorkspaceSlug', () {
      test('should return null for valid slug', () {
        // Act
        final result = WorkspaceValidator.validateWorkspaceSlug('valid-slug');

        // Assert
        expect(result, isNull);
      });

      test('should return error for empty slug', () {
        // Act
        final result = WorkspaceValidator.validateWorkspaceSlug('');

        // Assert
        expect(result, equals('Workspace slug cannot be empty'));
      });

      test('should return error for short slug', () {
        // Act
        final result = WorkspaceValidator.validateWorkspaceSlug('a');

        // Assert
        expect(result, equals('Workspace slug must be at least 2 characters'));
      });

      test('should return error for long slug', () {
        // Act
        final result = WorkspaceValidator.validateWorkspaceSlug('a' * 31);

        // Assert
        expect(result, equals('Workspace slug must be less than 30 characters'));
      });

      test('should return error for invalid characters', () {
        // Act
        final result = WorkspaceValidator.validateWorkspaceSlug('invalid_slug');

        // Assert
        expect(result, equals('Workspace slug can only contain lowercase letters, numbers, and hyphens'));
      });

      test('should return error for consecutive hyphens', () {
        // Act
        final result = WorkspaceValidator.validateWorkspaceSlug('invalid--slug');

        // Assert
        expect(result, equals('Workspace slug cannot contain consecutive hyphens'));
      });

      test('should return error for leading hyphen', () {
        // Act
        final result = WorkspaceValidator.validateWorkspaceSlug('-invalid-slug');

        // Assert
        expect(result, equals('Workspace slug cannot start or end with a hyphen'));
      });

      test('should return error for trailing hyphen', () {
        // Act
        final result = WorkspaceValidator.validateWorkspaceSlug('invalid-slug-');

        // Assert
        expect(result, equals('Workspace slug cannot start or end with a hyphen'));
      });
    });
  });
}
