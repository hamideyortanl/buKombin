import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GenderCard extends StatelessWidget {
  final String? gender;
  final ValueChanged<String?> onGenderChanged;
  final String? femaleMode;
  final ValueChanged<String?> onFemaleModeChanged;

  const GenderCard({
    super.key,
    required this.gender,
    required this.onGenderChanged,
    required this.femaleMode,
    required this.onFemaleModeChanged,
  });

  static const _borderSoft = Color(0x66B4A193);
  static const _textBrown = Color(0xFF4A3428);
  static const _textLight = Colors.white;

  Widget _buildCompactOption({
    required String label,
    IconData? icon,
    String? svgPath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = isSelected ? _textLight : _textBrown.withOpacity(0.8);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          // 🌟 Padding'i milimetrik daralttık (12'den 8'e)
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? _textBrown : _borderSoft.withOpacity(0.3),
              width: isSelected ? 1.5 : 1,
            ),
            color: isSelected ? _textBrown : Colors.transparent,
          ),
          // 🌟 FITTEDBOX BELASINDAN KURTULDUK! Onun yerine standart Row ve Flexible kullanıyoruz.
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (svgPath != null)
                SvgPicture.asset(
                  svgPath,
                  width: 20, // İkonu 22'den 20'ye düşürdük
                  height: 20,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                )
              else if (icon != null)
                Icon(icon, color: color, size: 20),

              const SizedBox(width: 4), // Aradaki boşluğu azalttık

              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Eğer yinede sığmazsa ... koysun çökmesin
                  style: TextStyle(
                    color: isSelected ? _textLight : _textBrown,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13, // 14'ten 13'e düşürdük, zarif durur ve sığar
                    letterSpacing: -0.3, // Harfleri çok hafif birbirine yaklaştırdık
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFemale = gender == 'female';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderSoft.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Cinsiyet',
              style: TextStyle(
                  color: _textBrown.withOpacity(0.8),
                  fontWeight: FontWeight.bold,
                  fontSize: 14
              ),
            ),
          ),
          Row(
            children: [
              _buildCompactOption(
                label: 'Kız', // Burayı zaten düzeltmiştik
                icon: Icons.female_rounded,
                isSelected: isFemale,
                onTap: () => onGenderChanged('female'),
              ),
              const SizedBox(width: 12),
              _buildCompactOption(
                label: 'Erkek',
                icon: Icons.male_rounded,
                isSelected: gender == 'male',
                onTap: () => onGenderChanged('male'),
              ),
            ],
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isFemale
                ? Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: _borderSoft.withOpacity(0.3), height: 1),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      _buildCompactOption(
                        label: 'Tesettürlü',
                        svgPath: 'assets/icons/tesetturlu.svg',
                        isSelected: femaleMode == 'closed',
                        onTap: () => onFemaleModeChanged('closed'),
                      ),
                      const SizedBox(width: 12),
                      _buildCompactOption(
                        label: 'Tesettürsüz',
                        svgPath: 'assets/icons/tesettursuz.svg',
                        isSelected: femaleMode == 'open',
                        onTap: () => onFemaleModeChanged('open'),
                      ),
                    ],
                  ),
                ],
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}