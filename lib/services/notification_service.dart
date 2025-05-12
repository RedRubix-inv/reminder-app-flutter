import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  //INITIALIZE NOTIFICATIONS

  Future<void> initialize() async {
    if (isInitialized) {
      return;
    }

    // Request permissions immediately
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    //preapre android init settings
    const initSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    //prepare ios init settings
    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    //init settings
    const initializationSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    //finally initialize the plugin
    await notificationsPlugin.initialize(initializationSettings);
    _isInitialized = true;
  }

  //notification detail setup

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Reminder',
        channelDescription: "Daily Reminder Channel",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        // sound: null,
      ),
      iOS: DarwinNotificationDetails(sound: 'default', presentSound: true),
    );
  }

  //show notification

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    if (!isInitialized) {
      await initialize();
    }
    return notificationsPlugin.show(id, title, body, notificationDetails());
  }
}
