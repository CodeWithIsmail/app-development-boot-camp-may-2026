import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mexpense/core/database/database_helper.dart';
import 'package:mexpense/core/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  static const String _prefsKey = 'mexpense_user_id';

  final DatabaseHelper _db = DatabaseHelper();

  User? _currentUser;
  bool _isBootstrapped = false;

  User? get currentUser => _currentUser;
  bool get isBootstrapped => _isBootstrapped;
  String? get displayName => _currentUser?.username;

  Future<String> _hashPassword(String password) async {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  Future<void> restoreSession() async {
    if (_isBootstrapped) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(_prefsKey);
    if (userId == null) {
      _currentUser = null;
      _isBootstrapped = true;
      notifyListeners();
      return;
    }

    final userMap = await _db.getUserById(userId);
    if (userMap == null) {
      await prefs.remove(_prefsKey);
      _currentUser = null;
    } else {
      _currentUser = User.fromMap(userMap);
    }

    _isBootstrapped = true;
    notifyListeners();
  }

  Future<User> signUp({
    required String username,
    required String password,
    required double initialBalance,
  }) async {
    final existing = await _db.getUserByUsername(username);
    if (existing != null) {
      throw Exception('Username already exists');
    }

    final passwordHash = await _hashPassword(password);
    final userId = await _db.insertUser({
      'username': username,
      'password_hash': passwordHash,
    });

    final now = DateTime.now();
    await _db.insertTransaction({
      'user_id': userId,
      'title': 'Income',
      'amount': initialBalance,
      'category': 'Initial Balance',
      'date': DateFormat('dd-MMM-yy').format(now),
      'dateTime': now.millisecondsSinceEpoch,
    });

    await _setCurrentUser(userId);
    return _currentUser!;
  }

  Future<User> signIn({
    required String username,
    required String password,
  }) async {
    final userMap = await _db.getUserByUsername(username);
    if (userMap == null) {
      throw Exception('Invalid credentials');
    }

    final passwordHash = await _hashPassword(password);
    if (passwordHash != userMap['password_hash']) {
      throw Exception('Invalid credentials');
    }

    final user = User.fromMap(userMap);
    await _setCurrentUser(user.id!);
    return user;
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    _currentUser = null;
    notifyListeners();
  }

  Future<void> _setCurrentUser(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKey, id);

    final userMap = await _db.getUserById(id);
    _currentUser = userMap == null ? null : User.fromMap(userMap);
    _isBootstrapped = true;
    notifyListeners();
  }
}
