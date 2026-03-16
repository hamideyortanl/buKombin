import '../../../models/clothing_item.dart';
import '../../../screens/wardrobe/care/wardrobe_care_models.dart';
import 'home_activity_item.dart';
import 'home_planned_event_view.dart';

class HomeSummary {
  final int wardrobeCount;
  final int readyPlanCount;
  final int favoriteCount;
  final int inLaundryCount;
  final int plannedEventCount;
  final double sustainabilityProgress;
  final String sustainabilityScoreText;
  final String sustainabilitySubtitle;
  final List<HomeActivityItem> activities;
  final List<HomePlannedEventView> plannedEvents;
  final List<WardrobeCareTip> topCareTips;
  final List<ClothingItem> recentItems;

  const HomeSummary({
    required this.wardrobeCount,
    required this.readyPlanCount,
    required this.favoriteCount,
    required this.inLaundryCount,
    required this.plannedEventCount,
    required this.sustainabilityProgress,
    required this.sustainabilityScoreText,
    required this.sustainabilitySubtitle,
    required this.activities,
    required this.plannedEvents,
    required this.topCareTips,
    required this.recentItems,
  });
}
