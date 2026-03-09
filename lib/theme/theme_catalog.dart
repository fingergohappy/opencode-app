import 'package:flutter/material.dart';
import 'theme_spec.dart';

const oc2ThemeLight = OpenCodeThemeVariant(
  background: Color(0xFFF8F8F8),
  text: Color(0xFF6F6F6F),
  textStrong: Color(0xFF171717),
  border: Color(0x24000000),
  accent: Color(0xFFDCDE8D),
  success: Color(0xFF12C905),
  warning: Color(0xFFFFDC17),
  error: Color(0xFFFC533A),
  info: Color(0xFFA753AE),
  interactive: Color(0xFF034CFF),
  diffAdd: Color(0xFF9FF29A),
  diffDelete: Color(0xFFFC533A),
);

const oc2ThemeDark = OpenCodeThemeVariant(
  background: Color(0xFF101010),
  text: Color(0xFFF1F1F1),
  textStrong: Color(0xFFFFFFFF),
  border: Color(0x2BFFFFFF),
  accent: Color(0xFFFAB283),
  success: Color(0xFF12C905),
  warning: Color(0xFFFCD53A),
  error: Color(0xFFFC533A),
  info: Color(0xFFEDB2F1),
  interactive: Color(0xFF034CFF),
  diffAdd: Color(0xFFC8FFC4),
  diffDelete: Color(0xFFFC533A),
);

const oc2Theme = OpenCodeThemeDefinition(
  id: 'oc-2',
  name: 'OC-2',
  light: oc2ThemeLight,
  dark: oc2ThemeDark,
);

const oc1ThemeLight = OpenCodeThemeVariant(
  background: Color(0xFFF8F7F7),
  text: Color(0xFF656363),
  textStrong: Color(0xFF211E1E),
  border: Color(0x320B0600),
  accent: Color(0xFFDCDE8D),
  success: Color(0xFF12C905),
  warning: Color(0xFFFFDC17),
  error: Color(0xFFFC533A),
  info: Color(0xFFA753AE),
  interactive: Color(0xFF034CFF),
  diffAdd: Color(0xFF9FF29A),
  diffDelete: Color(0xFFFC533A),
);

const oc1ThemeDark = OpenCodeThemeVariant(
  background: Color(0xFF131010),
  text: Color(0xFFE4E4E7),
  textStrong: Color(0xFFFFFFFF),
  border: Color(0xFF2A2A2E),
  accent: Color(0xFFFAB283),
  success: Color(0xFF12C905),
  warning: Color(0xFFFCD53A),
  error: Color(0xFFFC533A),
  info: Color(0xFFEDB2F1),
  interactive: Color(0xFF034CFF),
  diffAdd: Color(0xFFC8FFC4),
  diffDelete: Color(0xFFFC533A),
);

const oc1Theme = OpenCodeThemeDefinition(
  id: 'oc-1',
  name: 'OC-1',
  light: oc1ThemeLight,
  dark: oc1ThemeDark,
);

const auraThemeLight = OpenCodeThemeVariant(
  background: Color(0xFFF5F0FF),
  text: Color(0xFF2D2640),
  textStrong: Color(0xFF15101F),
  border: Color(0xFFB5A6D4),
  accent: Color(0xFFA277FF),
  success: Color(0xFF40BF7A),
  warning: Color(0xFFD9A24A),
  error: Color(0xFFD94F4F),
  info: Color(0xFF5BB8D9),
  interactive: Color(0xFFA277FF),
  diffAdd: Color(0xFFB3E6CC),
  diffDelete: Color(0xFFF5B3B3),
);

const auraThemeDark = OpenCodeThemeVariant(
  background: Color(0xFF15141B),
  text: Color(0xFFEDECEE),
  textStrong: Color(0xFFFFFFFF),
  border: Color(0xFF433F5A),
  accent: Color(0xFFA277FF),
  success: Color(0xFF61FFCA),
  warning: Color(0xFFFFCA85),
  error: Color(0xFFFF6767),
  info: Color(0xFF82E2FF),
  interactive: Color(0xFFA277FF),
  diffAdd: Color(0xFF61FFCA),
  diffDelete: Color(0xFFFF6767),
);

const auraTheme = OpenCodeThemeDefinition(
  id: 'aura',
  name: 'Aura',
  light: auraThemeLight,
  dark: auraThemeDark,
);

const ayuThemeLight = OpenCodeThemeVariant(
  background: Color(0xFFFDFAF4),
  text: Color(0xFF4F5964),
  textStrong: Color(0xFF1B232B),
  border: Color(0xFFBFB3A3),
  accent: Color(0xFF4AA8C8),
  success: Color(0xFF5FB978),
  warning: Color(0xFFEA9F41),
  error: Color(0xFFE6656A),
  info: Color(0xFF2F9BCE),
  interactive: Color(0xFF4AA8C8),
  diffAdd: Color(0xFFB1D780),
  diffDelete: Color(0xFFE6656A),
);

const ayuThemeDark = OpenCodeThemeVariant(
  background: Color(0xFF0F1419),
  text: Color(0xFFD6DAE0),
  textStrong: Color(0xFFFBFBFD),
  border: Color(0xFF475367),
  accent: Color(0xFF3FB7E3),
  success: Color(0xFF78D05C),
  warning: Color(0xFFE4A75C),
  error: Color(0xFFF58572),
  info: Color(0xFF66C6F1),
  interactive: Color(0xFF3FB7E3),
  diffAdd: Color(0xFF59C57C),
  diffDelete: Color(0xFFF58572),
);

const ayuTheme = OpenCodeThemeDefinition(
  id: 'ayu',
  name: 'Ayu',
  light: ayuThemeLight,
  dark: ayuThemeDark,
);

const carbonfoxThemeLight = OpenCodeThemeVariant(
  background: Color(0xFFFFFFFF),
  text: Color(0xFF161616),
  textStrong: Color(0xFF000000),
  border: Color(0xFFE8E8E8),
  accent: Color(0xFF0072C3),
  success: Color(0xFF198038),
  warning: Color(0xFFF1C21B),
  error: Color(0xFFDA1E28),
  info: Color(0xFF0043CE),
  interactive: Color(0xFF0F62FE),
  diffAdd: Color(0xFF198038),
  diffDelete: Color(0xFFDA1E28),
);

const carbonfoxThemeDark = OpenCodeThemeVariant(
  background: Color(0xFF161616),
  text: Color(0xFFF2F4F8),
  textStrong: Color(0xFFFFFFFF),
  border: Color(0xFF525252),
  accent: Color(0xFF33B1FF),
  success: Color(0xFF42BE65),
  warning: Color(0xFFF1C21B),
  error: Color(0xFFFF8389),
  info: Color(0xFF78A9FF),
  interactive: Color(0xFF4589FF),
  diffAdd: Color(0xFF42BE65),
  diffDelete: Color(0xFFFF8389),
);

const carbonfoxTheme = OpenCodeThemeDefinition(
  id: 'carbonfox',
  name: 'Carbonfox',
  light: carbonfoxThemeLight,
  dark: carbonfoxThemeDark,
);

const catppuccinThemeLight = OpenCodeThemeVariant(
  background: Color(0xFFF5E0DC),
  text: Color(0xFF4C4F69),
  textStrong: Color(0xFF1F1F2A),
  border: Color(0xFFBCA6B2),
  accent: Color(0xFF7287FD),
  success: Color(0xFF40A02B),
  warning: Color(0xFFDF8E1D),
  error: Color(0xFFD20F39),
  info: Color(0xFF04A5E5),
  interactive: Color(0xFF7287FD),
  diffAdd: Color(0xFFA6D189),
  diffDelete: Color(0xFFE78284),
);

const catppuccinThemeDark = OpenCodeThemeVariant(
  background: Color(0xFF1E1E2E),
  text: Color(0xFFCDD6F4),
  textStrong: Color(0xFFF4F2FF),
  border: Color(0xFF4A4763),
  accent: Color(0xFFB4BEFE),
  success: Color(0xFFA6D189),
  warning: Color(0xFFF4B8E4),
  error: Color(0xFFF38BA8),
  info: Color(0xFF89DCEB),
  interactive: Color(0xFFB4BEFE),
  diffAdd: Color(0xFF94E2D5),
  diffDelete: Color(0xFFF38BA8),
);

const catppuccinTheme = OpenCodeThemeDefinition(
  id: 'catppuccin',
  name: 'Catppuccin',
  light: catppuccinThemeLight,
  dark: catppuccinThemeDark,
);

const draculaThemeLight = OpenCodeThemeVariant(
  background: Color(0xFFF8F8F2),
  text: Color(0xFF1F1F2F),
  textStrong: Color(0xFF05040C),
  border: Color(0xFFC4C6BA),
  accent: Color(0xFF7C6BF5),
  success: Color(0xFF2FBF71),
  warning: Color(0xFFF7A14D),
  error: Color(0xFFD9536F),
  info: Color(0xFF1D7FC5),
  interactive: Color(0xFF7C6BF5),
  diffAdd: Color(0xFF9FE3B3),
  diffDelete: Color(0xFFF8A1B8),
);

const draculaThemeDark = OpenCodeThemeVariant(
  background: Color(0xFF14151F),
  text: Color(0xFFF8F8F2),
  textStrong: Color(0xFFFFFFFF),
  border: Color(0xFF3F415A),
  accent: Color(0xFFBD93F9),
  success: Color(0xFF50FA7B),
  warning: Color(0xFFFFB86C),
  error: Color(0xFFFF5555),
  info: Color(0xFF8BE9FD),
  interactive: Color(0xFFBD93F9),
  diffAdd: Color(0xFF2FB27D),
  diffDelete: Color(0xFFFF6B81),
);

const draculaTheme = OpenCodeThemeDefinition(
  id: 'dracula',
  name: 'Dracula',
  light: draculaThemeLight,
  dark: draculaThemeDark,
);

const gruvboxThemeLight = OpenCodeThemeVariant(
  background: Color(0xFFFBF1C7),
  text: Color(0xFF3C3836),
  textStrong: Color(0xFF282828),
  border: Color(0xFFBDAE93),
  accent: Color(0xFF076678),
  success: Color(0xFF79740E),
  warning: Color(0xFFB57614),
  error: Color(0xFF9D0006),
  info: Color(0xFF8F3F71),
  interactive: Color(0xFF076678),
  diffAdd: Color(0xFF79740E),
  diffDelete: Color(0xFF9D0006),
);

const gruvboxThemeDark = OpenCodeThemeVariant(
  background: Color(0xFF282828),
  text: Color(0xFFEBDBB2),
  textStrong: Color(0xFFFBF1C7),
  border: Color(0xFF665C54),
  accent: Color(0xFF83A598),
  success: Color(0xFFB8BB26),
  warning: Color(0xFFFABD2F),
  error: Color(0xFFFB4934),
  info: Color(0xFFD3869B),
  interactive: Color(0xFF83A598),
  diffAdd: Color(0xFFB8BB26),
  diffDelete: Color(0xFFFB4934),
);

const gruvboxTheme = OpenCodeThemeDefinition(
  id: 'gruvbox',
  name: 'Gruvbox',
  light: gruvboxThemeLight,
  dark: gruvboxThemeDark,
);

const monokaiThemeLight = OpenCodeThemeVariant(
  background: Color(0xFFFDF8EC),
  text: Color(0xFF292318),
  textStrong: Color(0xFF1C150C),
  border: Color(0xFFC7B9A5),
  accent: Color(0xFFBF7BFF),
  success: Color(0xFF4FB54B),
  warning: Color(0xFFF1A948),
  error: Color(0xFFE54B4B),
  info: Color(0xFF2D9AD7),
  interactive: Color(0xFFBF7BFF),
  diffAdd: Color(0xFFBFE7A3),
  diffDelete: Color(0xFFF6A3AE),
);

const monokaiThemeDark = OpenCodeThemeVariant(
  background: Color(0xFF23241E),
  text: Color(0xFFF8F8F2),
  textStrong: Color(0xFFFFFFFF),
  border: Color(0xFF494A3A),
  accent: Color(0xFFAE81FF),
  success: Color(0xFFA6E22E),
  warning: Color(0xFFFD971F),
  error: Color(0xFFF92672),
  info: Color(0xFF66D9EF),
  interactive: Color(0xFFAE81FF),
  diffAdd: Color(0xFF4D7F2A),
  diffDelete: Color(0xFFF4477C),
);

const monokaiTheme = OpenCodeThemeDefinition(
  id: 'monokai',
  name: 'Monokai',
  light: monokaiThemeLight,
  dark: monokaiThemeDark,
);

const nightowlThemeLight = OpenCodeThemeVariant(
  background: Color(0xFFFBFBFB),
  text: Color(0xFF403F53),
  textStrong: Color(0xFF1A1A1A),
  border: Color(0xFFC0C0C0),
  accent: Color(0xFF4876D6),
  success: Color(0xFF2AA298),
  warning: Color(0xFFC96765),
  error: Color(0xFFDE3D3B),
  info: Color(0xFF4876D6),
  interactive: Color(0xFF4876D6),
  diffAdd: Color(0xFF2AA298),
  diffDelete: Color(0xFFDE3D3B),
);

const nightowlThemeDark = OpenCodeThemeVariant(
  background: Color(0xFF011627),
  text: Color(0xFFD6DEEB),
  textStrong: Color(0xFFFFFFFF),
  border: Color(0xFF3A5A75),
  accent: Color(0xFF82AAFF),
  success: Color(0xFFC5E478),
  warning: Color(0xFFECC48D),
  error: Color(0xFFEF5350),
  info: Color(0xFF82AAFF),
  interactive: Color(0xFF82AAFF),
  diffAdd: Color(0xFFC5E478),
  diffDelete: Color(0xFFEF5350),
);

const nightowlTheme = OpenCodeThemeDefinition(
  id: 'nightowl',
  name: 'Night Owl',
  light: nightowlThemeLight,
  dark: nightowlThemeDark,
);

const nordThemeLight = OpenCodeThemeVariant(
  background: Color(0xFFECEFF4),
  text: Color(0xFF2E3440),
  textStrong: Color(0xFF1F2530),
  border: Color(0xFFAFB7CB),
  accent: Color(0xFF5E81AC),
  success: Color(0xFF8FBCBB),
  warning: Color(0xFFD08770),
  error: Color(0xFFBF616A),
  info: Color(0xFF81A1C1),
  interactive: Color(0xFF5E81AC),
  diffAdd: Color(0xFFA3BE8C),
  diffDelete: Color(0xFFBF616A),
);

const nordThemeDark = OpenCodeThemeVariant(
  background: Color(0xFF1F2430),
  text: Color(0xFFE5E9F0),
  textStrong: Color(0xFFF8FAFC),
  border: Color(0xFF4A5163),
  accent: Color(0xFF88C0D0),
  success: Color(0xFFA3BE8C),
  warning: Color(0xFFD08770),
  error: Color(0xFFBF616A),
  info: Color(0xFF81A1C1),
  interactive: Color(0xFF88C0D0),
  diffAdd: Color(0xFF81A1C1),
  diffDelete: Color(0xFFBF616A),
);

const nordTheme = OpenCodeThemeDefinition(
  id: 'nord',
  name: 'Nord',
  light: nordThemeLight,
  dark: nordThemeDark,
);

const onedarkproThemeLight = OpenCodeThemeVariant(
  background: Color(0xFFF5F6F8),
  text: Color(0xFF2B303B),
  textStrong: Color(0xFF0E1118),
  border: Color(0xFFB5BCCD),
  accent: Color(0xFF528BFF),
  success: Color(0xFF4FA66D),
  warning: Color(0xFFD19A66),
  error: Color(0xFFE06C75),
  info: Color(0xFF61AFEF),
  interactive: Color(0xFF528BFF),
  diffAdd: Color(0xFFC2EBCF),
  diffDelete: Color(0xFFF7C1C5),
);

const onedarkproThemeDark = OpenCodeThemeVariant(
  background: Color(0xFF1E222A),
  text: Color(0xFFABB2BF),
  textStrong: Color(0xFFF6F7FB),
  border: Color(0xFF4A5164),
  accent: Color(0xFF61AFEF),
  success: Color(0xFF98C379),
  warning: Color(0xFFE5C07B),
  error: Color(0xFFE06C75),
  info: Color(0xFF56B6C2),
  interactive: Color(0xFF61AFEF),
  diffAdd: Color(0xFF4B815A),
  diffDelete: Color(0xFFB2555F),
);

const onedarkproTheme = OpenCodeThemeDefinition(
  id: 'onedarkpro',
  name: 'One Dark Pro',
  light: onedarkproThemeLight,
  dark: onedarkproThemeDark,
);

const shadesOfPurpleThemeLight = OpenCodeThemeVariant(
  background: Color(0xFFF7EBFF),
  text: Color(0xFF3B2C59),
  textStrong: Color(0xFF1C1033),
  border: Color(0xFFBAA4D5),
  accent: Color(0xFF7A5AF8),
  success: Color(0xFF3DD598),
  warning: Color(0xFFF7C948),
  error: Color(0xFFFF6BD5),
  info: Color(0xFF62D4FF),
  interactive: Color(0xFF7A5AF8),
  diffAdd: Color(0xFFC8F8DA),
  diffDelete: Color(0xFFFFC3EF),
);

const shadesOfPurpleThemeDark = OpenCodeThemeVariant(
  background: Color(0xFF1A102B),
  text: Color(0xFFF5F0FF),
  textStrong: Color(0xFFFFFFFF),
  border: Color(0xFF4D3A73),
  accent: Color(0xFFC792FF),
  success: Color(0xFF7BE0B0),
  warning: Color(0xFFFFD580),
  error: Color(0xFFFF7AC6),
  info: Color(0xFF7DD4FF),
  interactive: Color(0xFFC792FF),
  diffAdd: Color(0xFF53C39F),
  diffDelete: Color(0xFFD85AA0),
);

const shadesOfPurpleTheme = OpenCodeThemeDefinition(
  id: 'shadesofpurple',
  name: 'Shades of Purple',
  light: shadesOfPurpleThemeLight,
  dark: shadesOfPurpleThemeDark,
);

const solarizedThemeLight = OpenCodeThemeVariant(
  background: Color(0xFFFDF6E3),
  text: Color(0xFF586E75),
  textStrong: Color(0xFF073642),
  border: Color(0xFFBCB5A0),
  accent: Color(0xFF268BD2),
  success: Color(0xFF859900),
  warning: Color(0xFFB58900),
  error: Color(0xFFDC322F),
  info: Color(0xFF2AA198),
  interactive: Color(0xFF268BD2),
  diffAdd: Color(0xFFC6DC7A),
  diffDelete: Color(0xFFF2A1A1),
);

const solarizedThemeDark = OpenCodeThemeVariant(
  background: Color(0xFF001F27),
  text: Color(0xFF93A1A1),
  textStrong: Color(0xFFFDF6E3),
  border: Color(0xFF31505B),
  accent: Color(0xFF6C71C4),
  success: Color(0xFF859900),
  warning: Color(0xFFB58900),
  error: Color(0xFFDC322F),
  info: Color(0xFF2AA198),
  interactive: Color(0xFF6C71C4),
  diffAdd: Color(0xFF4C7654),
  diffDelete: Color(0xFFC34B4B),
);

const solarizedTheme = OpenCodeThemeDefinition(
  id: 'solarized',
  name: 'Solarized',
  light: solarizedThemeLight,
  dark: solarizedThemeDark,
);

const tokyonightThemeLight = OpenCodeThemeVariant(
  background: Color(0xFFE1E2E7),
  text: Color(0xFF273153),
  textStrong: Color(0xFF1C2544),
  border: Color(0xFFA7ABBB),
  accent: Color(0xFF2E7DE9),
  success: Color(0xFF587539),
  warning: Color(0xFF8C6C3E),
  error: Color(0xFFC94060),
  info: Color(0xFF007197),
  interactive: Color(0xFF2E7DE9),
  diffAdd: Color(0xFF4F8F7B),
  diffDelete: Color(0xFFD05F7C),
);

const tokyonightThemeDark = OpenCodeThemeVariant(
  background: Color(0xFF0F111A),
  text: Color(0xFFC0CAF5),
  textStrong: Color(0xFFEAEAFF),
  border: Color(0xFF3A3E57),
  accent: Color(0xFF7AA2F7),
  success: Color(0xFF9ECE6A),
  warning: Color(0xFFE0AF68),
  error: Color(0xFFF7768E),
  info: Color(0xFF7DCFFF),
  interactive: Color(0xFF7AA2F7),
  diffAdd: Color(0xFF41A6B5),
  diffDelete: Color(0xFFC34043),
);

const tokyonightTheme = OpenCodeThemeDefinition(
  id: 'tokyonight',
  name: 'Tokyonight',
  light: tokyonightThemeLight,
  dark: tokyonightThemeDark,
);

const vesperThemeLight = OpenCodeThemeVariant(
  background: Color(0xFFFFFFFF),
  text: Color(0xFF101010),
  textStrong: Color(0xFF000000),
  border: Color(0xFFD0D0D0),
  accent: Color(0xFFFFC799),
  success: Color(0xFF99FFE4),
  warning: Color(0xFFFFC799),
  error: Color(0xFFFF8080),
  info: Color(0xFFFFC799),
  interactive: Color(0xFFFFC799),
  diffAdd: Color(0xFF99FFE4),
  diffDelete: Color(0xFFFF8080),
);

const vesperThemeDark = OpenCodeThemeVariant(
  background: Color(0xFF101010),
  text: Color(0xFFFFFFFF),
  textStrong: Color(0xFFFFFFFF),
  border: Color(0xFF282828),
  accent: Color(0xFFFFC799),
  success: Color(0xFF99FFE4),
  warning: Color(0xFFFFC799),
  error: Color(0xFFFF8080),
  info: Color(0xFFFFC799),
  interactive: Color(0xFFFFC799),
  diffAdd: Color(0xFF99FFE4),
  diffDelete: Color(0xFFFF8080),
);

const vesperTheme = OpenCodeThemeDefinition(
  id: 'vesper',
  name: 'Vesper',
  light: vesperThemeLight,
  dark: vesperThemeDark,
);

class OpenCodeThemeCatalog {
  static const themes = [
    oc1Theme,
    oc2Theme,
    auraTheme,
    ayuTheme,
    carbonfoxTheme,
    catppuccinTheme,
    draculaTheme,
    gruvboxTheme,
    monokaiTheme,
    nightowlTheme,
    nordTheme,
    onedarkproTheme,
    shadesOfPurpleTheme,
    solarizedTheme,
    tokyonightTheme,
    vesperTheme,
  ];
  static const defaultTheme = oc1Theme;

  static OpenCodeThemeDefinition byId(String id) {
    return themes.firstWhere((t) => t.id == id, orElse: () => defaultTheme);
  }
}
