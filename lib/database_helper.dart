import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'app_database.db');

    return await openDatabase(
      path,
      version: 3, // Versiyonu artırarak yeni tabloyu ekledim
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE user_favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_email TEXT NOT NULL,
        exercise_name TEXT NOT NULL,
        muscle TEXT,
        equipment TEXT,
        difficulty TEXT,
        instructions TEXT,
        FOREIGN KEY (user_email) REFERENCES users(email)
      )
    ''');

    await db.execute('''
      CREATE TABLE user_health_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_email TEXT NOT NULL,
        height REAL NOT NULL,   -- Boy (cm)
        weight REAL NOT NULL,   -- Kilo (kg)
        exercise_duration INTEGER NOT NULL, -- Egzersiz süresi (dakika)
        steps INTEGER NOT NULL, -- Adım sayısı
        entry_date TEXT NOT NULL, -- Tarih
        FOREIGN KEY (user_email) REFERENCES users(email)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE user_favorites (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_email TEXT NOT NULL,
          exercise_name TEXT NOT NULL,
          muscle TEXT,
          equipment TEXT,
          difficulty TEXT,
          instructions TEXT,
          FOREIGN KEY (user_email) REFERENCES users(email)
        )
      ''');
    }

    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE user_health_data (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_email TEXT NOT NULL,
          height REAL NOT NULL,   -- Boy (cm)
          weight REAL NOT NULL,   -- Kilo (kg)
          exercise_duration INTEGER NOT NULL, -- Egzersiz süresi (dakika)
          steps INTEGER NOT NULL, -- Adım sayısı
          entry_date TEXT NOT NULL, -- Tarih
          FOREIGN KEY (user_email) REFERENCES users(email)
        )
      ''');
    }
  }

  // Kullanıcı ekleme
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert(
      'users',
      user,
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  // Kullanıcı doğrulama
  Future<bool> authenticateUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty;
  }

  // Kullanıcının favori egzersizlerini ekleme
  Future<void> addFavoriteExercise(String userEmail, Map<String, dynamic> exercise) async {
    final db = await database;
    await db.insert('user_favorites', {
      'user_email': userEmail,
      'exercise_name': exercise['name'],
      'muscle': exercise['muscle'],
      'equipment': exercise['equipment'],
      'difficulty': exercise['difficulty'],
      'instructions': exercise['instructions'],
    });
  }

  // Kullanıcının favori egzersizlerini çekme
  Future<List<Map<String, dynamic>>> getUserFavorites(String userEmail) async {
    final db = await database;
    return await db.query(
      'user_favorites',
      where: 'user_email = ?',
      whereArgs: [userEmail],
    );
  }

  // Kullanıcının favori egzersizini silme
  Future<void> deleteFavoriteExercise(int id) async {
    final db = await database;
    await db.delete(
      'user_favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Kullanıcının sağlık verilerini ekle
  Future<void> insertHealthData(String userEmail, Map<String, dynamic> healthData) async {
    final db = await database;
    await db.insert('user_health_data', {
      'user_email': userEmail,
      'height': healthData['height'],
      'weight': healthData['weight'],
      'exercise_duration': healthData['exercise_duration'],
      'steps': healthData['steps'],
      'entry_date': DateTime.now().toIso8601String(),
    });
  }

  // Kullanıcının sağlık verilerini getir
  Future<List<Map<String, dynamic>>> getHealthData(String userEmail) async {
    final db = await database;
    return await db.query(
      'user_health_data',
      where: 'user_email = ?',
      whereArgs: [userEmail],
      orderBy: 'entry_date DESC', // En yeni veriyi öne al
    );
  }

  // Tüm kullanıcıları çekme
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }
}


