import 'package:meta/meta.dart';

@immutable
class User {
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.companyId,
    required this.createdAt,
    this.profileImageUrl,
    this.departmentId,
    this.managerUserId,
    this.invitedByUserId,
    this.mustChangePassword = false,
    this.lastLoginAt,
    this.isActive = true,
    this.preferences,
  });

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
      managerUserId: map['managerUserId']?.toString(),
      invitedByUserId: map['invitedByUserId']?.toString(),
      mustChangePassword: (map['mustChangePassword'] as bool?) ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] is int ? map['createdAt'] as int : 0),
      lastLoginAt: map['lastLoginAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastLoginAt'] is int ? map['lastLoginAt'] as int : 0)
          : null,
      isActive: (map['isActive'] as bool?) ?? true,
      preferences: map['preferences'] is Map<String, dynamic> ? map['preferences'] as Map<String, dynamic> : null,
    );
  }
  // Copy with method
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImageUrl,
    String? role,
    String? companyId,
    String? departmentId,
    String? managerUserId,
    String? invitedByUserId,
    bool? mustChangePassword,
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
      managerUserId: managerUserId ?? this.managerUserId,
      invitedByUserId: invitedByUserId ?? this.invitedByUserId,
      mustChangePassword: mustChangePassword ?? this.mustChangePassword,
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
      'managerUserId': managerUserId,
      'invitedByUserId': invitedByUserId,
      'mustChangePassword': mustChangePassword,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastLoginAt': lastLoginAt?.millisecondsSinceEpoch,
      'isActive': isActive,
      'preferences': preferences,
    };
  }


  final String id;
  final String email;
  final String name;
  final String? profileImageUrl;
  final String role;
  final String companyId;
  final String? departmentId;
  final String? managerUserId; // direct manager for hierarchy
  final String? invitedByUserId; // who invited this user
  final bool mustChangePassword; // require password change on first login
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isActive;
  final Map<String, dynamic>? preferences;

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
  bool get isAdmin => role == 'admin';
  bool get isDepartmentManager => role == 'user_level_0';
  bool get isTeamLead => role == 'user_level_1';
  bool get isRegularUser => role == 'user_level_2';
  
  // Legacy support
  bool get isCompanyAdmin => role == 'admin';
  bool get isDepartmentAdmin => role == 'user_level_0';
  
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
