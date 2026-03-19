// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'OpenCode Themes';

  @override
  String get homeTitle => 'OpenCode Theme Playground';

  @override
  String get themeControlsTitle => 'Theme Controls';

  @override
  String get themeControlsDescription =>
      'Switch the preset theme and choose whether the app uses light, dark, or system mode.';

  @override
  String get presetThemeLabel => 'Preset theme';

  @override
  String get themeModeLabel => 'Theme mode';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChinese => 'Chinese';

  @override
  String get themeModeSystem => 'System';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeDark => 'Dark';

  @override
  String presetChipLabel(Object themeName) {
    return 'Preset: $themeName';
  }

  @override
  String modeChipLabel(Object mode) {
    return 'Mode: $mode';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsGeneralSectionTitle => 'General';

  @override
  String get settingsShowReasoningSummariesTitle => 'Show reasoning summaries';

  @override
  String get settingsShowReasoningSummariesSubtitle =>
      'Display AI reasoning process';

  @override
  String get settingsExpandShellToolPartsTitle => 'Expand shell tool parts';

  @override
  String get settingsExpandShellToolPartsSubtitle =>
      'Auto-expand shell command outputs';

  @override
  String get settingsExpandEditToolPartsTitle => 'Expand edit tool parts';

  @override
  String get settingsExpandEditToolPartsSubtitle =>
      'Auto-expand edit operation details';

  @override
  String get settingsFollowUpBehaviorTitle => 'Follow-up behavior';

  @override
  String get settingsFollowUpBehaviorAuto => 'Automatic';

  @override
  String get settingsFollowUpBehaviorManual => 'Manual confirmation';

  @override
  String get settingsFollowUpBehaviorDisabled => 'Disabled';

  @override
  String get settingsAppearanceSectionTitle => 'Appearance';

  @override
  String get settingsColorSchemeTitle => 'Color scheme';

  @override
  String get settingsThemeTitle => 'Theme';

  @override
  String get settingsUnknownTheme => 'Unknown';

  @override
  String get settingsNotificationsSectionTitle => 'System Notifications';

  @override
  String get settingsNotificationAgentTitle => 'Agent';

  @override
  String get settingsNotificationAgentSubtitle =>
      'Notify when tasks complete or need attention';

  @override
  String get settingsNotificationPermissionsTitle => 'Permissions';

  @override
  String get settingsNotificationPermissionsSubtitle =>
      'Notify when permissions are requested';

  @override
  String get settingsNotificationErrorsTitle => 'Errors';

  @override
  String get settingsNotificationErrorsSubtitle => 'Notify when errors occur';

  @override
  String get settingsSoundSectionTitle => 'Sound';

  @override
  String get settingsEnableSoundTitle => 'Enable sound';

  @override
  String get settingsEnableSoundSubtitle =>
      'Play audio feedback for notifications';

  @override
  String get settingsUpdatesSectionTitle => 'Updates';

  @override
  String get settingsAutoCheckUpdatesTitle => 'Auto-check for updates';

  @override
  String get settingsAutoCheckUpdatesSubtitle =>
      'Automatically check for new versions';

  @override
  String get settingsShowReleaseNotesTitle => 'Show release notes';

  @override
  String get settingsShowReleaseNotesSubtitle =>
      'Display what\'s new after updates';

  @override
  String get counterDescription =>
      'You have pushed the button this many times:';

  @override
  String get incrementTooltip => 'Increment';
}
