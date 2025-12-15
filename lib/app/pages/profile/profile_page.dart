import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../features/auth/domain/entities/user.dart' as app_user;
import '../../../features/workspace/presentation/controllers/workspace_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../routes/app_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/services/snackbar_service.dart';
import '../../widgets/td_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.I.profile),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: GetBuilder<AuthController>(
        builder: (authController) => Obx(() {
          final user = authController.currentUser;
          if (user == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Profile Card
                _buildUserProfileCard(user),
                const SizedBox(height: AppSpacing.lg),
                
                // Current Workspace Info
                GetBuilder<WorkspaceController>(
                  builder: (workspaceController) => Obx(() {
                    final currentWorkspace = workspaceController.currentWorkspace.value;
                    if (currentWorkspace != null) {
                      return _buildWorkspaceInfoCard(currentWorkspace.name);
                    }
                    return const SizedBox.shrink();
                  }),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Account Section
                _SectionTitle(title: AppStrings.I.account),
                const SizedBox(height: AppSpacing.sm),
                _ListTile(
                  icon: Icons.edit_outlined,
                  title: AppStrings.I.editProfile,
                  onTap: () {
                    SnackbarService().showInfo(
                      title: AppStrings.I.info,
                      message: AppStrings.I.editProfileFeatureComingSoon,
                    );
                  },
                ),
                _ListTile(
                  icon: Icons.lock_reset,
                  title: AppStrings.I.changePassword,
                  onTap: () async {
                    await NavigationService().toNamed<void>(AppRouter.changePassword);
                  },
                ),
                _ListTile(
                  icon: Icons.settings_outlined,
                  title: AppStrings.I.settings,
                  onTap: () async {
                    await NavigationService().toNamed<void>(AppRouter.settings);
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                
                // About Section
                _SectionTitle(title: AppStrings.I.about),
                const SizedBox(height: AppSpacing.sm),
                _ListTile(
                  icon: Icons.info_outline,
                  title: AppStrings.I.appVersion,
                  trailing: Text(AppStrings.I.appVersionNumber),
                  onTap: () {},
                ),
                const SizedBox(height: AppSpacing.lg),
                
                // Logout Button
                Center(
                  child: TDButton(
                    text: AppStrings.I.logout,
                    onPressed: () async {
                      final auth = Get.find<AuthController>();
                      await auth.signOut();
                    },
                    icon: Icons.logout,
                    width: 200,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// Build user profile card
  Widget _buildUserProfileCard(app_user.User user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar and basic info
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primary,
                backgroundImage: user.profileImageUrl != null 
                    ? NetworkImage(user.profileImageUrl!) 
                    : null,
                child: user.profileImageUrl == null
                    ? Text(
                        user.initials,
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: AppColors.onPrimary,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      user.email,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        user.role.toUpperCase(),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Additional user info
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildInfoRow(AppStrings.I.userID, user.id),
                _buildInfoRow(AppStrings.I.created, _formatDate(user.createdAt)),
                if (user.lastLoginAt != null)
                  _buildInfoRow(AppStrings.I.lastLogin, _formatDate(user.lastLoginAt!)),
                _buildInfoRow(AppStrings.I.status, user.isActive ? AppStrings.I.active : AppStrings.I.inactive),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build workspace info card
  Widget _buildWorkspaceInfoCard(String workspaceName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.business,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.I.currentWorkspace,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  workspaceName,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build info row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Format date
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline.withOpacity(0.2)),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.onSurface),
        title: Text(title),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}


