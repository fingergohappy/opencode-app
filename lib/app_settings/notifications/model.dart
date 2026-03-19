import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class NotificationSettings {
  const NotificationSettings({
    this.agentNotifications = true,
    this.permissionNotifications = true,
    this.errorNotifications = true,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);

  @JsonKey(defaultValue: true)
  final bool agentNotifications;

  @JsonKey(defaultValue: true)
  final bool permissionNotifications;

  @JsonKey(defaultValue: true)
  final bool errorNotifications;

  NotificationSettings copyWith({
    bool? agentNotifications,
    bool? permissionNotifications,
    bool? errorNotifications,
  }) =>
      NotificationSettings(
        agentNotifications: agentNotifications ?? this.agentNotifications,
        permissionNotifications:
            permissionNotifications ?? this.permissionNotifications,
        errorNotifications: errorNotifications ?? this.errorNotifications,
      );

  Map<String, dynamic> toJson() => _$NotificationSettingsToJson(this);
}
