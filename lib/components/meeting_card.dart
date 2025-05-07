import 'package:flutter/material.dart';
import 'package:reminder_app/pages/home/meeting_details_view.dart';
import 'package:reminder_app/utils/helpers.dart';
import 'package:reminder_app/utils/theme.dart';

class MeetingCard extends StatelessWidget {
  final String title;
  final DateTime dateTime;
  final String priority;
  final String createdBy;
  final String agendas;
  final List<String> participants;

  const MeetingCard({
    super.key,
    required this.title,
    required this.dateTime,
    required this.priority,
    required this.createdBy,
    required this.agendas,
    required this.participants,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => MeetingDetailsView(
                  title: title,
                  dateTime: dateTime,
                  priority: priority,
                  agendas: agendas,
                  participants: participants,
                  createdBy: createdBy,
                ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        priority == 'High'
                            ? Colors.red.withOpacity(0.1)
                            : priority == 'Medium'
                            ? Colors.orange.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    priority,
                    style: TextStyle(
                      color:
                          priority == 'High'
                              ? Colors.red
                              : priority == 'Medium'
                              ? Colors.orange
                              : Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: textColor),
                const SizedBox(width: 8),
                Text(
                  formatDateTime(dateTime),
                  style: TextStyle(color: textColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.timer, size: 16, color: textColor),
                const SizedBox(width: 8),
                Text(
                  getRemainingTime(dateTime),
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: textColor),
                const SizedBox(width: 8),
                Text(
                  'Created by: $createdBy',
                  style: TextStyle(color: textColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
