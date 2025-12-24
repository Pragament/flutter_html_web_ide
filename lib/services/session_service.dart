class SessionService {
  static String? currentUsername;

  static void login(String username) {
    currentUsername = username;
  }

  static void logout() {
    currentUsername = null;
  }

  static bool get isLoggedIn => currentUsername != null;
}
