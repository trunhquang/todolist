class Company {
  final String id;
  final String name;
  final String? description;
  final String? logoUrl;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final Map<String, dynamic>? settings;

  const Company({
    required this.id,
    required this.name,
    this.description,
    this.logoUrl,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
    this.settings,
  });

  // Copy with method
  Company copyWith({
    String? id,
    String? name,
    String? description,
    String? logoUrl,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    Map<String, dynamic>? settings,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      settings: settings ?? this.settings,
    );
  }

  // Convert to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logoUrl': logoUrl,
      'createdBy': createdBy,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
      'isActive': isActive,
      'settings': settings,
    };
  }

  // Create from map
  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString(),
      logoUrl: map['logoUrl']?.toString(),
      createdBy: map['createdBy']?.toString() ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] is int ? map['createdAt'] as int : 0),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] is int ? map['updatedAt'] as int : 0)
          : null,
      isActive: map['isActive'] is bool ? map['isActive'] as bool : true,
      settings: map['settings'] is Map<String, dynamic> ? map['settings'] as Map<String, dynamic> : null,
    );
  }

  // Equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Company &&
        other.id == id &&
        other.name == name &&
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
        description.hashCode ^
        logoUrl.hashCode ^
        createdBy.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        isActive.hashCode;
  }

  @override
  String toString() {
    return 'Company(id: $id, name: $name, createdBy: $createdBy, isActive: $isActive)';
  }

  // Helper methods
  String get displayName => name;
  
  String get initials {
    if (name.isEmpty) return 'C';
    final nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return nameParts[0][0].toUpperCase();
  }
  
  bool get hasLogo => logoUrl != null && logoUrl!.isNotEmpty;
  
  bool get hasDescription => description != null && description!.isNotEmpty;
}
