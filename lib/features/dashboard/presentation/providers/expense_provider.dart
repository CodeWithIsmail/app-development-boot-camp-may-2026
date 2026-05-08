import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mexpense/core/constants/data.dart';
import 'package:mexpense/core/database/database_helper.dart';
import 'package:mexpense/core/models/transaction.dart';

class ExpenseProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();
  final List<Transaction> _expenses = [];

  int? _currentUserId;
  bool _isLoading = false;

  List<Transaction> get expenses => List.unmodifiable(_expenses);
  bool get isLoading => _isLoading;
  int? get currentUserId => _currentUserId;

  int get incomeTotal {
    return _expenses
        .where((expense) => expense.title != 'Expense')
        .fold<int>(0, (sum, expense) => sum + expense.amount.toInt());
  }

  int get expenseTotal {
    return _expenses
        .where((expense) => expense.title == 'Expense')
        .fold<int>(0, (sum, expense) => sum + expense.amount.toInt());
  }

  int get netBalance => incomeTotal - expenseTotal;

  void syncUser(int? userId) {
    if (_currentUserId == userId) {
      return;
    }

    _currentUserId = userId;
    if (userId == null) {
      _expenses.clear();
      notifyListeners();
      return;
    }

    unawaited(loadExpenses());
  }

  Future<void> loadExpenses() async {
    if (_currentUserId == null) {
      _expenses.clear();
      _isLoading = false;
      notifyListeners();
      return;
    }

    final int userId = _currentUserId!;
    _isLoading = true;
    notifyListeners();

    final rows = await _db.getTransactionsForUser(userId);
    if (_currentUserId != userId) {
      return;
    }

    _expenses
      ..clear()
      ..addAll(rows.map(Transaction.fromMap));
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addExpense({
    required String transactionType,
    required String category,
    required double amount,
    required String date,
    required DateTime dateTime,
  }) async {
    if (_currentUserId == null) {
      throw StateError('No active user session');
    }

    _isLoading = true;
    notifyListeners();

    await _db.insertTransaction(
      Transaction(
        userId: _currentUserId!,
        title: transactionType,
        amount: amount,
        category: category,
        date: date,
        dateTime: dateTime,
      ).toMap(),
    );
    await loadExpenses();
  }

  Future<void> updateExpense({
    required int id,
    required String transactionType,
    required String category,
    required double amount,
    required String date,
    required DateTime dateTime,
  }) async {
    _isLoading = true;
    notifyListeners();

    await _db.updateTransaction(id, {
      'title': transactionType,
      'amount': amount,
      'category': category,
      'date': date,
      'dateTime': dateTime.millisecondsSinceEpoch,
    });
    await loadExpenses();
  }

  Future<void> deleteExpense(int id) async {
    _isLoading = true;
    notifyListeners();

    await _db.deleteTransaction(id);
    await loadExpenses();
  }

  Map<String, double> categoryTotals() {
    final totals = {for (final cat in category) cat: 0.0};
    for (final expense in _expenses.where((item) => item.title == 'Expense')) {
      totals[expense.category] =
          (totals[expense.category] ?? 0.0) + expense.amount;
    }
    return totals;
  }

  Map<String, double> dailyTotals(DateTime endDate, {int days = 15}) {
    final DateTime normalizedEnd = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
    );
    final DateTime startDate = normalizedEnd.subtract(Duration(days: days - 1));
    final DateFormat dayFormat = DateFormat('dd');

    final Map<String, double> totals = {
      for (int i = days - 1; i >= 0; i--)
        dayFormat.format(normalizedEnd.subtract(Duration(days: i))): 0.0,
    };

    for (final expense in _expenses.where((e) => e.title == 'Expense')) {
      final expenseDate = DateTime(
        expense.dateTime.year,
        expense.dateTime.month,
        expense.dateTime.day,
      );
      if (!expenseDate.isBefore(startDate) &&
          !expenseDate.isAfter(normalizedEnd)) {
        final dayKey = dayFormat.format(expenseDate);
        totals[dayKey] = (totals[dayKey] ?? 0.0) + expense.amount;
      }
    }

    return totals;
  }
}
