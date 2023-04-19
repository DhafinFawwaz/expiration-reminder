import 'package:expiration_reminder/backend/reminder_helper.dart';
import 'package:expiration_reminder/widget/reminder_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/reminder_model.dart';
import 'list_view.dart';

class CalendarViewPage extends StatefulWidget {
  const CalendarViewPage({super.key, required this.refreshPages});
  final Function refreshPages;

  @override
  State<CalendarViewPage> createState() => CalendarViewPageState();
}

class CalendarViewPageState extends State<CalendarViewPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<Reminder> _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    _selectedEvents = _getEventsForDay(DateTime.now());
  }

  List<Reminder> _getEventsForDay(DateTime day) {
    List<Reminder> todayReminder = ReminderHelper.reminders.where(
      (reminder) => isSameDay(reminder.expirationDate, day)
    ).toList();
    return todayReminder;
  }
  
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        _selectedDay = selectedDay;
        _selectedEvents = _getEventsForDay(selectedDay);
      });
    }
  }

  void refresh() {
    debugPrint("refresh calendar");
    setState(() {
      _selectedEvents = _getEventsForDay(_selectedDay);
    });
  }

  // List view 2
  final GlobalKey<ListViewPageState> _listViewPageState = GlobalKey<ListViewPageState>();


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TableCalendar(
          calendarStyle: const CalendarStyle(
            rangeHighlightColor: Colors.deepPurple
          ),
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: _onDaySelected,
          availableCalendarFormats: const {
            CalendarFormat.month: 'Month',
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          eventLoader: (day) {
            return _getEventsForDay(day);
          },
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(top: 7),
            children: _selectedEvents.map((reminder) => 
              reminderTile(reminder, context, widget.refreshPages)
            ).toList()
          ),
        ),
      
      ],
    );
  }
}