import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String seenKey = 'seen_get_started';

  static Future<bool> hasSeenGetStarted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(seenKey) ?? false;
  }

  static Future<void> setSeenGetStarted(bool seen) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(seenKey, seen);
  }
}
