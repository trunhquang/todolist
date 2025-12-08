import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class TDWelcomeSection extends StatelessWidget {
  const TDWelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.welcomeMessage,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.onPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.overview,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onPrimary.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
