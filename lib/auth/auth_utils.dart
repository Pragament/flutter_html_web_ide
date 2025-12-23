import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthUtils {
  AuthUtils._();

  // Firestore users collection
  static final CollectionReference usersCollection = FirebaseFirestore.instance
      .collection('users');

  // Email validation
  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email.trim());
  }

  // Password strength
  static bool isStrongPassword(String password) {
    if (password.length < 8) return false;

    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasLower = password.contains(RegExp(r'[a-z]'));
    final hasNumber = password.contains(RegExp(r'\d'));

    return hasUpper && hasLower && hasNumber;
  }

  // Normalize email
  static String normalizeEmail(String email) {
    return email.trim().toLowerCase();
  }

  // Hash password (optional future use)
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }
}
