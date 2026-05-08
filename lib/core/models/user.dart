class User {
  final int? id;
  final String username;
  final String passwordHash;

  const User({this.id, required this.username, required this.passwordHash});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      username: map['username'] as String? ?? '',
      passwordHash: map['password_hash'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'username': username, 'password_hash': passwordHash};
  }
}
