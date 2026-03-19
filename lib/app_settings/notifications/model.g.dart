// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationSettings _$NotificationSettingsFromJson(
  Map<String, dynamic> json,
) => NotificationSettings(
  agentNotifications: json['agentNotifications'] as bool? ?? true,
  permissionNotifications: json['permissionNotifications'] as bool? ?? true,
  errorNotifications: json['errorNotifications'] as bool? ?? true,
);

Map<String, dynamic> _$NotificationSettingsToJson(
  NotificationSettings instance,
) => <String, dynamic>{
  'agentNotifications': instance.agentNotifications,
  'permissionNotifications': instance.permissionNotifications,
  'errorNotifications': instance.errorNotifications,
};
