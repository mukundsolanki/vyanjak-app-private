import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _name = '';
  String _role = '';

  String get name => _name;
  String get role => _role;

  bool get isLoggedIn => _name.isNotEmpty && _role.isNotEmpty;

  void login(String name, String role) {
    _name = name;
    _role = role;
    notifyListeners();
  }

  void logout() {
    _name = '';
    _role = '';
    notifyListeners();
  }
}
