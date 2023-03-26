import 'package:flutter/material.dart';

class GlobalTheme {
  static const  slate50 = Color(0xfff8fafc);
  static const slate100 = Color(0xfff1f5f9);
  static const slate200 = Color(0xffe2e8f0);
  static const slate300 = Color(0xffcbd5e1);
  static const slate700 = Color(0xff334155);
  static const slate800 = Color(0xff1e293b);
  static const slate900 = Color(0xff0f172a);
  static const shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(15))
  );

  static const InputDecoration dateDecoration = InputDecoration(
    hintStyle: TextStyle(color: Colors.black45),
    errorStyle: TextStyle(color: Colors.redAccent),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide.none
    ),
    
    suffixIcon: Icon(Icons.event_note),
    labelText: 'Expiration Date',
    filled: true,
    fillColor: GlobalTheme.slate50,
  );
  static const InputDecoration timeDecoration = InputDecoration(
    hintStyle: TextStyle(color: Colors.black45),
    errorStyle: TextStyle(color: Colors.redAccent),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide.none
    ),
    
    suffixIcon: Icon(Icons.alarm),
    labelText: 'Notification Time',
    filled: true,
    fillColor: GlobalTheme.slate50,
  );
}