import 'package:flutter/foundation.dart';
import 'package:mexpense/features/auth/data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  int? _currentUserId;
  bool _isLoading = false;
  String? _error;

  int? get currentUserId => _currentUserId;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> signUp({
    required String name,
    required String username,
    required String password,
    required double initialBalance,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUserId = await _authRepository.signUp(
        name: name,
        username: username,
        password: password,
        initialBalance: initialBalance,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUserId = await _authRepository.signIn(
        username: username,
        password: password,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    _currentUserId = null;
    notifyListeners();
  }

  Future<void> loadCurrentUser() async {
    _currentUserId = await _authRepository.getCurrentUserId();
    notifyListeners();
  }
}
