import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

ThemeMode _themeModeFromJson(String? v) => switch (v) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

String _themeModeToJson(ThemeMode v) => v.name;

@JsonSerializable()
class ThemeSettings {
  const ThemeSettings({required this.selectedThemeId, required this.themeMode});

  factory ThemeSettings.fromJson(Map<String, dynamic> json) =>
      _$ThemeSettingsFromJson(json);

  @JsonKey(defaultValue: 'aura')
  final String selectedThemeId;

  @JsonKey(fromJson: _themeModeFromJson, toJson: _themeModeToJson)
  final ThemeMode themeMode;

  static ThemeSettings get defaults => const ThemeSettings(
        selectedThemeId: 'aura',
        themeMode: ThemeMode.system,
      );

  ThemeSettings copyWith({String? selectedThemeId, ThemeMode? themeMode}) =>
      ThemeSettings(
        selectedThemeId: selectedThemeId ?? this.selectedThemeId,
        themeMode: themeMode ?? this.themeMode,
      );

  Map<String, dynamic> toJson() => _$ThemeSettingsToJson(this);
}
