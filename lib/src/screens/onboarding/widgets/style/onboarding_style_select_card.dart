import 'package:flutter/material.dart';

class OnboardingSelectCard extends StatelessWidget {
  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? assetPath;

  const OnboardingSelectCard({
    super.key,
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
    this.assetPath,
  });

  static const _borderSoft = Color(0x66B4A193);
  static const _textBrown = Color(0xFF4A3428);
  static const _textLight = Color(0xFFE8DDD5);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            width: 2,
            color: selected ? const Color(0xFF4A3428) : _borderSoft,
          ),
          gradient: selected
              ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF5C4033), Color(0xFF4A3428)],
          )
              : null,
          color: selected ? null : Colors.white.withOpacity(0.60),
          boxShadow: selected
              ? [
            BoxShadow(
              color: const Color(0xFF4A3428).withOpacity(0.18),
              blurRadius: 18,
              offset: const Offset(0, 10),
            )
          ]
              : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // ✅ Görsel alanı: kartın büyük kısmını kaplasın
            Expanded(
              flex: 7,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: _ImageOrEmoji(
                      assetPath: assetPath,
                      emoji: emoji,
                    ),
                  ),

                  // Çok hafif üstten alt gölge: yazıya geçiş daha zarif
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Yazı alanı: sadece burada padding
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: selected ? _textLight : _textBrown,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: selected
                        ? const Icon(Icons.check, key: ValueKey('on'), color: _textLight, size: 20)
                        : const SizedBox(key: ValueKey('off'), width: 20, height: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageOrEmoji extends StatelessWidget {
  final String? assetPath;
  final String emoji;

  const _ImageOrEmoji({required this.assetPath, required this.emoji});

  @override
  Widget build(BuildContext context) {
    if (assetPath != null) {
      return Image.asset(
        assetPath!,
        fit: BoxFit.cover, // ✅ sağ boşluk bırakmaz, alanı kaplar
        alignment: Alignment.topCenter, // üst ağırlıklı (dikey uzun görüntüde daha iyi)
        errorBuilder: (_, __, ___) {
          return Container(
            color: Colors.black.withOpacity(0.03),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 34)),
          );
        },
      );
    }

    return Container(
      color: Colors.black.withOpacity(0.03),
      alignment: Alignment.center,
      child: Text(emoji, style: const TextStyle(fontSize: 34)),
    );
  }
}
