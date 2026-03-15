import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/clothing_item.dart';

class WardrobeService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  WardrobeService({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _auth = auth ?? FirebaseAuth.instance;

  User get _currentUser {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Oturum bulunamadı.');
    }
    return user;
  }

  CollectionReference<Map<String, dynamic>> _itemsRef(String uid) {
    return _firestore.collection('users').doc(uid).collection('wardrobe');
  }

  Stream<List<ClothingItem>> streamWardrobeItems() {
    final uid = _currentUser.uid;

    return _itemsRef(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(ClothingItem.fromFirestore)
          .toList(),
    );
  }

  Future<List<ClothingItem>> fetchWardrobeItems() async {
    final uid = _currentUser.uid;

    final snapshot = await _itemsRef(uid)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map(ClothingItem.fromFirestore)
        .toList();
  }

  Future<Map<String, String>> _uploadImage({
    required String uid,
    required String itemId,
    required XFile imageFile,
  }) async {
    final extension = _readExtension(imageFile.name, imageFile.path);
    final imagePath = 'wardrobe/$uid/items/$itemId.$extension';

    final ref = _storage.ref().child(imagePath);

    final metadata = SettableMetadata(
      contentType: _guessContentType(extension),
    );

    await ref.putFile(File(imageFile.path), metadata);
    final imageUrl = await ref.getDownloadURL();

    return {
      'imagePath': imagePath,
      'imageUrl': imageUrl,
    };
  }

  Future<ClothingItem> createWardrobeItem({
    required XFile imageFile,
    required String ownerName,
    required ClothingOwnerType ownerType,
    required String name,
    required String category,
    required String subcategory,
    required String colorName,
    required bool isShared,
    String? season,
    String? material,
    String? brand,
    String? notes,
    List<String> tags = const [],
    String? careInstructions,
  }) async {
    final user = _currentUser;
    final uid = user.uid;
    final docRef = _itemsRef(uid).doc();
    final now = DateTime.now();

    final uploadResult = await _uploadImage(
      uid: uid,
      itemId: docRef.id,
      imageFile: imageFile,
    );

    final item = ClothingItem(
      id: docRef.id,
      ownerUid: uid,
      ownerName: ownerName.trim(),
      ownerType: isShared ? ClothingOwnerType.shared : ownerType,
      name: name.trim(),
      category: category.trim(),
      subcategory: subcategory.trim(),
      colorName: colorName.trim(),
      imageUrl: uploadResult['imageUrl']!,
      imagePath: uploadResult['imagePath']!,
      isShared: isShared,
      createdAt: now,
      updatedAt: now,
      season: _cleanNullable(season),
      material: _cleanNullable(material),
      brand: _cleanNullable(brand),
      notes: _cleanNullable(notes),
      tags: _normalizeTags(tags),
      usageCount: 0,
      lastWornAt: null,
      careInstructions: _cleanNullable(careInstructions),
      isFavorite: false,
    );

    await docRef.set(item.toMap());
    return item;
  }

  Future<void> updateWardrobeItem(ClothingItem item) async {
    final uid = _currentUser.uid;

    await _itemsRef(uid).doc(item.id).set(
      item.copyWith(updatedAt: DateTime.now()).toMap(),
      SetOptions(merge: true),
    );
  }

  Future<void> incrementUsageCount({
    required String itemId,
    int step = 1,
  }) async {
    final uid = _currentUser.uid;

    await _itemsRef(uid).doc(itemId).set(
      {
        'usageCount': FieldValue.increment(step),
        'lastWornAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> toggleFavorite({
    required String itemId,
    required bool isFavorite,
  }) async {
    final uid = _currentUser.uid;

    await _itemsRef(uid).doc(itemId).set(
      {
        'isFavorite': isFavorite,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> deleteWardrobeItem(ClothingItem item) async {
    final uid = _currentUser.uid;

    if (item.imagePath.trim().isNotEmpty) {
      try {
        await _storage.ref().child(item.imagePath).delete();
      } catch (_) {}
    }

    await _itemsRef(uid).doc(item.id).delete();
  }

  Future<List<String>> fetchFamilyOwnerNames() async {
    final uid = _currentUser.uid;
    final userDoc = await _firestore.collection('users').doc(uid).get();
    final data = userDoc.data() ?? <String, dynamic>{};

    final rawMembers = data['familyMembers'];
    final result = <String>[];

    if (rawMembers is List) {
      for (final member in rawMembers) {
        if (member is Map) {
          final name = (member['name'] ?? '').toString().trim();
          if (name.isNotEmpty && !_isMineLabel(name) && !result.contains(name)) {
            result.add(name);
          }
        }
      }
    }

    return result;
  }

  bool _isMineLabel(String value) {
    final normalized = value.trim().toLowerCase();
    return normalized == 'benim' ||
        normalized == 'ben' ||
        normalized == 'kendim' ||
        normalized == 'self';
  }

  String _readExtension(String name, String path) {
    final source = name.trim().isNotEmpty ? name : path;
    final dotIndex = source.lastIndexOf('.');

    if (dotIndex == -1 || dotIndex == source.length - 1) {
      return 'jpg';
    }

    return source.substring(dotIndex + 1).toLowerCase();
  }

  String _guessContentType(String extension) {
    switch (extension) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      case 'jpeg':
      case 'jpg':
      default:
        return 'image/jpeg';
    }
  }

  String? _cleanNullable(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }

  List<String> _normalizeTags(List<String> tags) {
    return tags
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
  }
}