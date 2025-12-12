import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/core/constants/app_strings.dart';
import 'package:todolist/core/services/navigation_service.dart';
import 'package:todolist/core/services/snackbar_service.dart';
import 'package:todolist/features/workspace/presentation/controllers/workspace_controller.dart';
import 'package:todolist/features/workspace/domain/entities/team_group.dart';
import 'package:todolist/features/workspace/domain/entities/workspace_member.dart';
import 'package:todolist/app/widgets/td_button.dart';
import 'package:todolist/app/widgets/td_text_field.dart';
import 'package:todolist/app/widgets/td_card.dart';
import 'package:todolist/app/widgets/td_app_bar.dart';
import 'package:todolist/app/widgets/td_loading_indicator.dart';
import 'package:todolist/app/widgets/td_chip.dart';

class TeamGroupDetailPage extends StatefulWidget {
  const TeamGroupDetailPage({
    super.key,
    required this.teamGroup,
  });

  final TeamGroup teamGroup;

  @override
  State<TeamGroupDetailPage> createState() => _TeamGroupDetailPageState();
}

class _TeamGroupDetailPageState extends State<TeamGroupDetailPage> {
  final WorkspaceController _controller = Get.find<WorkspaceController>();
  final TextEditingController _searchController = TextEditingController();
  final RxString _searchQuery = ''.obs;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Check if user has permission to access team group management
  Future<void> _checkPermissions() async {
    try {
      final canManageUsers = await _controller.hasPermission('manage_users');
      if (!canManageUsers) {
        SnackbarService().showError(
          title: AppStrings.error,
          message: AppStrings.permissionDenied,
        );
        NavigationService().back<void>();
        return;
      }
    } catch (e) {
      SnackbarService().showError(
        title: AppStrings.error,
        message: AppStrings.permissionDenied,
      );
      NavigationService().back<void>();
    }
  }

  /// Get member by user ID
  WorkspaceMember? _getMember(String userId) {
    return _controller.workspaceMembers.firstWhereOrNull((m) => m.userId == userId);
  }

  /// Get lead group member
  WorkspaceMember? _getLeadGroupMember() {
    return _getMember(widget.teamGroup.leadGroupUserId);
  }

  /// Get group members
  List<WorkspaceMember> _getGroupMembers() {
    return widget.teamGroup.members
        .map((userId) => _getMember(userId))
        .where((member) => member != null)
        .cast<WorkspaceMember>()
        .toList();
  }

  /// Get available members (not in group)
  List<WorkspaceMember> _getAvailableMembers() {
    final groupMemberIds = widget.teamGroup.members.toSet();
    groupMemberIds.add(widget.teamGroup.leadGroupUserId); // Include lead group
    
    return _controller.workspaceMembers
        .where((member) => !groupMemberIds.contains(member.userId))
        .toList();
  }

  /// Filter members based on search query
  List<WorkspaceMember> _filterMembers(List<WorkspaceMember> members) {
    final query = _searchQuery.value.toLowerCase();
    if (query.isEmpty) return members;

    return members.where((member) {
      final displayName = member.displayName.toLowerCase();
      final email = member.email.toLowerCase();
      return displayName.contains(query) || email.contains(query);
    }).toList();
  }

  /// Add member to group
  void _addMemberToGroup(WorkspaceMember member) {
    // TODO: Implement add member to group
    SnackbarService().showInfo(
      title: 'Info',
      message: 'Add member functionality coming soon',
    );
  }

  /// Remove member from group
  void _removeMemberFromGroup(WorkspaceMember member) {
    // TODO: Implement remove member from group
    SnackbarService().showInfo(
      title: 'Info',
      message: 'Remove member functionality coming soon',
    );
  }

  /// Show add member dialog
  void _showAddMemberDialog() {
    final availableMembers = _getAvailableMembers();
    
    if (availableMembers.isEmpty) {
      SnackbarService().showInfo(
        title: 'Info',
        message: 'No available members to add',
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Member to Group'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: availableMembers.length,
            itemBuilder: (context, index) {
              final member = availableMembers[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  child: Text(
                    member.displayName.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(member.displayName),
                subtitle: Text(member.email),
                trailing: TDButton(
                  text: 'Add',
                  variant: TDButtonVariant.outlined,
                  onPressed: () {
                    Navigator.of(context).pop();
                    _addMemberToGroup(member);
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDAppBar(
        title: widget.teamGroup.name,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddMemberDialog,
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.isLoading) {
          return const Center(child: TDLoadingIndicator());
        }

        final leadGroupMember = _getLeadGroupMember();
        final groupMembers = _getGroupMembers();

        return Column(
          children: [
            // Group Info Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: TDCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Group Information',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TDChip(
                            label: '${groupMembers.length} members',
                            type: TDChipType.info,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 16,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Lead Group: ${leadGroupMember?.displayName ?? 'Unknown'}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      if (widget.teamGroup.description != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          widget.teamGroup.description!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TDTextField(
                controller: _searchController,
                hint: 'Search members...',
                prefixIcon: Icons.search,
                onChanged: (value) => _searchQuery.value = value,
              ),
            ),

            const SizedBox(height: 16),

            // Members List
            Expanded(
              child: groupMembers.isEmpty
                  ? _buildEmptyMembers()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filterMembers(groupMembers).length,
                      itemBuilder: (context, index) {
                        final member = _filterMembers(groupMembers)[index];
                        return _buildMemberCard(member);
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyMembers() {
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
            'No Members',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Add members to this group to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TDButton(
            text: 'Add Members',
            onPressed: _showAddMemberDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(WorkspaceMember member) {
    final isLeadGroup = member.userId == widget.teamGroup.leadGroupUserId;
    
    return TDCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isLeadGroup 
              ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
              : Theme.of(context).colorScheme.surfaceVariant,
          child: Text(
            member.displayName.substring(0, 1).toUpperCase(),
            style: TextStyle(
              color: isLeadGroup 
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                member.displayName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (isLeadGroup)
              TDChip(
                label: 'Lead',
                type: TDChipType.info,
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...[
            Text(
              member.email,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: 4),
          ],
            Text(
              'Manager: ${member.managerUserId != null ? _getMember(member.managerUserId!)?.displayName ?? 'Unknown' : 'Lead Group'}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
        trailing: !isLeadGroup
            ? IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                color: Theme.of(context).colorScheme.error,
                onPressed: () => _removeMemberFromGroup(member),
              )
            : null,
      ),
    );
  }
}
