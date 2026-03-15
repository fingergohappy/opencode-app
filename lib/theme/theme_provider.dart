import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'opencode_theme.dart';
import 'opencode_themes.dart';

/// 当前主题模式 Provider (使用 Flutter 内置 ThemeMode)
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  void toggleTheme() {
    switch (state) {
      case ThemeMode.system:
      case ThemeMode.light:
        state = ThemeMode.dark;
      case ThemeMode.dark:
        state = ThemeMode.light;
    }
  }
}

/// 当前选中的预设主题 id
final selectedThemeIdProvider = NotifierProvider<SelectedThemeNotifier, String>(
  SelectedThemeNotifier.new,
);

class SelectedThemeNotifier extends Notifier<String> {
  @override
  String build() {
    return opencodeThemes.first.id;
  }

  void setThemeId(String themeId) {
    if (opencodeThemeById.containsKey(themeId)) {
      state = themeId;
    }
  }
}

/// 当前选中的预设主题
final selectedOpencodeThemeProvider = Provider<OpencodeTheme>((ref) {
  final selectedThemeId = ref.watch(selectedThemeIdProvider);
  return opencodeThemeById[selectedThemeId] ?? opencodeThemes.first;
});

/// 当前选中预设主题的亮色 ThemeData
final lightThemeProvider = Provider<ThemeData>((ref) {
  final selectedTheme = ref.watch(selectedOpencodeThemeProvider);
  return selectedTheme.lightTheme;
});

/// 当前选中预设主题的暗色 ThemeData
final darkThemeProvider = Provider<ThemeData>((ref) {
  final selectedTheme = ref.watch(selectedOpencodeThemeProvider);
  return selectedTheme.darkTheme;
});
