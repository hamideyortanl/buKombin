import 'dart:ui';
import 'package:flutter/material.dart';

class OutfitsHeader extends StatelessWidget {
  final VoidCallback onCalendarTap;
  const OutfitsHeader({super.key, required this.onCalendarTap});

  static const _headerG1 = Color(0xFF5C4033);
  static const _headerG2 = Color(0xFF4A3428);
  static const _headerG3 = Color(0xFF3E2723);

  static const _textLight = Color(0xFFE8DDD5);
  static const _mutedLight = Color(0xFFD4C5B9);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [_headerG1, _headerG2, _headerG3],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A3428).withOpacity(0.30),
            blurRadius: 40,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Kombinler',
                  style: TextStyle(
                    color: _textLight,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: InkWell(
                    onTap: onCalendarTap,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        border: Border.all(color: Colors.white.withOpacity(0.20)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.calendar_month, color: _textLight, size: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // AI card
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFB8956A).withOpacity(0.20),
                      const Color(0xFFA67C52).withOpacity(0.20),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFB8956A), Color(0xFFA67C52)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 6),
                              )
                            ],
                          ),
                          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('AI Stil Asistanı',
                                  style: TextStyle(color: _textLight, fontWeight: FontWeight.w600)),
                              SizedBox(height: 2),
                              Text('Bugün için önerileriniz hazır',
                                  style: TextStyle(color: _mutedLight)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.20),
                              foregroundColor: _textLight,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Önerileri Gör (demo)')),
                            ),
                            child: const Text('Önerileri Gör'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
