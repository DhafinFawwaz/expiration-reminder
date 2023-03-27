import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../backend/sql_helper.dart';
import '../model/reminder_model.dart';
import '../pages/reminder.dart';
import '../util/global_theme.dart';

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

  Container reminderTile(Reminder reminder, BuildContext context, Function refreshPages)
  =>
      Container(
        margin: const EdgeInsets.all(7),
        child: ScaleTile(
          onTap:() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => ReminderPage(reminder: reminder,),
              ),
            ).then((value) => refreshPages());
          },
          head: Container(
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
          trailing: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: FloatingActionButton( // Delete button
              heroTag: null,
              onPressed: () async {
                await SQLHelper.deleteReminder(reminder.id);
                refreshPages();
              },
              elevation: 0,
              highlightElevation: 0,
              backgroundColor: Colors.transparent,
              child: const Icon(Icons.delete, color: GlobalTheme.slate800)
            ),
          ),
        ),
      );
      
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


class ScaleTile extends StatefulWidget {
  const ScaleTile({
    super.key, 
    required this.head, 
    required this.trailing,
    required this.onTap
  });
  final Widget head;
  final Widget trailing;
  final Function onTap;

  @override
  State<ScaleTile> createState() => _ScaleTileState();
}

class _ScaleTileState extends State<ScaleTile> {
  double currentScale = 1;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: currentScale,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutQuart,
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: [
          GestureDetector(
            onTap: () {
              widget.onTap();
            },
            child: Listener(
              onPointerDown: (event) {
                setState(() {
                  currentScale = 0.95;
                });
              },
              onPointerUp: (event) {
                setState(() {
                  currentScale = 1;
                });
              },
              child: widget.head,
            ),
          ),
          widget.trailing
        ],
      ),
    );
  }
}