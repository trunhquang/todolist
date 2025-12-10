import 'package:todolist/app/widgets/td_chip.dart';
import 'package:todolist/features/tasks/domain/entities/project_status.dart';

TDChipType projectStatusChipType(ProjectStatus? status) {
  switch (status) {
    case ProjectStatus.inProgress:
      return TDChipType.info;
    case ProjectStatus.completed:
      return TDChipType.success;
    case ProjectStatus.cancelled:
      return TDChipType.error;
    case ProjectStatus.pending:
      return TDChipType.secondary;
    case null:
      return TDChipType.primary;
  }
}

