import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarViewPage extends StatefulWidget {
  const CalendarViewPage({super.key, required this.refreshPages});
  final Function refreshPages;

  @override
  State<CalendarViewPage> createState() => CalendarViewPageState();
}

class CalendarViewPageState extends State<CalendarViewPage> {
  void refresh() {
    print("refresh calendar");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),
      ),
    );
  }
}