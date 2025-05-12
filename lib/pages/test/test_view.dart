import 'package:flutter/material.dart';
import 'package:reminder_app/services/notification_service.dart';

class TestView extends StatelessWidget {
  const TestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test View')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            NotificationService().showNotification(
              title: 'Test Notification',
              body: 'This is a test notification',
            );
          },
          child: Text('Send Notification'),
        ),
      ),
    );
  }
}
