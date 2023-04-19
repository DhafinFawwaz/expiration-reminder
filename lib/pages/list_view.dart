import 'package:expiration_reminder/backend/reminder_helper.dart';
import 'package:flutter/material.dart';
import '../widget/reminder_tile_widget.dart';
import '../model/reminder_model.dart';

class ListViewPage extends StatefulWidget {
  
  const ListViewPage({Key? key, required this.refreshPages}) : super(key: key);
  final Function refreshPages;

  @override
  State<ListViewPage> createState() => ListViewPageState();
}

class ListViewPageState extends State<ListViewPage> {

  void refresh() {
    debugPrint("refresh list");
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
