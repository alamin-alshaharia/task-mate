import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/profile_model.dart';

class ProfileDatabaseHelper {
  static final ProfileDatabaseHelper _instance =
      ProfileDatabaseHelper._internal();
  static Database? _database;

  factory ProfileDatabaseHelper() => _instance;
  ProfileDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'profile_database.db');
    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) {
        return db.execute('CREATE TABLE profiles('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'name TEXT, '
            'profession TEXT, '
            'imageData BLOB)');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          // Handle database schema changes if needed
        }
      },
    );
  }

  // Insert or Update Profile
  Future<int> insertProfile(ProfileModel profile) async {
    final db = await database;
    return await db.insert(
      'profiles',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get Profile
  Future<ProfileModel?> getProfile() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('profiles');

    // Return the first profile if exists, otherwise return null
    return maps.isNotEmpty ? ProfileModel.fromMap(maps.first) : null;
  }

  // Delete Profile
  Future<int> deleteProfile() async {
    final db = await database;
    return await db.delete('profiles');
  }

  // Update Specific Fields
  Future<int> updateProfile(ProfileModel profile) async {
    final db = await database;
    return await db.update(
      'profiles',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  // Check if Profile Exists
  Future<bool> profileExists() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM profiles'));
    return count != null && count > 0;
  }
}
