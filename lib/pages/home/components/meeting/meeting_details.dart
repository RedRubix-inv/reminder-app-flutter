import 'package:flutter/material.dart';
import 'package:reminder_app/utils/helpers.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';

class MeetingDetails extends StatelessWidget {
  final String title;
  final DateTime dateTime;
  final String priority;
  final String createdBy;
  final String? agendas;
  final List<String>? participants;

  const MeetingDetails({
    super.key,
    required this.title,
    required this.dateTime,
    required this.priority,
    required this.createdBy,
    this.agendas,
    this.participants,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
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
          const VerticalSpace(16),
          _buildInfoRow(
            icon: Icons.calendar_today,
            title: 'Date & Time',
            content: formatDateTime(dateTime),
          ),
          const VerticalSpace(16),
          _buildInfoRow(
            icon: Icons.timer,
            title: 'Time Remaining',
            content: getRemainingTime(dateTime),
          ),
          const VerticalSpace(16),
          _buildInfoRow(
            icon: Icons.person,
            title: 'Created by',
            content: createdBy,
          ),
          if (agendas != null) ...[
            const VerticalSpace(24),
            const Text(
              'Agendas & Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const VerticalSpace(8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                agendas!,
                style: TextStyle(color: Colors.grey[800], height: 1.5),
              ),
            ),
          ],
          if (participants != null && participants!.isNotEmpty) ...[
            const VerticalSpace(24),
            const Text(
              'Participants',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const VerticalSpace(12),
            ...participants!.map(
              (email) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey[200],
                      child: Text(
                        email[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(email, style: TextStyle(color: Colors.grey[800])),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
