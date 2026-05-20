import 'dart:async';

import 'package:flutter_task_planner_app/model/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NoteDatabaseHelper {
  NoteDatabaseHelper._privateConstructor();
  static final NoteDatabaseHelper instance =
      NoteDatabaseHelper._privateConstructor();
  static Database? _database;

  static const _dbName = "notes.db";
  static const _dbVersion = 2;
  static const _tableName = "notes";

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initiateDatabase();
    return _database!;
  }

  Future<Database> _initiateDatabase() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        dateTimeEdited TEXT NOT NULL,
        dateTimeCreated TEXT NOT NULL,
        isFavorite INTEGER NOT NULL DEFAULT 0
      )
      ''');
  }

  // Add Note
  Future<int> addNote(Note note) async {
    Database db = await instance.database;
    return await db.insert(_tableName, note.toJson());
  }

  // Delete Note
  Future<int> deleteNote(Note note) async {
    Database db = await instance.database;
    return await db.delete(
      _tableName,
      where: "id = ?",
      whereArgs: [note.id],
    );
  }

  // Delete All Notes
  Future<int> deleteAllNotes() async {
    Database db = await instance.database;
    return await db.delete(_tableName);
  }

  // Update Note (preserves isFavorite from the note object)
  Future<void> updateNote(Note note) async {
    final db = await database;
    await db.update(
      _tableName,
      note.toJson(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<List<Note>> getNoteList() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query(_tableName, orderBy: 'dateTimeCreated DESC');
    return maps.map((map) => Note.fromJson(map)).toList();
  }
}
