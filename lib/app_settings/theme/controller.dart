import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/opencode_themes.dart';
import '../providers.dart';
import 'model.dart';

class ThemeController extends Notifier<ThemeSettings> {
  @override
  ThemeSettings build() {
    return ref.read(appSettingsStorageProvider).load().theme;
  }

  void setThemeId(String themeId) {
    if (!isValidOpencodeThemeId(themeId)) return;
    state = state.copyWith(selectedThemeId: themeId);
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  void toggleTheme() {
    final next = switch (state.themeMode) {
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system || ThemeMode.light => ThemeMode.dark,
    };
    state = state.copyWith(themeMode: next);
  }
}
