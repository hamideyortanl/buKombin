import 'dart:ui';

import 'package:flutter/material.dart';

class HomeGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const HomeGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  static const _borderSoft = Color(0x66B4A193);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.60),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _borderSoft),
          ),
          child: child,
        ),
      ),
    );
  }
}
