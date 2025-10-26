import 'package:flutter_test/flutter_test.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';

void main() {
  group('Workspace Entity Tests', () {
    late Workspace workspace;

    setUp(() {
      workspace = Workspace(
        id: 'test-workspace-id',
        name: 'Test Workspace',
        type: WorkspaceType.company,
        createdBy: 'test-user-id',
        createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
        description: 'Test workspace description',
      );
    });

    test('should create workspace from map', () {
      // Arrange
      final map = {
        'id': 'test-workspace-id',
        'name': 'Test Workspace',
        'type': 'company',
        'createdBy': 'test-user-id',
        'createdAt': 1704067200000, // 2024-01-01T00:00:00Z
        'description': 'Test workspace description',
        'isActive': true,
      };

      // Act
      final result = Workspace.fromMap(map);

      // Assert
      expect(result.id, equals('test-workspace-id'));
      expect(result.name, equals('Test Workspace'));
      expect(result.type, equals(WorkspaceType.company));
      expect(result.createdBy, equals('test-user-id'));
      expect(result.description, equals('Test workspace description'));
      expect(result.isActive, equals(true));
    });

    test('should convert workspace to map', () {
      // Act
      final result = workspace.toMap();

      // Assert
      expect(result['id'], equals('test-workspace-id'));
      expect(result['name'], equals('Test Workspace'));
      expect(result['type'], equals('company'));
      expect(result['createdBy'], equals('test-user-id'));
      expect(result['description'], equals('Test workspace description'));
      expect(result['isActive'], equals(true));
    });

    test('should copy workspace with new values', () {
      // Act
      final result = workspace.copyWith(
        name: 'Updated Workspace',
        description: 'Updated description',
      );

      // Assert
      expect(result.id, equals(workspace.id));
      expect(result.name, equals('Updated Workspace'));
      expect(result.description, equals('Updated description'));
      expect(result.type, equals(workspace.type));
      expect(result.createdBy, equals(workspace.createdBy));
    });

    test('should return correct display name', () {
      // Act
      final result = workspace.displayName;

      // Assert
      expect(result, equals('Test Workspace'));
    });

    test('should return correct initials', () {
      // Act
      final result = workspace.initials;

      // Assert
      expect(result, equals('TW'));
    });

    test('should return correct initials for single word', () {
      // Arrange
      final singleWordWorkspace = workspace.copyWith(name: 'Test');

      // Act
      final result = singleWordWorkspace.initials;

      // Assert
      expect(result, equals('T'));
    });

    test('should return correct workspace type checks', () {
      // Act & Assert
      expect(workspace.isCompany, equals(true));
      expect(workspace.isPersonal, equals(false));
    });

    test('should return correct hasDescription check', () {
      // Act & Assert
      expect(workspace.hasDescription, equals(true));

      // Test with null description
      final workspaceWithoutDescription = workspace.copyWith();
      expect(workspaceWithoutDescription.hasDescription, equals(false));
    });

    test('should return correct hasLogo check', () {
      // Act & Assert
      expect(workspace.hasLogo, equals(false));

      // Test with logo URL
      final workspaceWithLogo = workspace.copyWith(logoUrl: 'https://example.com/logo.png');
      expect(workspaceWithLogo.hasLogo, equals(true));
    });

    test('should support equality comparison', () {
      // Arrange
      final sameWorkspace = Workspace(
        id: 'test-workspace-id',
        name: 'Test Workspace',
        type: WorkspaceType.company,
        createdBy: 'test-user-id',
        createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
        description: 'Test workspace description',
      );

      // Act & Assert
      expect(workspace, equals(sameWorkspace));
      expect(workspace.hashCode, equals(sameWorkspace.hashCode));
    });

    test('should return correct string representation', () {
      // Act
      final result = workspace.toString();

      // Assert
      expect(result, contains('test-workspace-id'));
      expect(result, contains('Test Workspace'));
      expect(result, contains('company'));
    });
  });

  group('WorkspaceType Tests', () {
    test('should create WorkspaceType from string', () {
      // Act & Assert
      expect(WorkspaceType.fromString('personal'), equals(WorkspaceType.personal));
      expect(WorkspaceType.fromString('company'), equals(WorkspaceType.company));
      expect(WorkspaceType.fromString('invalid'), equals(WorkspaceType.personal)); // default
    });

    test('should return correct display names', () {
      // Act & Assert
      expect(WorkspaceType.personal.displayName, equals('Personal'));
      expect(WorkspaceType.company.displayName, equals('Company'));
    });

    test('should return correct values', () {
      // Act & Assert
      expect(WorkspaceType.personal.value, equals('personal'));
      expect(WorkspaceType.company.value, equals('company'));
    });
  });
}
