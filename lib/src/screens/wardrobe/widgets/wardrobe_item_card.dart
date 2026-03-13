import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/clothing_item.dart';
import '../wardrobe_palette.dart';

class WardrobeItemCard extends StatelessWidget {
  final ClothingItem item;
  final bool showOwner;

  const WardrobeItemCard({super.key, required this.item, required this.showOwner});

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
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.60),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: WardrobePalette.borderSoft),
              boxShadow: [
                BoxShadow(
                  color: WardrobePalette.textBrown.withOpacity(0.10),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(gradient: WardrobePalette.tileGradient),
                    child: Center(
                      child: Icon(
                        item.category == 'Ayakkabı' ? Icons.directions_walk : Icons.checkroom,
                        size: 44,
                        color: item.color.withOpacity(0.95),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
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
                      const SizedBox(height: 4),
                      Text(item.category, style: const TextStyle(color: WardrobePalette.muted2)),
                      if (showOwner) ...[
                        const SizedBox(height: 6),
                        Text('Sahip: ${item.owner}', style: const TextStyle(color: WardrobePalette.muted2)),
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
}
