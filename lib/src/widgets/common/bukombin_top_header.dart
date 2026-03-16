import 'dart:ui';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class BuKombinTopHeader extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? bottom;
  final Widget? content;
  final EdgeInsetsGeometry padding;

  const BuKombinTopHeader({
    super.key,
    required this.title,
    this.actions,
    this.bottom,
    this.content,
    this.padding = BuKombinMetrics.standardHeaderPadding,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Container(
      padding: padding.add(EdgeInsets.only(top: top)),
      decoration: BuKombinDecorations.headerBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: BuKombinColors.beige1,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
          if (content != null) ...[
            const SizedBox(height: 12),
            content!,
          ],
          if (bottom != null) ...[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BuKombinDecorations.glassSurface(),
                  child: bottom!,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
