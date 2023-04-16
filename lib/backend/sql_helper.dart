import 'dart:convert';
import 'dart:io';

import 'package:expiration_reminder/backend/notification_helper.dart';
import 'package:expiration_reminder/model/description_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import '../model/reminder_model.dart';
import 'package:http/http.dart' as http;

class SQLHelper{
  // static const String URI = "expiration-reminder-backend.vercel.app";
  static const String URI = "expiration-reminder-backend.vercel.app";
  static const String databaseFile = "expiration.db";
  static const String reminderTable = "reminder";
  static const String descriptionTable = "description";

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE $reminderTable(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      productName TEXT,
      productAlias TEXT,
      expirationDate TEXT,
      notificationTime TEXT,
      type TEXT
    )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      databaseFile,
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
      reminderTable,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace
    );
    print("Reminder created");
    NotificationHelper.scheduleNotification(reminder);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getReminders() async {
    final db = await SQLHelper.db();
    return db.query(reminderTable, orderBy: "id");
  }

  static Future<int> updateReminder(int id, Reminder reminder) async{
    final db = await SQLHelper.db();

    final data = reminder.toJson();
    final result = await db.update(reminderTable, data, where: "id = ?", whereArgs: [id]);
    NotificationHelper.scheduleNotification(reminder);
    return result;
  }

  static Future<void> deleteReminder(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete(reminderTable, where: "id = ?", whereArgs: [id]);
      NotificationHelper.deleteNotification(id);
    } catch (err) {
      debugPrint("Error when deleting an item: $err");
    }
  }


  // ------------ Description ------------

  static Future<sql.Database> initDescriptionTable() async {
    print("Initializing description table...");
    return sql.openDatabase(
      databaseFile,
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createDescriptionTables(database);
      }
    );
  }
  static Future<void> createDescriptionTables(sql.Database database) async {
    print("Creating description table...");
    await database.execute("""CREATE TABLE ${descriptionTable}(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      productName TEXT,
      description TEXT
    )""");
  }

  static Future<String> getDescription(Reminder reminder) async {
    final productName = reminder.productAlias;

    // Check if reminder is added manually
    // if (reminder.type == "Manual") {
    //   debugPrint("Manual added reminder");
    //   return "";
    // }
    
    debugPrint("\nGetting description for $productName...");
    
    String description = "";

    // Check if description exists locally
    final db = await SQLHelper.initDescriptionTable();
    db.execute("CREATE TABLE IF NOT EXISTS $descriptionTable (id INTEGER PRIMARY KEY, productName TEXT, description TEXT)");
    
    debugPrint("Querying database...");
    final descriptionResult = await db.query(descriptionTable, where: "productName = ?", whereArgs: [productName]);
    debugPrint(descriptionResult.toString());
    
    // If description exists locally, return it
    if (descriptionResult.isNotEmpty) {
      var descriptions = descriptionResult.map((description) => Description.fromJson(description)).toList();
      description = descriptions[0].description;
      
      // Remove leading new line
      description = description.replaceAll("\n", "");

      return description;
    }

    // If description doesn't exist locally, Get description from API
    debugPrint("Getting description from API...");
    final queryParameters = {
      'productName': productName,
    };
    final uri = Uri.http(URI, '/api', queryParameters);
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    final response = await http.get(uri, headers: headers);
    debugPrint("API Call done");
    if (response.statusCode != 200) {
      debugPrint("Error when getting description from API");
      return "";
    }

    // description 
    description = json.decode(json.encode(response.body));
    description = description.replaceAll("\n", "");
    debugPrint(description);
    
    // Create the description locally
    final data = {
      "productName": productName,
      "description": description
    };
    
    // If the api returns an empty string, don't save the description
    if (description == "") {
      debugPrint("Description is empty");
      return "";
    }

    final id = await db.insert(
      descriptionTable,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace
    );
    debugPrint("Description created");
    
    return description;
      
  }
}
