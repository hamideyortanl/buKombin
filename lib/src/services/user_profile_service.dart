import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserProfile({
    required String uid,
    required String username,
    required String email,
    String? fullName,
    String? gender,
    String? femaleMode,
    required bool isFamilyAccount,
  }) async {
    final trimmedFullName = fullName?.trim();
    final trimmedGender = gender?.trim();
    final trimmedFemaleMode = femaleMode?.trim();

    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'username': username.trim(),
      'email': email.trim(),
      'fullName': (trimmedFullName == null || trimmedFullName.isEmpty)
          ? null
          : trimmedFullName,
      'gender': (trimmedGender == null || trimmedGender.isEmpty)
          ? null
          : trimmedGender,
      'femaleMode': (trimmedFemaleMode == null || trimmedFemaleMode.isEmpty)
          ? null
          : trimmedFemaleMode,
      'isFamilyAccount': isFamilyAccount,
      'onboardingCompleted': false,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateUserProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}