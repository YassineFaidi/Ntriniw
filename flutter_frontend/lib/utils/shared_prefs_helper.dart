import 'dart:convert';

import 'package:flutter_frontend/models/user_credential.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String seenKey = 'seen_get_started';
  static const String userCredentialKey = 'userCredential';

  static Future<bool> hasSeenGetStarted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(seenKey) ?? false;
  }

  static Future<void> setSeenGetStarted(bool seen) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(seenKey, seen);
  }

  static Future<UserCredential?> getUserCredential() async {
    final prefs = await SharedPreferences.getInstance();
    final userCredentialString = prefs.getString(userCredentialKey);
    if (userCredentialString != null) {
      final userCredentialJson = jsonDecode(userCredentialString);
      return UserCredential.fromJson(userCredentialJson);
    }
    return null;
  }

  static Future<UserCredential?> setUserCredential(
      Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    final userCredential = UserCredential.fromJson(user);
    await prefs.setString(
        'userCredential', jsonEncode(userCredential.toJson()));
    return userCredential;
  }
}
