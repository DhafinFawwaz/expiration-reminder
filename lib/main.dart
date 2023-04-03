import '../util/global_theme.dart';
import 'package:flutter/material.dart';
import './pages/home.dart';
import 'backend/notification_helper.dart';

void main() {
  NotificationHelper.initializeNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expiration Reminder',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: GlobalTheme.slate200

      ),
      home: const MyHomePage(),
    );
  }
}