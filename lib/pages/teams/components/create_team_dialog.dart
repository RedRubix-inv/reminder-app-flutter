import 'package:flutter/material.dart';
import 'package:reminder_app/components/app_textarea.dart';
import 'package:reminder_app/components/app_textfield.dart';
import 'package:reminder_app/components/show_toast.dart';
import 'package:reminder_app/models/team.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';
import 'package:toastification/toastification.dart';

class CreateTeamDialog extends StatefulWidget {
  final Function(String, String, List<String>) onCreateTeam;

  const CreateTeamDialog({super.key, required this.onCreateTeam});

  @override
  State<CreateTeamDialog> createState() => _CreateTeamDialogState();
}

class _CreateTeamDialogState extends State<CreateTeamDialog> {
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();
  final List<TeamMember> _invitedMembers = [];

  @override
  void dispose() {
    _teamNameController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _addMember() {
    final email = _emailController.text.trim();
    if (email.isNotEmpty &&
        email.contains('@') &&
        !_invitedMembers.any((member) => member.email == email)) {
      setState(() {
        _invitedMembers.add(
          TeamMember(
            email: email,
            role: TeamRole.member,
            name: email.split('@')[0],
            avatarUrl: 'assets/images/profile.png',
          ),
        );
        _emailController.clear();
      });
    }
  }

  void _removeMember(TeamMember member) {
    setState(() {
      _invitedMembers.remove(member);
    });
  }

  void _updateMemberRole(TeamMember member, TeamRole newRole) {
    setState(() {
      final index = _invitedMembers.indexOf(member);
      _invitedMembers[index] = TeamMember(
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
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: getScreenWidth(context) * 0.04,
        vertical: 24.0,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Create New Team',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _invitedMembers.clear();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const VerticalSpace(24),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        hintText: 'Team Name',
                        labelText: 'Team Name',
                        onChanged: (value) {
                          _teamNameController.text = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a team name';
                          }
                          return null;
                        },
                      ),
                      const VerticalSpace(16),
                      AppTextArea(
                        hintText: "Team Description",
                        labelText: "Team Description",
                        onChanged: (value) {
                          _descriptionController.text = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a team description';
                          }
                          return null;
                        },
                        maxLines: 2,
                        minLines: 1,
                        maxLength: 200,
                      ),
                      const VerticalSpace(16),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              hintText: 'Invite by Email',
                              labelText: 'Invite by Email',
                              initialValue: _emailController.text,
                              onChanged: (value) {
                                _emailController.text = value;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an email address';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: _addMember,
                            icon: const Icon(Icons.add_circle),
                            color: primaryColor,
                          ),
                        ],
                      ),
                      if (_invitedMembers.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Invited Members:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.2,
                          ),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children:
                                  _invitedMembers.map((member) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.person_outline,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  member.email,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Text(
                                                  _getRoleText(member.role),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuButton<TeamRole>(
                                            enabled: true,
                                            itemBuilder:
                                                (context) =>
                                                    TeamRole.values.map((role) {
                                                      return PopupMenuItem(
                                                        value: role,
                                                        child: Text(
                                                          _getRoleText(role),
                                                        ),
                                                      );
                                                    }).toList(),
                                            onSelected:
                                                (role) => _updateMemberRole(
                                                  member,
                                                  role,
                                                ),
                                            child: const Icon(
                                              Icons.edit,
                                              size: 18,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.close,
                                              size: 18,
                                            ),
                                            onPressed:
                                                () => _removeMember(member),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                      ],
                      const VerticalSpace(24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              _invitedMembers.clear();
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (_invitedMembers.isEmpty) {
                                  showToast(
                                    context,
                                    type: ToastificationType.error,
                                    title: 'Error',
                                    description:
                                        'Please add at least one team member',
                                  );
                                  return;
                                }
                                widget.onCreateTeam(
                                  _teamNameController.text,
                                  _descriptionController.text,
                                  _invitedMembers.map((m) => m.email).toList(),
                                );
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Create Team'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
