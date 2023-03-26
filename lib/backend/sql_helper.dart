import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import '../model/reminder_model.dart';

class SQLHelper{
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE reminders(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      productName TEXT,
      expirationDate TEXT,
      notificationTime TEXT,
      description TEXT
    )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'reminders.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      }
    );
  }

  static Future<int> createReminder(Reminder reminder) async {
    final db = await SQLHelper.db();

    final data = reminder.toJson();
    final id = await db.insert(
      'reminders',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace
    );
    print("Reminder created");
    return id;
  }

  static Future<List<Map<String, dynamic>>> getReminders() async {
    final db = await SQLHelper.db();
    return db.query('reminders', orderBy: "id");
  }

  static Future<int> updateReminder(int id, Reminder reminder) async{
    final db = await SQLHelper.db();

    final data = reminder.toJson();
    final result = await db.update('reminders', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteReminder(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("reminders", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Error when deleting an item: $err");
    }
  }
}