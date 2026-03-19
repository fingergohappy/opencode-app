library;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'model.dart';

const _kSettingsKey = 'app_settings';

class AppSettingsStorage {
  AppSettingsStorage(this._prefs);

  final SharedPreferences _prefs;

  AppSettings load() {
    final raw = _prefs.getString(_kSettingsKey);
    if (raw == null) return AppSettings.defaults;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return AppSettings.fromJson(json);
    } catch (_) {
      return AppSettings.defaults;
    }
  }

  Future<void> save(AppSettings settings) async {
    await _prefs.setString(_kSettingsKey, jsonEncode(settings.toJson()));
  }
}
