import 'package:flutter/material.dart';

import '../../../../core/services/navigation_service.dart';
import '../../../../features/tasks/domain/entities/task.dart';
import '../../../routes/app_router.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/td_card.dart';


class ListTaskWidget extends StatelessWidget {
  const ListTaskWidget({
    super.key,
    required this.items,
    this.isScroll = false, // Mặc định là false (giống Column)
  });

  final List<TaskEntity> items; // Bạn nên thay 'dynamic' bằng 'Task' nếu đã có model
  final bool isScroll;

  @override
  Widget build(BuildContext context) {
    // Sử dụng ListView.builder hiệu quả hơn map().toList() cho danh sách dài
    return ListView.builder(
      // Nếu không cho scroll, padding mặc định của ListView có thể gây lệch layout
      // nên ta set về zero.
      padding: EdgeInsets.zero,

      itemCount: items.length,

      // --- LOGIC QUAN TRỌNG Ở ĐÂY ---
      // Nếu isScroll = false: shrinkWrap = true (co lại)
      // Nếu isScroll = true: shrinkWrap = false (bung ra)
      shrinkWrap: !isScroll,

      // Nếu isScroll = false: Không cho cuộn (để cha cuộn)
      // Nếu isScroll = true: Cho phép cuộn bình thường
      physics: isScroll
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),

      itemBuilder: (context, index) {
        final t = items[index];

        // Trả về giao diện item của bạn
        return TDCard(
          child: Container(
            padding: const EdgeInsets.all(16),
            // Thêm margin bottom nhẹ nếu bạn muốn các item tách nhau ra
            // (Column mặc định dính liền)
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.title,
                        style: AppTextStyles.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${t.status} · ${t.taskType} · ${t.priority}',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () async {
                    await NavigationService().toNamed<void>(
                      AppRouter.taskEdit,
                      arguments: t,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}