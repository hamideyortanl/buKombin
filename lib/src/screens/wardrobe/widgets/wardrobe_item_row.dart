import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/clothing_item.dart';
import '../wardrobe_palette.dart';
import 'wardrobe_tag.dart';

class WardrobeItemRow extends StatelessWidget {
  final ClothingItem item;
  final bool showOwner;

  const WardrobeItemRow({super.key, required this.item, required this.showOwner});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${item.name} detayı (demo)'))),
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
                  child: Center(
                    child: Icon(
                      item.category == 'Ayakkabı' ? Icons.directions_walk : Icons.checkroom,
                      color: item.color.withOpacity(0.95),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: WardrobePalette.textDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          WardrobeTag(text: item.category),
                          if (showOwner) WardrobeTag(text: item.owner),
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
}
