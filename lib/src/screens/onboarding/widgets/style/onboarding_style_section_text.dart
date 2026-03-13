import 'package:flutter/material.dart';

class OnboardingSectionTitle extends StatelessWidget {
  final String title;
  const OnboardingSectionTitle({super.key, required this.title});

  static const _textBrown = Color(0xFF4A3428);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: _textBrown,
        fontSize: 19,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class OnboardingSectionSub extends StatelessWidget {
  final String text;
  const OnboardingSectionSub({super.key, required this.text});

  static const _textMuted = Color(0xFF6B675F);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: _textMuted,
          fontSize: 14,
          height: 1.4,
        ),
      ),
    );
  }
}
