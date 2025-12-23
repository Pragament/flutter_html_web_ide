import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/encryption_service.dart';

class LoginController extends ChangeNotifier {
  bool isLoading = false;
  String? error;

  Future<bool> login({
    required String username,
    required String password,
    required String phoneLast6,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      if (phoneLast6.length != 6) {
        throw Exception('Phone last 6 digits required');
      }


      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(username.trim())
              .get();

      if (!doc.exists) {
        throw Exception('Invalid credentials');
      }

      final storedEncrypted = doc.data()!['encryptedPassword'] as String;

      final encryptedInput =
          EncryptionService.encryptPassword(password, phoneLast6.trim()).base64;
      
      if (storedEncrypted != encryptedInput) {
        throw Exception('Invalid credentials');
      }

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
