import 'package:flutter/material.dart';

class OpenCodeThemeVariant {
  final Color background;
  final Color text;
  final Color textStrong;
  final Color border;
  final Color accent;
  final Color success;
  final Color warning;
  final Color error;
  final Color info;
  final Color interactive;
  final Color diffAdd;
  final Color diffDelete;

  const OpenCodeThemeVariant({
    required this.background,
    required this.text,
    required this.textStrong,
    required this.border,
    required this.accent,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.interactive,
    required this.diffAdd,
    required this.diffDelete,
  });
}

class OpenCodeThemeDefinition {
  final String id;
  final String name;
  final OpenCodeThemeVariant light;
  final OpenCodeThemeVariant dark;

  const OpenCodeThemeDefinition({
    required this.id,
    required this.name,
    required this.light,
    required this.dark,
  });

  ThemeData toThemeData(bool isDark) {
    final variant = isDark ? dark : light;
    final surface = isDark
        ? _mixColors(variant.background, variant.textStrong, 0.08)
        : _mixColors(variant.background, Colors.white, 0.58);
    final surfaceVariant = isDark
        ? _mixColors(variant.background, variant.textStrong, 0.16)
        : _mixColors(variant.background, Colors.black, 0.05);

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: variant.interactive,
        onPrimary: _contentColorFor(variant.interactive),
        secondary: variant.accent,
        onSecondary: _contentColorFor(variant.accent),
        tertiary: variant.warning,
        onTertiary: _contentColorFor(variant.warning),
        error: variant.error,
        onError: _contentColorFor(variant.error),
        surface: surface,
        onSurface: variant.textStrong,
        surfaceContainerHighest: surfaceVariant,
        onSurfaceVariant: variant.text,
        outline: variant.border,
        outlineVariant: variant.border.withValues(alpha: 0.7),
      ),
      scaffoldBackgroundColor: variant.background,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: variant.textStrong,
        elevation: 2,
      ),
    );
  }

  Color _mixColors(Color a, Color b, double ratio) {
    final clamped = ratio.clamp(0.0, 1.0);
    final inverse = 1.0 - clamped;
    return Color.fromARGB(
      _channelToInt(a.a * inverse + b.a * clamped),
      _channelToInt(a.r * inverse + b.r * clamped),
      _channelToInt(a.g * inverse + b.g * clamped),
      _channelToInt(a.b * inverse + b.b * clamped),
    );
  }

  int _channelToInt(double value) => (value * 255).round().clamp(0, 255);

  Color _contentColorFor(Color background) {
    return background.computeLuminance() > 0.45
        ? const Color(0xFF111111)
        : Colors.white;
  }
}
