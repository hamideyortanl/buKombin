import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'onboarding_family_input.dart';

class OnboardingFamilyAddForm extends StatelessWidget {
  final TextEditingController nameC;
  final TextEditingController roleC;

  final List<String> avatarOptions;
  final String selectedAvatar;
  final ValueChanged<String> onSelectAvatar;

  final VoidCallback onCancel;
  final VoidCallback onAdd;

  const OnboardingFamilyAddForm({
    super.key,
    required this.nameC,
    required this.roleC,
    required this.avatarOptions,
    required this.selectedAvatar,
    required this.onSelectAvatar,
    required this.onCancel,
    required this.onAdd,
  });

  static const textBrown = Color(0xFF4A3428);
  static const textMuted = Color(0xFF6B675F);
  static const borderSoft = Color(0x66B4A193);

  // ✅ sadece harf + boşluk (TR dahil)
  static final _lettersAndSpace =
  FilteringTextInputFormatter.allow(RegExp(r"[a-zA-ZığüşöçİĞÜŞÖÇ\s]"));

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.60),
            border: Border.all(color: borderSoft),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Yeni Üye Ekle',
                style: TextStyle(color: textBrown, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 14),

              OnboardingFamilyInput(
                controller: nameC,
                hint: 'Ad Soyad',
                icon: Icons.person_outline,
                inputFormatters: [_lettersAndSpace],
              ),
              const SizedBox(height: 12),

              OnboardingFamilyInput(
                controller: roleC,
                hint: 'Rol (örn. Anne, Kardeş)',
                icon: Icons.badge_outlined,
                inputFormatters: [_lettersAndSpace],
              ),

              const SizedBox(height: 16),
              const Text('Avatar Seç', style: TextStyle(color: textMuted)),
              const SizedBox(height: 10),

              LayoutBuilder(
                builder: (context, c) {
                  final w = c.maxWidth;
                  int cross = 4;
                  if (w < 320) cross = 3;
                  if (w < 240) cross = 2;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: avatarOptions.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cross,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, i) {
                      final a = avatarOptions[i];
                      final selected = a == selectedAvatar;

                      return GestureDetector(
                        onTap: () => onSelectAvatar(a),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: selected
                                  ? const [Color(0xFF5C4033), Color(0xFF4A3428)]
                                  : const [Color(0xFFD4C5B9), Color(0xFFC9B8A8)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                    selected ? 0.10 : 0.06),
                                blurRadius: selected ? 14 : 8,
                                offset: const Offset(0, 6),
                              ),
                            ],
                            border: selected
                                ? Border.all(
                                color: const Color(0xFF4A3428), width: 2)
                                : null,
                          ),
                          child: Center(
                            child: Text(a, style: const TextStyle(fontSize: 22)),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.white.withOpacity(0.80),
                        side: const BorderSide(color: borderSoft),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        foregroundColor: textBrown,
                      ),
                      child: const Text('İptal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: nameC,
                      builder: (_, __, ___) {
                        final enabled = nameC.text.trim().isNotEmpty;
                        return GestureDetector(
                          onTap: enabled ? onAdd : null,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 160),
                            opacity: enabled ? 1.0 : 0.5,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFF5C4033),
                                    Color(0xFF4A3428)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Center(
                                child: Text(
                                  'Ekle',
                                  style: TextStyle(
                                    color: Color(0xFFE8DDD5),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
