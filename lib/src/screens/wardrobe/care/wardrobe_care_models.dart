import '../../../models/clothing_item.dart';

class FabricCareProfile {
  final String washTemperature;
  final String washMethod;
  final String dryingMethod;
  final String ironLevel;
  final int washAfterWears;
  final String sustainabilityTip;
  final String handlingTip;

  const FabricCareProfile({
    required this.washTemperature,
    required this.washMethod,
    required this.dryingMethod,
    required this.ironLevel,
    required this.washAfterWears,
    required this.sustainabilityTip,
    required this.handlingTip,
  });
}

class WardrobeCareTip {
  final ClothingItem item;
  final String title;
  final String message;
  final String emoji;
  final int priority;

  const WardrobeCareTip({
    required this.item,
    required this.title,
    required this.message,
    required this.emoji,
    required this.priority,
  });
}
