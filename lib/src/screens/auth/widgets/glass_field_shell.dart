import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class GlassFieldShell extends StatelessWidget {
  final Widget child;
  final Color borderColor;

  const GlassFieldShell({super.key, required this.child, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BuKombinDecorations.inputShell(borderColor: borderColor),
      child: child,
    );
  }
}
