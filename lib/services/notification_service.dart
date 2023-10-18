import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialize the notification service
  Future<void> initialize() async {
    // Android Initialization
    AndroidInitializationSettings androidInitializationSettings = const
    AndroidInitializationSettings("todo_icon");

    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channel_id', 'Channel_name',
        channelDescription: "todo_app",
        importance: Importance.max,
        priority: Priority.max,
      ),
    );
  }

  Future showNotification({int id=0,
    String? title,
    String? body,
    String? payload,
    required tz.TZDateTime scheduledDate,
  }) async {
    return flutterLocalNotificationsPlugin.show(
        id, title, body, await notificationDetails());
  }


  Future scheduleNotification({
    int id = 0,
    String? title,
    String? desc,
    String? payload,
    required DateTime scheduleNotificationTime}) async {
    return flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      desc,
      tz.TZDateTime.from(
        scheduleNotificationTime,
        tz.local,
      ),
      await notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation
          .absoluteTime,
    );
  }
}