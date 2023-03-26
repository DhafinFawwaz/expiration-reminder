import '../model/reminder_model.dart';
import 'sql_helper.dart';

class ReminderHelper {
  static List<Reminder> reminders = [];
  
  static Future refreshReminders() async {
    final data = await SQLHelper.getReminders();
    reminders = data.map((reminder) => Reminder.fromJson(reminder)).toList();
  }
}