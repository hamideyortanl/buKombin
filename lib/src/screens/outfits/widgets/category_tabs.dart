import 'package:flutter/material.dart';

class CategoryTabs extends StatelessWidget {
  final TabController controller;
  final List<String> categories;

  const CategoryTabs({super.key, required this.controller, required this.categories});

  static const _borderSoft = Color(0x66B4A193);
  static const _textDark = Color(0xFF4A3428);

  static const _g1 = Color(0xFF5C4033);
  static const _g2 = Color(0xFF4A3428);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final selected = controller.index == i;

          return GestureDetector(
            onTap: () => controller.animateTo(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: selected
                    ? const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [_g1, _g2],
                )
                    : null,
                color: selected ? null : Colors.white.withOpacity(0.60),
                border: Border.all(
                  color: selected ? Colors.transparent : _borderSoft,
                  width: 1,
                ),
                boxShadow: selected
                    ? [
                  BoxShadow(
                    color: _textDark.withOpacity(0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  )
                ]
                    : null,
              ),
              child: Center(
                child: Text(
                  categories[i],
                  style: TextStyle(
                    color: selected ? const Color(0xFFE8DDD5) : _textDark,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
