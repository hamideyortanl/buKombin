import 'package:flutter/material.dart';

class GlassFieldShell extends StatelessWidget {
  final Widget child;
  final Color borderColor;

  const GlassFieldShell({super.key, required this.child, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        border: Border.all(color: borderColor, width: 1.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}