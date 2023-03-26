import 'dart:ffi';

import 'package:expiration_reminder/backend/reminder_helper.dart';
import 'package:expiration_reminder/backend/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../widget/reminder_tile_widget.dart';
import './scanner.dart';
import '../model/reminder_model.dart';
import '../widget/refresh_widget.dart';
import './reminder.dart';
import 'package:intl/intl.dart';
import '../util/global_theme.dart';

class ListViewPage extends StatefulWidget {
  
  const ListViewPage({Key? key, required this.refreshPages}) : super(key: key);
  final Function refreshPages;

  @override
  State<ListViewPage> createState() => ListViewPageState();
}

class ListViewPageState extends State<ListViewPage> {

  void refresh() {
    print("refresh list");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Reminder>>(
        builder: (context, snapshot) {
          return ListView(
              padding: const EdgeInsets.only(top: 7),
              children: ReminderHelper.reminders.map((reminder) => 
                reminderTile(reminder, context, widget.refreshPages)
              ).toList(),
          );
        },
      ),
    );
  }
}
