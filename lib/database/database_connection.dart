import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  // static _databasePath() async {
  //   join(await getDatabasesPath(), 'bill.db');
  // }

  // Future<Database> database = openDatabase(_databasePath(), version: 1,
  //     onCreate: (Database db, int version) async {
  //   await db.execute(
  //       'CREATE TABLE Bill (id INTEGER PRIMARY KEY, name TEXT, amount REAL, plannedAmout REAL, cateogory TEXT, status TEXT, dueDate TEXT, recurrent BOOL)');
  // });

  Future<Database> getDatabaseConnection() async {
    final Future<Database> database = openDatabase(
      // Set the path to the database.
      join(await getDatabasesPath(), 'bill.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        print("creating table Bill");
        return db.execute(
          'CREATE TABLE Bill (id INTEGER PRIMARY KEY, name TEXT, amount REAL, planned_amount REAL, category TEXT, status TEXT, dueDate TEXT, recurrent BOOL)'
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 2,
    );

    return database;
  }
}
