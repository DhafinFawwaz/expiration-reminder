import 'package:flutter/material.dart';
import './scanner.dart';
import '../model/reminder_model.dart';
import '../widget/refresh_widget.dart';
import './reminder.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    
    List<Reminder> reminders = 
      [
        Reminder(productName: "Sausage",expirationDate: DateTime.now(), notificationTime: DateTime.now(), hasExpired: true, description: ""),
        Reminder(productName: "Bread",  expirationDate: DateTime.now(), notificationTime: DateTime.now(), hasExpired: false, description: "The shelf life of bread kept at room temperature ranges from 3–7 days but may vary depending on ingredients, type of bread, and storage method. Bread is more likely to spoil if stored in warm, moist environments. To prevent mold, it should be kept sealed at room temperature or colder. Room-temperature bread typically lasts 3–4 days if it’s homemade or up to 7 days if it’s store-bought. Refrigeration can increase the shelf life of both commercial and homemade bread by 3–5 days."),
        Reminder(productName: "Sauce",  expirationDate: DateTime.now(), notificationTime: DateTime.now(), hasExpired: false, description: ""),
      ];


    List<Reminder> readUsers() => reminders;

    Future reloadUser() async {
      setState(() {
        
      });
      
    }

    Widget getSubtitle(Reminder reminder)
    {
      if(reminder.hasExpired)
        return Text(
            "Expired! | Expired on ${DateFormat.yMMMMd('en_US').format(reminder.expirationDate)}",
            style: TextStyle(
              color: Colors.red
            ),
          );
      else
        return Text(
          "${reminder.expirationDate.day} days left | Expired on ${DateFormat.yMMMMd('en_US').format(reminder.expirationDate)}",
        );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const ScannerPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
        elevation: 0,
        highlightElevation: 0,
        hoverColor: Colors.red,
      ),


      body: FutureBuilder<List<Reminder>>(
        builder: (context, snapshot) {
          return RefreshWidget(
            onRefresh: reloadUser,
            child: ListView(
              children: reminders.map((Reminder reminder) => ListTile(
                title: Text(
                  reminder.productName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: getSubtitle(reminder),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => RemainderPage(reminder: reminder,),
                    ),
                  );
                },
                trailing: FloatingActionButton(
                  onPressed: () {},
                  child: const Icon(Icons.delete),
                  elevation: 0,
                  highlightElevation: 0,
                  backgroundColor: Color.fromRGBO(48, 48, 48, 1),
                ),
                
                // trailing: ElevatedButton(
                //   child: Text("Consume"),
                //   onPressed: () {},
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Color.fromRGBO(48, 48, 48, 1),
                //   ),
                // ),




              )).toList(),
            ),
          );
        },
      ),
        
    );
  }

}
