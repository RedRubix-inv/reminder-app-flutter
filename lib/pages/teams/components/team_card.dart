import 'package:flutter/material.dart';
import 'package:reminder_app/models/team.dart';
import 'package:reminder_app/pages/teams/components/team_management.dart';
import 'package:reminder_app/pages/teams/team_reminders_view.dart';

class TeamCard extends StatelessWidget {
  final Team team;

  const TeamCard({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeamManagementView(team: team),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
                  radius: 24,
                  backgroundImage: AssetImage(team.avatarUrl),
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${team.memberCount} members',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeamRemindersView(team: team),
                          ),
                        );
                      },
                      icon: const Icon(Icons.notifications_outlined),
                      tooltip: 'View Reminders',
                      color: Colors.grey[600],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => TeamManagementView(team: team),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ],
            ),
            if (team.description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                team.description,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (team.reminders.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.notifications, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${team.reminders.length} active reminders',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
