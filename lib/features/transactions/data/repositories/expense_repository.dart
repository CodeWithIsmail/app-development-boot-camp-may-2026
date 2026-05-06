import 'dart:async';

import 'package:mexpense/core/database/database_helper.dart';

class ExpenseRepository {
  final DatabaseHelper _db = DatabaseHelper();

  Future<List<Map<String, dynamic>>> getExpensesForUser(int userId) async {
    return await _db.getExpenses(userId);
  }

  Future<void> addExpense(int userId, Map<String, dynamic> expense) async {
    await _db.insertExpense(
      userId: userId,
      title: expense['title'] as String,
      category: expense['category'] as String,
      amount: expense['amount'] as double,
      date: expense['date'] as String,
      dateTime: expense['dateTime'] as int,
    );
  }

  Future<void> updateExpense(int id, Map<String, dynamic> values) async {
    await _db.updateExpense(
      id: id,
      title: values['title'] as String? ?? '',
      category: values['category'] as String? ?? '',
      amount: values['amount'] as double? ?? 0.0,
      date: values['date'] as String? ?? '',
      dateTime: values['dateTime'] as int? ?? 0,
    );
  }

  Future<void> deleteExpense(int id) async {
    await _db.deleteExpense(id);
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    return await _db.getUserById(id);
  }
}
