import 'dart:convert';

class HomeEventPlan {
  final String id;
  final String title;
  final String type;
  final String? notes;
  final DateTime dateTime;
  final DateTime createdAt;

  const HomeEventPlan({
    required this.id,
    required this.title,
    required this.type,
    required this.dateTime,
    required this.createdAt,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'notes': notes,
      'dateTime': dateTime.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory HomeEventPlan.fromMap(Map<String, dynamic> map) {
    return HomeEventPlan(
      id: (map['id'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      type: (map['type'] ?? '').toString(),
      notes: map['notes']?.toString(),
      dateTime: DateTime.tryParse((map['dateTime'] ?? '').toString()) ?? DateTime.now(),
      createdAt: DateTime.tryParse((map['createdAt'] ?? '').toString()) ?? DateTime.now(),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory HomeEventPlan.fromJson(String source) {
    return HomeEventPlan.fromMap(jsonDecode(source) as Map<String, dynamic>);
  }
}
