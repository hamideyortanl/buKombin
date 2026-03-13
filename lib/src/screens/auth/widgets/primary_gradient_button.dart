import 'package:flutter/material.dart';

class PrimaryGradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool enabled;

  const PrimaryGradientButton({
    super.key,
    required this.text,
    required this.onTap,
    this.enabled = true,
  });

  @override
  State<PrimaryGradientButton> createState() => _PrimaryGradientButtonState();
}

class _PrimaryGradientButtonState extends State<PrimaryGradientButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled;

    return GestureDetector(
      onTapDown: (_) => enabled ? setState(() => _pressed = true) : null,
      onTapCancel: () => enabled ? setState(() => _pressed = false) : null,
      onTapUp: (_) => enabled ? setState(() => _pressed = false) : null,
      onTap: enabled ? widget.onTap : null,
      child: AnimatedScale(
        scale: _pressed && enabled ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 56, // Yükseklik sabitlendi
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: enabled
                ? const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF5C4033),
                Color(0xFF4A3428),
                Color(0xFF3E2723),
              ],
            )
                : null,
            color: enabled ? null : Colors.black.withOpacity(0.08), // Pasif rengi yumuşatıldı
            boxShadow: enabled
                ? [
              BoxShadow(
                color: const Color(0xFF4A3428).withOpacity(0.20), // Gölge hafifletildi
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ]
                : null,
          ),
          child: Center(
            child: Text(
              widget.text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: enabled ? Colors.white : const Color(0xFF6B675F), // Yazı bembeyaz oldu
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}