import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mexpense/models/app_user.dart';
import 'package:mexpense/services/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  static const String _prefsKey = 'mexpense_user_id';

  final DatabaseHelper _db = DatabaseHelper();

  AppUser? _currentUser;
  bool _isBootstrapped = false;

  AppUser? get currentUser => _currentUser;
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
      _currentUser = AppUser.fromMap(userMap);
    }

    _isBootstrapped = true;
    notifyListeners();
  }

  Future<AppUser> signUp({
    required String name,
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
      'name': name,
      'username': username,
      'password_hash': passwordHash,
      'current_balance': initialBalance,
    });

    final now = DateTime.now();
    await _db.insertExpense({
      'user_id': userId,
      'title': 'Initial Balance',
      'amount': initialBalance,
      'category': 'Initial Balance',
      'date': DateFormat('dd-MMM-yy').format(now),
      'dateTime': now.millisecondsSinceEpoch,
    });

    await _setCurrentUser(userId);
    return _currentUser!;
  }

  Future<AppUser> signIn({
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

    final user = AppUser.fromMap(userMap);
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
    _currentUser = userMap == null ? null : AppUser.fromMap(userMap);
    _isBootstrapped = true;
    notifyListeners();
  }
}
