import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/td_text_field.dart';
import '../controllers/user_management_controller.dart';

class UserManagementSearchBar extends StatelessWidget {
  const UserManagementSearchBar({
    super.key,
    required this.controller,
  });

  final UserManagementController controller;

  @override
  Widget build(BuildContext context) {
    return TDTextField(
      controller: controller.searchController,
      hintText: AppStrings.I.searchUsers,
      prefixIcon: const Icon(Icons.search),
      onChanged: controller.updateSearchQuery,
    );
  }
}


