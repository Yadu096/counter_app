import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StateNotifierProvider<AuthNotifier, String?>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});

class AuthNotifier extends StateNotifier<String?> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(null) {
    _checkCurrentUser();
  }

  void _checkCurrentUser() {
    state = _authService.getCurrentUser();
  }

  Future<bool> login(String email, String password) async {
    final success = await _authService.login(email, password);
    if (success) {
      state = email;
    }
    return success;
  }

  Future<bool> signUp(String email, String password) async {
    return await _authService.signUp(email, password);
  }

  Future<void> logout() async {
    await _authService.logout();
    state = null;
  }
}
