import 'package:flutter/material.dart';

@immutable
class OpenCodeThemeColors extends ThemeExtension<OpenCodeThemeColors> {
  final Color diffAdd;
  final Color diffDelete;
  final Color warning;
  final Color error;
  final Color success;
  final Color info;
  final Color accent;
  final Color interactive;
  final Color border;

  const OpenCodeThemeColors({
    required this.diffAdd,
    required this.diffDelete,
    required this.warning,
    required this.error,
    required this.success,
    required this.info,
    required this.accent,
    required this.interactive,
    required this.border,
  });

  factory OpenCodeThemeColors.fromVariant(OpenCodeThemeVariant variant) {
    return OpenCodeThemeColors(
      diffAdd: variant.diffAdd,
      diffDelete: variant.diffDelete,
      warning: variant.warning,
      error: variant.error,
      success: variant.success,
      info: variant.info,
      accent: variant.accent,
      interactive: variant.interactive,
      border: variant.border,
    );
  }

  @override
  OpenCodeThemeColors copyWith({
    Color? diffAdd,
    Color? diffDelete,
    Color? warning,
    Color? error,
    Color? success,
    Color? info,
    Color? accent,
    Color? interactive,
    Color? border,
  }) {
    return OpenCodeThemeColors(
      diffAdd: diffAdd ?? this.diffAdd,
      diffDelete: diffDelete ?? this.diffDelete,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      success: success ?? this.success,
      info: info ?? this.info,
      accent: accent ?? this.accent,
      interactive: interactive ?? this.interactive,
      border: border ?? this.border,
    );
  }

  @override
  OpenCodeThemeColors lerp(
    covariant ThemeExtension<OpenCodeThemeColors>? other,
    double t,
  ) {
    if (other is! OpenCodeThemeColors) {
      return this;
    }

    return OpenCodeThemeColors(
      diffAdd: Color.lerp(diffAdd, other.diffAdd, t) ?? diffAdd,
      diffDelete: Color.lerp(diffDelete, other.diffDelete, t) ?? diffDelete,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      error: Color.lerp(error, other.error, t) ?? error,
      success: Color.lerp(success, other.success, t) ?? success,
      info: Color.lerp(info, other.info, t) ?? info,
      accent: Color.lerp(accent, other.accent, t) ?? accent,
      interactive: Color.lerp(interactive, other.interactive, t) ?? interactive,
      border: Color.lerp(border, other.border, t) ?? border,
    );
  }
}

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

    final colorScheme = ColorScheme(
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
    );

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      extensions: <ThemeExtension<dynamic>>[
        OpenCodeThemeColors.fromVariant(variant),
      ],
      colorScheme: colorScheme,
      scaffoldBackgroundColor: variant.background,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: variant.textStrong,
        elevation: 2,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.primary.withValues(alpha: 0.38);
            }
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.primary.withValues(alpha: 0.8);
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.primary.withValues(alpha: 0.92);
            }
            return colorScheme.primary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onPrimary.withValues(alpha: 0.38);
            }
            return colorScheme.onPrimary;
          }),
          overlayColor: WidgetStateProperty.all(
            colorScheme.onPrimary.withValues(alpha: 0.08),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.38,
              );
            }
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.primaryContainer.withValues(alpha: 0.9);
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.primaryContainer.withValues(alpha: 0.95);
            }
            return colorScheme.primaryContainer;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.38);
            }
            return colorScheme.onPrimaryContainer;
          }),
          elevation: WidgetStateProperty.all(2),
          shadowColor: WidgetStateProperty.all(colorScheme.shadow),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.38),
              );
            }
            if (states.contains(WidgetState.focused)) {
              return BorderSide(color: colorScheme.primary, width: 2);
            }
            return BorderSide(color: colorScheme.outline);
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.38);
            }
            return colorScheme.primary;
          }),
          overlayColor: WidgetStateProperty.all(
            colorScheme.primary.withValues(alpha: 0.08),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.38);
            }
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.primary.withValues(alpha: 0.7);
            }
            return colorScheme.primary;
          }),
          overlayColor: WidgetStateProperty.all(
            colorScheme.primary.withValues(alpha: 0.08),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        contentTextStyle: TextStyle(
          fontSize: 14,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceVariant,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        margin: EdgeInsets.zero,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor: Colors.transparent,
        selectedTileColor: colorScheme.primary.withValues(alpha: 0.08),
        selectedColor: colorScheme.primary,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 0.5,
        space: 1,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.primary,
        selectionColor: colorScheme.primary.withValues(alpha: 0.3),
        selectionHandleColor: colorScheme.primary,
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
