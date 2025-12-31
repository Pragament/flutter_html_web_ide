import 'package:cloud_firestore/cloud_firestore.dart';
import 'encryption_service.dart';

class ForgotService {
  /// Step 1: Find username using phone last 6 digits + birth day
  static Future<String> findUsername({
    required String phoneLast6,
    required int birthDay,
  }) async {
    final normalizedPhone = phoneLast6.trim();
    final phoneLast2 = normalizedPhone.substring(4);

    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('phoneLast2', isEqualTo: phoneLast2)
        .where('birthDay', isEqualTo: birthDay)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      throw 'No matching account found';
    }

    // Username is document ID
    return query.docs.first.id;
  }

  /// Step 2 (optional): Reset password
  static Future<void> resetPassword({
    required String username,
    required String newPassword,
    required String phoneLast6,
  }) async {
    final encrypted = EncryptionService.encryptPassword(
      newPassword.trim(),
      phoneLast6.trim(),
    ).base64;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .update({
      'encryptedPassword': encrypted,
    });
  }
}
