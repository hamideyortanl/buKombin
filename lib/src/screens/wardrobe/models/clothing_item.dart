import 'package:flutter/material.dart';

class ClothingItem {
  final String name;
  final String owner;
  final String category;
  final Color color;

  const ClothingItem({
    required this.name,
    required this.owner,
    required this.category,
    required this.color,
  });
}
