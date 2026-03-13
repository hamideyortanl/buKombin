import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  final String text;
  final Color lineColor;
  final Color textColor;

  const OrDivider({
    super.key,
    required this.text,
    required this.lineColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Divider(color: lineColor, thickness: 1),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          color: Colors.transparent,
          child: Text(text, style: TextStyle(color: textColor)),
        ),
      ],
    );
  }
}
