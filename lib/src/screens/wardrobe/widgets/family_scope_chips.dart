import 'package:flutter/material.dart';

import '../wardrobe_palette.dart';

class FamilyScopeChips extends StatelessWidget {
  final String scope;
  final List<String> scopes;
  final ValueChanged<String> onChanged;

  const FamilyScopeChips({
    super.key,
    required this.scope,
    required this.scopes,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: scopes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final s = scopes[i];
          final selected = s == scope;

          return GestureDetector(
            onTap: () => onChanged(s),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white.withOpacity(selected ? 0.72 : 0.60),
                border: Border.all(
                  color: selected
                      ? WardrobePalette.textBrown
                      : WardrobePalette.borderSoft,
                  width: selected ? 2 : 1,
                ),
              ),
              child: Center(
                child: Text(
                  s,
                  style: TextStyle(
                    color: selected
                        ? WardrobePalette.textBrown
                        : WardrobePalette.textDark,
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