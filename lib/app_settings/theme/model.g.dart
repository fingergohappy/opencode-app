// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThemeSettings _$ThemeSettingsFromJson(Map<String, dynamic> json) =>
    ThemeSettings(
      selectedThemeId: json['selectedThemeId'] as String? ?? 'aura',
      themeMode: _themeModeFromJson(json['themeMode'] as String?),
    );

Map<String, dynamic> _$ThemeSettingsToJson(ThemeSettings instance) =>
    <String, dynamic>{
      'selectedThemeId': instance.selectedThemeId,
      'themeMode': _themeModeToJson(instance.themeMode),
    };
