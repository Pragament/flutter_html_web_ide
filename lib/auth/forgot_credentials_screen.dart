import 'package:flutter/foundation.dart';
import 'auth_service.dart';

class ForgotPasswordController extends ChangeNotifier {
  bool isLoading = false;
  bool emailSent = false;
  String? error;

  Future<void> sendResetEmail(String email) async {
    isLoading = true;
    error = null;
    emailSent = false;
    notifyListeners();

    try {
      await AuthService.resetPassword(email);
      emailSent = true;
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
