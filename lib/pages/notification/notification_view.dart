import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:reminder_app/components/custom_appbar.dart';
import 'package:reminder_app/components/delete_dialog/delete_dialog.dart';
import 'package:reminder_app/components/show_toast.dart';
import 'package:reminder_app/models/notification.dart';
import 'package:reminder_app/pages/notification/components/notification_card.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';
import 'package:toastification/toastification.dart' as toast;

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      title: 'Daily Reminder',
      message: 'Your daily reminder "Morning Exercise" is due in 15 minutes',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      type: 'reminder',
      isRead: false,
    ),
    AppNotification(
      id: '2',
      title: 'Weekend Reminder',
      message:
          'Your weekend reminder "Family Dinner" is scheduled for tomorrow at 7:00 PM',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      type: 'reminder',
      isRead: false,
    ),
    AppNotification(
      id: '3',
      title: 'Reminder Completed',
      message: 'You have completed "Weekly Report" reminder',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      type: 'reminder',
      isRead: true,
    ),
    AppNotification(
      id: '4',
      title: 'Multiple Dates Reminder',
      message: 'Your reminder "Project Review" is scheduled for next 3 days',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      type: 'reminder',
      isRead: false,
    ),
    AppNotification(
      id: '5',
      title: 'Reminder Overdue',
      message: 'Your reminder "Call Mom" is overdue by 2 hours',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      type: 'reminder',
      isRead: false,
    ),
    AppNotification(
      id: '6',
      title: 'Weekday Reminder',
      message:
          'Your weekday reminder "Team Standup" is scheduled for next 5 days',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: 'reminder',
      isRead: true,
    ),
    AppNotification(
      id: '7',
      title: 'Reminder Deleted',
      message: 'Your reminder "Old Task" has been deleted',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: 'reminder',
      isRead: true,
    ),
    AppNotification(
      id: '8',
      title: 'Reminder Created',
      message: 'New reminder "Weekly Planning" has been created',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      type: 'reminder',
      isRead: true,
    ),
  ];

  void _markAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] = AppNotification(
          id: _notifications[index].id,
          title: _notifications[index].title,
          message: _notifications[index].message,
          timestamp: _notifications[index].timestamp,
          type: _notifications[index].type,
          isRead: true,
          actionUrl: _notifications[index].actionUrl,
        );
      }
    });
  }

  void _handleClearAllNotifications() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteDialog(
          title: 'Clear All Notifications',
          message: 'Are you sure you want to clear all notifications?',
          deleteButtonText: 'Clear All',
          onDelete: () {
            showToast(
              context,
              type: toast.ToastificationType.success,
              title: 'Notifications Cleared',
              description: 'All notifications have been cleared successfully',
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        displayMode: LeadingDisplayMode.backWithText,
        leadingText: 'Notifications',
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Notifications',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                IconButton(
                  onPressed: _handleClearAllNotifications,
                  icon: Icon(LucideIcons.trash2, color: errorColor, size: 24),
                ),
              ],
            ),
            const VerticalSpace(16),
            Expanded(
              child: ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return NotificationCard(
                    notification: notification,
                    onTap: () => _markAsRead(notification.id),
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
