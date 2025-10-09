import 'package:meta/meta.dart';

@immutable
class ReportEntity {
  const ReportEntity({
    required this.id,
    required this.userId,
    required this.companyId,
    this.departmentId,
    required this.date,
    required this.summary,
    this.completedTaskIds = const <String>[],
    this.createdAt,
    this.submittedAt,
    this.status = ReportStatus.draft,
    this.metrics,
  });

  factory ReportEntity.fromMap(Map<dynamic, dynamic> map) {
    return ReportEntity(
      id: (map['id'] as String?) ?? '',
      userId: (map['userId'] as String?) ?? '',
      companyId: (map['companyId'] as String?) ?? '',
      departmentId: map['departmentId'] as String?,
      date: DateTime.fromMillisecondsSinceEpoch((map['date'] as int?) ?? 0),
      summary: (map['summary'] as String?) ?? '',
      completedTaskIds: (map['completedTaskIds'] as List<dynamic>?)?.cast<String>() ?? const <String>[],
      createdAt: (map['createdAt'] as int?) != null ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int) : null,
      submittedAt: (map['submittedAt'] as int?) != null ? DateTime.fromMillisecondsSinceEpoch(map['submittedAt'] as int) : null,
      status: _statusFromString(map['status'] as String?),
      metrics: (map['metrics'] as Map<dynamic, dynamic>?)?.cast<String, dynamic>(),
    );
  }

  final String id;
  final String userId;
  final String companyId;
  final String? departmentId;
  final DateTime date;
  final String summary;
  final List<String> completedTaskIds;
  final DateTime? createdAt;
  final DateTime? submittedAt;
  final ReportStatus status;
  final Map<String, dynamic>? metrics;

  ReportEntity copyWith({
    String? id,
    String? userId,
    String? companyId,
    String? departmentId,
    DateTime? date,
    String? summary,
    List<String>? completedTaskIds,
    DateTime? createdAt,
    DateTime? submittedAt,
    ReportStatus? status,
    Map<String, dynamic>? metrics,
  }) {
    return ReportEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      companyId: companyId ?? this.companyId,
      departmentId: departmentId ?? this.departmentId,
      date: date ?? this.date,
      summary: summary ?? this.summary,
      completedTaskIds: completedTaskIds ?? this.completedTaskIds,
      createdAt: createdAt ?? this.createdAt,
      submittedAt: submittedAt ?? this.submittedAt,
      status: status ?? this.status,
      metrics: metrics ?? this.metrics,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'companyId': companyId,
      'departmentId': departmentId,
      'date': date.millisecondsSinceEpoch,
      'summary': summary,
      'completedTaskIds': completedTaskIds,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'submittedAt': submittedAt?.millisecondsSinceEpoch,
      'status': status.name,
      'metrics': metrics,
    };
  }
}

enum ReportStatus { draft, submitted }

ReportStatus _statusFromString(String? value) {
  switch (value) {
    case 'submitted':
      return ReportStatus.submitted;
    case 'draft':
    default:
      return ReportStatus.draft;
  }
}



