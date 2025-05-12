import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:reminder_app/components/custom_appbar.dart';
import 'package:reminder_app/models/team.dart';
import 'package:reminder_app/pages/teams/components/create_team_page.dart';
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

      members: [
        TeamMember(
          email: 'emma.wilson@reminderapp.com',
          role: TeamRole.admin,
          name: 'Emma Wilson',
        ),
        TeamMember(
          email: 'liam.smith@reminderapp.com',
          role: TeamRole.member,
          name: 'Liam Smith',
        ),
        TeamMember(
          email: 'olivia.brown@reminderapp.com',
          role: TeamRole.member,
          name: 'Olivia Brown',
        ),
        TeamMember(
          email: 'noah.jones@reminderapp.com',
          role: TeamRole.member,
          name: 'Noah Jones',
        ),
        TeamMember(
          email: 'ava.davis@reminderapp.com',
          role: TeamRole.moderator,
          name: 'Ava Davis',
        ),
      ],
    ),
    Team(
      id: '2',
      name: 'Development Team',
      description: 'Building robust and scalable applications',

      members: [
        TeamMember(
          email: 'james.martin@reminderapp.com',
          role: TeamRole.admin,
          name: 'James Martin',
        ),
        TeamMember(
          email: 'sophia.thomas@reminderapp.com',
          role: TeamRole.member,
          name: 'Sophia Thomas',
        ),
        TeamMember(
          email: 'benjamin.jackson@reminderapp.com',
          role: TeamRole.member,
          name: 'Benjamin Jackson',
        ),
        TeamMember(
          email: 'mia.white@reminderapp.com',
          role: TeamRole.member,
          name: 'Mia White',
        ),
        TeamMember(
          email: 'william.harris@reminderapp.com',
          role: TeamRole.member,
          name: 'William Harris',
        ),
        TeamMember(
          email: 'isabella.moore@reminderapp.com',
          role: TeamRole.member,
          name: 'Isabella Moore',
        ),
        TeamMember(
          email: 'daniel.taylor@reminderapp.com',
          role: TeamRole.member,
          name: 'Daniel Taylor',
        ),
        TeamMember(
          email: 'charlotte.anderson@reminderapp.com',
          role: TeamRole.moderator,
          name: 'Charlotte Anderson',
        ),
      ],
    ),
    Team(
      id: '3',
      name: 'Marketing Team',
      description: 'Promoting our brand and engaging customers',

      members: [
        TeamMember(
          email: 'henry.lee@reminderapp.com',
          role: TeamRole.admin,
          name: 'Henry Lee',
        ),
        TeamMember(
          email: 'amelia.walker@reminderapp.com',
          role: TeamRole.member,
          name: 'Amelia Walker',
        ),
        TeamMember(
          email: 'ethan.miller@reminderapp.com',
          role: TeamRole.member,
          name: 'Ethan Miller',
        ),
        TeamMember(
          email: 'harper.thompson@reminderapp.com',
          role: TeamRole.moderator,
          name: 'Harper Thompson',
        ),
      ],
    ),
    Team(
      id: '4',
      name: 'Product Team',
      description: 'Defining product vision and managing roadmaps',

      members: [
        TeamMember(
          email: 'lucas.roberts@reminderapp.com',
          role: TeamRole.admin,
          name: 'Lucas Roberts',
        ),
        TeamMember(
          email: 'evelyn.martinez@reminderapp.com',
          role: TeamRole.member,
          name: 'Evelyn Martinez',
        ),
        TeamMember(
          email: 'mason.hernandez@reminderapp.com',
          role: TeamRole.member,
          name: 'Mason Hernandez',
        ),
        TeamMember(
          email: 'sofia.gonzalez@reminderapp.com',
          role: TeamRole.member,
          name: 'Sofia Gonzalez',
        ),
        TeamMember(
          email: 'jack.morris@reminderapp.com',
          role: TeamRole.member,
          name: 'Jack Morris',
        ),
        TeamMember(
          email: 'lily.rogers@reminderapp.com',
          role: TeamRole.moderator,
          name: 'Lily Rogers',
        ),
      ],
    ),
    Team(
      id: '5',
      name: 'QA Team',
      description: 'Ensuring product quality through rigorous testing',

      members: [
        TeamMember(
          email: 'michael.scott@reminderapp.com',
          role: TeamRole.admin,
          name: 'Michael Scott',
        ),
        TeamMember(
          email: 'emily.evans@reminderapp.com',
          role: TeamRole.member,
          name: 'Emily Evans',
        ),
        TeamMember(
          email: 'david.clark@reminderapp.com',
          role: TeamRole.member,
          name: 'David Clark',
        ),
      ],
    ),
    Team(
      id: '6',
      name: 'Support Team',
      description: 'Providing exceptional customer support and assistance',

      members: [
        TeamMember(
          email: 'chloe.king@reminderapp.com',
          role: TeamRole.admin,
          name: 'Chloe King',
        ),
        TeamMember(
          email: 'matthew.green@reminderapp.com',
          role: TeamRole.member,
          name: 'Matthew Green',
        ),
        TeamMember(
          email: 'grace.hall@reminderapp.com',
          role: TeamRole.member,
          name: 'Grace Hall',
        ),
        TeamMember(
          email: 'andrew.baker@reminderapp.com',
          role: TeamRole.member,
          name: 'Andrew Baker',
        ),
        TeamMember(
          email: 'ella.carter@reminderapp.com',
          role: TeamRole.moderator,
          name: 'Ella Carter',
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
            const VerticalSpace(24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Teams',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Sora',
                      ),
                    ),
                    const HorizontalSpace(12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: secondaryColor),
                      ),
                      child: Text(
                        '${_teams.length} Teams',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontFamily: 'Sora',
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _showCreateTeamPage,
                  icon: const Icon(
                    LucideIcons.userPlus2,
                    size: 40,
                    color: textColor,
                  ),
                  tooltip: 'Create New Team',
                ),
              ],
            ),
            const VerticalSpace(24),
            Expanded(
              child:
                  _teams.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.users2,
                              size: 64,
                              color: textColorSecondary.withOpacity(0.5),
                            ),
                            const VerticalSpace(16),
                            Text(
                              'No Teams Yet',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: textColorSecondary,
                                fontFamily: 'Sora',
                              ),
                            ),
                            const VerticalSpace(8),
                            Text(
                              'Create your first team to get started',
                              style: TextStyle(
                                fontSize: 16,
                                color: textColorSecondary.withOpacity(0.8),
                                fontFamily: 'Sora',
                              ),
                            ),
                            const VerticalSpace(24),
                            ElevatedButton.icon(
                              onPressed: _showCreateTeamPage,
                              icon: const Icon(LucideIcons.userPlus2),
                              label: const Text('Create Team'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: _teams.length,
                        padding: const EdgeInsets.only(bottom: 24),
                        itemBuilder: (context, index) {
                          final team = _teams[index];
                          return TeamCard(team: team);
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateTeamPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CreateTeamPage(
              onCreateTeam: (name, description, emails) {
                setState(() {
                  _teams.add(
                    Team(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      description: description,

                      members: [
                        TeamMember(
                          email: emails.first,
                          role: TeamRole.admin,
                          name: emails.first.split('@')[0],
                        ),
                        ...emails
                            .skip(1)
                            .map(
                              (email) => TeamMember(
                                email: email,
                                role: TeamRole.member,
                                name: email.split('@')[0],
                              ),
                            ),
                      ],
                    ),
                  );
                });
              },
            ),
      ),
    );
  }
}
