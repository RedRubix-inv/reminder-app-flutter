import 'package:flutter/material.dart';
import 'package:reminder_app/components/app_textfield.dart';
import 'package:reminder_app/components/custom_appbar.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';

class TeamManagementView extends StatefulWidget {
  const TeamManagementView({super.key});

  @override
  State<TeamManagementView> createState() => _TeamManagementViewState();
}

class _TeamManagementViewState extends State<TeamManagementView> {
  final _emailController = TextEditingController();
  final List<TeamMember> _teamMembers = [
    TeamMember(
      email: 'john.doe@example.com',
      name: 'John Doe',
      role: 'Admin',
      avatarUrl: 'assets/images/profile.png',
    ),
    TeamMember(
      email: 'maharjanm9@gmail.com',
      name: 'Manish Maharjan',
      role: 'Moderator',
      avatarUrl: 'assets/images/person1.jpg',
    ),
    TeamMember(
      email: 'silva123@gmail.com',
      name: 'Silva',
      role: 'Member',
      avatarUrl: 'assets/images/profile.png',
    ),
    TeamMember(
      email: 'speedy@gmail.com',
      name: 'Speedy',
      role: 'Member',
      avatarUrl: 'assets/images/person1.jpg',
    ),
    TeamMember(
      email: 'sakura@gmail.com',
      name: 'Sakura',
      role: 'Member',
      avatarUrl: 'assets/images/profile.png',
    ),
    TeamMember(
      email: 'albert321@gmail.com',
      name: 'Albert',
      role: 'Member',
      avatarUrl: 'assets/images/person1.jpg',
    ),
  ];

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _addTeamMember() {
    if (_emailController.text.isNotEmpty) {
      // TODO: Implement team member invitation
      _emailController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        displayMode: LeadingDisplayMode.backWithText,
        leadingText: 'Team Management',
        onNotificationPressed: () {},
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Team',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
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
              'Current Team Members',
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
                      backgroundImage: AssetImage(member.avatarUrl),
                      backgroundColor: Colors.grey.shade200,
                    ),
                    title: Text(
                      member.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(member.email),
                        Text(
                          member.role,
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        // TODO: Show member options menu
                      },
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

class TeamMember {
  final String email;
  final String name;
  final String role;
  final String avatarUrl;

  TeamMember({
    required this.email,
    required this.name,
    required this.role,
    required this.avatarUrl,
  });
}
