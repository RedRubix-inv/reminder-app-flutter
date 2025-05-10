import 'package:flutter/material.dart';
import 'package:reminder_app/components/app_textfield.dart';
import 'package:reminder_app/components/custom_appbar.dart';
import 'package:reminder_app/models/team.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';

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

  void _addTeamMember() {
    if (_emailController.text.isNotEmpty) {
      setState(() {
        _teamMembers.add(
          TeamMember(
            email: _emailController.text,
            role: TeamRole.member,
            name: _emailController.text.split('@')[0],
            avatarUrl: 'assets/images/profile.png',
          ),
        );
      });
      _emailController.clear();
    }
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
        avatarUrl: member.avatarUrl,
      );
    });
  }

  String _getRoleText(TeamRole role) {
    switch (role) {
      case TeamRole.admin:
        return 'Admin';
      case TeamRole.member:
        return 'Member';
      case TeamRole.viewer:
        return 'Viewer';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        displayMode: LeadingDisplayMode.backWithText,
        leadingText: "Team Management",
        onNotificationPressed: () {},
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
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
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(widget.team.avatarUrl),
                        backgroundColor: Colors.grey[200],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.team.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${widget.team.memberCount} members',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (widget.team.description.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.team.description,
                      style: TextStyle(color: Colors.grey[800], height: 1.5),
                    ),
                  ],
                ],
              ),
            ),
            const VerticalSpace(24),
            const Text(
              'Add Team Member',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const VerticalSpace(8),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    hintText: 'Enter email address',
                    initialValue: _emailController.text,
                    onChanged: (value) {
                      _emailController.text = value;
                    },
                  ),
                ),
                const HorizontalSpace(8),
                IconButton(
                  onPressed: _addTeamMember,
                  icon: const Icon(Icons.add_circle),
                  color: primaryColor,
                ),
              ],
            ),
            const VerticalSpace(24),
            const Text(
              'Team Members',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const VerticalSpace(16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _teamMembers.length,
              itemBuilder: (context, index) {
                final member = _teamMembers[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
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
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(
                        member.avatarUrl ?? 'assets/images/profile.png',
                      ),
                      backgroundColor: Colors.grey.shade200,
                    ),
                    title: Text(
                      member.name ?? member.email,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(member.email),
                        Text(
                          _getRoleText(member.role),
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PopupMenuButton<TeamRole>(
                          enabled: member.role != TeamRole.admin,
                          itemBuilder:
                              (context) =>
                                  TeamRole.values
                                      .where((role) => role != TeamRole.admin)
                                      .map((role) {
                                        return PopupMenuItem(
                                          value: role,
                                          child: Text(_getRoleText(role)),
                                        );
                                      })
                                      .toList(),
                          onSelected: (role) => _updateMemberRole(member, role),
                          child: const Icon(Icons.edit, size: 20),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed:
                              member.role == TeamRole.admin
                                  ? null
                                  : () => _removeTeamMember(member),
                          icon: const Icon(Icons.delete_outline, size: 20),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
