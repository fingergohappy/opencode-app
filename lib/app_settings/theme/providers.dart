import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/opencode_theme.dart';
import '../../theme/opencode_themes.dart';
import 'controller.dart';
import 'model.dart';

final themeControllerProvider =
    NotifierProvider<ThemeController, ThemeSettings>(ThemeController.new);

final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(themeControllerProvider).themeMode;
});

final selectedThemeIdProvider = Provider<String>((ref) {
  return ref.watch(themeControllerProvider).selectedThemeId;
});

final selectedOpencodeThemeProvider = Provider<OpencodeTheme>((ref) {
  final selectedThemeId = ref.watch(selectedThemeIdProvider);
  return opencodeThemeById[selectedThemeId] ?? opencodeThemes.first;
});

final lightThemeProvider = Provider<ThemeData>((ref) {
  final selectedTheme = ref.watch(selectedOpencodeThemeProvider);
  return selectedTheme.lightTheme;
});

final darkThemeProvider = Provider<ThemeData>((ref) {
  final selectedTheme = ref.watch(selectedOpencodeThemeProvider);
  return selectedTheme.darkTheme;
});
