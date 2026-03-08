import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings.dart';

class SettingsStore {
  static const _keyThemeMode = 'theme_mode';
  static const _keyThemePreset = 'theme_preset';
  static const _keyLanguage = 'language';

  Future<AppThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return AppThemeMode.fromValue(prefs.getString(_keyThemeMode));
  }

  Future<AppThemePreset> getThemePreset() async {
    final prefs = await SharedPreferences.getInstance();
    return AppThemePreset.fromValue(prefs.getString(_keyThemePreset));
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, mode.value);
  }

  Future<void> setThemePreset(AppThemePreset preset) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemePreset, preset.value);
  }

  Future<AppLanguage> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return AppLanguage.fromValue(prefs.getString(_keyLanguage));
  }

  Future<void> setLanguage(AppLanguage language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, language.value);
  }
}
