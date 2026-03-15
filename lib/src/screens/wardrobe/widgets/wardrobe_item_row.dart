import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../models/clothing_item.dart';
import '../wardrobe_palette.dart';
import 'wardrobe_tag.dart';

class WardrobeItemRow extends StatelessWidget {
  final ClothingItem item;
  final bool showOwner;
  final VoidCallback? onTap;

  const WardrobeItemRow({
    super.key,
    required this.item,
    required this.showOwner,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayColor = _colorFromName(item.colorName);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.60),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: WardrobePalette.borderSoft),
            ),
            child: Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: WardrobePalette.tileGradient,
                  ),
                  child: item.hasImage
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            item.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              item.category == 'Ayakkabı'
                                  ? Icons.directions_walk
                                  : Icons.checkroom,
                              color: displayColor.withOpacity(0.95),
                            ),
                          ),
                        )
                      : Center(
                          child: Icon(
                            item.category == 'Ayakkabı'
                                ? Icons.directions_walk
                                : Icons.checkroom,
                            color: displayColor.withOpacity(0.95),
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: WardrobePalette.textDark,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (item.isFavorite)
                            const Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Icon(
                                Icons.favorite_rounded,
                                size: 16,
                                color: WardrobePalette.textBrown,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          WardrobeTag(text: item.category),
                          WardrobeTag(text: item.colorName),
                          if (showOwner) WardrobeTag(text: item.ownerName),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: WardrobePalette.muted2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _colorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'siyah':
        return Colors.black87;
      case 'beyaz':
        return Colors.white;
      case 'mavi':
        return Colors.blue;
      case 'lacivert':
        return Colors.indigo;
      case 'kırmızı':
      case 'kirmizi':
        return Colors.red;
      case 'yeşil':
      case 'yesil':
        return Colors.green;
      case 'gri':
        return Colors.grey;
      case 'kahverengi':
        return Colors.brown;
      case 'bej':
        return const Color(0xFFD6C1A3);
      case 'krem':
        return const Color(0xFFE8DDD5);
      case 'pembe':
        return Colors.pink;
      case 'mor':
        return Colors.purple;
      case 'sarı':
      case 'sari':
        return Colors.amber;
      case 'turuncu':
        return Colors.orange;
      default:
        return WardrobePalette.textBrown;
    }
  }
}
