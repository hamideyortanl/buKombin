import 'package:flutter/material.dart';

class WelcomeProgressDots extends StatelessWidget {
  final int activeIndex;
  const WelcomeProgressDots({super.key, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) => _buildDot(index == activeIndex)),
    );
  }

  Widget _buildDot(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: active ? 32 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF4A3428) : const Color(0xFFB4A193).withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}