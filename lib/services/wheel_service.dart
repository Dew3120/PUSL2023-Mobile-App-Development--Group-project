import 'package:shared_preferences/shared_preferences.dart';

/// Incrementally Increasing Interval Algorithm
/// Wheel appears at app opens: 1, 5, 11, 19 → reset → 20, 24, 30, 38 → reset → ...
/// Gaps: +4, +6, +8, then reset (gap=1), repeat
/// Each cycle = 19 opens. Trigger positions (0-indexed): 0, 4, 10, 18
class WheelService {
  WheelService._();

  static const _keyOpenCount = 'mc_app_open_count';
  static const _cycleLength = 19;
  static const _triggerPositions = {0, 4, 10, 18};

  /// Call once on every app open. Returns true if wheel should appear.
  static Future<bool> recordOpenAndCheck() async {
    final prefs = await SharedPreferences.getInstance();
    final count = (prefs.getInt(_keyOpenCount) ?? 0) + 1;
    await prefs.setInt(_keyOpenCount, count);

    final positionInCycle = (count - 1) % _cycleLength;
    return _triggerPositions.contains(positionInCycle);
  }

  static Future<int> getOpenCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyOpenCount) ?? 0;
  }

  /// Returns the next open count (>= current) at which the wheel will appear.
  static int nextTriggerOpen(int currentCount) {
    // Search forward starting from the *next* open
    for (int n = currentCount + 1; n < currentCount + _cycleLength * 2; n++) {
      final positionInCycle = (n - 1) % _cycleLength;
      if (_triggerPositions.contains(positionInCycle)) return n;
    }
    return currentCount + 1;
  }

  // ── For testing: reset counter ─────────────────────────────────────────
  static Future<void> resetForTesting() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyOpenCount, 0);
  }
}
