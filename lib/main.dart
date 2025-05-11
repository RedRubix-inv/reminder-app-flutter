import 'package:flutter/material.dart';
import 'package:reminder_app/services/notification_service.dart';

import 'utils/router.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Reminder App',
      theme: lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
