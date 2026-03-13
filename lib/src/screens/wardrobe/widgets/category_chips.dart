import 'package:flutter/material.dart';

import '../wardrobe_palette.dart';

class CategoryChips extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const CategoryChips({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const cats = ['Tümü', 'Üst', 'Alt', 'Ayakkabı'];

    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final c = cats[i];
          final selected = c == value;

          return GestureDetector(
            onTap: () => onChanged(c),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: selected
                    ? const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [WardrobePalette.g1, WardrobePalette.g2],
                      )
                    : null,
                color: selected ? null : Colors.white.withOpacity(0.60),
                border: Border.all(
                  color: selected ? Colors.transparent : WardrobePalette.borderSoft,
                  width: 1,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: WardrobePalette.textBrown.withOpacity(0.18),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        )
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  c,
                  style: TextStyle(
                    color: selected ? const Color(0xFFE8DDD5) : WardrobePalette.textDark,
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
