import 'package:flutter/material.dart';

import 'home_event_plan.dart';

class HomePlannedEventView {
  final HomeEventPlan event;
  final String dateLabel;
  final String outfitText;
  final IconData icon;
  final String? recommendation;
  final bool isUrgent;

  const HomePlannedEventView({
    required this.event,
    required this.dateLabel,
    required this.outfitText,
    required this.icon,
    this.recommendation,
    this.isUrgent = false,
  });
}
