import 'dart:ui';
import 'package:flutter/material.dart';

class FamilyCard extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const FamilyCard({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.60),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x66B4A193)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 26,
                height: 26,
                child: Checkbox(
                  value: value,
                  onChanged: (v) => onChanged(v ?? false),
                  activeColor: const Color(0xFF4A3428),
                  side: const BorderSide(color: Color(0xFFB4A193)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aile Hesabı',
                        style: TextStyle(
                          color: Color(0xFF3E2723),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Birden fazla kullanıcı için ortak dolap ve kombin yönetimi',
                        style: TextStyle(color: Color(0xFF6B675F)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
