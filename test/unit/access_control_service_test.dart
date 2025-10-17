import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart' as m;
import 'package:mockito/annotations.dart';
import 'package:todolist/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:todolist/features/workspace/domain/services/access_control_service.dart';
import 'package:dartz/dartz.dart';
import 'package:todolist/core/errors/failures.dart';

@GenerateNiceMocks([
  MockSpec<WorkspaceRepository>(as: #MockWorkspaceRepository),
])
import 'access_control_service_test.mocks.dart';

void main() {
  group('AccessControlService', () {
    late MockWorkspaceRepository repo;
    late AccessControlService service;

    setUp(() {
      repo = MockWorkspaceRepository();
      service = AccessControlService(
        workspaceRepository: repo,
        currentUserIdProvider: () => 'u1',
        currentWorkspaceIdProvider: () => 'w1',
      );
    });

    test('has returns true when repository allows', () async {
      m.when(repo.hasPermission(m.any, m.any, m.any))
          .thenAnswer((_) async => const Right(true));
      final allowed = await service.has('p1');
      expect(allowed, isTrue);
    });

    test('ensure throws when denied', () async {
      m.when(repo.hasPermission(m.any, m.any, m.any))
          .thenAnswer((_) async => const Right(false));
      expect(() => service.ensure('p1'), throwsA(isA<Failure>()));
    });
  });
}


