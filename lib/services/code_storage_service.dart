import 'package:cloud_firestore/cloud_firestore.dart';

class CodeStorageService {
  static Future<void> saveProject({
    required String username,
    required String projectName,
    required String html,
    required String css,
    required String js,
  }) async {
    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(username);

    final filesRef = userRef.collection('files');

    await filesRef.add({
      'name': projectName,
      'html': html,
      'css': css,
      'js': js,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
