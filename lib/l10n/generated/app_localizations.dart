import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'OpenCode Themes'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'OpenCode Theme Playground'**
  String get homeTitle;

  /// No description provided for @themeControlsTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme Controls'**
  String get themeControlsTitle;

  /// No description provided for @themeControlsDescription.
  ///
  /// In en, this message translates to:
  /// **'Switch the preset theme and choose whether the app uses light, dark, or system mode.'**
  String get themeControlsDescription;

  /// No description provided for @presetThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'Preset theme'**
  String get presetThemeLabel;

  /// No description provided for @themeModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme mode'**
  String get themeModeLabel;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get languageChinese;

  /// No description provided for @themeModeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeModeSystem;

  /// No description provided for @themeModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeModeLight;

  /// No description provided for @themeModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeModeDark;

  /// No description provided for @presetChipLabel.
  ///
  /// In en, this message translates to:
  /// **'Preset: {themeName}'**
  String presetChipLabel(Object themeName);

  /// No description provided for @modeChipLabel.
  ///
  /// In en, this message translates to:
  /// **'Mode: {mode}'**
  String modeChipLabel(Object mode);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsGeneralSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneralSectionTitle;

  /// No description provided for @settingsShowReasoningSummariesTitle.
  ///
  /// In en, this message translates to:
  /// **'Show reasoning summaries'**
  String get settingsShowReasoningSummariesTitle;

  /// No description provided for @settingsShowReasoningSummariesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Display AI reasoning process'**
  String get settingsShowReasoningSummariesSubtitle;

  /// No description provided for @settingsExpandShellToolPartsTitle.
  ///
  /// In en, this message translates to:
  /// **'Expand shell tool parts'**
  String get settingsExpandShellToolPartsTitle;

  /// No description provided for @settingsExpandShellToolPartsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-expand shell command outputs'**
  String get settingsExpandShellToolPartsSubtitle;

  /// No description provided for @settingsExpandEditToolPartsTitle.
  ///
  /// In en, this message translates to:
  /// **'Expand edit tool parts'**
  String get settingsExpandEditToolPartsTitle;

  /// No description provided for @settingsExpandEditToolPartsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-expand edit operation details'**
  String get settingsExpandEditToolPartsSubtitle;

  /// No description provided for @settingsFollowUpBehaviorTitle.
  ///
  /// In en, this message translates to:
  /// **'Follow-up behavior'**
  String get settingsFollowUpBehaviorTitle;

  /// No description provided for @settingsFollowUpBehaviorAuto.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get settingsFollowUpBehaviorAuto;

  /// No description provided for @settingsFollowUpBehaviorManual.
  ///
  /// In en, this message translates to:
  /// **'Manual confirmation'**
  String get settingsFollowUpBehaviorManual;

  /// No description provided for @settingsFollowUpBehaviorDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get settingsFollowUpBehaviorDisabled;

  /// No description provided for @settingsAppearanceSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceSectionTitle;

  /// No description provided for @settingsColorSchemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Color scheme'**
  String get settingsColorSchemeTitle;

  /// No description provided for @settingsThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeTitle;

  /// No description provided for @settingsUnknownTheme.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get settingsUnknownTheme;

  /// No description provided for @settingsNotificationsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'System Notifications'**
  String get settingsNotificationsSectionTitle;

  /// No description provided for @settingsNotificationAgentTitle.
  ///
  /// In en, this message translates to:
  /// **'Agent'**
  String get settingsNotificationAgentTitle;

  /// No description provided for @settingsNotificationAgentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Notify when tasks complete or need attention'**
  String get settingsNotificationAgentSubtitle;

  /// No description provided for @settingsNotificationPermissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get settingsNotificationPermissionsTitle;

  /// No description provided for @settingsNotificationPermissionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Notify when permissions are requested'**
  String get settingsNotificationPermissionsSubtitle;

  /// No description provided for @settingsNotificationErrorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Errors'**
  String get settingsNotificationErrorsTitle;

  /// No description provided for @settingsNotificationErrorsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Notify when errors occur'**
  String get settingsNotificationErrorsSubtitle;

  /// No description provided for @settingsSoundSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get settingsSoundSectionTitle;

  /// No description provided for @settingsEnableSoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable sound'**
  String get settingsEnableSoundTitle;

  /// No description provided for @settingsEnableSoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Play audio feedback for notifications'**
  String get settingsEnableSoundSubtitle;

  /// No description provided for @settingsUpdatesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get settingsUpdatesSectionTitle;

  /// No description provided for @settingsAutoCheckUpdatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-check for updates'**
  String get settingsAutoCheckUpdatesTitle;

  /// No description provided for @settingsAutoCheckUpdatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Automatically check for new versions'**
  String get settingsAutoCheckUpdatesSubtitle;

  /// No description provided for @settingsShowReleaseNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Show release notes'**
  String get settingsShowReleaseNotesTitle;

  /// No description provided for @settingsShowReleaseNotesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Display what\'s new after updates'**
  String get settingsShowReleaseNotesSubtitle;

  /// No description provided for @counterDescription.
  ///
  /// In en, this message translates to:
  /// **'You have pushed the button this many times:'**
  String get counterDescription;

  /// No description provided for @incrementTooltip.
  ///
  /// In en, this message translates to:
  /// **'Increment'**
  String get incrementTooltip;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
