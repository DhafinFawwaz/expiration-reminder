import '../model/reminder_model.dart';
import 'sql_helper.dart';

class ReminderHelper {
  static List<Reminder> reminders = [];
  
  static Future refreshReminders() async {
    final data = await SQLHelper.getReminders();
    print(data);
    reminders = data.map((reminder) => Reminder.fromJson(reminder)).toList();
    sortByDate();
  }

  static void sortByDate() {
    reminders.sort((a, b) => a.expirationDate.compareTo(b.expirationDate));
  }
}