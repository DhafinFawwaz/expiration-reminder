import 'package:flutter/material.dart';

class FloatingBackButton extends StatelessWidget {
  FloatingBackButton(this.foregroundColor);

  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "0",
      onPressed: (){
        Navigator.pop(context, true);
      },
      elevation: 0,
      highlightElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: foregroundColor,
      child: const Icon(Icons.arrow_back_ios_new),
    );
  }
}