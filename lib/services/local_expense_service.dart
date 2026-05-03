import 'dart:async';

import 'package:mexpense/services/database_helper.dart';

/// LocalDocument and LocalQuerySnapshot are lightweight types used by the
/// UI to remain compatible with previous Firestore-based code.
class LocalDocument {
  final String id;
  final Map<String, dynamic> _data;
  LocalDocument(this.id, this._data);
  Map<String, dynamic> data() => _data;
}

class LocalQuerySnapshot {
  final List<LocalDocument> docs;
  LocalQuerySnapshot(this.docs);
}

/// LocalExpenseService - a lightweight local replacement for Firestore-backed
/// access. It provides the methods the UI expects (`getRecords`, `addRecord`,
/// `updateRecord`, `deleteRecord`) but stores data in SQLite.
class LocalExpenseService {
  final String collectionName; // previously used as username
  final DatabaseHelper _db = DatabaseHelper();

  // stream controller to mimic snapshots
  final StreamController<LocalQuerySnapshot> _controller =
      StreamController.broadcast();

  LocalExpenseService(this.collectionName) {
    _emitCurrent();
  }

  Future<void> _emitCurrent() async {
    try {
      // collectionName used as username OR numeric id string; try to parse int
      int? userId = int.tryParse(collectionName);
      if (userId == null) {
        final user = await _db.getUserByUsername(collectionName);
        if (user == null) {
          _controller.add(LocalQuerySnapshot([]));
          return;
        }
        userId = user['id'] as int?;
      }

      final rows = await _db.getExpensesForUser(userId!);
      final docs = rows.map((r) {
        final mapped = {
          'Transaction_type': r['title'],
          'Category': r['category'],
          'Amount': r['amount'],
          'date': r['date'],
          'dateTime': DateTime.fromMillisecondsSinceEpoch(r['dateTime']),
        };
        return LocalDocument(r['id'].toString(), mapped);
      }).toList();
      _controller.add(LocalQuerySnapshot(docs));
    } catch (e) {
      _controller.add(LocalQuerySnapshot([]));
    }
  }

  Future<void> addRecord(
    String type,
    String category,
    int amount,
    String date,
    DateTime datetime,
  ) async {
    int? userId = int.tryParse(collectionName);
    if (userId == null) {
      final user = await _db.getUserByUsername(collectionName);
      if (user == null) throw Exception('Invalid user for LocalExpenseService');
      userId = user['id'] as int;
    }

    await _db.insertExpense({
      'user_id': userId,
      'title': type,
      'amount': amount,
      'category': category,
      'date': date,
      'dateTime': datetime.millisecondsSinceEpoch,
    });
    await _emitCurrent();
  }

  Future<void> updateRecord(
    String type,
    String category,
    int amount,
    String date,
    String id,
    DateTime datetime,
  ) async {
    await _db.updateExpense(int.parse(id), {
      'title': type,
      'amount': amount,
      'category': category,
      'date': date,
      'dateTime': datetime.millisecondsSinceEpoch,
    });
    await _emitCurrent();
  }

  Future<void> deleteRecord(String id) async {
    await _db.deleteExpense(int.parse(id));
    await _emitCurrent();
  }

  Stream<LocalQuerySnapshot> getRecords() {
    // return broadcast stream
    // ensure current data is emitted on listen
    Future.microtask(() => _emitCurrent());
    return _controller.stream;
  }
}
