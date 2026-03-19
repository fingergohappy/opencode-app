import 'package:json_annotation/json_annotation.dart';

part 'model.g.dart';

enum FollowUpBehavior { auto, manual, disabled }

@JsonSerializable()
class GeneralSettings {
  const GeneralSettings({
    this.showReasoningSummaries = true,
    this.expandShellToolParts = false,
    this.expandEditToolParts = false,
    this.followUpBehavior = FollowUpBehavior.auto,
  });

  factory GeneralSettings.fromJson(Map<String, dynamic> json) =>
      _$GeneralSettingsFromJson(json);

  @JsonKey(defaultValue: true)
  final bool showReasoningSummaries;

  @JsonKey(defaultValue: false)
  final bool expandShellToolParts;

  @JsonKey(defaultValue: false)
  final bool expandEditToolParts;

  @JsonKey(defaultValue: FollowUpBehavior.auto)
  final FollowUpBehavior followUpBehavior;

  GeneralSettings copyWith({
    bool? showReasoningSummaries,
    bool? expandShellToolParts,
    bool? expandEditToolParts,
    FollowUpBehavior? followUpBehavior,
  }) =>
      GeneralSettings(
        showReasoningSummaries:
            showReasoningSummaries ?? this.showReasoningSummaries,
        expandShellToolParts: expandShellToolParts ?? this.expandShellToolParts,
        expandEditToolParts: expandEditToolParts ?? this.expandEditToolParts,
        followUpBehavior: followUpBehavior ?? this.followUpBehavior,
      );

  Map<String, dynamic> toJson() => _$GeneralSettingsToJson(this);
}
