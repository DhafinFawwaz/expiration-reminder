import 'package:flutter/material.dart';
import '../model/reminder_model.dart';
import 'package:date_field/date_field.dart';
import '../widget/back_widget.dart';

class RemainderPage extends StatefulWidget {
  const RemainderPage({super.key, required this.reminder});
  final Reminder reminder;

  @override
  State<RemainderPage> createState() => _RemainderPageState();
}

class _RemainderPageState extends State<RemainderPage> {

  void onConfirm()
  {

  }

  @override
  Widget build(BuildContext context) {
    DateTime? selectedExpirationDate;
    DateTime? selectedNotificationDate;

    String description = widget.reminder.description;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
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
      
                    (description == "") ? 
                      const SizedBox(height: 0)
                    :
                      const SizedBox(height: 10)
                    ,
      
                    Text(
                      description,
                      textAlign: TextAlign.justify,
                    ),
      
                    (description == "") ? 
                      const SizedBox(height: 0)
                    :
                      const SizedBox(height: 20)
                    ,
      
      
          
                    DateTimeFormField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: 'Expiration Date',
                      ),
                      mode: DateTimeFieldPickerMode.date,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                      onDateSelected: (DateTime value) {
                        print(value);
                      },
                      initialValue: DateTime.now(),
                      
                    ),
          
                    const SizedBox(height: 20),
          
                    DateTimeFormField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.black45),
                        errorStyle: TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event_note),
                        labelText: 'Notification Time',
                      ),
                      mode: DateTimeFieldPickerMode.time,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                      onDateSelected: (DateTime value) {
                        print(value);
                      },
                      initialValue: DateTime.now(),
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
                          shadowColor: Colors.transparent,
                          elevation: 0.0,
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        ).copyWith(elevation:ButtonStyleButton.allOrNull(0.0))
                      ),
                    ),
          
                  ],)
                ),
              ],
            ),
          ),
        ),

          Positioned(
            top: 15.0,
            left: 15.0, // or whatever
            child: FloatingBackButton(Colors.black),
          ),
        ],
        
      
      ),
    );
  }
}