import 'package:flutter/material.dart';
import 'package:reminder_app/components/custom_appbar.dart';
import 'package:reminder_app/models/team.dart';
import 'package:reminder_app/pages/teams/components/create_team_dialog.dart';
import 'package:reminder_app/pages/teams/components/team_card.dart';
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
      id: '1',
      name: 'Design Team',
      description:
          'Creating stunning visuals and user interfaces Creating stunning visuals and user interfaces Creating stunning visuals and user interfaces',
      avatarUrl: 'assets/images/profile.png',
      members: [
        TeamMember(
          email: 'emma.wilson@reminderapp.com',
          role: TeamRole.admin,
          name: 'Emma Wilson',
          avatarUrl: 'assets/images/profile.png',
        ),
        TeamMember(
          email: 'liam.smith@reminderapp.com',
          role: TeamRole.member,
          name: 'Liam Smith',
          avatarUrl: 'assets/images/person1.jpg',
        ),
        TeamMember(
          email: 'olivia.brown@reminderapp.com',
          role: TeamRole.member,
          name: 'Olivia Brown',
          avatarUrl: 'assets/images/profile.png',
        ),
        TeamMember(
          email: 'noah.jones@reminderapp.com',
          role: TeamRole.member,
          name: 'Noah Jones',
          avatarUrl: 'assets/images/person1.jpg',
        ),
        TeamMember(
          email: 'ava.davis@reminderapp.com',
          role: TeamRole.viewer,
          name: 'Ava Davis',
          avatarUrl: 'assets/images/profile.png',
        ),
      ],
    ),
    Team(
      id: '2',
      name: 'Development Team',
      description: 'Building robust and scalable applications',
      avatarUrl: 'assets/images/person1.jpg',
      members: [
        TeamMember(
          email: 'james.martin@reminderapp.com',
          role: TeamRole.admin,
          name: 'James Martin',
          avatarUrl: 'assets/images/profile.png',
        ),
        TeamMember(
          email: 'sophia.thomas@reminderapp.com',
          role: TeamRole.member,
          name: 'Sophia Thomas',
          avatarUrl: 'assets/images/person1.jpg',
        ),
        TeamMember(
          email: 'benjamin.jackson@reminderapp.com',
          role: TeamRole.member,
          name: 'Benjamin Jackson',
          avatarUrl: 'assets/images/profile.png',
        ),
        TeamMember(
          email: 'mia.white@reminderapp.com',
          role: TeamRole.member,
          name: 'Mia White',
          avatarUrl: 'assets/images/person1.jpg',
        ),
        TeamMember(
          email: 'william.harris@reminderapp.com',
          role: TeamRole.member,
          name: 'William Harris',
          avatarUrl: 'assets/images/profile.png',
        ),
        TeamMember(
          email: 'isabella.moore@reminderapp.com',
          role: TeamRole.member,
          name: 'Isabella Moore',
          avatarUrl: 'assets/images/person1.jpg',
        ),
        TeamMember(
          email: 'daniel.taylor@reminderapp.com',
          role: TeamRole.member,
          name: 'Daniel Taylor',
          avatarUrl: 'assets/images/profile.png',
        ),
        TeamMember(
          email: 'charlotte.anderson@reminderapp.com',
          role: TeamRole.viewer,
          name: 'Charlotte Anderson',
          avatarUrl: 'assets/images/person1.jpg',
        ),
      ],
    ),
    Team(
      id: '3',
      name: 'Marketing Team',
      description: 'Promoting our brand and engaging customers',
      avatarUrl: 'assets/images/profile.png',
      members: [
        TeamMember(
          email: 'henry.lee@reminderapp.com',
          role: TeamRole.admin,
          name: 'Henry Lee',
          avatarUrl: 'assets/images/person1.jpg',
        ),
        TeamMember(
          email: 'amelia.walker@reminderapp.com',
          role: TeamRole.member,
          name: 'Amelia Walker',
          avatarUrl: 'assets/images/profile.png',
        ),
        TeamMember(
          email: 'ethan.miller@reminderapp.com',
          role: TeamRole.member,
          name: 'Ethan Miller',
          avatarUrl: 'assets/images/person1.jpg',
        ),
        TeamMember(
          email: 'harper.thompson@reminderapp.com',
          role: TeamRole.viewer,
          name: 'Harper Thompson',
          avatarUrl: 'assets/images/profile.png',
        ),
      ],
    ),
    Team(
      id: '4',
      name: 'Product Team',
      description: 'Defining product vision and managing roadmaps',
      avatarUrl: 'assets/images/person1.jpg',
      members: [
        TeamMember(
          email: 'lucas.roberts@reminderapp.com',
          role: TeamRole.admin,
          name: 'Lucas Roberts',
          avatarUrl: 'assets/images/profile.png',
        ),
        TeamMember(
          email: 'evelyn.martinez@reminderapp.com',
          role: TeamRole.member,
          name: 'Evelyn Martinez',
          avatarUrl: 'assets/images/person1.jpg',
        ),
        TeamMember(
          email: 'mason.hernandez@reminderapp.com',
          role: TeamRole.member,
          name: 'Mason Hernandez',
          avatarUrl: 'assets/images/profile.png',
        ),
        TeamMember(
          email: 'sofia.gonzalez@reminderapp.com',
          role: TeamRole.member,
          name: 'Sofia Gonzalez',
          avatarUrl: 'assets/images/person1.jpg',
        ),
        TeamMember(
          email: 'jack.morris@reminderapp.com',
          role: TeamRole.member,
          name: 'Jack Morris',
          avatarUrl: 'assets/images/profile.png',
        ),
        TeamMember(
          email: 'lily.rogers@reminderapp.com',
          role: TeamRole.viewer,
          name: 'Lily Rogers',
          avatarUrl: 'assets/images/person1.jpg',
        ),
      ],
    ),
    Team(
      id: '5',
      name: 'QA Team',
      description: 'Ensuring product quality through rigorous testing',
      avatarUrl: 'assets/images/profile.png',
      members: [
        TeamMember(
          email: 'michael.scott@reminderapp.com',
          role: TeamRole.admin,
          name: 'Michael Scott',
          avatarUrl: 'assets/images/person1.jpg',
        ),
        TeamMember(
          email: 'emily.evans@reminderapp.com',
          role: TeamRole.member,
          name: 'Emily Evans',
          avatarUrl: 'assets/images/profile.png',
        ),
        TeamMember(
          email: 'david.clark@reminderapp.com',
          role: TeamRole.member,
          name: 'David Clark',
          avatarUrl: 'assets/images/person1.jpg',
        ),
      ],
    ),
    Team(
      id: '6',
      name: 'Support Team',
      description: 'Providing exceptional customer support and assistance',
      avatarUrl: 'assets/images/person1.jpg',
      members: [
        TeamMember(
          email: 'chloe.king@reminderapp.com',
          role: TeamRole.admin,
          name: 'Chloe King',
          avatarUrl: 'assets/images/profile.png',
        ),
        TeamMember(
          email: 'matthew.green@reminderapp.com',
          role: TeamRole.member,
          name: 'Matthew Green',
          avatarUrl: 'assets/images/person1.jpg',
        ),
        TeamMember(
          email: 'grace.hall@reminderapp.com',
          role: TeamRole.member,
          name: 'Grace Hall',
          avatarUrl: 'assets/images/profile.png',
        ),
        TeamMember(
          email: 'andrew.baker@reminderapp.com',
          role: TeamRole.member,
          name: 'Andrew Baker',
          avatarUrl: 'assets/images/person1.jpg',
        ),
        TeamMember(
          email: 'ella.carter@reminderapp.com',
          role: TeamRole.viewer,
          name: 'Ella Carter',
          avatarUrl: 'assets/images/profile.png',
        ),
      ],
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
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                    description: description,
                    avatarUrl: 'assets/images/profile.png',
                    members: [
                      TeamMember(
                        email: emails.first,
                        role: TeamRole.admin,
                        name: emails.first.split('@')[0],
                        avatarUrl: 'assets/images/profile.png',
                      ),
                      ...emails
                          .skip(1)
                          .map(
                            (email) => TeamMember(
                              email: email,
                              role: TeamRole.member,
                              name: email.split('@')[0],
                              avatarUrl: 'assets/images/profile.png',
                            ),
                          ),
                    ],
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
