import 'dart:ui';
import 'package:flutter/material.dart';

import '../models/outfit.dart';

class OutfitCard extends StatelessWidget {
  final Outfit outfit;
  final VoidCallback onTap;
  final VoidCallback onToggleFav;
  final VoidCallback onShare;

  const OutfitCard({
    super.key,
    required this.outfit,
    required this.onTap,
    required this.onToggleFav,
    required this.onShare,
  });

  static const _borderSoft = Color(0x66B4A193);
  static const _textDark = Color(0xFF3E2723);
  static const _muted2 = Color(0xFF8B8680);

  static const _tileBg1 = Color(0xFFF5F1ED);
  static const _tileBg2 = Color(0xFFE8DDD5);

  @override
  Widget build(BuildContext context) {
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
              border: Border.all(color: _borderSoft),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A3428).withOpacity(0.10),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [_tileBg1, _tileBg2],
                          ),
                        ),
                        child: outfit.imageUrl.isNotEmpty
                            ? Image.network(outfit.imageUrl, fit: BoxFit.cover)
                            : const SizedBox(),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        right: 10,
                        child: Row(
                          children: [
                            if (outfit.isAI)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [Color(0xFFB8956A), Color(0xFFA67C52)],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.20),
                                      blurRadius: 10,
                                      offset: const Offset(0, 6),
                                    )
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.auto_awesome, size: 14, color: Colors.white),
                                    SizedBox(width: 4),
                                    Text('AI',
                                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                            const Spacer(),
                            InkWell(
                              onTap: onToggleFav,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: outfit.isFavorite
                                      ? Colors.red.withOpacity(0.80)
                                      : Colors.white.withOpacity(0.80),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 10,
                                      offset: const Offset(0, 6),
                                    )
                                  ],
                                ),
                                child: Icon(
                                  outfit.isFavorite ? Icons.favorite : Icons.favorite_border,
                                  size: 18,
                                  color: outfit.isFavorite ? Colors.white : const Color(0xFF4A3428),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: InkWell(
                          onTap: onShare,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white.withOpacity(0.80),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 10,
                                  offset: const Offset(0, 6),
                                )
                              ],
                            ),
                            child: const Icon(Icons.share, size: 18, color: Color(0xFF4A3428)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        outfit.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _textDark, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text('${outfit.items} parça', style: const TextStyle(color: _muted2)),
                          const Spacer(),
                          Text(outfit.date, style: const TextStyle(color: _muted2)),
                        ],
                      ),
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
