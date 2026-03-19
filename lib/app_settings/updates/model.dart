import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

@JsonSerializable()
class UpdateSettings {
  const UpdateSettings({
    this.autoCheckUpdates = true,
    this.showReleaseNotes = true,
  });

  factory UpdateSettings.fromJson(Map<String, dynamic> json) =>
      _$UpdateSettingsFromJson(json);

  @JsonKey(defaultValue: true)
  final bool autoCheckUpdates;

  @JsonKey(defaultValue: true)
  final bool showReleaseNotes;

  UpdateSettings copyWith({bool? autoCheckUpdates, bool? showReleaseNotes}) =>
      UpdateSettings(
        autoCheckUpdates: autoCheckUpdates ?? this.autoCheckUpdates,
        showReleaseNotes: showReleaseNotes ?? this.showReleaseNotes,
      );

  Map<String, dynamic> toJson() => _$UpdateSettingsToJson(this);
}
