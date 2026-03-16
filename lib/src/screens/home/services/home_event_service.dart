import 'package:shared_preferences/shared_preferences.dart';

import '../models/home_event_plan.dart';

class HomeEventService {
  static const _storagePrefix = 'home_planned_events_';

  Future<List<HomeEventPlan>> loadEvents(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final values = prefs.getStringList('$_storagePrefix$username') ?? <String>[];

    final items = values
        .map(HomeEventPlan.fromJson)
        .where((event) => event.dateTime.isAfter(DateTime.now().subtract(const Duration(days: 1))))
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return items;
  }

  Future<void> saveEvents(String username, List<HomeEventPlan> events) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = events.map((event) => event.toJson()).toList();
    await prefs.setStringList('$_storagePrefix$username', encoded);
  }

  Future<void> addEvent(String username, HomeEventPlan event) async {
    final items = await loadEvents(username);
    items.add(event);
    items.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    await saveEvents(username, items);
  }
}
