import 'package:json_annotation/json_annotation.dart';

import 'general/model.dart';
import 'locale/model.dart';
import 'notifications/model.dart';
import 'sound/model.dart';
import 'theme/model.dart';
import 'updates/model.dart';

export 'locale/model.dart';
export 'theme/model.dart';

part 'model.g.dart';

@JsonSerializable()
class AppSettings {
  const AppSettings({
    required this.theme,
    required this.locale,
    required this.general,
    required this.notifications,
    required this.sound,
    required this.updates,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  final ThemeSettings theme;
  final LocaleSettings locale;
  final GeneralSettings general;
  final NotificationSettings notifications;
  final SoundSettings sound;
  final UpdateSettings updates;

  static AppSettings get defaults => AppSettings(
        theme: ThemeSettings.defaults,
        locale: LocaleSettings.defaults,
        general: const GeneralSettings(),
        notifications: const NotificationSettings(),
        sound: const SoundSettings(),
        updates: const UpdateSettings(),
      );

  AppSettings copyWith({
    ThemeSettings? theme,
    LocaleSettings? locale,
    GeneralSettings? general,
    NotificationSettings? notifications,
    SoundSettings? sound,
    UpdateSettings? updates,
  }) =>
      AppSettings(
        theme: theme ?? this.theme,
        locale: locale ?? this.locale,
        general: general ?? this.general,
        notifications: notifications ?? this.notifications,
        sound: sound ?? this.sound,
        updates: updates ?? this.updates,
      );

  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);
}
