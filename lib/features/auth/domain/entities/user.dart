class User {
  final String id;
  final String email;
  final String name;
  final String? profileImageUrl;
  final String role;
  final String companyId;
  final String? departmentId;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isActive;
  final Map<String, dynamic>? preferences;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.profileImageUrl,
    required this.role,
    required this.companyId,
    this.departmentId,
    required this.createdAt,
    this.lastLoginAt,
    this.isActive = true,
    this.preferences,
  });

  // Copy with method
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImageUrl,
    String? role,
    String? companyId,
    String? departmentId,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isActive,
    Map<String, dynamic>? preferences,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      companyId: companyId ?? this.companyId,
      departmentId: departmentId ?? this.departmentId,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isActive: isActive ?? this.isActive,
      preferences: preferences ?? this.preferences,
    );
  }

  // Convert to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'role': role,
      'companyId': companyId,
      'departmentId': departmentId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastLoginAt': lastLoginAt?.millisecondsSinceEpoch,
      'isActive': isActive,
      'preferences': preferences,
    };
  }

  // Create from map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      profileImageUrl: map['profileImageUrl']?.toString(),
      role: map['role']?.toString() ?? '',
      companyId: map['companyId']?.toString() ?? '',
      departmentId: map['departmentId']?.toString(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] is int ? map['createdAt'] as int : 0),
      lastLoginAt: map['lastLoginAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastLoginAt'] is int ? map['lastLoginAt'] as int : 0)
          : null,
      isActive: map['isActive'] is bool ? map['isActive'] as bool : true,
      preferences: map['preferences'] is Map<String, dynamic> ? map['preferences'] as Map<String, dynamic> : null,
    );
  }

  // Equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.profileImageUrl == profileImageUrl &&
        other.role == role &&
        other.companyId == companyId &&
        other.departmentId == departmentId &&
        other.createdAt == createdAt &&
        other.lastLoginAt == lastLoginAt &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        name.hashCode ^
        profileImageUrl.hashCode ^
        role.hashCode ^
        companyId.hashCode ^
        departmentId.hashCode ^
        createdAt.hashCode ^
        lastLoginAt.hashCode ^
        isActive.hashCode;
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, role: $role, companyId: $companyId, departmentId: $departmentId, isActive: $isActive)';
  }

  // Helper methods
  bool get isCompanyAdmin => role == 'company_admin';
  bool get isDepartmentAdmin => role == 'department_admin';
  bool get isRegularUser => role == 'user';
  
  bool get hasDepartment => departmentId != null && departmentId!.isNotEmpty;
  
  String get displayName => name.isNotEmpty ? name : email;
  
  String get initials {
    if (name.isEmpty) return email.substring(0, 1).toUpperCase();
    final nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return nameParts[0][0].toUpperCase();
  }
}
