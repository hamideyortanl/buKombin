import 'package:flutter/material.dart';

class TermsRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const TermsRow({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 22,
          height: 22,
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
            padding: EdgeInsets.only(top: 1),
            child: Text(
              "Kullanım Şartları ve Gizlilik Politikası'nı kabul ediyorum",
              style: TextStyle(color: Color(0xFF6B675F), height: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}
