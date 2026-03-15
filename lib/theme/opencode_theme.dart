import 'package:flutter/material.dart';

abstract class OpencodeTheme {
  const OpencodeTheme();

  String get id;
  String get name;
  ThemeData get lightTheme;
  ThemeData get darkTheme;
}

ThemeData buildBaseTheme({
  required Brightness brightness,
  required Color primary,
  required Color secondary,
  required Color tertiary,
  required Color error,
  required Color background,
  required Color surface,
  required Color card,
  required Color border,
  required Color text,
  required Color textMuted,
  required Color textStrong,
  required Color inputFill,
  required Color hover,
  required Color focus,
  required Color selection,
}) {
  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
    ),
  );

  final colorScheme = base.colorScheme.copyWith(
    primary: primary,
    secondary: secondary,
    tertiary: tertiary,
    error: error,
    surface: surface,
    onSurface: text,
    onSurfaceVariant: textMuted,
    outline: border,
    outlineVariant: withOpacity(border, 0.72),
    surfaceTint: primary,
  );

  final textTheme = base.textTheme
      .apply(bodyColor: text, displayColor: textStrong)
      .copyWith(
        bodySmall: base.textTheme.bodySmall?.copyWith(color: textMuted),
        labelSmall: base.textTheme.labelSmall?.copyWith(color: textMuted),
      );

  final radius = BorderRadius.circular(12);

  return base.copyWith(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: background,
    canvasColor: background,
    cardColor: card,
    dividerColor: border,
    focusColor: focus,
    hoverColor: hover,
    splashColor: withOpacity(primary, 0.12),
    highlightColor: withOpacity(primary, 0.08),
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      foregroundColor: textStrong,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      color: card,
      elevation: 0,
      margin: EdgeInsets.zero,
      shadowColor: Colors.black12,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: border),
      ),
    ),
    dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: inputFill,
      hoverColor: hover,
      focusColor: focus,
      hintStyle: TextStyle(color: textMuted),
      labelStyle: TextStyle(color: textMuted),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: focus),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: error),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primary,
      selectionColor: selection,
      selectionHandleColor: primary,
    ),
  );
}

Color withOpacity(Color color, double opacity) {
  return Color.fromARGB(
    (opacity * 255).round().clamp(0, 255),
    (color.r * 255.0).round().clamp(0, 255),
    (color.g * 255.0).round().clamp(0, 255),
    (color.b * 255.0).round().clamp(0, 255),
  );
}
