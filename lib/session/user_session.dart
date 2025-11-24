import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _email;
  String? _name;

  bool get isLoggedIn => _isLoggedIn;
  String? get email => _email;
  String? get name => _name;

  // 🔹 Load session from SharedPreferences
  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _email = prefs.getString('email');
    _name = prefs.getString('name');
    notifyListeners();
  }

  // 🔹 Save user data when logging in
  Future<void> logIn({required String email, String? name}) async {
    _isLoggedIn = true;
    _email = email;
    _name = name;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('email', email);
    if (name != null) await prefs.setString('name', name);

    notifyListeners();
  }

  // 🔹 Get user data as a map
  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!isLoggedIn) return null;

    return {
      'email': prefs.getString('email'),
      'name': prefs.getString('name'),
    };
  }

  // 🔹 Logout and clear user data
  Future<void> logOut() async {
    _isLoggedIn = false;
    _email = null;
    _name = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // clear all keys

    notifyListeners();
  }
}

final userSession = UserSession();
