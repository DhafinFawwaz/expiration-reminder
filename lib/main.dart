import 'package:expiration_reminder/pages/manual.dart';
import 'package:expiration_reminder/pages/scanner.dart';
import '../util/global_theme.dart';
import 'package:flutter/material.dart';
import './pages/home.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting().then((_) =>
    runApp(const MyApp())
  );
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