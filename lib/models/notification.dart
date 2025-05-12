class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String type; // 'task', 'meeting', 'team', etc.
  final bool isRead;
  final String?
  actionUrl; // Optional URL to navigate to when notification is tapped

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.actionUrl,
  });
}
