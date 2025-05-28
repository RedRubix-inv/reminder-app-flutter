import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:reminder_app/components/app_textfield.dart';
import 'package:reminder_app/components/custom_appbar.dart';
import 'package:reminder_app/components/show_toast.dart';
import 'package:reminder_app/models/team.dart';
import 'package:reminder_app/utils/router.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';
import 'package:toastification/toastification.dart';

class TeamManagementView extends StatefulWidget {
  final Team team;

  const TeamManagementView({super.key, required this.team});

  @override
  State<TeamManagementView> createState() => _TeamManagementViewState();
}

class _TeamManagementViewState extends State<TeamManagementView> {
  final _emailController = TextEditingController();
  late List<TeamMember> _teamMembers;

  @override
  void initState() {
    super.initState();
    _teamMembers = List.from(widget.team.members);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _addTeamMember() {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      showToast(
        context,
        type: ToastificationType.error,
        title: 'Error',
        description: 'Please enter an email address',
      );
      return;
    }

    if (!_isValidEmail(email)) {
      showToast(
        context,
        type: ToastificationType.error,
        title: 'Error',
        description: 'Please enter a valid email address',
      );
      return;
    }

    // Check if member already exists
    if (_teamMembers.any(
      (member) => member.email.toLowerCase() == email.toLowerCase(),
    )) {
      showToast(
        context,
        type: ToastificationType.warning,
        title: 'Warning',
        description: 'Team member already exists',
      );
      return;
    }

    setState(() {
      _teamMembers.add(
        TeamMember(
          email: email,
          role: TeamRole.member,
          name: email.split('@')[0],
        ),
      );
    });

    _emailController.clear();

    showToast(
      context,
      type: ToastificationType.success,
      title: 'Success',
      description: 'Team member added successfully',
    );
  }

  void _removeTeamMember(TeamMember member) {
    setState(() {
      _teamMembers.remove(member);
    });
  }

  void _updateMemberRole(TeamMember member, TeamRole newRole) {
    setState(() {
      final index = _teamMembers.indexOf(member);
      _teamMembers[index] = TeamMember(
        email: member.email,
        role: newRole,
        name: member.name,
      );
    });
  }

  String _getRoleText(TeamRole role) {
    switch (role) {
      case TeamRole.admin:
        return 'Admin';
      case TeamRole.member:
        return 'Member';
      case TeamRole.moderator:
        return 'Moderator';
    }
  }

  Color _getRoleColor(TeamRole role) {
    switch (role) {
      case TeamRole.admin:
        return textColor;
      case TeamRole.moderator:
        return primaryColor;
      case TeamRole.member:
        return primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        displayMode: LeadingDisplayMode.backWithText,
        leadingText: "Team Management",
        showNotification: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: getScreenWidth(context) * 0.04,
          vertical: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.users2, color: textColor, size: 24),
                      const HorizontalSpace(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.team.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Sora',
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    // TODO: Implement notification settings
                                    context.push(RouteName.createReminder);
                                  },
                                  icon: const Icon(
                                    LucideIcons.bellPlus,
                                    size: 30,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),

                            Container(
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Text(
                                '${widget.team.memberCount} Members',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Sora',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (widget.team.description.isNotEmpty) ...[
                    const VerticalSpace(16),
                    Text(
                      widget.team.description,
                      style: TextStyle(
                        color: textColorSecondary,
                        fontSize: 14,
                        height: 1.5,
                        fontFamily: 'Sora',
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ],
              ),
            ),
            const VerticalSpace(24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.userPlus2, color: textColor, size: 24),
                      const HorizontalSpace(12),
                      const Text(
                        'Add Team Member',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Sora',
                        ),
                      ),
                    ],
                  ),
                  const VerticalSpace(16),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          hintText: 'Enter email address',
                          labelText: 'Email',
                          initialValue: _emailController.text,
                          onChanged: (value) {
                            setState(() {
                              _emailController.text = value;
                            });
                          },
                        ),
                      ),
                      const HorizontalSpace(12),
                      IconButton(
                        onPressed: _addTeamMember,
                        icon: const Icon(LucideIcons.mailPlus),
                        color: textColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const VerticalSpace(24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(LucideIcons.users2, color: textColor, size: 24),
                      const HorizontalSpace(12),
                      Text(
                        'Team Members (${_teamMembers.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Sora',
                        ),
                      ),
                    ],
                  ),
                  const VerticalSpace(16),
                  ..._teamMembers.map((member) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          // const Icon(LucideIcons.user2, size: 20),
                          const HorizontalSpace(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  member.name ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Sora',
                                  ),
                                ),
                                Text(
                                  member.email,
                                  style: TextStyle(
                                    color: textColorSecondary,
                                    fontSize: 14,
                                    fontFamily: 'Sora',
                                  ),
                                ),
                                const VerticalSpace(4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getRoleColor(
                                      member.role,
                                    ).withAlpha(30),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    _getRoleText(member.role),
                                    style: TextStyle(
                                      color: _getRoleColor(member.role),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Sora',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(
                              LucideIcons.moreVertical,
                              size: 20,
                              color: textColor,
                            ),
                            itemBuilder:
                                (context) => [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        const Icon(
                                          LucideIcons.pencil,
                                          size: 16,
                                        ),
                                        const HorizontalSpace(8),
                                        const Text(
                                          'Edit Role',
                                          style: TextStyle(fontFamily: 'Sora'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        const Icon(
                                          LucideIcons.trash2,
                                          size: 16,
                                          color: Colors.red,
                                        ),
                                        const HorizontalSpace(8),
                                        const Text(
                                          'Remove Member',
                                          style: TextStyle(
                                            fontFamily: 'Sora',
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                            onSelected: (value) {
                              if (value == 'edit') {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: const Text(
                                          'Edit Member Role',
                                          style: TextStyle(fontFamily: 'Sora'),
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children:
                                              TeamRole.values.map((role) {
                                                return ListTile(
                                                  title: Text(
                                                    _getRoleText(role),
                                                    style: const TextStyle(
                                                      fontFamily: 'Sora',
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    _updateMemberRole(
                                                      member,
                                                      role,
                                                    );
                                                    Navigator.pop(context);
                                                    showToast(
                                                      context,
                                                      type:
                                                          ToastificationType
                                                              .success,
                                                      title: 'Success',
                                                      description:
                                                          'Member role updated successfully',
                                                    );
                                                  },
                                                );
                                              }).toList(),
                                        ),
                                      ),
                                );
                              } else if (value == 'delete') {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: const Text(
                                          'Remove Member',
                                          style: TextStyle(fontFamily: 'Sora'),
                                        ),
                                        content: Text(
                                          'Are you sure you want to remove ${member.name ?? member.email} from the team?',
                                          style: const TextStyle(
                                            fontFamily: 'Sora',
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                fontFamily: 'Sora',
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _removeTeamMember(member);
                                              Navigator.pop(context);
                                              showToast(
                                                context,
                                                type:
                                                    ToastificationType.success,
                                                title: 'Success',
                                                description:
                                                    'Member removed successfully',
                                              );
                                            },
                                            child: const Text(
                                              'Remove',
                                              style: TextStyle(
                                                fontFamily: 'Sora',
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
