class Expense {
  final int? id;
  final int userId;
  final String title;
  final double amount;
  final String category;
  final String date;
  final DateTime dateTime;

  const Expense({
    this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.dateTime,
  });

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      title: map['title'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      category: map['category'] as String? ?? '',
      date: map['date'] as String? ?? '',
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        map['dateTime'] as int? ?? 0,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }
}
