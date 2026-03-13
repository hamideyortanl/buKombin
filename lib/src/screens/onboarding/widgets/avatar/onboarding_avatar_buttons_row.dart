import 'dart:ui';
import 'package:flutter/material.dart';

class OnboardingAvatarButtonsRow extends StatelessWidget {
  final VoidCallback onPickImage;
  final VoidCallback onAiAvatar;

  const OnboardingAvatarButtonsRow({
    super.key,
    required this.onPickImage,
    required this.onAiAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final isNarrow = c.maxWidth < 360;

        final uploadBtn = _GlassButton(
          text: 'Fotoğraf Yükle',
          icon: Icons.upload_outlined,
          onTap: onPickImage,
        );

        final aiBtn = _PrimaryMiniButton(
          text: 'AI Avatar',
          icon: Icons.auto_awesome,
          onTap: onAiAvatar,
        );

        if (isNarrow) {
          return Column(
            children: [
              SizedBox(width: double.infinity, child: uploadBtn),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: aiBtn),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: uploadBtn),
            const SizedBox(width: 12),
            Expanded(child: aiBtn),
          ],
        );
      },
    );
  }
}

class _GlassButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _GlassButton({required this.text, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.60),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0x66B4A193)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: const Color(0xFF4A3428), size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFF4A3428)),
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

class _PrimaryMiniButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _PrimaryMiniButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // ✅ hep aktif
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF5C4033), Color(0xFF4A3428), Color(0xFF3E2723)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A3428).withOpacity(0.20),
              blurRadius: 26,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFE8DDD5), size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFE8DDD5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
