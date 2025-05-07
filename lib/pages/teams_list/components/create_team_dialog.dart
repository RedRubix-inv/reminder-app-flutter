import 'package:flutter/material.dart';
import 'package:reminder_app/components/app_textarea.dart';
import 'package:reminder_app/components/app_textfield.dart';
import 'package:reminder_app/components/show_toast.dart';
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
  final List<String> _invitedEmails = [];

  @override
  void dispose() {
    _teamNameController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _addEmail() {
    final email = _emailController.text.trim();
    if (email.isNotEmpty &&
        email.contains('@') &&
        !_invitedEmails.contains(email)) {
      setState(() {
        _invitedEmails.add(email);
        _emailController.clear();
      });
    }
  }

  void _removeEmail(String email) {
    setState(() {
      _invitedEmails.remove(email);
    });
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
                        _invitedEmails.clear();
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
                            onPressed: _addEmail,
                            icon: const Icon(Icons.add_circle),
                            color: primaryColor,
                          ),
                        ],
                      ),
                      if (_invitedEmails.isNotEmpty) ...[
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
                                  _invitedEmails.map((email) {
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
                                            child: Text(
                                              email,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.close,
                                              size: 18,
                                            ),
                                            onPressed:
                                                () => _removeEmail(email),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _invitedEmails.clear();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontFamily: "Sora", fontSize: 14),
                      ),
                    ),
                    const HorizontalSpace(10),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onCreateTeam(
                            _teamNameController.text,
                            _descriptionController.text,
                            _invitedEmails,
                          );
                          Navigator.pop(context);
                          showToast(
                            context,
                            type: ToastificationType.success,
                            title: 'Team Created!',
                            description:
                                'Team ${_teamNameController.text} created successfully',
                          );
                          _teamNameController.clear();
                          _descriptionController.clear();
                          _emailController.clear();
                          _invitedEmails.clear();
                        }
                      },
                      child: const Text(
                        'Create Team',
                        style: TextStyle(fontFamily: "Sora", fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
