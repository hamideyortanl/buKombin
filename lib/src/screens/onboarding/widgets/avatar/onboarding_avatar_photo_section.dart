import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'onboarding_avatar_buttons_row.dart';

class OnboardingAvatarPhotoSection extends StatelessWidget {
  final IconData placeholderIcon;
  final Uint8List? imageBytes;
  final String? imageName;

  final VoidCallback onPickImage;
  final VoidCallback onAiAvatar;

  const OnboardingAvatarPhotoSection({
    super.key,
    required this.placeholderIcon,
    required this.imageBytes,
    required this.imageName,
    required this.onPickImage,
    required this.onAiAvatar,
  });

  static const _textMuted = Color(0xFF6B675F);

  bool get _hasImage => imageBytes != null && imageBytes!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: 138,
            height: 138,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF5C4033), Color(0xFF4A3428)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A3428).withOpacity(0.30),
                  blurRadius: 60,
                  offset: const Offset(0, 20),
                )
              ],
            ),
            child: ClipOval(
              child: _hasImage
                  ? Image.memory(imageBytes!, fit: BoxFit.cover)
                  : Center(
                child: Icon(
                  placeholderIcon,
                  size: 46,
                  color: const Color(0xFFE8DDD5),
                ),
              ),
            ),
          ),
        ),

        if (imageName != null) ...[
          const SizedBox(height: 10),
          Text(
            imageName!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _textMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],

        const SizedBox(height: 16),

        // ✅ küçük ekran overflow çözümü: dar olunca alt alta
        OnboardingAvatarButtonsRow(
          onPickImage: onPickImage,
          onAiAvatar: onAiAvatar, // ✅ hep aktif
        ),
      ],
    );
  }
}
