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

    return raw.map((entry) {
      if (entry.isEmpty) return null;
      try {
        // Preferred/new format: a single JSON object string.
        return Ride.decode(entry);
      } catch (_) {
        try {
          // Backward-compatible fallback for older malformed list wrappers.
          final rides = Ride.decodeList(entry.startsWith('[') ? entry : '[$entry]');
          return rides.isEmpty ? null : rides.first;
        } catch (_) {
          return null;
        }
      }
    }).toList();
  }

  Future<void> saveSlots(List<Ride?> slots) async {
    final payload = slots.map((ride) => ride == null ? '' : Ride.encode(ride)).toList();
    await prefs.setStringList(_activeKey, payload);
  }

  List<Ride> loadHistory() {
    final raw = prefs.getString(_historyKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      return Ride.decodeList(raw);
    } catch (_) {
      return [];
    }
  }

  Future<void> saveHistory(List<Ride> rides) => prefs.setString(_historyKey, Ride.encodeList(rides));
}
