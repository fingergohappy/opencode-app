import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

enum AppLanguage { system, english, chinese }

AppLanguage _appLanguageFromJson(String? v) => switch (v) {
      'english' => AppLanguage.english,
      'chinese' => AppLanguage.chinese,
      _ => AppLanguage.system,
    };

String _appLanguageToJson(AppLanguage v) => v.name;

@JsonSerializable()
class LocaleSettings {
  const LocaleSettings({required this.language});

  factory LocaleSettings.fromJson(Map<String, dynamic> json) =>
      _$LocaleSettingsFromJson(json);

  static const LocaleSettings defaults =
      LocaleSettings(language: AppLanguage.system);

  @JsonKey(fromJson: _appLanguageFromJson, toJson: _appLanguageToJson)
  final AppLanguage language;

  LocaleSettings copyWith({AppLanguage? language}) =>
      LocaleSettings(language: language ?? this.language);

  Map<String, dynamic> toJson() => _$LocaleSettingsToJson(this);
}
