import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:reminder_app/utils/helpers.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';

class ReminderCard extends StatelessWidget {
  final String title;
  final String description;
  final TimeOfDay time;
  final List<DateTime> dates;
  final String frequency;
  final VoidCallback? onTap;
  final String type;
  const ReminderCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.dates,
    required this.frequency,
    required this.type,
    this.onTap,
  });

  String _getRelativeTime(DateTime date, TimeOfDay time) {
    final now = DateTime.now();
    final reminderDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    if (reminderDateTime.isBefore(now)) {
      return 'Overdue';
    }

    final difference = reminderDateTime.difference(now);
    if (difference.inDays > 0) {
      return 'in ${difference.inDays} day${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'in ${difference.inHours} hour${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'in ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'Now';
    }
  }

  Color _getTimeColor(DateTime date, TimeOfDay time) {
    final now = DateTime.now();
    final reminderDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    if (reminderDateTime.isBefore(now)) {
      return Colors.red;
    }

    final difference = reminderDateTime.difference(now);
    if (difference.inDays >= 5) {
      return Colors.green;
    } else if (difference.inDays >= 2) {
      return Colors.orange;
    } else if (difference.inDays > 0) {
      return Colors.orange.shade700;
    } else if (difference.inHours > 0) {
      return Colors.orange.shade900;
    } else {
      return Colors.red.shade700;
    }
  }

  Color _getTimeBackgroundColor(DateTime date, TimeOfDay time) {
    final now = DateTime.now();
    final reminderDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    if (reminderDateTime.isBefore(now)) {
      return Colors.red.withAlpha(30);
    }

    final difference = reminderDateTime.difference(now);
    if (difference.inDays >= 5) {
      return Colors.green.withAlpha(30);
    } else if (difference.inDays >= 2) {
      return Colors.orange.withAlpha(30);
    } else if (difference.inDays > 0) {
      return Colors.orange.shade700.withAlpha(30);
    } else if (difference.inHours > 0) {
      return Colors.orange.shade900.withAlpha(30);
    } else {
      return Colors.red.shade700.withAlpha(30);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the next upcoming date
    final now = DateTime.now();
    final futureDates =
        dates
            .where(
              (date) => DateTime(
                date.year,
                date.month,
                date.day,
                time.hour,
                time.minute,
              ).isAfter(now),
            )
            .toList();

    // If no future dates, use the most recent date
    final targetDate =
        futureDates.isNotEmpty
            ? futureDates.reduce((a, b) => a.isBefore(b) ? a : b)
            : dates.reduce((a, b) => a.isAfter(b) ? a : b);

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    type.toUpperCase() == 'PERSONAL'
                        ? LucideIcons.user2
                        : LucideIcons.users2,
                    size: 20,
                    color: textColor,
                  ),
                  const HorizontalSpace(8),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sora',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withAlpha(50),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      formatDateToHumanReadable(targetDate),
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Sora',
                      ),
                    ),
                  ),
                ],
              ),
              const VerticalSpace(8),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColorSecondary,
                  fontSize: 14,
                  fontFamily: 'Sora',
                ),
              ),
              const VerticalSpace(12),
              Row(
                children: [
                  Icon(LucideIcons.clock, size: 16, color: textColorSecondary),
                  const SizedBox(width: 4),
                  Text(
                    time.format(context),
                    style: TextStyle(
                      color: textColorSecondary,
                      fontSize: 14,
                      fontFamily: 'Sora',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    LucideIcons.calendar,
                    size: 16,
                    color: textColorSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${dates.length} date${dates.length > 1 ? 's' : ''}',
                    style: TextStyle(
                      color: textColorSecondary,
                      fontSize: 14,
                      fontFamily: 'Sora',
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getTimeBackgroundColor(targetDate, time),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.hourglass,
                          size: 14,
                          color: _getTimeColor(targetDate, time),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getRelativeTime(targetDate, time),
                          style: TextStyle(
                            color: _getTimeColor(targetDate, time),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Sora',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
