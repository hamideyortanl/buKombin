import 'package:flutter/material.dart';

class HomeActivityItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final DateTime sortDate;

  const HomeActivityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.sortDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'iconCodePoint': icon.codePoint,
      'title': title,
      'subtitle': subtitle,
      'sortDate': sortDate.toIso8601String(),
    };
  }

  factory HomeActivityItem.fromMap(Map<String, dynamic> map) {
    return HomeActivityItem(
      icon: IconData(
        (map['iconCodePoint'] as num?)?.toInt() ?? Icons.history.codePoint,
        fontFamily: 'MaterialIcons',
      ),
      title: (map['title'] ?? '').toString(),
      subtitle: (map['subtitle'] ?? '').toString(),
      sortDate: DateTime.tryParse((map['sortDate'] ?? '').toString()) ?? DateTime.now(),
    );
  }
}
