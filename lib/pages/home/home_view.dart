import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:reminder_app/components/custom_appbar.dart';
import 'package:reminder_app/pages/home/components/reminder/reminder_card.dart';
import 'package:reminder_app/pages/home/components/reminder/reminder_details_view.dart';
import 'package:reminder_app/utils/router.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';

enum TeamRole { admin, member, moderator }

class TeamMember {
  final String name;
  final String email;
  final TeamRole role;

  const TeamMember({
    required this.name,
    required this.email,
    required this.role,
  });
}

class Reminder {
  final String title;
  final String description;
  final TimeOfDay time;
  final List<DateTime> dates;
  final String frequency;
  final String type;
  final List<TeamMember> teamMembers;

  Reminder({
    required this.title,
    required this.description,
    required this.time,
    required this.dates,
    required this.frequency,
    required this.type,
    this.teamMembers = const [],
  });
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Reminder> reminders = [
      Reminder(
        title: 'Team Standup',
        description: 'Daily team sync to discuss progress and blockers',
        time: const TimeOfDay(hour: 10, minute: 0),
        dates: [
          DateTime.now().add(const Duration(days: 1)),
          DateTime.now().add(const Duration(days: 2)),
          DateTime.now().add(const Duration(days: 3)),
        ],
        frequency: 'Weekday (Mon-Fri)',
        type: 'team',
        teamMembers: [
          TeamMember(
            name: 'Manish Maharjan',
            email: 'manish.maharjan@example.com',
            role: TeamRole.admin,
          ),
          TeamMember(
            name: 'John Doe',
            email: 'john.doe@example.com',
            role: TeamRole.moderator,
          ),
          TeamMember(
            name: 'Jane Smith',
            email: 'jane.smith@example.com',
            role: TeamRole.member,
          ),
          TeamMember(
            name: 'Bhavudipu',
            email: 'bhavudipu@example.com',
            role: TeamRole.member,
          ),
          TeamMember(
            name: 'Jane Smith',
            email: 'jane.smith@example.com',
            role: TeamRole.member,
          ),
          TeamMember(
            name: 'Jane Smith',
            email: 'jane.smith@example.com',
            role: TeamRole.member,
          ),
          TeamMember(
            name: 'Jane Smith',
            email: 'jane.smith@example.com',
            role: TeamRole.member,
          ),
          TeamMember(
            name: 'Jane Smith',
            email: 'jane.smith@example.com',
            role: TeamRole.member,
          ),
        ],
      ),
      Reminder(
        title: 'Project Review',
        description: 'Weekly project status review with stakeholders',
        time: const TimeOfDay(hour: 14, minute: 30),
        dates: [DateTime.now().subtract(const Duration(days: 5))],
        frequency: 'One-time',
        type: 'personal',
      ),
      Reminder(
        title: 'Gym Session',
        description: 'Regular workout session',
        time: const TimeOfDay(hour: 18, minute: 0),
        dates: [
          DateTime.now().subtract(const Duration(days: 1)),
          DateTime.now().add(const Duration(days: 3)),
          DateTime.now().add(const Duration(days: 5)),
          DateTime.now().add(const Duration(days: 7)),
          DateTime.now().add(const Duration(days: 9)),
          DateTime.now().add(const Duration(days: 11)),
          DateTime.now().add(const Duration(days: 13)),
          DateTime.now().add(const Duration(days: 15)),
          DateTime.now().add(const Duration(days: 17)),
          DateTime.now().add(const Duration(days: 19)),
          DateTime.now().add(const Duration(days: 21)),
        ],
        frequency: 'Multiple Dates',
        type: 'personal',
      ),
      Reminder(
        title: 'Weekend Planning Of MAIDAAN',
        description: 'Plan activities for the weekend',
        time: const TimeOfDay(hour: 11, minute: 0),
        dates: [
          DateTime.now().add(const Duration(days: 6)),
          DateTime.now().add(const Duration(days: 7)),
        ],
        frequency: 'Weekend (Sat-Sun)',
        type: 'team',
        teamMembers: [
          TeamMember(
            name: 'Manish Maharjan',
            email: 'manish.maharjan@example.com',
            role: TeamRole.admin,
          ),
          TeamMember(
            name: 'John Doe',
            email: 'john.doe@example.com',
            role: TeamRole.moderator,
          ),
          TeamMember(
            name: 'Jane Smith',
            email: 'jane.smith@example.com',
            role: TeamRole.member,
          ),
        ],
      ),
      Reminder(
        title: 'Client Call',
        description: 'Important client meeting to discuss project requirements',
        time: const TimeOfDay(hour: 15, minute: 0),
        dates: [DateTime.now().add(const Duration(days: 2))],
        frequency: 'One-time',
        type: 'personal',
      ),
      Reminder(
        title: 'Team Standup',
        description: 'Daily team sync to discuss progress and blockers',
        time: const TimeOfDay(hour: 10, minute: 0),
        dates: [DateTime.now().add(const Duration(days: 1))],
        frequency: 'Weekday (Mon-Fri)',
        type: 'team',
        teamMembers: [
          TeamMember(
            name: 'Manish Maharjan',
            email: 'manish.maharjan@example.com',
            role: TeamRole.admin,
          ),
          TeamMember(
            name: 'John Doe',
            email: 'john.doe@example.com',
            role: TeamRole.moderator,
          ),
          TeamMember(
            name: 'Jane Smith',
            email: 'jane.smith@example.com',
            role: TeamRole.member,
          ),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        displayMode: LeadingDisplayMode.avatarOnly,
        avatarImageUrl: 'assets/images/profile.png',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getScreenWidth(context) * 0.04,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Hello,',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.normal,
                    color: textColor,
                  ),
                ),
                Text(
                  'Manish!',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const VerticalSpace(8),
            Text(
              'Check your schedule and reminders.',
              style: TextStyle(fontSize: 16, color: textColorSecondary),
            ),
            const VerticalSpace(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upcoming Reminders (${reminders.length})',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const HorizontalSpace(16),
                IconButton(
                  onPressed: () {
                    context.push(RouteName.createReminder);
                  },
                  icon: const Icon(
                    LucideIcons.bellPlus,
                    color: textColor,
                    size: 30,
                  ),
                ),
              ],
            ),
            const VerticalSpace(8),
            Expanded(
              child: ListView.builder(
                itemCount: reminders.length,
                itemBuilder: (context, index) {
                  final reminder = reminders[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ReminderCard(
                      title: reminder.title,
                      description: reminder.description,
                      time: reminder.time,
                      dates: reminder.dates,
                      frequency: reminder.frequency,
                      type: reminder.type,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ReminderDetailsView(
                                  title: reminder.title,
                                  description: reminder.description,
                                  time: reminder.time,
                                  dates: reminder.dates,
                                  frequency: reminder.frequency,
                                  teamMembers: reminder.teamMembers,
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
