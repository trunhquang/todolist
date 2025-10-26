import 'package:flutter_test/flutter_test.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';

void main() {
  group('Workspace Entity Simple Tests', () {
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

    group('Constructor and Properties', () {
      test('should create workspace with all required properties', () {
        expect(workspace.id, equals('test-workspace-id'));
        expect(workspace.name, equals('Test Workspace'));
        expect(workspace.type, equals(WorkspaceType.company));
        expect(workspace.createdBy, equals('test-user-id'));
        expect(workspace.createdAt, equals(DateTime.parse('2024-01-01T00:00:00Z')));
        expect(workspace.description, equals('Test workspace description'));
        expect(workspace.isActive, isTrue);
      });

      test('should create workspace with minimal required properties', () {
        final minimalWorkspace = Workspace(
          id: 'minimal-id',
          name: 'Minimal Workspace',
          type: WorkspaceType.personal,
          createdBy: 'user-id',
          createdAt: DateTime.now(),
        );

        expect(minimalWorkspace.id, equals('minimal-id'));
        expect(minimalWorkspace.name, equals('Minimal Workspace'));
        expect(minimalWorkspace.type, equals(WorkspaceType.personal));
        expect(minimalWorkspace.description, isNull);
        expect(minimalWorkspace.logoUrl, isNull);
        expect(minimalWorkspace.updatedAt, isNull);
        expect(minimalWorkspace.settings, isNull);
        expect(minimalWorkspace.isActive, isTrue);
      });
    });

    group('Equality and HashCode', () {
      test('should be equal when all properties are the same', () {
        final sameWorkspace = Workspace(
          id: 'test-workspace-id',
          name: 'Test Workspace',
          type: WorkspaceType.company,
          createdBy: 'test-user-id',
          createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
          description: 'Test workspace description',
        );

        expect(workspace, equals(sameWorkspace));
        expect(workspace.hashCode, equals(sameWorkspace.hashCode));
      });

      test('should not be equal when properties differ', () {
        final differentWorkspace = Workspace(
          id: 'different-id',
          name: 'Different Workspace',
          type: WorkspaceType.personal,
          createdBy: 'different-user-id',
          createdAt: DateTime.parse('2024-01-02T00:00:00Z'),
        );

        expect(workspace, isNot(equals(differentWorkspace)));
        expect(workspace.hashCode, isNot(equals(differentWorkspace.hashCode)));
      });
    });

    group('copyWith Method', () {
      test('should create copy with updated properties', () {
        final updatedWorkspace = workspace.copyWith(
          name: 'Updated Workspace',
          description: 'Updated description',
          isActive: false,
        );

        expect(updatedWorkspace.id, equals(workspace.id));
        expect(updatedWorkspace.name, equals('Updated Workspace'));
        expect(updatedWorkspace.description, equals('Updated description'));
        expect(updatedWorkspace.isActive, isFalse);
        expect(updatedWorkspace.type, equals(workspace.type));
        expect(updatedWorkspace.createdBy, equals(workspace.createdBy));
      });

      test('should create copy with null values', () {
        final nulledWorkspace = workspace.copyWith(
          
        );

        expect(nulledWorkspace.description, isNull);
        expect(nulledWorkspace.logoUrl, isNull);
        expect(nulledWorkspace.settings, isNull);
        expect(nulledWorkspace.name, equals(workspace.name));
      });

      test('should preserve original when no changes', () {
        final unchangedWorkspace = workspace.copyWith();

        expect(unchangedWorkspace, isNot(same(workspace)));
        expect(unchangedWorkspace.id, equals(workspace.id));
        expect(unchangedWorkspace.name, equals(workspace.name));
      });
    });

    group('toMap Method', () {
      test('should convert workspace to map with all properties', () {
        final map = workspace.toMap();

        expect(map['id'], equals('test-workspace-id'));
        expect(map['name'], equals('Test Workspace'));
        expect(map['type'], equals('company'));
        expect(map['createdBy'], equals('test-user-id'));
        expect(map['description'], equals('Test workspace description'));
        expect(map['isActive'], isTrue);
        expect(map['createdAt'], isA<int>());
      });

      test('should handle null values in map', () {
        final minimalWorkspace = Workspace(
          id: 'minimal-id',
          name: 'Minimal Workspace',
          type: WorkspaceType.personal,
          createdBy: 'user-id',
          createdAt: DateTime.now(),
        );

        final map = minimalWorkspace.toMap();

        expect(map['description'], isNull);
        expect(map['logoUrl'], isNull);
        expect(map['updatedAt'], isNull);
        expect(map['settings'], isNull);
      });
    });

    group('fromMap Method', () {
      test('should create workspace from map', () {
        final map = {
          'id': 'from-map-id',
          'name': 'From Map Workspace',
          'type': 'company',
          'createdBy': 'map-user-id',
          'createdAt': '2024-01-01T00:00:00Z',
          'description': 'From map description',
          'isActive': true,
        };

        final fromMapWorkspace = Workspace.fromMap(map);

        expect(fromMapWorkspace.id, equals('from-map-id'));
        expect(fromMapWorkspace.name, equals('From Map Workspace'));
        expect(fromMapWorkspace.type, equals(WorkspaceType.company));
        expect(fromMapWorkspace.createdBy, equals('map-user-id'));
        expect(fromMapWorkspace.description, equals('From map description'));
        expect(fromMapWorkspace.isActive, isTrue);
      });

      test('should handle missing optional fields', () {
        final map = {
          'id': 'minimal-map-id',
          'name': 'Minimal Map Workspace',
          'type': 'personal',
          'createdBy': 'minimal-user-id',
          'createdAt': '2024-01-01T00:00:00Z',
        };

        final fromMapWorkspace = Workspace.fromMap(map);

        expect(fromMapWorkspace.id, equals('minimal-map-id'));
        expect(fromMapWorkspace.name, equals('Minimal Map Workspace'));
        expect(fromMapWorkspace.type, equals(WorkspaceType.personal));
        expect(fromMapWorkspace.description, isNull);
        expect(fromMapWorkspace.settings, isNull);
      });
    });

    group('Workspace Type Tests', () {
      test('should handle personal workspace type', () {
        final personalWorkspace = workspace.copyWith(type: WorkspaceType.personal);
        expect(personalWorkspace.type, equals(WorkspaceType.personal));
      });

      test('should handle company workspace type', () {
        final companyWorkspace = workspace.copyWith(type: WorkspaceType.company);
        expect(companyWorkspace.type, equals(WorkspaceType.company));
      });
    });

    group('Validation Tests', () {
      test('should allow empty workspace name', () {
        final workspace = Workspace(
          id: 'test-id',
          name: '',
          type: WorkspaceType.company,
          createdBy: 'user-id',
          createdAt: DateTime.now(),
        );
        expect(workspace.name, equals(''));
      });

      test('should allow empty workspace ID', () {
        final workspace = Workspace(
          id: '',
          name: 'Test Workspace',
          type: WorkspaceType.company,
          createdBy: 'user-id',
          createdAt: DateTime.now(),
        );
        expect(workspace.id, equals(''));
      });

      test('should allow empty createdBy', () {
        final workspace = Workspace(
          id: 'test-id',
          name: 'Test Workspace',
          type: WorkspaceType.company,
          createdBy: '',
          createdAt: DateTime.now(),
        );
        expect(workspace.createdBy, equals(''));
      });
    });

    group('Business Logic Tests', () {
      test('should check if workspace has description', () {
        expect(workspace.hasDescription, isTrue);
        
        final noDescriptionWorkspace = workspace.copyWith();
        expect(noDescriptionWorkspace.hasDescription, isFalse);
      });

      test('should get display name', () {
        expect(workspace.displayName, equals('Test Workspace'));
        
        final noNameWorkspace = workspace.copyWith(name: '');
        expect(noNameWorkspace.displayName, equals(''));
      });
    });
  });
}
