import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mexpense/core/database/helper/database_helper.dart';

class ExpenseRepository {
  final DatabaseHelper _db = DatabaseHelper();

  Future<List<Map<String, dynamic>>> getExpensesForUser(int userId) async {
    return await _db.getExpensesForUser(userId);
  }

  Future<void> addExpense(int userId, Map<String, dynamic> expense) async {
    await _db.insertExpense({'user_id': userId, ...expense});
  }

  Future<void> updateExpense(int id, Map<String, dynamic> values) async {
    await _db.updateExpense(id, values);
  }

  Future<void> deleteExpense(int id) async {
    await _db.deleteExpense(id);
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    return await _db.getUserById(id);
  }

  Future<void> updateUserBalance(int userId, double balance) async {
    await _db.updateUserBalance(userId, balance);
  }
}
