import 'package:flutter/material.dart';

class FloatingBackButton extends StatelessWidget {
  FloatingBackButton(this.foregroundColor);

  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: (){
        Navigator.pop(context);
      },
      child: const Icon(Icons.arrow_back_ios_new),
      elevation: 0,
      highlightElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: foregroundColor,
    );
  }
}