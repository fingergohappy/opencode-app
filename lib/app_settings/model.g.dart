// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
  theme: ThemeSettings.fromJson(json['theme'] as Map<String, dynamic>),
  locale: LocaleSettings.fromJson(json['locale'] as Map<String, dynamic>),
  general: GeneralSettings.fromJson(json['general'] as Map<String, dynamic>),
  notifications: NotificationSettings.fromJson(
    json['notifications'] as Map<String, dynamic>,
  ),
  sound: SoundSettings.fromJson(json['sound'] as Map<String, dynamic>),
  updates: UpdateSettings.fromJson(json['updates'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'theme': instance.theme,
      'locale': instance.locale,
      'general': instance.general,
      'notifications': instance.notifications,
      'sound': instance.sound,
      'updates': instance.updates,
    };
