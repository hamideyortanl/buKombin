import 'dart:ui';
import 'package:flutter/material.dart';

import 'onboarding_avatar_number_field.dart';

class OnboardingAvatarMeasurementsCard extends StatelessWidget {
  final TextEditingController heightC;
  final TextEditingController weightC;
  final TextEditingController chestC;
  final TextEditingController waistC;
  final TextEditingController hipC;

  const OnboardingAvatarMeasurementsCard({
    super.key,
    required this.heightC,
    required this.weightC,
    required this.chestC,
    required this.waistC,
    required this.hipC,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      title: 'Vücut Ölçüleri',
      subtitle: 'En az boy ve kilo girmeniz yeterli',
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, c) {
              final isNarrow = c.maxWidth < 360;

              if (isNarrow) {
                return Column(
                  children: [
                    OnboardingAvatarNumberField(label: 'Boy (cm)', controller: heightC, hint: '170'),
                    const SizedBox(height: 12),
                    OnboardingAvatarNumberField(label: 'Kilo (kg)', controller: weightC, hint: '70'),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: OnboardingAvatarNumberField(
                      label: 'Boy (cm)',
                      controller: heightC,
                      hint: '170',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OnboardingAvatarNumberField(
                      label: 'Kilo (kg)',
                      controller: weightC,
                      hint: '70',
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),

          LayoutBuilder(
            builder: (context, c) {
              final isNarrow = c.maxWidth < 360;

              if (isNarrow) {
                return Column(
                  children: [
                    OnboardingAvatarNumberField(label: 'Göğüs (cm)', controller: chestC, hint: '90'),
                    const SizedBox(height: 12),
                    OnboardingAvatarNumberField(label: 'Bel (cm)', controller: waistC, hint: '75'),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: OnboardingAvatarNumberField(
                      label: 'Göğüs (cm)',
                      controller: chestC,
                      hint: '90',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OnboardingAvatarNumberField(
                      label: 'Bel (cm)',
                      controller: waistC,
                      hint: '75',
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 12),

          // Kalça
          OnboardingAvatarNumberField(
            label: 'Kalça (cm)',
            controller: hipC,
            hint: '95',
          ),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _GlassCard({required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.60),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0x66B4A193)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF4A3428),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(subtitle, style: const TextStyle(color: Color(0xFF6B675F), height: 1.35)),
              const SizedBox(height: 14),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
