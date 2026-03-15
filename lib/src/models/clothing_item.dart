import 'package:cloud_firestore/cloud_firestore.dart';

enum ClothingOwnerType {
  self,
  familyMember,
  shared;

  String get value {
    switch (this) {
      case ClothingOwnerType.self:
        return 'self';
      case ClothingOwnerType.familyMember:
        return 'familyMember';
      case ClothingOwnerType.shared:
        return 'shared';
    }
  }

  static ClothingOwnerType fromValue(String? value) {
    switch (value) {
      case 'familyMember':
        return ClothingOwnerType.familyMember;
      case 'shared':
        return ClothingOwnerType.shared;
      case 'self':
      default:
        return ClothingOwnerType.self;
    }
  }
}

class ClothingItem {
  final String id;
  final String ownerUid;
  final String ownerName;
  final ClothingOwnerType ownerType;
  final String name;
  final String category;
  final String subcategory;
  final String colorName;
  final String imageUrl;
  final String imagePath;
  final bool isShared;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String? season;
  final String? material;
  final String? brand;
  final String? notes;
  final List<String> tags;
  final int usageCount;
  final DateTime? lastWornAt;
  final String? careInstructions;
  final bool isFavorite;

  const ClothingItem({
    required this.id,
    required this.ownerUid,
    required this.ownerName,
    required this.ownerType,
    required this.name,
    required this.category,
    required this.subcategory,
    required this.colorName,
    required this.imageUrl,
    required this.imagePath,
    required this.isShared,
    required this.createdAt,
    required this.updatedAt,
    this.season,
    this.material,
    this.brand,
    this.notes,
    this.tags = const [],
    this.usageCount = 0,
    this.lastWornAt,
    this.careInstructions,
    this.isFavorite = false,
  });

  bool get hasNotes => notes != null && notes!.trim().isNotEmpty;
  bool get hasBrand => brand != null && brand!.trim().isNotEmpty;
  bool get hasMaterial => material != null && material!.trim().isNotEmpty;
  bool get hasSeason => season != null && season!.trim().isNotEmpty;
  bool get hasCareInstructions =>
      careInstructions != null && careInstructions!.trim().isNotEmpty;

  String get ownerTypeValue => ownerType.value;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerUid': ownerUid,
      'ownerName': ownerName,
      'ownerType': ownerType.value,
      'name': name,
      'category': category,
      'subcategory': subcategory,
      'colorName': colorName,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'isShared': isShared,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'season': season,
      'material': material,
      'brand': brand,
      'notes': notes,
      'tags': tags,
      'usageCount': usageCount,
      'lastWornAt':
      lastWornAt == null ? null : Timestamp.fromDate(lastWornAt!),
      'careInstructions': careInstructions,
      'isFavorite': isFavorite,
    };
  }

  factory ClothingItem.fromMap(Map<String, dynamic> map) {
    DateTime readDate(dynamic value, {DateTime? fallback}) {
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      return fallback ?? DateTime.now();
    }

    final rawTags = map['tags'];
    final parsedTags = rawTags is List
        ? rawTags
        .whereType<String>()
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList()
        : <String>[];

    return ClothingItem(
      id: (map['id'] ?? '') as String,
      ownerUid: (map['ownerUid'] ?? '') as String,
      ownerName: (map['ownerName'] ?? '') as String,
      ownerType: ClothingOwnerType.fromValue(map['ownerType'] as String?),
      name: (map['name'] ?? '') as String,
      category: (map['category'] ?? '') as String,
      subcategory: (map['subcategory'] ?? '') as String,
      colorName: (map['colorName'] ?? '') as String,
      imageUrl: (map['imageUrl'] ?? '') as String,
      imagePath: (map['imagePath'] ?? '') as String,
      isShared: (map['isShared'] ?? false) as bool,
      createdAt: readDate(map['createdAt']),
      updatedAt: readDate(map['updatedAt']),
      season: map['season'] as String?,
      material: map['material'] as String?,
      brand: map['brand'] as String?,
      notes: map['notes'] as String?,
      tags: parsedTags,
      usageCount: (map['usageCount'] ?? 0) as int,
      lastWornAt: map['lastWornAt'] == null
          ? null
          : readDate(map['lastWornAt']),
      careInstructions: map['careInstructions'] as String?,
      isFavorite: (map['isFavorite'] ?? false) as bool,
    );
  }

  factory ClothingItem.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data() ?? <String, dynamic>{};
    return ClothingItem.fromMap({
      ...data,
      'id': data['id'] ?? doc.id,
    });
  }

  ClothingItem copyWith({
    String? id,
    String? ownerUid,
    String? ownerName,
    ClothingOwnerType? ownerType,
    String? name,
    String? category,
    String? subcategory,
    String? colorName,
    String? imageUrl,
    String? imagePath,
    bool? isShared,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? season,
    String? material,
    String? brand,
    String? notes,
    List<String>? tags,
    int? usageCount,
    DateTime? lastWornAt,
    String? careInstructions,
    bool? isFavorite,
  }) {
    return ClothingItem(
      id: id ?? this.id,
      ownerUid: ownerUid ?? this.ownerUid,
      ownerName: ownerName ?? this.ownerName,
      ownerType: ownerType ?? this.ownerType,
      name: name ?? this.name,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      colorName: colorName ?? this.colorName,
      imageUrl: imageUrl ?? this.imageUrl,
      imagePath: imagePath ?? this.imagePath,
      isShared: isShared ?? this.isShared,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      season: season ?? this.season,
      material: material ?? this.material,
      brand: brand ?? this.brand,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      usageCount: usageCount ?? this.usageCount,
      lastWornAt: lastWornAt ?? this.lastWornAt,
      careInstructions: careInstructions ?? this.careInstructions,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}