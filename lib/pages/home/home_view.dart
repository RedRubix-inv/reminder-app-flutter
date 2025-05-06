import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reminder_app/components/custom_appbar.dart';
import 'package:reminder_app/components/meeting_card.dart';
import 'package:reminder_app/utils/router.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';

class Meeting {
  final String title;
  final DateTime dateTime;
  final String priority;
  final String agendas;
  final String createdBy;
  final List<String> participants;
  Meeting({
    required this.title,
    required this.dateTime,
    required this.priority,
    required this.agendas,
    required this.createdBy,
    required this.participants,
  });
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Meeting> meetings = [
      Meeting(
        title: 'Team Sync Meeting',
        dateTime: DateTime.now().add(const Duration(days: 0)),
        priority: 'High',
        agendas:
            "Weekly team sync to discuss progress and blockers. We will review the sprint goals and address any challenges faced by team members.",
        createdBy: 'john.doe@example.com',
        participants: [
          'john.doe@example.com',
          'jane.smith@example.com',
          'alex.wilson@example.com',
          'sarah.brown@example.com',
          'mike.jones@example.com',
        ],
      ),
      Meeting(
        title: 'Project Review',
        dateTime: DateTime.now().add(const Duration(days: 2)),
        priority: 'Medium',
        agendas:
            "Weekly team sync to discuss progress and blockers. We will review the sprint goals and address any challenges faced by team members.",
        createdBy: 'maharjanm9@gmail.com',
        participants: [
          'maharjanm9@gmail.com',
          'jane.smith@example.com',
          'sarah.brown@example.com',
          'mike.jones@example.com',
          'emma.davis@example.com',
        ],
      ),
      Meeting(
        title: 'Client Presentation',
        dateTime: DateTime.now().add(const Duration(days: 3)),
        priority: 'High',
        agendas:
            "Weekly team sync to discuss progress and blockers. We will review the sprint goals and address any challenges faced by team members.",
        createdBy: 'silva123@gmail.com',
        participants: [
          'silva123@gmail.com',
          'john.doe@example.com',
          'alex.wilson@example.com',
          'emma.davis@example.com',
          'liam.martin@example.com',
        ],
      ),
      Meeting(
        title: 'Sprint Planning',
        dateTime: DateTime.now().add(const Duration(days: 4)),
        priority: 'Medium',
        agendas:
            "Weekly team sync to discuss progress and blockers. We will review the sprint goals and address any challenges faced by team members.",
        createdBy: 'speedy@gmail.com',
        participants: [
          'speedy@gmail.com',
          'jane.smith@example.com',
          'sarah.brown@example.com',
          'liam.martin@example.com',
          'olivia.white@example.com',
        ],
      ),
      Meeting(
        title: 'Design Review',
        dateTime: DateTime.now().add(const Duration(days: 5)),
        priority: 'Low',
        agendas:
            "Weekly team sync to discuss progress and blockers. We will review the sprint goals and address any challenges faced by team members.",
        createdBy: 'sakura@gmail.com',
        participants: [
          'sakura@gmail.com',
          'mike.jones@example.com',
          'alex.wilson@example.com',
          'emma.davis@example.com',
          'olivia.white@example.com',
        ],
      ),
    ];

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
              'Look at your meeting schedule.',
              style: TextStyle(fontSize: 16, color: textColorSecondary),
            ),
            const VerticalSpace(20),
            Text(
              'Upcoming Meetings (${meetings.length})',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const VerticalSpace(16),
            Expanded(
              child: ListView.builder(
                itemCount: meetings.length,
                itemBuilder: (context, index) {
                  final meeting = meetings[index];
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
                    child: MeetingCard(
                      title: meeting.title,
                      dateTime: meeting.dateTime,
                      priority: meeting.priority,
                      agendas: meeting.agendas,
                      createdBy: meeting.createdBy,
                      participants: meeting.participants,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(RouteName.createMeeting);
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
