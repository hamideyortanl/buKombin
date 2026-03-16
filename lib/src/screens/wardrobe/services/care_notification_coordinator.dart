import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/clothing_item.dart';
import '../../../services/notification_service.dart';
import '../care/wardrobe_care_models.dart';

class CareNotificationCoordinator {
  const CareNotificationCoordinator();

  static const _storageKey = 'care_notification_state_v1';

  Future<void> pushCareTips(List<WardrobeCareTip> tips) async {
    if (tips.isEmpty) return;

    final granted = await NotificationService.instance.requestPermission();
    if (!granted) return;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    final decoded = raw == null ? <String, dynamic>{} : jsonDecode(raw) as Map<String, dynamic>;
    final state = decoded.map((key, value) => MapEntry(key, value.toString()));

    final urgentTips = tips.take(3).toList();
    var updated = false;

    for (var i = 0; i < urgentTips.length; i++) {
      final tip = urgentTips[i];
      final key = _storageFingerprint(tip);
      final itemKey = tip.item.id;
      final previous = state[itemKey];
      if (previous == key) continue;

      await NotificationService.instance.showNow(
        id: _notificationId(tip.item, i),
        title: _titleFor(tip),
        body: tip.message,
      );
      state[itemKey] = key;
      updated = true;
    }

    if (updated) {
      await prefs.setString(_storageKey, jsonEncode(state));
    }
  }

  String _titleFor(WardrobeCareTip tip) {
    if (tip.item.isInLaundry) {
      return 'Yikama onerisi: ${tip.item.name}';
    }
    return 'Bakim onerisi: ${tip.item.name}';
  }

  String _storageFingerprint(WardrobeCareTip tip) {
    return [
      tip.priority,
      tip.message,
      tip.item.usageCount,
      tip.item.laundryStatus,
      tip.item.lastWashedAt?.millisecondsSinceEpoch ?? 0,
      tip.item.lastWornAt?.millisecondsSinceEpoch ?? 0,
    ].join('|');
  }

  int _notificationId(ClothingItem item, int index) {
    return item.id.hashCode ^ (index + 31);
  }
}
