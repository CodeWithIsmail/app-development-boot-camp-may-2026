import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'mexpense.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        initial_balance REAL DEFAULT 0.0,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        category TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        dateTime INTEGER NOT NULL,
        FOREIGN KEY(user_id) REFERENCES users(id)
      )
    ''');
  }

  // User methods
  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await database;
    final result = await db.query('users', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> insertUser({
    required String name,
    required String username,
    required String password,
    required double initialBalance,
  }) async {
    final db = await database;
    return await db.insert('users', {
      'name': name,
      'username': username,
      'password': password,
      'initial_balance': initialBalance,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // Expense methods
  Future<void> insertExpense({
    required int userId,
    required String title,
    required String category,
    required double amount,
    required String date,
    required int dateTime,
  }) async {
    final db = await database;
    await db.insert('expenses', {
      'user_id': userId,
      'title': title,
      'category': category,
      'amount': amount,
      'date': date,
      'dateTime': dateTime,
    });
  }

  Future<List<Map<String, dynamic>>> getExpenses(int userId) async {
    final db = await database;
    return await db.query(
      'expenses',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'dateTime DESC',
    );
  }

  Future<void> updateExpense({
    required int id,
    required String title,
    required String category,
    required double amount,
    required String date,
    required int dateTime,
  }) async {
    final db = await database;
    await db.update(
      'expenses',
      {
        'title': title,
        'category': category,
        'amount': amount,
        'date': date,
        'dateTime': dateTime,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteExpense(int id) async {
    final db = await database;
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
