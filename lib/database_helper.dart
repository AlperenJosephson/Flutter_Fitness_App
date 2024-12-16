// database ile yapılacak işlemler buraya eklenecek
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
}