import 'dart:ffi';

import 'package:expiration_reminder/backend/reminder_helper.dart';
import 'package:expiration_reminder/backend/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
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
  void onRemove(int id) async {
    await SQLHelper.deleteReminder(id);
    widget.refreshPages();
  }

  Widget getSubtitle(Reminder reminder)
  {
    final dayDifference = daysBetween(DateTime.now(), reminder.expirationDate);
    if(dayDifference < 0)
      return Text(
          "Expired! | Expired on ${DateFormat.yMMMMd('en_US').format(reminder.expirationDate)}",
          style: TextStyle(
            color: Colors.red,
          ),
        );
    else if(dayDifference > 0){
      String expirationDate = DateFormat.yMMMMd('en_US').format(reminder.expirationDate);
      return Text(
        "$dayDifference days left | Expired on ${expirationDate}",
      );
    }
    else { // dayDifference == 0
      String expirationDate = DateFormat.yMMMMd('en_US').format(reminder.expirationDate);
      return Text(
        "Expires today | Expired on ${expirationDate}",
        style: TextStyle(
            color: Colors.blue
          ),
      );
    }
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  List<Widget> reminderTile()
  {
    return ReminderHelper.reminders.map((Reminder reminder) => 
      Container(
        margin: const EdgeInsets.all(7),

        child: Stack(
          alignment: AlignmentDirectional.centerEnd,
          children: [
            ZoomTapAnimation(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ReminderPage(reminder: reminder,),
                  ),
                ).then((value) => widget.refreshPages());
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: GlobalTheme.slate50,
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: GlobalTheme.slate700
                      )
                    ),
                    const SizedBox(height: 3),
                    getSubtitle(reminder),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: FloatingActionButton( // Delete button
                heroTag: null,
                onPressed: () {
                  onRemove(reminder.id);
                },
                elevation: 0,
                highlightElevation: 0,
                backgroundColor: Colors.transparent,
                child: const Icon(Icons.delete, color: GlobalTheme.slate800)
              ),
            ),
          ],
        ),
      )
      
      // Container(
      //   margin: const EdgeInsets.all(7),
      //   child: ListTile(
      //     title: Text( // Expired on
      //       reminder.productName,
      //       style: TextStyle(
      //         fontWeight: FontWeight.w600,
      //         color: GlobalTheme.slate700
      //       ),
      //     ),
      //     shape: GlobalTheme.shape,
      //     tileColor: GlobalTheme.slate50,
      //     subtitle: getSubtitle(reminder), // days left
      //     onTap: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (BuildContext context) => ReminderPage(reminder: reminder,),
      //         ),
      //       ).then((value) => widget.refreshPages());
      //     },
      //     trailing: FloatingActionButton( // Delete button
      //       heroTag: null,
      //       onPressed: () {
      //         onRemove(reminder.id);
      //       },
      //       elevation: 0,
      //       highlightElevation: 0,
      //       backgroundColor: Colors.transparent,
      //       child: Icon(Icons.delete, color: GlobalTheme.slate800),
      //     ),
      //   ),
      // )
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Reminder>>(
        builder: (context, snapshot) {
          return ListView(
              padding: const EdgeInsets.only(top: 7),
              children: reminderTile(),
          );
        },
      ),
    );
  }
}
