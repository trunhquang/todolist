import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart' as m;
import 'package:mockito/annotations.dart';
import 'package:todolist/features/workspace/presentation/controllers/workspace_controller.dart';
import 'package:todolist/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:todolist/features/workspace/domain/entities/workspace.dart';

@GenerateNiceMocks([
  MockSpec<WorkspaceRepository>(as: #MockWorkspaceRepository),
])
import 'permission_validation_integration_test.mocks.dart';

void main() {
  group('Integration: permission validation', () {
    late MockWorkspaceRepository repo;
    late WorkspaceController controller;

    setUp(() {
      repo = MockWorkspaceRepository();
      controller = WorkspaceController(workspaceRepository: repo);
      // Seed current workspace
      controller.currentWorkspace.value = Workspace(
        id: 'w1',
        name: 'W',
        type: WorkspaceType.company,
        createdBy: 'u1',
        createdAt: DateTime.now(),
      );
    });

    test('inviteUserToWorkspace blocks without invite_users permission', () async {
      m.when(repo.hasPermission(m.any, 'w1', m.any))
          .thenAnswer((_) async => const Right(false));
      await controller.inviteUserToWorkspace('x@example.com');
      // Expect no repo.addMember calls
      m.verifyNever(repo.addMember(m.any));
    });

    test('grantPermission blocks without assign_permissions', () async {
      m.when(repo.hasPermission(m.any, 'w1', m.any))
          .thenAnswer((_) async => const Right(false));
      await controller.grantPermission('u2', 'p');
      m.verifyNever(repo.updateMemberPermissions(m.any, m.any, m.any));
    });
  });
}


