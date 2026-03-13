import 'package:flutter/material.dart';

class OnboardingAvatarHeader extends StatelessWidget {
  final String title;
  final String stepText;
  final double progress;
  final VoidCallback onBack;

  const OnboardingAvatarHeader({
    super.key,
    required this.title,
    required this.stepText,
    required this.progress,
    required this.onBack,
  });

  static const _textDark = Color(0xFF3E2723);
  static const _textMuted = Color(0xFF6B675F);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: onBack,
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.arrow_back, color: _textDark),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: _textDark,
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  height: 1.1,
                ),
              ),
            ),
            Text(stepText, style: const TextStyle(color: _textMuted)),
          ],
        ),
        const SizedBox(height: 14),

        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Container(
            height: 4,
            color: Colors.white.withOpacity(0.40),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF5C4033), Color(0xFF4A3428)],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
