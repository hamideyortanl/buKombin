import 'dart:ui';

import 'package:flutter/material.dart';

import '../wardrobe_palette.dart';

class WardrobeHeader extends StatelessWidget {
  final String title;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final bool grid;
  final VoidCallback onToggleGrid;
  final VoidCallback onOpenFilter;

  const WardrobeHeader({
    super.key,
    required this.title,
    required this.query,
    required this.onQueryChanged,
    required this.grid,
    required this.onToggleGrid,
    required this.onOpenFilter,
  });

  static const _textLight = Color(0xFFE8DDD5);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: WardrobePalette.headerGradient,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: WardrobePalette.textBrown.withOpacity(0.30),
            blurRadius: 40,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _textLight,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          _GlassTextField(
            value: query,
            hintText: 'Parça ara...',
            prefixIcon: Icons.search,
            onChanged: onQueryChanged,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _GlassButton(
                  onTap: onOpenFilter,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.tune, color: _textLight, size: 18),
                      SizedBox(width: 8),
                      Text('Filtrele', style: TextStyle(color: _textLight)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _GlassButton(
                width: 54,
                height: 46,
                onTap: onToggleGrid,
                child: Icon(
                  grid ? Icons.view_agenda_outlined : Icons.grid_view_rounded,
                  color: _textLight,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GlassTextField extends StatelessWidget {
  final String value;
  final String hintText;
  final IconData prefixIcon;
  final ValueChanged<String> onChanged;

  const _GlassTextField({
    required this.value,
    required this.hintText,
    required this.prefixIcon,
    required this.onChanged,
  });

  static const _textLight = Color(0xFFE8DDD5);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
            border: Border.all(color: Colors.white.withOpacity(0.20)),
            borderRadius: BorderRadius.circular(14),
          ),
          child: TextField(
            onChanged: onChanged,
            controller: TextEditingController(text: value)
              ..selection = TextSelection.collapsed(offset: value.length),
            style: const TextStyle(color: _textLight),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.white),
              prefixIcon: Icon(prefixIcon, color: Colors.white),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final double? width;
  final double? height;

  const _GlassButton({
    required this.child,
    required this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            padding: width == null ? const EdgeInsets.symmetric(horizontal: 14, vertical: 12) : null,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              border: Border.all(color: Colors.white.withOpacity(0.20)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
