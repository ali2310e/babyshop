import 'package:flutter/foundation.dart';

class AuthManager extends ChangeNotifier {
  static final AuthManager _instance = AuthManager._internal();

  factory AuthManager() {
    return _instance;
  }

  AuthManager._internal();

  String? _userName;
  String? _email;
  bool _isGuest = false;

  bool get isLoggedIn => _userName != null || _isGuest;
  String get userName => _userName ?? 'Guest';
  String get email => _email ?? '';
  bool get isGuest => _isGuest;

  void login(String name, String email) {
    _userName = name;
    _email = email;
    _isGuest = false;
    notifyListeners();
  }

  void loginAsGuest() {
    _userName = "Guest";
    _email = "";
    _isGuest = true;
    notifyListeners();
  }

  void logout() {
    _userName = null;
    _email = null;
    _isGuest = false;
    notifyListeners();
  }
}
