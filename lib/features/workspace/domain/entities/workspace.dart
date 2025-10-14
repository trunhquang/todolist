import 'package:meta/meta.dart';

/// Workspace entity following V1 architecture
/// Supports both personal and company workspaces
@immutable
class Workspace {
  const Workspace({
    required this.id,
    required this.name,
    required this.type,
    required this.createdBy,
    required this.createdAt,
    this.description,
    this.logoUrl,
    this.updatedAt,
    this.isActive = true,
    this.settings,
  });

  /// Create from map
  factory Workspace.fromMap(Map<String, dynamic> map) {
    return Workspace(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      type: WorkspaceType.fromString(map['type']?.toString() ?? 'personal'),
      description: map['description']?.toString(),
      logoUrl: map['logoUrl']?.toString(),
      createdBy: map['createdBy']?.toString() ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] is int ? map['createdAt'] as int : 0,
      ),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['updatedAt'] is int ? map['updatedAt'] as int : 0,
            )
          : null,
      isActive: (map['isActive'] as bool?) ?? true,
      settings: map['settings'] is Map<String, dynamic>
          ? map['settings'] as Map<String, dynamic>
          : null,
    );
  }

  final String id;
  final String name;
  final WorkspaceType type;
  final String? description;
  final String? logoUrl;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final Map<String, dynamic>? settings;

  /// Copy with method
  Workspace copyWith({
    String? id,
    String? name,
    WorkspaceType? type,
    String? description,
    String? logoUrl,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    Map<String, dynamic>? settings,
  }) {
    return Workspace(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description,
      logoUrl: logoUrl,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt,
      isActive: isActive ?? this.isActive,
      settings: settings,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.value,
      'description': description,
      'logoUrl': logoUrl,
      'createdBy': createdBy,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'isActive': isActive,
      'settings': settings,
    };
  }

  /// Equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Workspace &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.description == description &&
        other.logoUrl == logoUrl &&
        other.createdBy == createdBy &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        type.hashCode ^
        description.hashCode ^
        logoUrl.hashCode ^
        createdBy.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        isActive.hashCode;
  }

  @override
  String toString() {
    return 'Workspace(id: $id, name: $name, type: $type, createdBy: $createdBy, isActive: $isActive)';
  }

  /// Helper methods
  String get displayName => name;

  String get initials {
    if (name.isEmpty) return 'W';
    final nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return nameParts[0][0].toUpperCase();
  }

  bool get hasLogo => logoUrl != null && logoUrl!.isNotEmpty;

  bool get hasDescription => description != null && description!.isNotEmpty;

  bool get isPersonal => type == WorkspaceType.personal;

  bool get isCompany => type == WorkspaceType.company;
}

/// Workspace type enum
enum WorkspaceType {
  personal('personal'),
  company('company');

  const WorkspaceType(this.value);

  final String value;

  static WorkspaceType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'personal':
        return WorkspaceType.personal;
      case 'company':
        return WorkspaceType.company;
      default:
        return WorkspaceType.personal;
    }
  }

  String get displayName {
    switch (this) {
      case WorkspaceType.personal:
        return 'Personal';
      case WorkspaceType.company:
        return 'Company';
    }
  }
}
