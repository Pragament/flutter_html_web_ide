import 'package:flutter/foundation.dart';
import 'auth_service.dart';

class LoginController extends ChangeNotifier {
  bool isLoading = false;
  String? error;

  Future<bool> login(String identifier, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      String emailToUse = identifier.trim();

      // If input does NOT look like email, treat as username
      if (!identifier.contains('@')) {
        final resolvedEmail = await AuthService.getEmailFromUsername(
          identifier.trim(),
        );

        if (resolvedEmail == null) {
          throw Exception('Username not found');
        }

        emailToUse = resolvedEmail;
      }

      await AuthService.login(email: emailToUse, password: password);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
