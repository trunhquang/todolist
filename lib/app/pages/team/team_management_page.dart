import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/services/navigation_service.dart';
import 'package:todolist/core/services/snackbar_service.dart';
import 'package:todolist/features/workspace/presentation/controllers/workspace_controller.dart';
import 'package:todolist/features/workspace/domain/entities/team_group.dart';
import 'package:todolist/app/widgets/td_button.dart';
import 'package:todolist/app/widgets/td_text_field.dart';
import 'package:todolist/app/widgets/td_card.dart';
import 'package:todolist/app/widgets/td_app_bar.dart';
import 'package:todolist/app/widgets/td_loading_indicator.dart';
import 'package:todolist/app/routes/app_router.dart';

class TeamManagementPage extends StatefulWidget {
  const TeamManagementPage({super.key});

  @override
  State<TeamManagementPage> createState() => _TeamManagementPageState();
}

class _TeamManagementPageState extends State<TeamManagementPage> {
  final WorkspaceController _controller = Get.find<WorkspaceController>();
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _leadGroupController = TextEditingController();
  
  // Mock data for team groups - in real implementation, this would come from controller
  final List<TeamGroup> _teamGroups = [
    TeamGroup(
      id: '1',
      name: 'Development Team',
      workspaceId: 'workspace1',
      leadGroupUserId: 'user1',
      members: ['user2', 'user3', 'user4'],
      createdBy: 'user1',
      createdAt: DateTime.now(),
      description: 'Frontend and Backend developers',
    ),
    TeamGroup(
      id: '2',
      name: 'Design Team',
      workspaceId: 'workspace1',
      leadGroupUserId: 'user5',
      members: ['user6', 'user7'],
      createdBy: 'user1',
      createdAt: DateTime.now(),
      description: 'UI/UX Designers',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _leadGroupController.dispose();
    super.dispose();
  }

  /// Check if user has permission to access team management
  Future<void> _checkPermissions() async {
    try {
      final canManageUsers = await _controller.hasPermission('manage_users');
      if (!canManageUsers) {
        SnackbarService().showError(
          title: AppStrings.I.error,
          message: AppStrings.I.permissionDenied,
        );
        NavigationService().back<void>();
        return;
      }
    } catch (e) {
      SnackbarService().showError(
        title: AppStrings.I.error,
        message: AppStrings.I.permissionDenied,
      );
      NavigationService().back<void>();
    }
  }

  /// Get lead group name by user ID
  String _getLeadGroupName(String userId) {
    final member = _controller.workspaceMembers.firstWhereOrNull((m) => m.userId == userId);
    return member?.displayName ?? 'Unknown';
  }

  /// Navigate to team group detail page
  void _navigateToTeamGroupDetail(TeamGroup teamGroup) {
    NavigationService().toNamed<void>(
      AppRouter.teamGroupDetail,
      arguments: teamGroup,
    );
  }

  /// Show create team group dialog
  void _showCreateTeamGroupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Team Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TDTextField(
              controller: _groupNameController,
              label: 'Group Name',
              hint: 'Enter group name',
            ),
            const SizedBox(height: 16),
            TDTextField(
              controller: _leadGroupController,
              label: 'Lead Group User ID',
              hint: 'Enter lead group user ID',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Create team group
              Navigator.of(context).pop();
              _groupNameController.clear();
              _leadGroupController.clear();
              SnackbarService().showInfo(
                title: 'Info',
                message: 'Create team group functionality coming soon',
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  TDAppBar(
        title: AppStrings.I.teamManagement,
      ),
      body: Obx(() {
        if (_controller.isLoading) {
          return const Center(child: TDLoadingIndicator());
        }

        final members = _controller.workspaceMembers;
        if (members.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Team Groups (${_teamGroups.length})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TDButton(
                    text: 'Create Group',
                    onPressed: _showCreateTeamGroupDialog,
                  ),
                ],
              ),
            ),
            Expanded(
              child: _teamGroups.isEmpty
                  ? _buildEmptyTeamGroups()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _teamGroups.length,
                      itemBuilder: (context, index) {
                        final teamGroup = _teamGroups[index];
                        return _buildTeamGroupCard(teamGroup);
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.I.noUsersFound,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Add users to workspace to create team groups',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTeamGroups() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.group_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No Team Groups',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first team group to organize members',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TDButton(
            text: 'Create Team Group',
            onPressed: _showCreateTeamGroupDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamGroupCard(TeamGroup teamGroup) {
    return TDCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _navigateToTeamGroupDetail(teamGroup),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      teamGroup.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${teamGroup.memberCount} members',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Lead: ${_getLeadGroupName(teamGroup.leadGroupUserId)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
              if (teamGroup.description != null) ...[
                const SizedBox(height: 4),
                Text(
                  teamGroup.description!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}


