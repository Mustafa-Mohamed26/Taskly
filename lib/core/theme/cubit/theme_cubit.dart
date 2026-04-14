import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../service/cache_helper.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class ThemeState {
  final ThemeMode mode;
  final Color accentColor;

  const ThemeState({required this.mode, required this.accentColor});

  ThemeState copyWith({ThemeMode? mode, Color? accentColor}) => ThemeState(
        mode: mode ?? this.mode,
        accentColor: accentColor ?? this.accentColor,
      );
}

// ---------------------------------------------------------------------------
// Default accent colour – matches the original AppColors.primary
// ---------------------------------------------------------------------------

const Color _defaultAccent = Color(0xFF2211D1);

// ---------------------------------------------------------------------------
// Cubit
// ---------------------------------------------------------------------------

@singleton
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(_loadInitialState());

  static ThemeState _loadInitialState() {
    final themeMode = _parseThemeMode(CacheHelper.getThemeMode());
    final accentInt = CacheHelper.getAccentColor();
    final accentColor = accentInt != null ? Color(accentInt) : _defaultAccent;
    return ThemeState(mode: themeMode, accentColor: accentColor);
  }

  static ThemeMode _parseThemeMode(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> changeTheme(ThemeMode themeMode) async {
    final themeString = themeMode == ThemeMode.light
        ? 'light'
        : themeMode == ThemeMode.dark
            ? 'dark'
            : 'system';
    await CacheHelper.setThemeMode(themeString);
    emit(state.copyWith(mode: themeMode));
  }

  Future<void> changeAccentColor(Color color) async {
    await CacheHelper.setAccentColor(color.toARGB32());
    emit(state.copyWith(accentColor: color));
  }
}
