import 'package:todolist/features/auth/domain/entities/company.dart';

class CompanyTestFixtures {
  static Company createCompany({
    String? id,
    String? name,
    String? description,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return Company(
      id: id ?? 'test-company-id',
      name: name ?? 'Test Company',
      description: description ?? 'Test Description',
      createdBy: createdBy ?? 'test-user-id',
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  static Company createPersonalWorkspace({
    String? id,
    String? userName,
    String? createdBy,
  }) {
    return createCompany(
      id: id,
      name: 'Personal Workspace for $userName',
      description: 'Personal workspace',
      createdBy: createdBy,
    );
  }

  static Company createCompanyWithLongName({
    String? id,
    String? createdBy,
  }) {
    return createCompany(
      id: id,
      name: 'A' * 1000, // Very long name
      createdBy: createdBy,
    );
  }

  static Company createCompanyWithSpecialCharacters({
    String? id,
    String? createdBy,
  }) {
    return createCompany(
      id: id,
      name: 'Test Company with Special Characters !@#\$%^&*()',
      description: 'Description with special characters: áéíóú',
      createdBy: createdBy,
    );
  }

  static List<Company> createCompanyList({
    int count = 3,
    String? createdBy,
  }) {
    return List.generate(count, (index) => createCompany(
      id: 'test-company-id-$index',
      name: 'Test Company $index',
      createdBy: createdBy,
    ));
  }

  static Company createInvalidCompany() {
    return Company(
      id: '', // Invalid empty ID
      name: '', // Invalid empty name
      description: '', // Invalid empty description
      createdBy: '', // Invalid empty createdBy
      createdAt: DateTime.now(),
    );
  }

  static Company createCompanyWithEmptyDescription({
    String? id,
    String? name,
    String? createdBy,
  }) {
    return createCompany(
      id: id,
      name: name,
      description: '', // Empty description
      createdBy: createdBy,
    );
  }

  static Company createCompanyWithNullDescription({
    String? id,
    String? name,
    String? createdBy,
  }) {
    return Company(
      id: id ?? 'test-company-id',
      name: name ?? 'Test Company',
      description: null, // Null description
      createdBy: createdBy ?? 'test-user-id',
      createdAt: DateTime.now(),
    );
  }
}
