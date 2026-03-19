// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'OpenCode 主题';

  @override
  String get homeTitle => 'OpenCode 主题演示';

  @override
  String get themeControlsTitle => '主题控制';

  @override
  String get themeControlsDescription => '切换预设主题，并选择应用使用浅色、深色或跟随系统模式。';

  @override
  String get presetThemeLabel => '预设主题';

  @override
  String get themeModeLabel => '主题模式';

  @override
  String get languageLabel => '语言';

  @override
  String get languageSystem => '跟随系统';

  @override
  String get languageEnglish => '英文';

  @override
  String get languageChinese => '中文';

  @override
  String get themeModeSystem => '跟随系统';

  @override
  String get themeModeLight => '浅色';

  @override
  String get themeModeDark => '深色';

  @override
  String presetChipLabel(Object themeName) {
    return '预设：$themeName';
  }

  @override
  String modeChipLabel(Object mode) {
    return '模式：$mode';
  }

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsGeneralSectionTitle => '通用';

  @override
  String get settingsShowReasoningSummariesTitle => '显示推理摘要';

  @override
  String get settingsShowReasoningSummariesSubtitle => '显示 AI 推理过程';

  @override
  String get settingsExpandShellToolPartsTitle => '展开 shell 工具片段';

  @override
  String get settingsExpandShellToolPartsSubtitle => '自动展开 shell 命令输出';

  @override
  String get settingsExpandEditToolPartsTitle => '展开 edit 工具片段';

  @override
  String get settingsExpandEditToolPartsSubtitle => '自动展开编辑操作详情';

  @override
  String get settingsFollowUpBehaviorTitle => '追问行为';

  @override
  String get settingsFollowUpBehaviorAuto => '自动';

  @override
  String get settingsFollowUpBehaviorManual => '手动确认';

  @override
  String get settingsFollowUpBehaviorDisabled => '禁用';

  @override
  String get settingsAppearanceSectionTitle => '外观';

  @override
  String get settingsColorSchemeTitle => '配色方案';

  @override
  String get settingsThemeTitle => '主题';

  @override
  String get settingsUnknownTheme => '未知';

  @override
  String get settingsNotificationsSectionTitle => '系统通知';

  @override
  String get settingsNotificationAgentTitle => 'Agent';

  @override
  String get settingsNotificationAgentSubtitle => '当任务完成或需要关注时通知';

  @override
  String get settingsNotificationPermissionsTitle => '权限';

  @override
  String get settingsNotificationPermissionsSubtitle => '当需要权限时通知';

  @override
  String get settingsNotificationErrorsTitle => '错误';

  @override
  String get settingsNotificationErrorsSubtitle => '发生错误时通知';

  @override
  String get settingsSoundSectionTitle => '声音';

  @override
  String get settingsEnableSoundTitle => '启用声音';

  @override
  String get settingsEnableSoundSubtitle => '为通知播放音频反馈';

  @override
  String get settingsUpdatesSectionTitle => '更新';

  @override
  String get settingsAutoCheckUpdatesTitle => '自动检查更新';

  @override
  String get settingsAutoCheckUpdatesSubtitle => '自动检查新版本';

  @override
  String get settingsShowReleaseNotesTitle => '显示发行说明';

  @override
  String get settingsShowReleaseNotesSubtitle => '更新后显示新内容';

  @override
  String get counterDescription => '你已经按下按钮这么多次了：';

  @override
  String get incrementTooltip => '增加';
}
