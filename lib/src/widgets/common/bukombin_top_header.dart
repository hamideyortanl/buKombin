import 'dart:ui';
import 'package:flutter/material.dart';

/// Uygulamadaki sayfaların üst kısmındaki ortak "kahverengi alan".
///
/// Diğer sayfalardaki (Home/Dolap vb.) başlık alanıyla aynı görsel dili kullanır:
/// - Kahverengi gradient
/// - Altta geniş yuvarlak köşe
/// - Hafif gölge
///
/// İsteğe bağlı olarak altına (örn. TabBar) bir [bottom] widget konabilir.
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
    this.padding = const EdgeInsets.fromLTRB(24, 18, 24, 18),
  });

  static const _textLight = Color(0xFFE8DDD5);

  static const _g1 = Color(0xFF5C4033);
  static const _g2 = Color(0xFF4A3428);
  static const _g3 = Color(0xFF3E2723);

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Container(
      padding: padding.add(EdgeInsets.only(top: top)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [_g1, _g2, _g3],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A3428).withOpacity(0.30),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
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
                    color: _textLight,
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
            // Diğer sayfalardaki "glass" hissiyle uyumlu.
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.22)),
                  ),
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
