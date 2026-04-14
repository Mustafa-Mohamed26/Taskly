import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? _sharedPreferences;

  static Future<void> init() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint('Error initializing SharedPreferences: $e');
    }
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (_sharedPreferences == null) await init();
    if (_sharedPreferences == null) return false;

    try {
      if (value is String) return await _sharedPreferences!.setString(key, value);
      if (value is int) return await _sharedPreferences!.setInt(key, value);
      if (value is bool) return await _sharedPreferences!.setBool(key, value);
      if (value is double) return await _sharedPreferences!.setDouble(key, value);
    } catch (e) {
      debugPrint('Error saving data to SharedPreferences: $e');
    }
    return false;
  }

  static dynamic getData({required String key}) {
    return _sharedPreferences?.get(key);
  }

  static Future<bool> removeData({required String key}) async {
    if (_sharedPreferences == null) await init();
    if (_sharedPreferences == null) return false;

    try {
      return await _sharedPreferences!.remove(key);
    } catch (e) {
      debugPrint('Error removing data from SharedPreferences: $e');
      return false;
    }
  }

  static Future<bool> clearData() async {
    if (_sharedPreferences == null) await init();
    if (_sharedPreferences == null) return false;

    try {
      return await _sharedPreferences!.clear();
    } catch (e) {
      debugPrint('Error clearing SharedPreferences: $e');
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // App Settings
  // ---------------------------------------------------------------------------

  static const String _onboardingKey = 'onboarding_completed';
  static const String _themeKey = 'theme_mode';
  static const String _accentColorKey = 'accent_color';

  static Future<bool> setOnboardingCompleted(bool value) async =>
      saveData(key: _onboardingKey, value: value);

  static bool getOnboardingCompleted() =>
      getData(key: _onboardingKey) ?? false;

  static Future<bool> setThemeMode(String value) async =>
      saveData(key: _themeKey, value: value);

  static String getThemeMode() => getData(key: _themeKey) ?? 'system';

  /// Stores the accent color as a 32-bit ARGB integer.
  static Future<bool> setAccentColor(int colorValue) async =>
      saveData(key: _accentColorKey, value: colorValue);

  /// Returns the stored accent color integer, or null if not yet set.
  static int? getAccentColor() => getData(key: _accentColorKey);

  // ---------------------------------------------------------------------------
  // Notification Settings
  // ---------------------------------------------------------------------------

  static const String _pushNotificationsKey = 'push_notifications_enabled';
  static const String _remindersKey = 'reminders_enabled';
  static const String _emailNotificationsKey = 'email_notifications_enabled';
  static const String _weeklyReportsKey = 'weekly_reports_enabled';

  static Future<bool> setPushNotificationsEnabled(bool value) async =>
      saveData(key: _pushNotificationsKey, value: value);

  static bool getPushNotificationsEnabled() =>
      getData(key: _pushNotificationsKey) ?? true;

  static Future<bool> setRemindersEnabled(bool value) async =>
      saveData(key: _remindersKey, value: value);

  static bool getRemindersEnabled() =>
      getData(key: _remindersKey) ?? true;

  static Future<bool> setEmailNotificationsEnabled(bool value) async =>
      saveData(key: _emailNotificationsKey, value: value);

  static bool getEmailNotificationsEnabled() =>
      getData(key: _emailNotificationsKey) ?? false;

  static Future<bool> setWeeklyReportsEnabled(bool value) async =>
      saveData(key: _weeklyReportsKey, value: value);

  static bool getWeeklyReportsEnabled() =>
      getData(key: _weeklyReportsKey) ?? true;
}
