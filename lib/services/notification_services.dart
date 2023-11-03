import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices{
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future initializeNotification()async{
    // Android initialize
    final AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings("todo_icon");
    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

  }

  static sendNotification({required String title,required String desc}) async {
    AndroidNotificationDetails androidNotificationDetails =
    const AndroidNotificationDetails(
      "channelId",
      "channelName",
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
        0, title, desc, notificationDetails);
  }
  // static showPeriodicNotification({
  //   required int id,
  //   required String title,
  //   required String desc})async{
  //   AndroidNotificationDetails androidNotificationDetails =
  //   const AndroidNotificationDetails(
  //     "channelId",
  //     "channelName",
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );NotificationDetails notificationDetails = NotificationDetails(
  //     android: androidNotificationDetails,
  //   );
  //   await flutterLocalNotificationsPlugin.periodicallyShow(id, title, desc, RepeatInterval.everyMinute, notificationDetails);
  // }
}