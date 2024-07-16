import 'dart:async';
import 'dart:io';

import 'package:flutter_task_planner_app/Tasks_taker/model/Task_model.dart';
import 'package:flutter_task_planner_app/task_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  late Database _database;

  static const _dbName = "Taskmate";
  static const _dbVersion = 1;
  static const _tableName = "task";

  Future<Database> get database async {
    _database = await initiateDatabase();
    return _database;
  }

  initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        date TEXT NOT NULL,
        startTime TEXT NOT NULL,
        endTime TEXT NOT NULL,
        color Created INTEGER  NOT NULL,
        isComplete NOT NULL DEFAULT 0
      )
      ''');
  }

  // Add Task
  Future<int> addTask(Task task) async {
    Database db = await instance.database;
    return await db.insert(_tableName, Task.toJson());
  }

  // Delete Task
  Future<int> deleteTask(Task task) async {
    Database db = await instance.database;
    return await db.delete(
      _tableName,
      where: "id = ?",
      whereArgs: [Task.id],
    );
  }

  // Delete All Tasks
  Future<int> deleteAllTasks() async {
    Database db = await instance.database;
    return await db.delete(_tableName);
  }

  // Update Task
  Future<int> updateTask(Task task) async {
    Database db = await instance.database;
    return await db.update(
      _tableName,
      Task.toJson(),
      where: "id = ?",
      whereArgs: [Task.id],
    );
  }

  Future<List<Task>> getTaskList() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query(_tableName, orderBy: 'dateTimeCreated DESC');
    return List.generate(
      maps.length,
      (index) {
        return Task(
          id: maps[index]["id"],
          title: maps[index]["title"],
          description: maps[index]["description"],
          startTime: maps[index]["dateTimeEdited"],
          endTime: maps[index]["dateTimeCreated"],
          isCompleted: maps[index]["isCompleate"],
        );
      },
    );
  }
}
