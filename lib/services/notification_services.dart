import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices{
  static Set<String> subscribedTokens = {};

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

  static Future<void> sendNotification({required String title,required String desc}) async {
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

  static Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<void> subscribeDevice(String deviceToken) async {
    await subscribedTokens.add(deviceToken);
  }

  static Future<void> unsubscribeDevice(String deviceToken) async {
    await subscribedTokens.remove(deviceToken);
  }

}