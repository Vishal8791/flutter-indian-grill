// user_session.dart
class UserSession {
  bool isLoggedIn = false; // Initial state: not logged in

  void logIn() {
    isLoggedIn = true;
  }

  void logOut() {
    isLoggedIn = false;
  }
}

final userSession = UserSession(); // Create a singleton instance
