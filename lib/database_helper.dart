// database ile yapılacak işlemler buraya eklenecek

/*
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();   // aynı ağlantı tekrar tekrar oluşmasını engeller
  factory DatabaseHelper() => _instance;

  static Database? _database;
  DatabaseHelper._internal();


  // Database'e erişim sağlayan getter
  Future<Database> get database async {   // veritabanına erişim sağlayan getter
    if (_database != null) return _database!; // database zaten bağlı ise onu döndür
    _database = await _initDatabase();    // veritabanı bağlantısını başlatır
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath(); // Veritabanı yolu
    final path = join(databasePath, 'app_database.db'); // Veritabanı dosya adı

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Veritabanını oluşturma işlemi
  // id,username,email,password
  Future<void> _onCreate(Database db, int version) async {
    // Kullanıcılar tablosunu oluşturuyoruz
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
    //print("Database and users table created.");
  }

  // Kullanıcı ekleme metodu
  Future<int> insertUser(Map<String, dynamic> user) async { // user adında veri gelir (name,mail,pass)
    final db = await database;
    return await db.insert(   // user verisini users tablosuna ekler
      'users',
      user,
      conflictAlgorithm: ConflictAlgorithm.fail, // UNIQUE ihlali durumunda hata fırlatır
    );
  }

  // Kullanıcı güncelleme
  /*Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final db = await database;
    return await db.update(
      'users',
      user,
      where: 'id = ?',
      whereArgs: [id],
    );
  }*/

  // kullanıcıların doğrulanması
  Future<bool> authenticateUser(String email, String password) async {
  final db = await database;
  final result = await db.query(  // users tablosunda mail ve şifreye göre kullanıcı arar db.query burada SELECT işlevinde
    'users',  // users tablosundaki tüm satırları döndürür
    where: 'email = ? AND password = ?',  // filtre uygular
    whereArgs: [email, password],   // buradaki ilk ? email ikincisi ise passwordu ifade eder 
  );

  // Kullanıcı bulunduysa liste boş olmayacaktır
  return result.isNotEmpty;
}

/*void printDatabasePath() async {
  final databasePath = await getDatabasesPath();
  print("Database path: $databasePath");
}*/

  // tüm kullanıcıları getirme
  Future<List<Map<String, dynamic>>> getAllUsers() async {
  final db = await database;
  return await db.query('users'); // 'users' tablosundaki tüm verileri getirir
}
}*/

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
      version: 2, // Versiyonu artırarak yeni tabloyu ekledim
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

  // Tüm kullanıcıları çekme
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }
}



