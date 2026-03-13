import 'package:flutter/material.dart';

class WelcomeLogoCard extends StatelessWidget {
  final Widget icon;
  const WelcomeLogoCard({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 140,
            height: 140,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF5C4033), Color(0xFF3E2723)],
              ),
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A3428).withOpacity(0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: icon,
          ),
          // Süsleme noktaları
          Positioned(
            top: -5,
            right: -5,
            child: _dot(18, const Color(0xFFB4A193)),
          ),
          Positioned(
            bottom: -5,
            left: -5,
            child: _dot(12, const Color(0xFF8B8680)),
          ),
        ],
      ),
    );
  }

  Widget _dot(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}