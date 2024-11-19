// import 'dart:async';
//
// import 'package:flutter_task_planner_app/model/task_model.dart';
// import 'package:sqflite/sqflite.dart';
//
// class DatabaseHelper {
//   static Database? _database;
//   static const _dbName = "Taskmate.db";
//   static const _dbVersion = 1;
//   static const _tableName = "task";
//
//   // Future<Database> get database async {
//   //   _database = await initiateDatabase();
//   //   return _database;
//   // }
//   // static final DatabaseHelper instance = DatabaseHelper._private();
//
//   // DatabaseHelper._private();
//   static Future<void> initDb() async {
//     if (_database != null) {
//       return;
//     }
//     try {
//       String _path = await getDatabasesPath() + _dbName;
//       _database = await openDatabase(
//         _path,
//         version: _dbVersion,
//         onCreate: (db, version) {
//           return db.execute(''' CREATE TABLE $_tableName(
//        id INTEGER PRIMARY KEY AUTOINCREMENT,
//         title STRING,
//         description TEXT ,
//         date TEXT ,
//         startTime STRING ,
//          remind INTEGER,
//         repeat STRING ,
//         endTime STRING,
//        color  INTEGER ,
//      isCompleted INTEGER,
//      isStar INTEGER
//           )''');
//         },
//       );
//     } catch (e) {
//       print(e);
//     }
//   }
// //
//   // static Future<void> listenForChanges(
//   //     void Function(int) onCountChanged) async {
//   //   final db = await _database;
//   //   // Replace with your actual table and column names
//   //   await db?.query(_tableName, columns: ['COUNT(*) AS count']).then((rows) {
//   //     final count = Sqflite.firstIntValue(rows);
//   //     onCountChanged(count ?? 0);
//   //   });
//   // }
//
//   static Future<int> updateTaskDetail(Task task) async {
//     print("update task detail function called");
//     return await _database!.update(_tableName, task.toJson(),
//         where: 'id = ?', whereArgs: [task.id]);
//   }
//
//   static Future<int> undoCompleted(int id) async {
//     print("undoCompleted function called");
//     return await _database!.update(
//       _tableName,
//       {'isCompleted': 0},
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
//
//   static Future<int> undoStar(int id) async {
//     print("undoStar function called");
//     return await _database!.update(
//       _tableName,
//       {'isStar': 0},
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
//
//   // Add Task
//   static Future<int> insertTask(Task? task) async {
//     return await _database?.insert(_tableName, task!.toJson()) ?? 1;
//   }
//
//   static Future<List<Map<String, dynamic>>> query() async {
//     return await _database!.query(_tableName);
//   }
//
//   static update(int id) async {
//     await _database?.rawUpdate('''
//     UPDATE $_tableName
//     SET  isCompleted =?
//         WHERE Id=?
//         ''', [1, id]);
//   }
//
//   static delete(Task task) async {
//     return await _database!.delete(
//       _tableName,
//       where: "id=?",
//       whereArgs: [task.id],
//     );
//   }
//
//   static Future<int> markStar(int id) async {
//     print("markStar function called");
//     return await _database!.update(
//       _tableName,
//       {'isStar': 1},
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
//
//   // Delete Task
//   // Future<int> deleteTask(Task task) async {
//   //   Database db = await instance.database;
//   //   return await db.delete(
//   //     _tableName,
//   //     where: "id = ?",
//   //
//   //   );
//   // }
//
//   // Delete All Tasks
//   // Future<int> deleteAllTasks() async {
//   //   Database db = await instance.database;
//   //   return await db.delete(_tableName);
//   // }
//
//   // Update Task
//   // Future<int> updateTask(Task task) async {
//   //   Database db = await instance.database;
//   //   return await db.update(
//   //     _tableName,
//   //     task.toJson(),
//   //     where: "id = ?",
//   //     whereArgs: [task.id],
//   //   );
//   // }
//
//   // Future<List<Task>> getTaskList() async {
//   //   Database db = await instance.database;
//   //   final List<Map<String, dynamic>> maps =
//   //       await db.query(_tableName, orderBy: 'dateTimeCreated DESC');
//   //   return List.generate(
//   //     maps.length,
//   //     (index) {
//   //       return Task(
//   //         id: maps[index]["id"],
//   //         title: maps[index]["title"],
//   //         description: maps[index]["description"],
//   //         startTime: maps[index]["dateTimeEdited"],
//   //         endTime: maps[index]["dateTimeCreated"],
//   //         isCompletedd: maps[index]["isCompleate"],
//   //       );
//   //     },
//   //   );
//   // }
// }
import 'dart:async';

import 'package:flutter_task_planner_app/model/task_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static const _tableName = "task";
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('taskmate.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE task(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title STRING,
        description TEXT,
        date TEXT,
        startTime STRING,
        remind INTEGER,
        repeat STRING,
        endTime STRING,
        color INTEGER,
        isCompleted INTEGER,
        isStar INTEGER
      )
    ''');
  }

  // Your existing database methods
  Future<List<Map<String, dynamic>>> query() async {
    final db = await database;
    return await db.query('task');
  }

  Future<int> insertTask(Task? task) async {
    final db = await database;
    return await db.insert('task', task!.toJson());
  }

  Future<int> updateTaskDetail(Task task) async {
    final db = await database;
    return await db
        .update('task', task.toJson(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> update(int id) async {
    final db = await database;
    return await db.rawUpdate('''
      UPDATE $_tableName
      SET isCompleted = ?
      WHERE Id = ?
    ''', [1, id]);
  }

  Future<int> delete(Task task) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: "id = ?",
      whereArgs: [task.id],
    );
  }

  Future<int> markStar(int id) async {
    final db = await database;
    return await db.update(
      _tableName,
      {'isStar': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> undoCompleted(int id) async {
    final db = await database;
    return await db.update(
      _tableName,
      {'isCompleted': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> undoStar(int id) async {
    final db = await database;
    return await db.update(
      _tableName,
      {'isStar': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
