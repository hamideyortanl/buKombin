import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../models/clothing_item.dart';
import '../wardrobe_palette.dart';

class WardrobeItemCard extends StatelessWidget {
  final ClothingItem item;
  final bool showOwner;
  final VoidCallback? onTap;

  const WardrobeItemCard({
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
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.60),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: WardrobePalette.borderSoft),
              boxShadow: [
                BoxShadow(
                  color: WardrobePalette.textBrown.withOpacity(0.10),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: item.hasImage
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: Image.network(
                            item.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _fallbackIcon(displayColor),
                          ),
                        )
                      : _fallbackIcon(displayColor),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
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
                      const SizedBox(height: 4),
                      Text(
                        '${item.category} • ${item.colorName}',
                        style: const TextStyle(color: WardrobePalette.muted2),
                      ),
                      if (showOwner) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Sahip: ${item.ownerName}',
                          style: const TextStyle(color: WardrobePalette.muted2),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fallbackIcon(Color displayColor) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: WardrobePalette.tileGradient,
      ),
      child: Center(
        child: Icon(
          item.category == 'Ayakkabı' ? Icons.directions_walk : Icons.checkroom,
          size: 44,
          color: displayColor.withOpacity(0.95),
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
