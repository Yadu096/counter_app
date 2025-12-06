import 'package:hive_flutter/hive_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/user.dart';

class AuthService {
  static const String _userBoxName = 'users';
  static const String _currentUserKey = 'currentUser';

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());
    await Hive.openBox<User>(_userBoxName);
    await Hive.openBox(_currentUserKey);
  }

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<bool> signUp(String email, String password) async {
    final box = Hive.box<User>(_userBoxName);
    
    // Check if user already exists
    if (box.values.any((user) => user.email == email)) {
      return false;
    }

    // Create new user
    final hashedPassword = _hashPassword(password);
    final user = User(email: email, password: hashedPassword);
    await box.put(email, user);
    return true;
  }

  Future<bool> login(String email, String password) async {
    final box = Hive.box<User>(_userBoxName);
    final user = box.get(email);

    if (user == null) return false;

    final hashedPassword = _hashPassword(password);
    if (user.password == hashedPassword) {
      final sessionBox = Hive.box(_currentUserKey);
      await sessionBox.put('email', email);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final sessionBox = Hive.box(_currentUserKey);
    await sessionBox.clear();
  }

  String? getCurrentUser() {
    final sessionBox = Hive.box(_currentUserKey);
    return sessionBox.get('email');
  }
}
