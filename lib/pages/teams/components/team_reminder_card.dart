import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/models/team.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';

class TeamReminderCard extends StatelessWidget {
  final TeamReminder reminder;
  final Team team;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onComplete;

  const TeamReminderCard({
    super.key,
    required this.reminder,
    required this.team,
    this.onEdit,
    this.onDelete,
    this.onComplete,
  });

  String _getFrequencyText() {
    switch (reminder.frequency) {
      case ReminderFrequency.oneTime:
        return 'One-time';
      case ReminderFrequency.multipleDates:
        return 'Multiple Dates';
      case ReminderFrequency.weekday:
        return 'Weekdays (Mon-Fri)';
      case ReminderFrequency.weekend:
        return 'Weekends (Sat-Sun)';
    }
  }

  String _getAssignedToName() {
    final member = team.members.firstWhere(
      (m) => m.email == reminder.assignedToEmail,
      orElse:
          () => TeamMember(
            email: reminder.assignedToEmail,
            role: TeamRole.member,
          ),
    );
    return member.name ?? member.email;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    reminder.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                if (onEdit != null || onDelete != null)
                  PopupMenuButton<String>(
                    itemBuilder:
                        (context) => [
                          if (onEdit != null)
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                          if (onDelete != null)
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                        ],
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit?.call();
                          break;
                        case 'delete':
                          onDelete?.call();
                          break;
                      }
                    },
                  ),
              ],
            ),
            const VerticalSpace(8),
            Text(
              reminder.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const VerticalSpace(16),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const HorizontalSpace(8),
                Text(
                  dateFormat.format(reminder.dateTime),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const HorizontalSpace(16),
                const Icon(Icons.access_time, size: 16),
                const HorizontalSpace(8),
                Text(
                  timeFormat.format(reminder.dateTime),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const VerticalSpace(8),
            Row(
              children: [
                const Icon(Icons.repeat, size: 16),
                const HorizontalSpace(8),
                Text(
                  _getFrequencyText(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const VerticalSpace(8),
            Row(
              children: [
                const Icon(Icons.person, size: 16),
                const HorizontalSpace(8),
                Text(
                  'Assigned to: ${_getAssignedToName()}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            if (onComplete != null) ...[
              const VerticalSpace(16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onComplete,
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        reminder.isCompleted ? Colors.green : primaryColor,
                  ),
                  child: Text(
                    reminder.isCompleted ? 'Completed' : 'Mark as Complete',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
