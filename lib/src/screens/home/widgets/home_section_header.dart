import 'package:flutter/material.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onAction;

  const HomeSectionHeader({
    super.key,
    required this.title,
    required this.actionText,
    required this.onAction,
  });

  static const _textBrown = Color(0xFF4A3428);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: _textBrown,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            foregroundColor: _textBrown,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
          child: Text(actionText),
        ),
      ],
    );
  }
}

class HomeSectionTitleOnly extends StatelessWidget {
  final String title;

  const HomeSectionTitleOnly({super.key, required this.title});

  static const _textBrown = Color(0xFF4A3428);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: _textBrown,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
