import 'package:todolist/features/auth/domain/entities/company.dart';

class CompanyFixtures {
  static Company createTestCompany({
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
      (index) => createTestCompany(
        id: 'test-company-id-${index + 1}',
        name: 'Test Company ${index + 1}',
        createdBy: createdBy,
      ),
    );
  }
}