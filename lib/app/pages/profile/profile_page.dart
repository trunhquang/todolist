import 'package:flutter/material.dart';

import '../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../routes/app_router.dart';
import '../../../core/constants/app_strings.dart';
import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = StorageService();
    final name = storage.getUserData<String>('user_name') ?? 'User';
    final email = storage.getUserData<String>('user_email') ?? 'user@example.com';
    final role = storage.getUserRole() ?? 'member';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'U',
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(email, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 4),
                      Text('Role: $role', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            const _SectionTitle(title: AppStrings.account),
            const SizedBox(height: 8),
            _ListTile(
              icon: Icons.edit_outlined,
              title: 'Edit Profile',
              onTap: () {
                Get.snackbar(AppStrings.profile, AppStrings.dataUpdated);
              },
            ),
            _ListTile(
              icon: Icons.lock_reset,
              title: 'Change Password',
              onTap: () async {
                await Get.toNamed<void>(AppRouter.changePassword);
              },
            ),
            _ListTile(
              icon: Icons.settings_outlined,
              title: AppStrings.settings,
              onTap: () async {
                await Get.toNamed<void>(AppRouter.settings);
              },
            ),
            const SizedBox(height: 24),
            const _SectionTitle(title: AppStrings.about),
            const SizedBox(height: 8),
            _ListTile(
              icon: Icons.info_outline,
              title: 'App Version',
              trailing: const Text('1.0.0'),
              onTap: () {},
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final auth = Get.find<AuthController>();
                  await auth.signOut();
                },
                icon: const Icon(Icons.logout),
                label: const Text(AppStrings.logout),
              ),
            ),
          ],
        ),
      ),
    );
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


