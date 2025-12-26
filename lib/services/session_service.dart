class SessionService {
  static String? currentUsername;
  static bool _isGuest = false;

  static void login(String username) {
    currentUsername = username;
    _isGuest = false;
  }

  static void loginAsGuest() {
    currentUsername = null;
    _isGuest = true;
  }

  static void logout() {
    currentUsername = null;
    _isGuest = false;
  }

  static bool get isLoggedIn => currentUsername != null;
  static bool get isGuest => _isGuest;
}
