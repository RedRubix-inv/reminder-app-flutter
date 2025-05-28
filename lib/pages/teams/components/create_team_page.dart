import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:reminder_app/components/app_textarea.dart';
import 'package:reminder_app/components/app_textfield.dart';
import 'package:reminder_app/components/button.dart';
import 'package:reminder_app/components/custom_appbar.dart';
import 'package:reminder_app/components/show_toast.dart';
import 'package:reminder_app/models/team.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';
import 'package:toastification/toastification.dart';

class CreateTeamPage extends StatefulWidget {
  final Function(String, String, List<String>) onCreateTeam;

  const CreateTeamPage({super.key, required this.onCreateTeam});

  @override
  State<CreateTeamPage> createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends State<CreateTeamPage> {
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _emailValue = '';
  final List<TeamMember> _invitedMembers = [];

  @override
  void dispose() {
    _teamNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addMember() {
    final email = _emailValue.trim();
    if (email.isEmpty) {
      showToast(
        context,
        type: ToastificationType.error,
        title: 'Error',
        description: 'Please enter an email address',
      );
      return;
    }
    if (!email.contains('@')) {
      showToast(
        context,
        type: ToastificationType.error,
        title: 'Error',
        description: 'Please enter a valid email address',
      );
      return;
    }
    if (_invitedMembers.any((member) => member.email == email)) {
      showToast(
        context,
        type: ToastificationType.error,
        title: 'Error',
        description: 'This email has already been added',
      );
      return;
    }
    setState(() {
      _invitedMembers.add(
        TeamMember(
          email: email,
          role: TeamRole.member,
          name: email.split('@')[0],
        ),
      );
      _emailValue = '';
      showToast(
        context,
        type: ToastificationType.success,
        title: 'Success',
        description: 'Member added successfully',
      );
    });
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

  void _createTeam() {
    if (_formKey.currentState!.validate()) {
      if (_invitedMembers.isEmpty) {
        showToast(
          context,
          type: ToastificationType.error,
          title: 'Error',
          description: 'Please add at least one team member to create a team',
        );
        return;
      }

      // Print form values
      print('Team Creation Details:');
      print('Team Name: ${_teamNameController.text}');
      print('Team Description: ${_descriptionController.text}');
      print('Team Members (${_invitedMembers.length}):');
      for (var member in _invitedMembers) {
        print('- ${member.email} (${_getRoleText(member.role)})');
      }

      widget.onCreateTeam(
        _teamNameController.text,
        _descriptionController.text,
        _invitedMembers.map((m) => m.email).toList(),
      );

      showToast(
        context,
        type: ToastificationType.success,
        title: 'Success',
        description:
            'Team "${_teamNameController.text}" created successfully with ${_invitedMembers.length} member${_invitedMembers.length > 1 ? 's' : ''}',
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        displayMode: LeadingDisplayMode.backWithText,
        leadingText: 'Create New Team',
        showNotification: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getScreenWidth(context) * 0.04,
            vertical: 24.0,
          ),
          child: Form(
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
                        hintText: 'Invite By Email',
                        labelText: 'Invite By Email',
                        initialValue: _emailValue,
                        onChanged: (value) {
                          setState(() {
                            _emailValue = value;
                          });
                        },
                      ),
                    ),
                    const HorizontalSpace(8),
                    IconButton(
                      onPressed: _addMember,
                      icon: const Icon(LucideIcons.mailPlus),
                      color: textColor,
                    ),
                  ],
                ),
                if (_invitedMembers.isNotEmpty) ...[
                  const VerticalSpace(16),
                  const Text(
                    'Invited Members:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const VerticalSpace(8),
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.5,
                    ),

                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: secondaryColor),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children:
                            _invitedMembers.map((member) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 4,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(LucideIcons.user2, size: 20),
                                    const HorizontalSpace(8),
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
                                          (role) =>
                                              _updateMemberRole(member, role),
                                      child: const Icon(
                                        LucideIcons.pencil,
                                        size: 18,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(LucideIcons.x, size: 18),
                                      onPressed: () => _removeMember(member),
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
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    title: 'Create Team',
                    onPressed: _createTeam,
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
