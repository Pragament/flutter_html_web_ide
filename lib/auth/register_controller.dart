import 'package:flutter/foundation.dart';
import 'auth_service.dart';

class RegisterController extends ChangeNotifier {
  bool isLoading = false;
  String? error;

  Future<bool> register(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await AuthService.register(email: email, password: password);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
