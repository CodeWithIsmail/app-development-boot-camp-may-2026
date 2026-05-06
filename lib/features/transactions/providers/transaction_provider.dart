import 'package:flutter/foundation.dart';
import 'package:mexpense/features/transactions/data/repositories/expense_repository.dart';

class TransactionProvider extends ChangeNotifier {
  final ExpenseRepository _expenseRepository = ExpenseRepository();

  List<Map<String, dynamic>> _expenses = [];
  bool _isLoading = false;
  String? _error;
  int? _currentUserId;

  List<Map<String, dynamic>> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get totalIncome => _calculateTotal('Income');
  double get totalExpense => _calculateTotal('Expense');
  double get netBalance => totalIncome - totalExpense;

  void setCurrentUser(int userId) {
    _currentUserId = userId;
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    if (_currentUserId == null) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _expenses = await _expenseRepository.getExpensesForUser(_currentUserId!);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addExpense(Map<String, dynamic> expense) async {
    if (_currentUserId == null) return;
    try {
      await _expenseRepository.addExpense(_currentUserId!, expense);
      await loadExpenses(); // Reload to update list and summaries
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateExpense(int id, Map<String, dynamic> values) async {
    try {
      await _expenseRepository.updateExpense(id, values);
      await loadExpenses();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      await _expenseRepository.deleteExpense(id);
      await loadExpenses();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  double _calculateTotal(String type) {
    return _expenses
        .where((e) => e['title'] == type)
        .fold(0.0, (sum, e) => sum + (e['amount'] as num).toDouble());
  }
}
