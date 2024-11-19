import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'task_management.db');

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            category TEXT,
            status INTEGER,
            created_at TEXT,
            updated_at TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            icon TEXT,
            color TEXT
          )
        ''');

        // Insert initial category data
        await db.insert('categories', {
          'name': 'Personal',
          'icon': 'person_outline',
          'color': '#FFF0E0',
        });
        await db.insert('categories', {
          'name': 'Work',
          'icon': 'work_outline',
          'color': '#FCE4EC',
        });
        await db.insert('categories', {
          'name': 'Health',
          'icon': 'favorite_border',
          'color': '#E3F2FD',
        });
      },
    );
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    final database = await this.database;
    return await database.query('tasks');
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final database = await this.database;
    return await database.query('categories');
  }

  Future<void> addTask(
    String title,
    String description,
    String category,
    int status,
    String createdAt,
    String updatedAt,
  ) async {
    final database = await this.database;
    await database.insert('tasks', {
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    });
  }

  Future<void> updateTask(
    int id,
    String title,
    String description,
    String category,
    int status,
    String updatedAt,
  ) async {
    final database = await this.database;
    await database.update(
      'tasks',
      {
        'title': title,
        'description': description,
        'category': category,
        'status': status,
        'updated_at': updatedAt,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteTask(int id) async {
    final database = await this.database;
    await database.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
