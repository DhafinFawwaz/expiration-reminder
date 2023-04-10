import 'package:expiration_reminder/backend/sql_helper.dart';
import 'package:flutter/material.dart';
import '../model/reminder_model.dart';
import 'package:date_field/date_field.dart';
import '../util/global_theme.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key, required this.reminder});
  final Reminder reminder;

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  DateTime? selectedExpirationDate;
  DateTime? selectedNotificationTime;

  

  @override
  void initState() {
    super.initState();
    selectedExpirationDate = widget.reminder.expirationDate;
    selectedNotificationTime = widget.reminder.notificationTime;
  }


  void onConfirm() {
    Reminder reminder = Reminder(
      id: widget.reminder.id,
      productName: widget.reminder.productName,
      expirationDate: selectedExpirationDate!,
      notificationTime: selectedNotificationTime!,
      type: widget.reminder.type,
    );
    SQLHelper.updateReminder(widget.reminder.id, reminder);
    Navigator.pop(context);
  }

  Widget getDescription() => Align(
                    alignment: Alignment.topLeft,
                    child: FutureBuilder(
                      future: SQLHelper.getDescription(widget.reminder),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                snapshot.data!,
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return const Text("");
                        } else if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text("");
                        }

                        // By default, show a loading spinner.
                        return const CircularProgressIndicator();
                      },
                    ),
                  );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(children: [
    
                  Text(
                    widget.reminder.productName,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                      
                    ),
                  ),
    
                  
                  getDescription(),
                  const SizedBox(height: 20),
    
    
        
                  DateTimeFormField(
                    decoration: GlobalTheme.dateDecoration,
                    mode: DateTimeFieldPickerMode.date,
                    autovalidateMode: AutovalidateMode.always,
                    onDateSelected: (DateTime value) {
                      selectedExpirationDate = value;
                    },
                    initialValue: widget.reminder.expirationDate,
                    
                  ),
        
                  const SizedBox(height: 20),
        
                  DateTimeFormField(
                    decoration: GlobalTheme.timeDecoration,
                    mode: DateTimeFieldPickerMode.time,
                    autovalidateMode: AutovalidateMode.always,
                    onDateSelected: (DateTime value) {
                      selectedNotificationTime = value;
                    },
                    initialValue: widget.reminder.notificationTime,
                  ),
        
                  const SizedBox(height: 15),
    
        
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: onConfirm,
                      child: Text("Confirm",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: GlobalTheme.shape,
                        shadowColor: Colors.transparent,
                        elevation: 0.0,
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      ).copyWith(elevation:ButtonStyleButton.allOrNull(0.0))
                    ),
                  ),


                  const SizedBox(height: 15),
                  // getDescription(),



                ],)
              ),
            ],
          ),
        ),
      ),
    );
  }
}