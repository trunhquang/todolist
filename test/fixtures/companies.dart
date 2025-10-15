import 'package:todolist/features/auth/domain/entities/company.dart';

class CompanyTestFixtures {
  static Company createCompany({
    String id = 'test-company-id',
    String name = 'Test Company',
    String? description,
    String? logoUrl,
    String createdBy = 'test-user-id',
    DateTime? createdAt,
    DateTime? updatedAt,
    bool isActive = true,
    Map<String, dynamic>? settings,
  }) {
    return Company(
      id: id,
      name: name,
      description: description,
      logoUrl: logoUrl,
      createdBy: createdBy,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt,
      isActive: isActive,
      settings: settings,
    );
  }

  static List<Company> createTestCompanies({
    int count = 5,
    String createdBy = 'test-user-id',
  }) {
    return List.generate(
      count,
      (index) => createCompany(
        id: 'test-company-id-${index + 1}',
        name: 'Test Company ${index + 1}',
        createdBy: createdBy,
      ),
    );
  }

  static Company createPersonalWorkspace({
    String id = 'personal-workspace-id',
    String userId = 'test-user-id',
    String name = 'Personal Workspace',
    String? userName,
    String? createdBy,
  }) {
    return createCompany(
      id: id,
      name: name,
      createdBy: createdBy ?? userId,
      description: 'Personal workspace for ${userName ?? name}',
    );
  }

  static List<Company> createCompanyList({int count = 3}) {
    return createTestCompanies(count: count);
  }

  static Company createCompanyWithEmptyDescription({
    String id = 'test-company-id',
    String name = 'Test Company',
    String createdBy = 'test-user-id',
  }) {
    return createCompany(
      id: id,
      name: name,
      createdBy: createdBy,
      description: '',
    );
  }

  static Company createCompanyWithNullDescription({
    String id = 'test-company-id',
    String name = 'Test Company',
    String createdBy = 'test-user-id',
  }) {
    return createCompany(
      id: id,
      name: name,
      createdBy: createdBy,
      description: null,
    );
  }

  static Company createCompanyWithLongName() {
    return createCompany(
      name: 'A' * 255,
    );
  }

  static Company createCompanyWithSpecialCharacters() {
    return createCompany(
      name: 'Company @#\$%^&*()',
    );
  }
}