import './calendar_view.dart';
import '../widget/refresh_widget.dart';
import 'package:flutter/material.dart';
import '../backend/reminder_helper.dart';
import '../backend/sql_helper.dart';
import '../model/reminder_model.dart';
import '../util/global_theme.dart';
import './scanner.dart';
import 'list_view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ListViewPageState> _listViewPageState = GlobalKey<ListViewPageState>();
  final GlobalKey<CalendarViewPageState> _calendarViewPageState = GlobalKey<CalendarViewPageState>();

  @override
  void initState() {
    super.initState();
    refreshPages();
  }

  void refreshPages() async {
    await ReminderHelper.refreshReminders();
    _listViewPageState.currentState?.refresh();
    _calendarViewPageState.currentState?.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: "1",
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => ScannerPage(refreshPages: refreshPages,),
              ),
            ).then((value) => refreshPages());
          },
          elevation: 0,
          highlightElevation: 0,
          hoverColor: Colors.red,
          child: const Icon(Icons.add),
        ),
    
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: GlobalTheme.slate50,
          bottom: TabBar(
            labelColor: GlobalTheme.slate800,
            indicatorColor: GlobalTheme.slate800,
            tabs: [
              Tab(child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.list),
                  SizedBox(width: 5),
                  Text("List View")
                ],
              )),
              Tab(child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.calendar_month_sharp),
                  SizedBox(width: 5),
                  Text("Calendar View")
                ],
              )),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListViewPage(key: _listViewPageState, refreshPages: refreshPages,),
            CalendarViewPage(key: _calendarViewPageState, refreshPages: refreshPages)
          ],
        ),
      ),
    );
  }

}
