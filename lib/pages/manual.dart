import 'package:expiration_reminder/backend/reminder_helper.dart';
import 'package:flutter/material.dart';
import '../model/reminder_model.dart';
import 'package:date_field/date_field.dart';
import '../util/global_theme.dart';
import '../widget/back_widget.dart';
import 'package:expiration_reminder/backend/sql_helper.dart';

import '../widget/reminder_snackbar_widget.dart';

class ManualPage extends StatefulWidget {
  const ManualPage({super.key, required this.refreshPages});
  final Function refreshPages;

  @override
  State<ManualPage> createState() => _ManualPageState();
}

class _ManualPageState extends State<ManualPage> {
  // Backend access
  Future<void> addReminder(Reminder reminder) async {
    await SQLHelper.createReminder(reminder);
    widget.refreshPages();
  }
  //

  final productNameController = TextEditingController();
  DateTime? selectedExpirationDate;
  DateTime? selectedNotificationTime;

  void onConfirm() {
    Reminder reminder = Reminder(
      id: 0,
      productName: productNameController.text,
      productAlias: productNameController.text,
      expirationDate: selectedExpirationDate!,
      notificationTime: selectedNotificationTime!,
      type: "Manual",
    );
    addReminder(reminder);

    final snackBar = getSnackbar(
      reminder,
      () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    );

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    setState(() {
      productNameController.text = "";
      // selectedExpirationDate = null;
      // selectedNotificationDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          filled: true,
                          fillColor: GlobalTheme.slate50,
                          labelText: 'Product Name',
                          suffixIcon: const Icon(Icons.menu_book)
                        ),
                        
                        controller: productNameController,
                      ),
                      const SizedBox(height: 20),
                      DateTimeFormField(
                        decoration: GlobalTheme.dateDecoration,
                        mode: DateTimeFieldPickerMode.date,
                        autovalidateMode: AutovalidateMode.always,
                        onDateSelected: (DateTime value) {
                          selectedExpirationDate = value;
                        },
                        
                      ),
                      const SizedBox(height: 20),
                      DateTimeFormField(
                        decoration: GlobalTheme.timeDecoration,
                        mode: DateTimeFieldPickerMode.time,
                        autovalidateMode: AutovalidateMode.always,
                        onDateSelected: (DateTime value) {
                          selectedNotificationTime = value;
                        },
                      ),
                      const SizedBox(height: 15),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                            onPressed: onConfirm,
                            child: Text(
                              "Add",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: GlobalTheme.shape,
                              shadowColor: Colors.transparent,
                              elevation: 0.0,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                            ).copyWith(
                                elevation:
                                    ButtonStyleButton.allOrNull(0.0))),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
