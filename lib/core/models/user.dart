class User {
  final int? id;
  final String name;
  final String username;
  final String passwordHash;
  final double currentBalance;

  const User({
    this.id,
    required this.name,
    required this.username,
    required this.passwordHash,
    required this.currentBalance,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      username: map['username'] as String? ?? '',
      passwordHash: map['password_hash'] as String? ?? '',
      currentBalance: (map['current_balance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'password_hash': passwordHash,
      'current_balance': currentBalance,
    };
  }
}
