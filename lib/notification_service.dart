import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
class NotificationService extends StatefulWidget{
  final String body;
  final String title;

  //NotificationService a singleton object
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal({
    Key key,@required this.body, @required this.title,

  }) : super(key: key);

  static const channelId = '1234';


  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
        'channel id',
    'channel name',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
        onlyAlertOnce: true,
  );
  AndroidNotificationDetails _androidNotificationDetails2 =
  AndroidNotificationDetails(
    'channel id',
  'channel name',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
    onlyAlertOnce: true,
  );
  AndroidNotificationDetails _androidNotificationDetails3 =
  AndroidNotificationDetails(
    'channel id',
    'channel name',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
    onlyAlertOnce: true,

  );
  AndroidNotificationDetails _androidNotificationDetails4 =
  AndroidNotificationDetails(
    'channel id',
    'channel name',
    playSound: true,
    importance: Importance.high,
    onlyAlertOnce: true,
  );
  AndroidNotificationDetails _androidNotificationDetails5 =
  AndroidNotificationDetails(
    'channel id',
    'channel name',
    playSound: true,
    importance: Importance.low,
    onlyAlertOnce: true,
    autoCancel: true,
  );
  AndroidNotificationDetails _androidNotificationDetails6 =
  AndroidNotificationDetails(
    'channel id',
    'channel name',
    playSound: true,
    importance: Importance.low,
    onlyAlertOnce: true,
    autoCancel: true,
  );
  AndroidNotificationDetails _androidNotificationDetails7 =
  AndroidNotificationDetails(
    'channel id',
    'channel name',
    playSound: true,
    importance: Importance.low,
    onlyAlertOnce: true,
    autoCancel: true,
  );
  Future<void> showNotifications(String body, String title) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      NotificationDetails(android: _androidNotificationDetails),
    );
  }

  Future<void> showNotifications2(String body, [String title]) async {
    await flutterLocalNotificationsPlugin.show(
      1,
      title,
      body,
      NotificationDetails(android: _androidNotificationDetails2),
    );
  }
  Future<void> showNotifications3(String body, [String title]) async {
    await flutterLocalNotificationsPlugin.show(
      2,
      title,
      body,
      NotificationDetails(android: _androidNotificationDetails3),
    );
  }
  Future<void> showNotifications4(String body, [String title]) async {
    await flutterLocalNotificationsPlugin.show(
      3,
      title,
      body,
      NotificationDetails(android: _androidNotificationDetails4),
    );
  }

  Future<void> showNotifications5(String body, [String title]) async {
    await flutterLocalNotificationsPlugin.show(
      4,
      title,
      body,
      NotificationDetails(android: _androidNotificationDetails5),
    );
  }
  Future<void> showNotifications6(String body, [String title]) async {
    await flutterLocalNotificationsPlugin.show(
      5,
      title,
      body,
      NotificationDetails(android: _androidNotificationDetails6),
    );
  }
  Future<void> showNotifications7(String body, [String title]) async {
    await flutterLocalNotificationsPlugin.show(
      6,
      title,
      body,
      NotificationDetails(android: _androidNotificationDetails7),
    );
  }






  Future<void> scheduleNotifications() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        "Notification Title",
        "This is the Notification Body!",
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        NotificationDetails(android: _androidNotificationDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(4);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

}

Future selectNotification(String payload) async {
  //handle your logic here

}
