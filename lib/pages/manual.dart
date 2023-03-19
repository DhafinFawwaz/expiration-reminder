import 'package:flutter/material.dart';
import '../model/reminder_model.dart';
import 'package:date_field/date_field.dart';

import '../widget/back_widget.dart';

class ManualPage extends StatefulWidget {
  const ManualPage({super.key});

  @override
  State<ManualPage> createState() => _ManualPageState();
}

class _ManualPageState extends State<ManualPage> {

  final productNameController = TextEditingController();
  DateTime? selectedExpirationDate;
  DateTime? selectedNotificationDate;


  void onConfirm(String scannedCode)
  {
    final snackBar = SnackBar(
      content: Text('Added ${productNameController.text}'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    setState(() {
      productNameController.text = "";
      selectedExpirationDate = null;
      selectedNotificationDate = null;
    });
  }
  
  @override
  Widget build(BuildContext context) {

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
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Product Name',
                        ),
                        controller: productNameController,
                        
                      ),

                      const SizedBox(height: 20),

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
                          onPressed: () {onConfirm("Bread;5-19-2022");},
                          child: Text("Add",
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