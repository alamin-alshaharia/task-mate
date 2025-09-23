import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/category_model.dart';
import '../model/task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // Table names
  static const String _taskTable = "tasks";
  static const String _categoryTable = "categories";

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
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Create Tasks Table
    await db.execute('''
      CREATE TABLE $_taskTable(
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
        isStar INTEGER,
        categoryId INTEGER
      )
    ''');

    // Create Categories Table
    await db.execute('''
      CREATE TABLE $_categoryTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        icon TEXT,
        color TEXT,
        remainingTasks INTEGER,
        completedTasks INTEGER
      )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // Handle database schema migrations if needed
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE $_taskTable ADD COLUMN categoryId INTEGER
      ''');
    }
  }

// In database_helper.dart
  Future<int> insertCategory(CategoryModel category) async {
    final db = await database;
    return await db.insert(_categoryTable, category.toJson());
  }

  Future<List<Map<String, dynamic>>> queryCategories() async {
    final db = await database;
    return await db.query(_categoryTable);
  }

  Future<int> updateCategory(CategoryModel category) async {
    final db = await database;
    return await db.update(
      _categoryTable,
      category.toJson(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.delete(
      _categoryTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Task-related methods
  Future<List<Map<String, dynamic>>> query() async {
    final db = await database;
    return await db.query(_taskTable);
  }

  Future<int> insertTask(Task? task) async {
    final db = await database;
    return await db.insert(_taskTable, task!.toJson());
  }

  Future<int> updateTaskDetail(Task task) async {
    final db = await database;
    return await db.update(_taskTable, task.toJson(),
        where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> update(int id) async {
    final db = await database;
    return await db.rawUpdate('''
      UPDATE $_taskTable
      SET isCompleted = ?
      WHERE Id = ?
    ''', [1, id]);
  }

  Future<int> delete(Task task) async {
    final db = await database;
    return await db.delete(
      _taskTable,
      where: "id = ?",
      whereArgs: [task.id],
    );
  }

  Future<int> markStar(int id) async {
    final db = await database;
    return await db.update(
      _taskTable,
      {'isStar': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> undoCompleted(int id) async {
    final db = await database;
    return await db.update(
      _taskTable,
      {'isCompleted': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> undoStar(int id) async {
    final db = await database;
    return await db.update(
      _taskTable,
      {'isStar': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Additional utility methods
  Future<List<Map<String, dynamic>>> getTasksByCategory(int categoryId) async {
    final db = await database;
    return await db.query(
      _taskTable,
      where: 'categoryId = ?',
      whereArgs: [categoryId],
    );
  }

  Future<void> updateCategoryTaskCounts(int categoryId) async {
    final db = await database;

    // Get tasks for the category
    List<Map<String, dynamic>> tasks = await getTasksByCategory(categoryId);

    // Calculate remaining and completed tasks
    int remainingTasks = tasks.where((task) => task['isCompleted'] == 0).length;
    int completedTasks = tasks.where((task) => task['isCompleted'] == 1).length;

    // Update category
    await db.update(
      _categoryTable,
      {
        'remainingTasks': remainingTasks,
        'completedTasks': completedTasks,
      },
      where: 'id = ?',
      whereArgs: [categoryId],
    );
  }

  // Method to clear all tasks
  Future<int> deleteAllTasks() async {
    final db = await database;
    // First, reset all category task counts
    await db.update(
      _categoryTable,
      {
        'remainingTasks': 0,
        'completedTasks': 0,
      },
    );
    // Then delete all tasks
    return await db.delete(_taskTable);
  }

  // Method to clear all data (tasks and categories)
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete(_taskTable);
    await db.delete(_categoryTable);
  }
}
