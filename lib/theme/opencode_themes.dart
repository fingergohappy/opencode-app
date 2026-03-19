import 'opencode_theme.dart';
import 'opencode_theme_presets.dart';

final List<OpencodeTheme> opencodeThemes = <OpencodeTheme>[
  const AuraTheme(),
  const AyuTheme(),
  const CarbonfoxTheme(),
  const CatppuccinTheme(),
  const DraculaTheme(),
  const GruvboxTheme(),
  const MonokaiTheme(),
  const NightowlTheme(),
  const NordTheme(),
  const Oc1Theme(),
  const Oc2Theme(),
  const OnedarkproTheme(),
  const ShadesofpurpleTheme(),
  const SolarizedTheme(),
  const TokyonightTheme(),
  const VesperTheme(),
];

final Map<String, OpencodeTheme> opencodeThemeById = <String, OpencodeTheme>{
  for (final theme in opencodeThemes) theme.id: theme,
};

String get defaultOpencodeThemeId => opencodeThemes.first.id;

bool isValidOpencodeThemeId(String themeId) {
  return opencodeThemeById.containsKey(themeId);
}
