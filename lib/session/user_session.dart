import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _email;
  String? _name;
  String? _photoUrl;
  String? get photoUrl => _photoUrl;
  bool get isLoggedIn => _isLoggedIn;
  String? get email => _email;
  String? get name => _name;

  // 🔹 Load session from SharedPreferences
  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _email = prefs.getString('email');
    _name = prefs.getString('name');
    _photoUrl = prefs.getString('photoUrl');
    notifyListeners();
  }

  // 🔹 Save user data when logging in
  Future<void> logIn({required String email, String? name, String? photoUrl}) async {
    _isLoggedIn = true;
    _email = email;
    _name = name;
    _photoUrl = photoUrl;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('email', email);
    if (name != null) await prefs.setString('name', name);
    if (photoUrl != null) await prefs.setString('photoUrl', photoUrl);
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
    _photoUrl = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // clear all keys

    notifyListeners();
  }
}

final userSession = UserSession();
