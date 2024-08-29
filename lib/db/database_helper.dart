import 'dart:async';

import 'package:flutter_task_planner_app/model/task_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static const _dbName = "Taskmate.db";
  static const _dbVersion = 1;
  static const _tableName = "task";

  // Future<Database> get database async {
  //   _database = await initiateDatabase();
  //   return _database;
  // }
  // static final DatabaseHelper instance = DatabaseHelper._private();

  // DatabaseHelper._private();
  static Future<void> initDb() async {
    if (_database != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + _dbName;
      _database = await openDatabase(
        _path,
        version: _dbVersion,
        onCreate: (db, version) {
          return db.execute(''' CREATE TABLE $_tableName(
       id INTEGER PRIMARY KEY AUTOINCREMENT,
        title STRING,
        description TEXT ,
        date TEXT ,
        startTime STRING ,
        repeat STRING ,
        endTime STRING,
       color  INTEGER ,
     isCompleted INTEGER
          )''');
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<void> listenForChanges(
      void Function(int) onCountChanged) async {
    final db = await _database;
    // Replace with your actual table and column names
    await db?.query(_tableName, columns: ['COUNT(*) AS count']).then((rows) {
      final count = Sqflite.firstIntValue(rows);
      onCountChanged(count ?? 0);
    });
  }

  static Future<int> countCompletedTasks() async {
    final db = await _database;
    final count = Sqflite.firstIntValue(
      await db!.query(
        _tableName,
        columns: ['COUNT(*)'],
        where: 'isCompleted = ?',
        whereArgs: [1],
      ),
    );
    return count ?? 0;
  }
  // static void name() {}
  // static Future<int> countCompletedTasks() async {
  //   final count = Sqflite.firstIntValue(
  //     await _database!.query(
  //       _tableName,
  //       columns: ['COUNT(*)'],
  //       where: 'isCompleted = ?',
  //       whereArgs: [1],
  //     ),
  //   );
  //   return count ?? 0;
  // }

  // Add Task
  static Future<int> insertTask(Task? task) async {
    return await _database?.insert(_tableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return await _database!.query(_tableName);
  }

  static update(int id) async {
    await _database?.rawUpdate('''
    UPDATE $_tableName
    SET  isCompleted =?
        WHERE Id=?
        ''', [1, id]);
  }

  static delete(Task task) async {
    return await _database!.delete(
      _tableName,
      where: "id=?",
      whereArgs: [task.id],
    );
  }

  // Delete Task
  // Future<int> deleteTask(Task task) async {
  //   Database db = await instance.database;
  //   return await db.delete(
  //     _tableName,
  //     where: "id = ?",
  //
  //   );
  // }

  // Delete All Tasks
  // Future<int> deleteAllTasks() async {
  //   Database db = await instance.database;
  //   return await db.delete(_tableName);
  // }

  // Update Task
  // Future<int> updateTask(Task task) async {
  //   Database db = await instance.database;
  //   return await db.update(
  //     _tableName,
  //     task.toJson(),
  //     where: "id = ?",
  //     whereArgs: [task.id],
  //   );
  // }

  // Future<List<Task>> getTaskList() async {
  //   Database db = await instance.database;
  //   final List<Map<String, dynamic>> maps =
  //       await db.query(_tableName, orderBy: 'dateTimeCreated DESC');
  //   return List.generate(
  //     maps.length,
  //     (index) {
  //       return Task(
  //         id: maps[index]["id"],
  //         title: maps[index]["title"],
  //         description: maps[index]["description"],
  //         startTime: maps[index]["dateTimeEdited"],
  //         endTime: maps[index]["dateTimeCreated"],
  //         isCompletedd: maps[index]["isCompleate"],
  //       );
  //     },
  //   );
  // }
}
