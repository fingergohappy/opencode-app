import 'package:flutter/material.dart';
import 'theme_spec.dart';

const oc2ThemeLight = OpenCodeThemeVariant(
  background: Color(0xFFF8F8F8),
  text: Color(0xFF6F6F6F),
  textStrong: Color(0xFF171717),
  border: Color(0x24000000),
  accent: Color(0xFFDCDE8D),
  success: Color(0xFF12C905),
  warning: Color(0xFFFFDC17),
  error: Color(0xFFFC533A),
  info: Color(0xFFA753AE),
  interactive: Color(0xFF034CFF),
  diffAdd: Color(0xFF9FF29A),
  diffDelete: Color(0xFFFC533A),
);

const oc2ThemeDark = OpenCodeThemeVariant(
  background: Color(0xFF101010),
  text: Color(0xFFF1F1F1),
  textStrong: Color(0xFFFFFFFF),
  border: Color(0x2BFFFFFF),
  accent: Color(0xFFFAB283),
  success: Color(0xFF12C905),
  warning: Color(0xFFFCD53A),
  error: Color(0xFFFC533A),
  info: Color(0xFFEDB2F1),
  interactive: Color(0xFF034CFF),
  diffAdd: Color(0xFFC8FFC4),
  diffDelete: Color(0xFFFC533A),
);

const oc2Theme = OpenCodeThemeDefinition(
  id: 'oc-2',
  name: 'OC-2',
  light: oc2ThemeLight,
  dark: oc2ThemeDark,
);

const oc1ThemeLight = OpenCodeThemeVariant(
  background: Color(0xFFFFFFFF),
  text: Color(0xFF666666),
  textStrong: Color(0xFF000000),
  border: Color(0x1A000000),
  accent: Color(0xFF0066FF),
  success: Color(0xFF00C853),
  warning: Color(0xFFFFAB00),
  error: Color(0xFFFF5252),
  info: Color(0xFF2196F3),
  interactive: Color(0xFF0066FF),
  diffAdd: Color(0xFFE6FFED),
  diffDelete: Color(0xFFFFEBEE),
);

const oc1ThemeDark = OpenCodeThemeVariant(
  background: Color(0xFF1E1E1E),
  text: Color(0xFFCCCCCC),
  textStrong: Color(0xFFFFFFFF),
  border: Color(0x33FFFFFF),
  accent: Color(0xFF4FC3F7),
  success: Color(0xFF69F0AE),
  warning: Color(0xFFFFD740),
  error: Color(0xFFFF5252),
  info: Color(0xFF40C4FF),
  interactive: Color(0xFF4FC3F7),
  diffAdd: Color(0xFF1B5E20),
  diffDelete: Color(0xFFB71C1C),
);

const oc1Theme = OpenCodeThemeDefinition(
  id: 'oc-1',
  name: 'OC-1',
  light: oc1ThemeLight,
  dark: oc1ThemeDark,
);

class OpenCodeThemeCatalog {
  static const themes = [oc1Theme, oc2Theme];
  static const defaultTheme = oc1Theme;

  static OpenCodeThemeDefinition byId(String id) {
    return themes.firstWhere((t) => t.id == id, orElse: () => defaultTheme);
  }
}
