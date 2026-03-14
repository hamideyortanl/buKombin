import 'package:cloud_firestore/cloud_firestore.dart';

class UsernameTakenException implements Exception {}

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String normalizeUsername(String username) {
    return username.trim().toLowerCase();
  }

  Future<void> createUserProfile({
    required String uid,
    required String username,
    required String email,
    String? fullName,
    String? gender,
    String? femaleMode,
    required bool isFamilyAccount,
  }) async {
    final trimmedUsername = username.trim();
    final trimmedEmail = email.trim();
    final trimmedFullName = fullName?.trim();
    final trimmedGender = gender?.trim();
    final trimmedFemaleMode = femaleMode?.trim();
    final usernameKey = normalizeUsername(trimmedUsername);

    final userRef = _firestore.collection('users').doc(uid);
    final usernameRef = _firestore.collection('usernames').doc(usernameKey);

    await _firestore.runTransaction((tx) async {
      final usernameSnap = await tx.get(usernameRef);

      if (usernameSnap.exists) {
        throw UsernameTakenException();
      }

      tx.set(userRef, {
        'uid': uid,
        'username': trimmedUsername,
        'usernameKey': usernameKey,
        'email': trimmedEmail,
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

      tx.set(usernameRef, {
        'uid': uid,
        'username': trimmedUsername,
        'usernameKey': usernameKey,
        'email': trimmedEmail,
        'createdAt': FieldValue.serverTimestamp(),
      });
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

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }

  Future<String?> resolveEmailForLogin(String identifier) async {
    final key = identifier.trim();
    if (key.isEmpty) return null;

    if (key.contains('@')) {
      return key;
    }

    final usernameKey = normalizeUsername(key);
    final doc = await _firestore.collection('usernames').doc(usernameKey).get();

    if (!doc.exists) return null;

    final data = doc.data();
    final email = data?['email'];

    if (email is String && email.trim().isNotEmpty) {
      return email.trim();
    }

    return null;
  }

  Future<void> ensureUsernameMapping({
    required String uid,
    required String username,
    required String email,
  }) async {
    final trimmedUsername = username.trim();
    final trimmedEmail = email.trim();
    final usernameKey = normalizeUsername(trimmedUsername);

    if (trimmedUsername.isEmpty || trimmedEmail.isEmpty) return;

    final usernameRef = _firestore.collection('usernames').doc(usernameKey);

    await usernameRef.set({
      'uid': uid,
      'username': trimmedUsername,
      'usernameKey': usernameKey,
      'email': trimmedEmail,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _firestore.collection('users').doc(uid).set({
      'usernameKey': usernameKey,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> saveFamilyMembers({
    required String uid,
    required List<Map<String, String>> members,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'familyMembers': members,
      'onboardingCompleted': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> markOnboardingCompleted({
    required String uid,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'onboardingCompleted': true,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}