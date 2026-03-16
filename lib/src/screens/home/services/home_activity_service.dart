import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/home_activity_item.dart';

class HomeActivityService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  HomeActivityService({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  User get _currentUser {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Oturum bulunamadı.');
    }
    return user;
  }

  CollectionReference<Map<String, dynamic>> _activityRef(String uid) {
    return _firestore.collection('users').doc(uid).collection('homeActivities');
  }

  Stream<List<HomeActivityItem>> streamActivities({int limit = 12}) {
    final uid = _currentUser.uid;
    return _activityRef(uid)
        .orderBy('sortDate', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => HomeActivityItem.fromMap(doc.data())).toList());
  }

  Future<void> logActivity({
    required IconData icon,
    required String title,
    required String subtitle,
    DateTime? at,
  }) async {
    final uid = _currentUser.uid;
    final when = at ?? DateTime.now();
    await _activityRef(uid).add({
      'iconCodePoint': icon.codePoint,
      'title': title,
      'subtitle': subtitle,
      'sortDate': when.toIso8601String(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
