// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneralSettings _$GeneralSettingsFromJson(Map<String, dynamic> json) =>
    GeneralSettings(
      showReasoningSummaries: json['showReasoningSummaries'] as bool? ?? true,
      expandShellToolParts: json['expandShellToolParts'] as bool? ?? false,
      expandEditToolParts: json['expandEditToolParts'] as bool? ?? false,
      followUpBehavior:
          $enumDecodeNullable(
            _$FollowUpBehaviorEnumMap,
            json['followUpBehavior'],
          ) ??
          FollowUpBehavior.auto,
    );

Map<String, dynamic> _$GeneralSettingsToJson(GeneralSettings instance) =>
    <String, dynamic>{
      'showReasoningSummaries': instance.showReasoningSummaries,
      'expandShellToolParts': instance.expandShellToolParts,
      'expandEditToolParts': instance.expandEditToolParts,
      'followUpBehavior': _$FollowUpBehaviorEnumMap[instance.followUpBehavior]!,
    };

const _$FollowUpBehaviorEnumMap = {
  FollowUpBehavior.auto: 'auto',
  FollowUpBehavior.manual: 'manual',
  FollowUpBehavior.disabled: 'disabled',
};
