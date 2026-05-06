import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mexpense/features/auth/data/repositories/auth_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  Future<int> signUp({
    required String name,
    required String username,
    required String password,
    required double initialBalance,
  }) async {
    return await _authService.signUp(
      name: name,
      username: username,
      password: password,
      initialBalance: initialBalance,
    );
  }

  Future<int> signIn({
    required String username,
    required String password,
  }) async {
    return await _authService.signIn(username: username, password: password);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<int?> getCurrentUserId() async {
    return await _authService.getCurrentUserId();
  }
}
