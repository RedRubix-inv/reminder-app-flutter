import 'package:flutter/material.dart';
import 'package:reminder_app/components/custom_appbar.dart';
import 'package:reminder_app/models/team.dart';
import 'package:reminder_app/pages/teams_list/components/create_team_dialog.dart';
import 'package:reminder_app/pages/teams_list/components/team_card.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';

class TeamsView extends StatefulWidget {
  const TeamsView({super.key});

  @override
  State<TeamsView> createState() => _TeamsViewState();
}

class _TeamsViewState extends State<TeamsView> {
  final List<Team> _teams = [
    Team(
      name: 'Design Team',
      members: 5,
      description:
          'Creating stunning visuals and user interfaces Creating stunning visuals and user interfaces Creating stunning visuals and user interfaces',
      avatarUrl: 'assets/images/profile.png',
    ),
    Team(
      name: 'Development Team',
      members: 8,
      description: 'Building robust and scalable applications',
      avatarUrl: 'assets/images/profile.png',
    ),
    Team(
      name: 'Marketing Team',
      members: 4,
      description: 'Promoting our brand and engaging customers',
      avatarUrl: 'assets/images/profile.png',
    ),
  ];

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

  void _showCreateTeamDialog() {
    showDialog(
      context: context,
      builder:
          (context) => CreateTeamDialog(
            onCreateTeam: (name, description, emails) {
              setState(() {
                _teams.add(
                  Team(
                    name: name,
                    members: emails.length + 1, // +1 for the creator
                    description: description,
                    avatarUrl: 'assets/images/profile.png',
                  ),
                );
              });
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        displayMode: LeadingDisplayMode.avatarOnly,
        avatarImageUrl: 'assets/images/profile.png',
        onNotificationPressed: () {},
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getScreenWidth(context) * 0.04,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VerticalSpace(20),
            Text(
              'Teams',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const VerticalSpace(16),
            Expanded(
              child: ListView.builder(
                itemCount: _teams.length,
                itemBuilder: (context, index) {
                  final team = _teams[index];
                  return TeamCard(team: team);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateTeamDialog,
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
