import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:reminder_app/components/custom_appbar.dart';
import 'package:reminder_app/components/delete_dialog/delete_dialog.dart';
import 'package:reminder_app/components/show_toast.dart';
import 'package:reminder_app/components/team_members_dialog/team_members_dialog.dart';
import 'package:reminder_app/models/team.dart';
import 'package:reminder_app/utils/helpers.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';
import 'package:toastification/toastification.dart';

class ReminderDetailsView extends StatelessWidget {
  final String title;
  final String description;
  final TimeOfDay time;
  final List<DateTime> dates;
  final String frequency;
  final List<TeamMember> teamMembers;

  const ReminderDetailsView({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.dates,
    required this.frequency,
    this.teamMembers = const [],
  });

  void _handleDelete(BuildContext context) {
    // TODO: Implement actual delete functionality
    showToast(
      context,
      type: ToastificationType.success,
      title: 'Reminder Deleted',
      description: 'Reminder "$title" has been deleted successfully',
    );
  }

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
    if (difference.inDays >= 5) {
      return 'in ${difference.inDays} days';
    } else if (difference.inDays >= 2) {
      return 'in ${difference.inDays} days';
    } else if (difference.inDays > 0) {
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

  Widget _buildInfoSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: textColorSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Sora',
          ),
        ),
        const VerticalSpace(4),
        content,
        const VerticalSpace(16),
      ],
    );
  }

  Widget _buildDateChip(DateTime date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: primaryColor.withAlpha(50),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Text(
        formatDateToHumanReadable(date),
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Sora',
        ),
      ),
    );
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

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        displayMode: LeadingDisplayMode.backWithText,
        leadingText: 'Reminder Details',
        onNotificationPressed: () {},
        showNotification: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: primaryColor.withAlpha(50),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          LucideIcons.bell,
                          color: primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Sora',
                                    ),
                                  ),
                                ),
                                if (teamMembers.isNotEmpty)
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return TeamMembersDialog(
                                            teamMembers: teamMembers,
                                            title: 'Team Members',
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      LucideIcons.users2,
                                      color: primaryColor,
                                      size: 24,
                                    ),
                                    tooltip: 'View Team Members',
                                  ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DeleteDialog(
                                          title: 'Delete Reminder',
                                          message:
                                              'Are you sure you want to delete this reminder?',
                                          onDelete:
                                              () => _handleDelete(context),
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    LucideIcons.trash2,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                  tooltip: 'Delete Reminder',
                                ),
                              ],
                            ),
                            const VerticalSpace(2),
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
                                frequency,
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
                      ),
                    ],
                  ),
                  const VerticalSpace(16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: primaryColor.withAlpha(50),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          LucideIcons.alignLeft,
                          color: primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          description,
                          style: TextStyle(
                            color: textColorSecondary,
                            fontSize: 16,
                            fontFamily: 'Sora',
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const VerticalSpace(24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection(
                    'Time',
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: primaryColor.withAlpha(50),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      LucideIcons.clock,
                                      size: 20,
                                      color: primaryColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      time.format(context),
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Sora',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const HorizontalSpace(8),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _getTimeBackgroundColor(
                                    targetDate,
                                    time,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      LucideIcons.hourglass,
                                      size: 20,
                                      color: _getTimeColor(targetDate, time),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _getRelativeTime(targetDate, time),
                                      style: TextStyle(
                                        color: _getTimeColor(targetDate, time),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Sora',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  _buildInfoSection(
                    'Dates',
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: primaryColor.withAlpha(50),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                LucideIcons.calendarCheck,
                                color: primaryColor,
                                size: 24,
                              ),
                            ),
                            const HorizontalSpace(12),
                            Text(
                              'Selected Dates',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Sora',
                              ),
                            ),
                          ],
                        ),
                        const VerticalSpace(12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 12,
                            runSpacing: 12,
                            children: dates.map(_buildDateChip).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
