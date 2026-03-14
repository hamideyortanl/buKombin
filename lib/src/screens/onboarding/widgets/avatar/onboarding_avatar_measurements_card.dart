import 'dart:ui';
import 'package:flutter/material.dart';

import 'onboarding_avatar_number_field.dart';

class OnboardingAvatarMeasurementsCard extends StatelessWidget {
  final TextEditingController heightC;
  final TextEditingController weightC;
  final TextEditingController chestC;
  final TextEditingController waistC;
  final TextEditingController hipC;

  final String? skinTone;
  final String? faceShape;
  final String? eyeColor;
  final String? hairColor;
  final String? hairTexture;
  final String? hairLength;

  final List<String> skinToneOptions;
  final List<String> faceShapeOptions;
  final List<String> eyeColorOptions;
  final List<String> hairColorOptions;
  final List<String> hairTextureOptions;
  final List<String> hairLengthOptions;

  final bool showHairFields;

  final ValueChanged<String?> onSkinToneChanged;
  final ValueChanged<String?> onFaceShapeChanged;
  final ValueChanged<String?> onEyeColorChanged;
  final ValueChanged<String?> onHairColorChanged;
  final ValueChanged<String?> onHairTextureChanged;
  final ValueChanged<String?> onHairLengthChanged;

  const OnboardingAvatarMeasurementsCard({
    super.key,
    required this.heightC,
    required this.weightC,
    required this.chestC,
    required this.waistC,
    required this.hipC,
    required this.skinTone,
    required this.faceShape,
    required this.eyeColor,
    required this.hairColor,
    required this.hairTexture,
    required this.hairLength,
    required this.skinToneOptions,
    required this.faceShapeOptions,
    required this.eyeColorOptions,
    required this.hairColorOptions,
    required this.hairTextureOptions,
    required this.hairLengthOptions,
    required this.showHairFields,
    required this.onSkinToneChanged,
    required this.onFaceShapeChanged,
    required this.onEyeColorChanged,
    required this.onHairColorChanged,
    required this.onHairTextureChanged,
    required this.onHairLengthChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      title: 'Avatar Profili',
      subtitle: 'En az boy, kilo ve temel görünüş özelliklerini girmeniz yeterli',
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, c) {
              final isNarrow = c.maxWidth < 360;

              if (isNarrow) {
                return Column(
                  children: [
                    OnboardingAvatarNumberField(
                      label: 'Boy (cm)',
                      controller: heightC,
                      hint: '170',
                    ),
                    const SizedBox(height: 12),
                    OnboardingAvatarNumberField(
                      label: 'Kilo (kg)',
                      controller: weightC,
                      hint: '70',
                    ),
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
                    OnboardingAvatarNumberField(
                      label: 'Göğüs (cm)',
                      controller: chestC,
                      hint: '90',
                    ),
                    const SizedBox(height: 12),
                    OnboardingAvatarNumberField(
                      label: 'Bel (cm)',
                      controller: waistC,
                      hint: '75',
                    ),
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
          OnboardingAvatarNumberField(
            label: 'Kalça (cm)',
            controller: hipC,
            hint: '95',
          ),
          const SizedBox(height: 18),
          _AvatarDropdownField(
            label: 'Ten Tonu',
            value: skinTone,
            items: skinToneOptions,
            onChanged: onSkinToneChanged,
          ),
          const SizedBox(height: 12),
          _AvatarDropdownField(
            label: 'Yüz Şekli',
            value: faceShape,
            items: faceShapeOptions,
            onChanged: onFaceShapeChanged,
          ),
          const SizedBox(height: 12),
          _AvatarDropdownField(
            label: 'Göz Rengi',
            value: eyeColor,
            items: eyeColorOptions,
            onChanged: onEyeColorChanged,
          ),
          if (showHairFields) ...[
            const SizedBox(height: 12),
            _AvatarDropdownField(
              label: 'Saç Rengi',
              value: hairColor,
              items: hairColorOptions,
              onChanged: onHairColorChanged,
            ),
            const SizedBox(height: 12),
            _AvatarDropdownField(
              label: 'Saç Dokusu',
              value: hairTexture,
              items: hairTextureOptions,
              onChanged: onHairTextureChanged,
            ),
            const SizedBox(height: 12),
            _AvatarDropdownField(
              label: 'Saç Uzunluğu',
              value: hairLength,
              items: hairLengthOptions,
              onChanged: onHairLengthChanged,
            ),
          ],
        ],
      ),
    );
  }
}

class _AvatarDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _AvatarDropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF6B675F),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.55),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0x66B4A193)),
              ),
              child: DropdownButtonFormField<String>(
                value: value,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                ),
                hint: Text(label),
                items: items
                    .map(
                      (item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ),
                )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _GlassCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

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
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF6B675F),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 14),
              child,
            ],
          ),
        ),
      ),
    );
  }
}