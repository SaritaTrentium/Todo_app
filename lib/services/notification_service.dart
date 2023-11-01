import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialize the notification service
  static Future initializeNotification({bool scheduled = false}) async {
    // Android Initialization
    final AndroidInitializationSettings androidInitializationSettings = const
    AndroidInitializationSettings("todo_icon");
    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  // static void sendNotification(String title,String body)async {
  //   NotificationDetails notificationDetails = NotificationDetails(
  //     android:AndroidNotificationDetails('channel_id 8', 'Channel_name',
  //       channelDescription: "todo_app",
  //       importance: Importance.max,
  //       priority: Priority.max,
  //     ),
  //   );
  //   flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  // }

  static notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channel id 0', 'Channel name',
        channelDescription: "todo_app",
        importance: Importance.max,
        priority: Priority.max,
      ),
    );
  }

  static Future showNotification({int id=0,
    String? title,
    String? body,
    String? payload,
  }) async {
    return flutterLocalNotificationsPlugin.show(
        id, title, body, await notificationDetails(), payload: payload);
  }


  static Future scheduleNotification({
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
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation
          .absoluteTime,
    );
  }
}