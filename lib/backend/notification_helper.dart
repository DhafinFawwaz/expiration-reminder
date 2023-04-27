import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../model/reminder_model.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/date_symbol_data_local.dart';

class NotificationHelper{

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static AndroidFlutterLocalNotificationsPlugin androidFlutterLocalNotificationsPlugin = AndroidFlutterLocalNotificationsPlugin();
  
  static Future<void> initializeNotification() async {
    await initializeDateFormatting();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    tz.initializeTimeZones();
    
  }

  static void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint("test");
    }
  }

  static Future<void> deleteNotification(Reminder reminder) async {
    await flutterLocalNotificationsPlugin.cancel(reminder.id);
    await flutterLocalNotificationsPlugin.cancel(-reminder.id);
  }

  static Future<void> scheduleNotification(Reminder reminder) async {
    const String appName = "Expiration Reminder";
    const int hmin = 1;
    String body = "${hmin == 1 ? "1 day" : "$hmin days"} left until ${reminder.productName} expire";

    DateTime notificationDateTime = DateTime(
      reminder.expirationDate.year, 
      reminder.expirationDate.month, 
      reminder.expirationDate.day, 
      reminder.notificationTime.hour, reminder.notificationTime.minute, reminder.notificationTime.second
    );

    tz.TZDateTime notificationTZDateTime = tz.TZDateTime.from(notificationDateTime, tz.local);


    // tz.TZDateTime notificationTZDateTime = tz.TZDateTime.from(notificationDateTime, tz.local);
    final tz.TZDateTime nowTZDateTime = tz.TZDateTime.now(tz.local);

    debugPrint("------------- setting notification -------------");
    debugPrint("notificationDateTime:      $notificationDateTime");
    debugPrint("notificationTZDateTime:    $notificationTZDateTime");
    debugPrint("nowTZDateTime:             $nowTZDateTime");

    if(notificationTZDateTime.subtract(const Duration(days: hmin)).isBefore(nowTZDateTime)) {
      deleteNotification(reminder);
      
      // Check if the reminder hasn't expired today
      if(notificationTZDateTime.isAfter(nowTZDateTime)) {
        debugPrint("Creating reminder only for today");
        debugPrint("reminder.id: ${reminder.id}");
        body = "${reminder.productName} will expire today";
        await flutterLocalNotificationsPlugin.zonedSchedule(
          -reminder.id,
          appName,
          body,
          notificationTZDateTime,
          const NotificationDetails(
              android: AndroidNotificationDetails(
                  '0', '0',
                  channelDescription: 'Reminder notification',
                  importance: Importance.max,
                  priority: Priority.high,
                  )),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime
        );
        
        return;
      }
      debugPrint("------------- already expire -------------");
      return;
    }

    debugPrint("------------- date valid -------------");

    print(notificationTZDateTime.subtract(const Duration(days: hmin)));
    print(nowTZDateTime);
    notificationDateTime = notificationDateTime.subtract(const Duration(days: 1));

    debugPrint("reminder.id: ${reminder.id}");
    await flutterLocalNotificationsPlugin.zonedSchedule(
      reminder.id,
      appName,
      body,
      notificationTZDateTime.subtract(const Duration(days: hmin)),
      const NotificationDetails(
          android: AndroidNotificationDetails(
              '0', '0',
              channelDescription: 'Reminder notification',
              importance: Importance.max,
              priority: Priority.high,
              )),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime
    );

    // Create reminder for today
    body = "${reminder.productName} will expire today";
    await flutterLocalNotificationsPlugin.zonedSchedule(
      -reminder.id,
      appName,
      body,
      notificationTZDateTime,
      const NotificationDetails(
          android: AndroidNotificationDetails(
              '0', '0',
              channelDescription: 'Reminder notification',
              importance: Importance.max,
              priority: Priority.high,
              )),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime
    );

    debugPrint("------------- notification successfull -------------");

  }

}