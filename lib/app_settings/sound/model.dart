import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class SoundSettings {
  const SoundSettings({this.soundEnabled = true});

  factory SoundSettings.fromJson(Map<String, dynamic> json) =>
      _$SoundSettingsFromJson(json);

  @JsonKey(defaultValue: true)
  final bool soundEnabled;

  SoundSettings copyWith({bool? soundEnabled}) =>
      SoundSettings(soundEnabled: soundEnabled ?? this.soundEnabled);

  Map<String, dynamic> toJson() => _$SoundSettingsToJson(this);
}
