import 'package:flutter/material.dart';

class OnboardingStyleFooter extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const OnboardingStyleFooter({
    super.key,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.only(top: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFC9B8A8).withOpacity(0.00),
              const Color(0xFFD4C5B9).withOpacity(0.85),
              const Color(0xFFC9B8A8).withOpacity(0.95),
            ],
          ),
        ),
        child: GestureDetector(
          onTap: enabled ? onTap : null,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: enabled ? 1.0 : 0.5,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF5C4033), Color(0xFF4A3428), Color(0xFF3E2723)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A3428).withOpacity(0.25),
                    blurRadius: 40,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Devam Et',
                  style: TextStyle(
                    color: Color(0xFFE8DDD5),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
