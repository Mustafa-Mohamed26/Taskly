import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static const String _onboardingKey = 'onboarding_completed';
  static const String _themeKey = 'theme_mode';

  static Future<bool> setOnboardingCompleted(bool value) async {
    return await _sharedPreferences.setBool(_onboardingKey, value);
  }

  static bool getOnboardingCompleted() {
    return _sharedPreferences.getBool(_onboardingKey) ?? false;
  }

  static Future<bool> setThemeMode(String value) async {
    return await _sharedPreferences.setString(_themeKey, value);
  }

  static String getThemeMode() {
    return _sharedPreferences.getString(_themeKey) ?? 'system';
  }

  static Future<bool> clear() async {
    return await _sharedPreferences.clear();
  }
}
