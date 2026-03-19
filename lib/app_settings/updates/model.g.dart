// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateSettings _$UpdateSettingsFromJson(Map<String, dynamic> json) =>
    UpdateSettings(
      autoCheckUpdates: json['autoCheckUpdates'] as bool? ?? true,
      showReleaseNotes: json['showReleaseNotes'] as bool? ?? true,
    );

Map<String, dynamic> _$UpdateSettingsToJson(UpdateSettings instance) =>
    <String, dynamic>{
      'autoCheckUpdates': instance.autoCheckUpdates,
      'showReleaseNotes': instance.showReleaseNotes,
    };
