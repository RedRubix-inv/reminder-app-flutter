import 'package:flutter/material.dart';
import 'package:reminder_app/components/custom_appbar.dart';
import 'package:reminder_app/models/notification.dart';
import 'package:reminder_app/pages/notification/components/notification_card.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      title: 'New Task Assigned',
      message: 'You have been assigned to "Design System Update" task',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      type: 'task',
      isRead: false,
    ),
    AppNotification(
      id: '2',
      title: 'Meeting Reminder',
      message: 'Team sync meeting starts in 15 minutes',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: 'meeting',
      isRead: true,
    ),
    AppNotification(
      id: '3',
      title: 'Team Update',
      message: 'New member joined the Development Team',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: 'team',
      isRead: false,
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
            const VerticalSpace(20),
            Text(
              'Recent Notifications',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
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
