import 'package:expiration_reminder/widget/reminder_tile_widget.dart';
import 'package:flutter/material.dart';

import '../model/reminder_model.dart';
import '../util/global_theme.dart';

SnackBar getSnackbar(Reminder reminder, Function onPressed)
=> SnackBar(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Added ${reminder.productName}',
            textAlign: TextAlign.left, 
            style: const TextStyle(
              color: GlobalTheme.slate50,
              fontWeight: FontWeight.w700
            )
          ),
          
          getSubtitle(reminder)
        ],
      ),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );