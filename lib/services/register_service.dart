import 'package:cloud_firestore/cloud_firestore.dart';
import 'encryption_service.dart';

class RegisterService {
  static Future<void> registerUser({
    required String username,
    required String password,
    required String confirmPassword,
    required String phoneLast6,
    required int birthDay,
  }) async {
    if (password != confirmPassword) {
      throw 'Passwords do not match';
    }

    if (phoneLast6.length != 6) {
      throw 'Phone number must be last 6 digits';
    }

    if (birthDay < 1 || birthDay > 31) {
      throw 'Invalid birth day';
    }

    final docRef = FirebaseFirestore.instance.collection('users').doc(username);

    final doc = await docRef.get();
    if (doc.exists) {
      throw 'Username already exists';
    }

    final encrypted = EncryptionService.encryptPassword(password, phoneLast6);

    await docRef.set({
      'encryptedPassword': encrypted.base64,
      'phoneLast2': phoneLast6.substring(4),
      'birthDay': birthDay,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
