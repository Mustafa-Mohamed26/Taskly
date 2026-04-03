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

  // --- Specific methods for easier access ---

  static const String _onboardingKey = 'onboarding_completed';
  static const String _themeKey = 'theme_mode';

  static Future<bool> setOnboardingCompleted(bool value) async {
    return await saveData(key: _onboardingKey, value: value);
  }

  static bool getOnboardingCompleted() {
    return getData(key: _onboardingKey) ?? false;
  }

  static Future<bool> setThemeMode(String value) async {
    return await saveData(key: _themeKey, value: value);
  }

  static String getThemeMode() {
    return getData(key: _themeKey) ?? 'system';
  }
}
