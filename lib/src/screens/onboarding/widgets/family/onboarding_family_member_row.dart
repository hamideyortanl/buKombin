import 'dart:ui';
import 'package:flutter/material.dart';

class OnboardingFamilyMemberRow extends StatelessWidget {
  final String name;
  final String role;
  final String avatar;
  final VoidCallback onDelete;

  const OnboardingFamilyMemberRow({
    super.key,
    required this.name,
    required this.role,
    required this.avatar,
    required this.onDelete,
  });

  static const textBrown = Color(0xFF4A3428);
  static const textMuted = Color(0xFF6B675F);
  static const borderSoft = Color(0x66B4A193);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.60),
            border: Border.all(color: borderSoft),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF5C4033), Color(0xFF4A3428)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4A3428).withOpacity(0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(avatar, style: const TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, // ✅ right overflow yok
                      style: const TextStyle(
                        color: textBrown,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis, // ✅ right overflow yok
                      style: const TextStyle(color: textMuted),
                    ),
                  ],
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onDelete,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.close,
                    color: const Color(0xFF6B675F).withOpacity(0.95),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
