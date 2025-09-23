import 'dart:async';
import 'dart:io';

import 'package:flutter_task_planner_app/model/note_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  late Database _database;

  static const _dbName = "notes.db";
  static const _dbVersion = 2;
  static const _tableName = "notes";

  Future<Database> get database async {
    _database = await initiateDatabase();
    return _database;
  }

  Future<Database> initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
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

  // Update Note
  Future<void> updateNote(Note note) async {
    final db = await database;

    // Retrieve the current value of isFavorite if you don't want to change it
    final currentNote = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [note.id],
    );

    // Check if the note exists
    if (currentNote.isNotEmpty) {
      // Get the current isFavorite value
      final currentIsFavorite = currentNote.first['isFavorite'] as int;

      // Update the note with the current isFavorite value
      await db.update(
        'notes',
        {
          'id': note.id,
          'title': note.title,
          'content': note.content,
          'dateTimeEdited': note.dateTimeEdited,
          'dateTimeCreated': note.dateTimeCreated,
          'isFavorite': currentIsFavorite, // Use the current value
        },
        where: 'id = ?',
        whereArgs: [note.id],
      );
    }
  }
  // Future<int> updateNote(Note note) async {
  //   Database db = await instance.database;
  //   return await db.update(
  //     _tableName,
  //     note.toJson(),
  //     where: "id = ?",
  //     whereArgs: [note.id],
  //   );
  // }

  Future<List<Note>> getNoteList() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query(_tableName, orderBy: 'dateTimeCreated DESC');
    return List.generate(
      maps.length,
      (index) {
        return Note(
          id: maps[index]["id"],
          title: maps[index]["title"],
          content: maps[index]["content"],
          dateTimeEdited: maps[index]["dateTimeEdited"],
          dateTimeCreated: maps[index]["dateTimeCreated"],
          isFavorite: maps[index]["isFavorite"] == 1 ? true : false,
        );
      },
    );
  }
}
