import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_utils.dart';

class AuthService {
  AuthService._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register
  static Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = AuthUtils.normalizeEmail(email);

    if (!AuthUtils.isValidEmail(normalizedEmail)) {
      throw Exception('Invalid email address');
    }

    if (!AuthUtils.isStrongPassword(password)) {
      throw Exception('Weak password');
    }

    final credential = await _auth.createUserWithEmailAndPassword(
      email: normalizedEmail,
      password: password,
    );

    final user = credential.user;
    if (user == null) throw Exception('User creation failed');

    await AuthUtils.usersCollection.doc(user.uid).set({
      'uid': user.uid,
      'email': normalizedEmail,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return credential;
  }

  // Login
  static Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: AuthUtils.normalizeEmail(email),
      password: password,
    );
  }

  // Logout
  static Future<void> logout() async {
    await _auth.signOut();
  }

  // Reset password
  static Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: AuthUtils.normalizeEmail(email));
  }

  static User? get currentUser => _auth.currentUser;

  /// Resolve username to email
  static Future<String?> getEmailFromUsername(String username) async {
    final query =
        await AuthUtils.usersCollection
            .where('username', isEqualTo: username)
            .limit(1)
            .get();

    if (query.docs.isEmpty) return null;

    return query.docs.first['email'] as String;
  }
}
