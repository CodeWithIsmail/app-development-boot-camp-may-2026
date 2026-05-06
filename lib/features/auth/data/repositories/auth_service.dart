import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:mexpense/core/database/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final DatabaseHelper _db = DatabaseHelper();
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final String _prefsKey = 'mexpense_user_id';

  Future<String> _hashPassword(String password) async {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<int> signUp({
    required String name,
    required String username,
    required String password,
    required double initialBalance,
  }) async {
    final existing = await _db.getUserByUsername(username);
    if (existing != null) {
      throw Exception('Username already exists');
    }

    final pwHash = await _hashPassword(password);
    final userId = await _db.insertUser(
      name: name,
      username: username,
      password: pwHash,
      initialBalance: initialBalance,
    );

    DateFormat dateFormat = DateFormat('dd-MMM-yy');
    final now = DateTime.now();
    await _db.insertExpense(
      userId: userId,
      title: 'Initial Balance',
      amount: initialBalance,
      category: 'Initial Balance',
      date: dateFormat.format(now),
      dateTime: now.millisecondsSinceEpoch,
    );

    await _setCurrentUserId(userId);
    return userId;
  }

  Future<int> signIn({
    required String username,
    required String password,
  }) async {
    final user = await _db.getUserByUsername(username);
    if (user == null) throw Exception('Invalid credentials');

    final pwHash = await _hashPassword(password);
    if (pwHash != user['password']) throw Exception('Invalid credentials');

    final int userId = user['id'] as int;
    await _setCurrentUserId(userId);
    return userId;
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }

  Future<int?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_prefsKey);
  }

  Future<void> _setCurrentUserId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKey, id);
  }
}
