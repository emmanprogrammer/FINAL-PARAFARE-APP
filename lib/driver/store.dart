import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

class DriverStore {
  DriverStore(this.prefs);
  final SharedPreferences prefs;

  static const _activeKey = 'driver_active_slots';
  static const _historyKey = 'driver_history';

  List<Ride?> loadSlots() {
    final raw = prefs.getStringList(_activeKey);
    if (raw == null || raw.length != 6) return List<Ride?>.filled(6, null);
    return raw.map((e) => e.isEmpty ? null : Ride.decodeList('[$e]').first).toList();
  }

  Future<void> saveSlots(List<Ride?> slots) async {
    await prefs.setStringList(_activeKey, slots.map((e) => e == null ? '' : Ride.encodeList([e]).replaceAll('[', '').replaceAll(']', '')).toList());
  }

  List<Ride> loadHistory() {
    final raw = prefs.getString(_historyKey);
    if (raw == null || raw.isEmpty) return [];
    return Ride.decodeList(raw);
  }

  Future<void> saveHistory(List<Ride> rides) => prefs.setString(_historyKey, Ride.encodeList(rides));
}
