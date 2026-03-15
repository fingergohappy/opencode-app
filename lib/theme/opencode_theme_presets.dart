import 'package:flutter/material.dart';

import 'opencode_theme.dart';

class AuraTheme extends OpencodeTheme {
  const AuraTheme();

  @override
  String get id => 'aura';

  @override
  String get name => 'Aura';

  @override
  ThemeData get lightTheme => buildBaseTheme(
      brightness: Brightness.light,
      primary: const Color(0xFFA277FF),
      secondary: const Color(0xFF5BB8D9),
      tertiary: const Color(0xFFD9A24A),
      error: const Color(0xFFD94F4F),
      background: const Color(0xFFF5F0FF),
      surface: const Color(0xFFFAF7FF),
      card: const Color(0xFFF5F0FF),
      border: const Color(0xFFE0D6F2),
      text: const Color(0xFF2D2640),
      textMuted: const Color(0xFF5C5270),
      textStrong: const Color(0xFF15101F),
      inputFill: const Color(0xFFF5F0FF),
      hover: const Color(0xFFF5F0FF),
      focus: const Color(0xFF9480BC),
      selection: const Color(0xFFA277FF),
    );

  @override
  ThemeData get darkTheme => buildBaseTheme(
      brightness: Brightness.dark,
      primary: const Color(0xFFA277FF),
      secondary: const Color(0xFF82E2FF),
      tertiary: const Color(0xFFFFCA85),
      error: const Color(0xFFFF6767),
      background: const Color(0xFF15141B),
      surface: const Color(0xFF121118),
      card: const Color(0xFF15141B),
      border: const Color(0xFF2D2B38),
      text: const Color(0xFFEDECEE),
      textMuted: const Color(0xFF6D6D6D),
      textStrong: const Color(0xFFFFFFFF),
      inputFill: const Color(0xFF15141B),
      hover: const Color(0xFF15141B),
      focus: const Color(0xFF58527B),
      selection: const Color(0xFFA277FF),
    );
}

class AyuTheme extends OpencodeTheme {
  const AyuTheme();

  @override
  String get id => 'ayu';

  @override
  String get name => 'Ayu';

  @override
  ThemeData get lightTheme => buildBaseTheme(
      brightness: Brightness.light,
      primary: const Color(0xFF4AA8C8),
      secondary: const Color(0xFF2F9BCE),
      tertiary: const Color(0xFFEA9F41),
      error: const Color(0xFFE6656A),
      background: const Color(0xFFFDFAF4),
      surface: const Color(0xFFFBF8F2),
      card: const Color(0xFFFDFAF4),
      border: const Color(0xFFE6DDCF),
      text: const Color(0xFF4F5964),
      textMuted: const Color(0xFF77818D),
      textStrong: const Color(0xFF1B232B),
      inputFill: const Color(0xFFFDFAF4),
      hover: const Color(0xFFFDFAF4),
      focus: const Color(0xFF9E9383),
      selection: const Color(0xFF4AA8C8),
    );

  @override
  ThemeData get darkTheme => buildBaseTheme(
      brightness: Brightness.dark,
      primary: const Color(0xFF3FB7E3),
      secondary: const Color(0xFF66C6F1),
      tertiary: const Color(0xFFE4A75C),
      error: const Color(0xFFF58572),
      background: const Color(0xFF0F1419),
      surface: const Color(0xFF0B1015),
      card: const Color(0xFF0F1419),
      border: const Color(0xFF2B3440),
      text: const Color(0xFFD6DAE0),
      textMuted: const Color(0xFFA3ADBA),
      textStrong: const Color(0xFFFBFBFD),
      inputFill: const Color(0xFF0F1419),
      hover: const Color(0xFF0F1419),
      focus: const Color(0xFF687795),
      selection: const Color(0xFF3FB7E3),
    );
}

class CarbonfoxTheme extends OpencodeTheme {
  const CarbonfoxTheme();

  @override
  String get id => 'carbonfox';

  @override
  String get name => 'Carbonfox';

  @override
  ThemeData get lightTheme => buildBaseTheme(
      brightness: Brightness.light,
      primary: const Color(0xFF0072C3),
      secondary: const Color(0xFF0043CE),
      tertiary: const Color(0xFFF1C21B),
      error: const Color(0xFFDA1E28),
      background: const Color(0xFFFFFFFF),
      surface: const Color(0xFFE8E8E8),
      card: const Color(0xFFFFFFFF),
      border: const Color(0xFF8E8E8E),
      text: const Color(0xFF161616),
      textMuted: const Color(0xFF525252),
      textStrong: const Color(0xFF000000),
      inputFill: const Color(0xFF8E8E8E),
      hover: const Color(0xFF8E8E8E),
      focus: const Color(0xFF0F62FE),
      selection: const Color(0xFF0F62FE),
    );

  @override
  ThemeData get darkTheme => buildBaseTheme(
      brightness: Brightness.dark,
      primary: const Color(0xFF33B1FF),
      secondary: const Color(0xFF78A9FF),
      tertiary: const Color(0xFFF1C21B),
      error: const Color(0xFFFF8389),
      background: const Color(0xFF161616),
      surface: const Color(0xFF0D0D0D),
      card: const Color(0xFF262626),
      border: const Color(0xFF393939),
      text: const Color(0xFFF2F4F8),
      textMuted: const Color(0xFF8D8D8D),
      textStrong: const Color(0xFFFFFFFF),
      inputFill: const Color(0xFF262626),
      hover: const Color(0xFF262626),
      focus: const Color(0xFF4589FF),
      selection: const Color(0xFF4589FF),
    );
}

class CatppuccinTheme extends OpencodeTheme {
  const CatppuccinTheme();

  @override
  String get id => 'catppuccin';

  @override
  String get name => 'Catppuccin';

  @override
  ThemeData get lightTheme => buildBaseTheme(
      brightness: Brightness.light,
      primary: const Color(0xFF7287FD),
      secondary: const Color(0xFF04A5E5),
      tertiary: const Color(0xFFDF8E1D),
      error: const Color(0xFFD20F39),
      background: const Color(0xFFF5E0DC),
      surface: const Color(0xFFF9E8E4),
      card: const Color(0xFFF5E0DC),
      border: const Color(0xFFE0CFD3),
      text: const Color(0xFF4C4F69),
      textMuted: const Color(0xFF6C6F85),
      textStrong: const Color(0xFF1F1F2A),
      inputFill: const Color(0xFFF5E0DC),
      hover: const Color(0xFFF5E0DC),
      focus: const Color(0xFF9A8894),
      selection: const Color(0xFF7287FD),
    );

  @override
  ThemeData get darkTheme => buildBaseTheme(
      brightness: Brightness.dark,
      primary: const Color(0xFFB4BEFE),
      secondary: const Color(0xFF89DCEB),
      tertiary: const Color(0xFFF4B8E4),
      error: const Color(0xFFF38BA8),
      background: const Color(0xFF1E1E2E),
      surface: const Color(0xFF1C1C29),
      card: const Color(0xFF1E1E2E),
      border: const Color(0xFF35324A),
      text: const Color(0xFFCDD6F4),
      textMuted: const Color(0xFFA6ADC8),
      textStrong: const Color(0xFFF4F2FF),
      inputFill: const Color(0xFF1E1E2E),
      hover: const Color(0xFF1E1E2E),
      focus: const Color(0xFF625F8A),
      selection: const Color(0xFFB4BEFE),
    );
}

class DraculaTheme extends OpencodeTheme {
  const DraculaTheme();

  @override
  String get id => 'dracula';

  @override
  String get name => 'Dracula';

  @override
  ThemeData get lightTheme => buildBaseTheme(
      brightness: Brightness.light,
      primary: const Color(0xFF7C6BF5),
      secondary: const Color(0xFF1D7FC5),
      tertiary: const Color(0xFFF7A14D),
      error: const Color(0xFFD9536F),
      background: const Color(0xFFF8F8F2),
      surface: const Color(0xFFF6F6F1),
      card: const Color(0xFFF8F8F2),
      border: const Color(0xFFE2E3DA),
      text: const Color(0xFF1F1F2F),
      textMuted: const Color(0xFF52526B),
      textStrong: const Color(0xFF05040C),
      inputFill: const Color(0xFFF8F8F2),
      hover: const Color(0xFFF8F8F2),
      focus: const Color(0xFF979A90),
      selection: const Color(0xFF7C6BF5),
    );

  @override
  ThemeData get darkTheme => buildBaseTheme(
      brightness: Brightness.dark,
      primary: const Color(0xFFBD93F9),
      secondary: const Color(0xFF8BE9FD),
      tertiary: const Color(0xFFFFB86C),
      error: const Color(0xFFFF5555),
      background: const Color(0xFF14151F),
      surface: const Color(0xFF161722),
      card: const Color(0xFF1D1E28),
      border: const Color(0xFF2D2F3C),
      text: const Color(0xFFF8F8F2),
      textMuted: const Color(0xFFB6B9E4),
      textStrong: const Color(0xFFFFFFFF),
      inputFill: const Color(0xFF1D1E28),
      hover: const Color(0xFF1D1E28),
      focus: const Color(0xFF55587F),
      selection: const Color(0xFFBD93F9),
    );
}

class GruvboxTheme extends OpencodeTheme {
  const GruvboxTheme();

  @override
  String get id => 'gruvbox';

  @override
  String get name => 'Gruvbox';

  @override
  ThemeData get lightTheme => buildBaseTheme(
      brightness: Brightness.light,
      primary: const Color(0xFF076678),
      secondary: const Color(0xFF8F3F71),
      tertiary: const Color(0xFFB57614),
      error: const Color(0xFF9D0006),
      background: const Color(0xFFFBF1C7),
      surface: const Color(0xFFF9F5D7),
      card: const Color(0xFFFBF1C7),
      border: const Color(0xFFD5C4A1),
      text: const Color(0xFF3C3836),
      textMuted: const Color(0xFF7C6F64),
      textStrong: const Color(0xFF282828),
      inputFill: const Color(0xFFFBF1C7),
      hover: const Color(0xFFFBF1C7),
      focus: const Color(0xFF928374),
      selection: const Color(0xFF076678),
    );

  @override
  ThemeData get darkTheme => buildBaseTheme(
      brightness: Brightness.dark,
      primary: const Color(0xFF83A598),
      secondary: const Color(0xFFD3869B),
      tertiary: const Color(0xFFFABD2F),
      error: const Color(0xFFFB4934),
      background: const Color(0xFF282828),
      surface: const Color(0xFF1D2021),
      card: const Color(0xFF282828),
      border: const Color(0xFF504945),
      text: const Color(0xFFEBDBB2),
      textMuted: const Color(0xFFA89984),
      textStrong: const Color(0xFFFBF1C7),
      inputFill: const Color(0xFF282828),
      hover: const Color(0xFF282828),
      focus: const Color(0xFF928374),
      selection: const Color(0xFF83A598),
    );
}

class MonokaiTheme extends OpencodeTheme {
  const MonokaiTheme();

  @override
  String get id => 'monokai';

  @override
  String get name => 'Monokai';

  @override
  ThemeData get lightTheme => buildBaseTheme(
      brightness: Brightness.light,
      primary: const Color(0xFFBF7BFF),
      secondary: const Color(0xFF2D9AD7),
      tertiary: const Color(0xFFF1A948),
      error: const Color(0xFFE54B4B),
      background: const Color(0xFFFDF8EC),
      surface: const Color(0xFFFBF5E8),
      card: const Color(0xFFFDF8EC),
      border: const Color(0xFFE9E0CF),
      text: const Color(0xFF292318),
      textMuted: const Color(0xFF6D5C40),
      textStrong: const Color(0xFF1C150C),
      inputFill: const Color(0xFFFDF8EC),
      hover: const Color(0xFFFDF8EC),
      focus: const Color(0xFFA49781),
      selection: const Color(0xFFBF7BFF),
    );

  @override
  ThemeData get darkTheme => buildBaseTheme(
      brightness: Brightness.dark,
      primary: const Color(0xFFAE81FF),
      secondary: const Color(0xFF66D9EF),
      tertiary: const Color(0xFFFD971F),
      error: const Color(0xFFF92672),
      background: const Color(0xFF23241E),
      surface: const Color(0xFF25261F),
      card: const Color(0xFF272822),
      border: const Color(0xFF343528),
      text: const Color(0xFFF8F8F2),
      textMuted: const Color(0xFFC5C5C0),
      textStrong: const Color(0xFFFFFFFF),
      inputFill: const Color(0xFF272822),
      hover: const Color(0xFF272822),
      focus: const Color(0xFF60624B),
      selection: const Color(0xFFAE81FF),
    );
}

class NightowlTheme extends OpencodeTheme {
  const NightowlTheme();

  @override
  String get id => 'nightowl';

  @override
  String get name => 'Night Owl';

  @override
  ThemeData get lightTheme => buildBaseTheme(
      brightness: Brightness.light,
      primary: const Color(0xFF4876D6),
      secondary: const Color(0xFF4876D6),
      tertiary: const Color(0xFFC96765),
      error: const Color(0xFFDE3D3B),
      background: const Color(0xFFFBFBFB),
      surface: const Color(0xFFFFFFFF),
      card: const Color(0xFFF0F0F0),
      border: const Color(0xFFD9D9D9),
      text: const Color(0xFF403F53),
      textMuted: const Color(0xFF7A8181),
      textStrong: const Color(0xFF1A1A1A),
      inputFill: const Color(0xFFF0F0F0),
      hover: const Color(0xFFF0F0F0),
      focus: const Color(0xFF4876D6),
      selection: const Color(0xFF4876D6),
    );

  @override
  ThemeData get darkTheme => buildBaseTheme(
      brightness: Brightness.dark,
      primary: const Color(0xFF82AAFF),
      secondary: const Color(0xFF82AAFF),
      tertiary: const Color(0xFFECC48D),
      error: const Color(0xFFEF5350),
      background: const Color(0xFF011627),
      surface: const Color(0xFF001122),
      card: const Color(0xFF011627),
      border: const Color(0xFF1D3B53),
      text: const Color(0xFFD6DEEB),
      textMuted: const Color(0xFF5F7E97),
      textStrong: const Color(0xFFFFFFFF),
      inputFill: const Color(0xFF011627),
      hover: const Color(0xFF011627),
      focus: const Color(0xFF82AAFF),
      selection: const Color(0xFF82AAFF),
    );
}

class NordTheme extends OpencodeTheme {
  const NordTheme();

  @override
  String get id => 'nord';

  @override
  String get name => 'Nord';

  @override
  ThemeData get lightTheme => buildBaseTheme(
      brightness: Brightness.light,
      primary: const Color(0xFF5E81AC),
      secondary: const Color(0xFF81A1C1),
      tertiary: const Color(0xFFD08770),
      error: const Color(0xFFBF616A),
      background: const Color(0xFFECEFF4),
      surface: const Color(0xFFF1F3F8),
      card: const Color(0xFFECEFF4),
      border: const Color(0xFFD5DBE7),
      text: const Color(0xFF2E3440),
      textMuted: const Color(0xFF4C566A),
      textStrong: const Color(0xFF1F2530),
      inputFill: const Color(0xFFECEFF4),
      hover: const Color(0xFFECEFF4),
      focus: const Color(0xFF8B94AD),
      selection: const Color(0xFF5E81AC),
    );

  @override
  ThemeData get darkTheme => buildBaseTheme(
      brightness: Brightness.dark,
      primary: const Color(0xFF88C0D0),
      secondary: const Color(0xFF81A1C1),
      tertiary: const Color(0xFFD08770),
      error: const Color(0xFFBF616A),
      background: const Color(0xFF1F2430),
      surface: const Color(0xFF1C202A),
      card: const Color(0xFF2E3440),
      border: const Color(0xFF343A47),
      text: const Color(0xFFE5E9F0),
      textMuted: const Color(0xFFA4ADBF),
      textStrong: const Color(0xFFF8FAFC),
      inputFill: const Color(0xFF2E3440),
      hover: const Color(0xFF2E3440),
      focus: const Color(0xFF606889),
      selection: const Color(0xFF88C0D0),
    );
}

class Oc1Theme extends OpencodeTheme {
  const Oc1Theme();

  @override
  String get id => 'oc-1';

  @override
  String get name => 'OC-1';

  @override
  ThemeData get lightTheme => buildBaseTheme(
      brightness: Brightness.light,
      primary: const Color(0xFFDCDE8D),
      secondary: const Color(0xFFA753AE),
      tertiary: const Color(0xFFFFDC17),
      error: const Color(0xFFFC533A),
      background: const Color(0xFFF8F7F7),
      surface: const Color(0xFFFDFCFC),
      card: const Color(0xFFFDFCFC),
      border: const Color(0x1F110000),
      text: const Color(0xFF656363),
      textMuted: const Color(0xFF8E8B8B),
      textStrong: const Color(0xFF211E1E),
      inputFill: const Color(0xFFFDFCFC),
      hover: const Color(0x0F050000),
      focus: const Color(0xFC004AFF),
      selection: const Color(0xFFDAEAFF),
    );

  @override
  ThemeData get darkTheme => buildBaseTheme(
      brightness: Brightness.dark,
      primary: const Color(0xFFFAB283),
      secondary: const Color(0xFFEDB2F1),
      tertiary: const Color(0xFFFCD53A),
      error: const Color(0xFFFC533A),
      background: const Color(0xFF131010),
      surface: const Color(0xFF151313),
      card: const Color(0x1EF2E1E1),
      border: const Color(0x31F5E8E8),
      text: const Color(0xB2FCF9F9),
      textMuted: const Color(0x67FAF5F4),
      textStrong: const Color(0xF0FDFBFB),
      inputFill: const Color(0xFF1B1818),
      hover: const Color(0x16E0B7B7),
      focus: const Color(0xFF89B5FF),
      selection: const Color(0xFF0D172B),
    );
}

class Oc2Theme extends OpencodeTheme {
  const Oc2Theme();

  @override
  String get id => 'oc-2';

  @override
  String get name => 'OC-2';

  @override
  ThemeData get lightTheme => buildBaseTheme(
      brightness: Brightness.light,
      primary: const Color(0xFFDCDE8D),
      secondary: const Color(0xFFA753AE),
      tertiary: const Color(0xFFFFDC17),
      error: const Color(0xFFFC533A),
      background: const Color(0xFFF8F8F8),
      surface: const Color(0xFFFCFCFC),
      card: const Color(0xFFFCFCFC),
      border: const Color(0xFFE5E5E5),
      text: const Color(0xFF6F6F6F),
      textMuted: const Color(0xFF8F8F8F),
      textStrong: const Color(0xFF171717),
      inputFill: const Color(0xFFFCFCFC),
      hover: const Color(0x0F000000),
      focus: const Color(0xFC004AFF),
      selection: const Color(0xFFDAEAFF),
    );

  @override
  ThemeData get darkTheme => buildBaseTheme(
      brightness: Brightness.dark,
      primary: const Color(0xFFFAB283),
      secondary: const Color(0xFFEDB2F1),
      tertiary: const Color(0xFFFCD53A),
      error: const Color(0xFFFC533A),
      background: const Color(0xFF101010),
      surface: const Color(0xFF121212),
      card: const Color(0x14FFFFFF),
      border: const Color(0xFF282828),
      text: const Color(0x96FFFFFF),
      textMuted: const Color(0x63FFFFFF),
      textStrong: const Color(0xEBFFFFFF),
      inputFill: const Color(0xFF1C1C1C),
      hover: const Color(0x0AFFFFFF),
      focus: const Color(0xFF89B5FF),
      selection: const Color(0xFF0D172B),
    );
}

class OnedarkproTheme extends OpencodeTheme {
  const OnedarkproTheme();

  @override
  String get id => 'onedarkpro';

  @override
  String get name => 'One Dark Pro';

  @override
  ThemeData get lightTheme => buildBaseTheme(
      brightness: Brightness.light,
      primary: const Color(0xFF528BFF),
      secondary: const Color(0xFF61AFEF),
      tertiary: const Color(0xFFD19A66),
      error: const Color(0xFFE06C75),
      background: const Color(0xFFF5F6F8),
      surface: const Color(0xFFFAFBFC),
      card: const Color(0xFFF5F6F8),
      border: const Color(0xFFDEE2EB),
      text: const Color(0xFF2B303B),
      textMuted: const Color(0xFF6B717F),
      textStrong: const Color(0xFF0E1118),
      inputFill: const Color(0xFFF5F6F8),
      hover: const Color(0xFFF5F6F8),
      focus: const Color(0xFF959CAE),
      selection: const Color(0xFF528BFF),
    );

  @override
  ThemeData get darkTheme => buildBaseTheme(
      brightness: Brightness.dark,
      primary: const Color(0xFF61AFEF),
      secondary: const Color(0xFF56B6C2),
      tertiary: const Color(0xFFE5C07B),
      error: const Color(0xFFE06C75),
      background: const Color(0xFF1E222A),
      surface: const Color(0xFF1B1F27),
      card: const Color(0xFF1E222A),
      border: const Color(0xFF323848),
      text: const Color(0xFFABB2BF),
      textMuted: const Color(0xFF818899),
      textStrong: const Color(0xFFF6F7FB),
      inputFill: const Color(0xFF1E222A),
      hover: const Color(0xFF1E222A),
      focus: const Color(0xFF60688A),
      selection: const Color(0xFF61AFEF),
    );
}

class ShadesofpurpleTheme extends OpencodeTheme {
  const ShadesofpurpleTheme();

  @override
  String get id => 'shadesofpurple';

  @override
  String get name => 'Shades of Purple';

  @override
  ThemeData get lightTheme => buildBaseTheme(
      brightness: Brightness.light,
      primary: const Color(0xFF7A5AF8),
      secondary: const Color(0xFF62D4FF),
      tertiary: const Color(0xFFF7C948),
      error: const Color(0xFFFF6BD5),
      background: const Color(0xFFF7EBFF),
      surface: const Color(0xFFFBF2FF),
      card: const Color(0xFFF7EBFF),
      border: const Color(0xFFE5D3FF),
      text: const Color(0xFF3B2C59),
      textMuted: const Color(0xFF6C568F),
      textStrong: const Color(0xFF1C1033),
      inputFill: const Color(0xFFF7EBFF),
      hover: const Color(0xFFF7EBFF),
      focus: const Color(0xFF9B82B8),
      selection: const Color(0xFF7A5AF8),
    );

  @override
  ThemeData get darkTheme => buildBaseTheme(
      brightness: Brightness.dark,
      primary: const Color(0xFFC792FF),
      secondary: const Color(0xFF7DD4FF),
      tertiary: const Color(0xFFFFD580),
      error: const Color(0xFFFF7AC6),
      background: const Color(0xFF1A102B),
      surface: const Color(0xFF1C122F),
      card: const Color(0xFF1A102B),
      border: const Color(0xFF352552),
      text: const Color(0xFFF5F0FF),
      textMuted: const Color(0xFFC9B6FF),
      textStrong: const Color(0xFFFFFFFF),
      inputFill: const Color(0xFF1A102B),
      hover: const Color(0xFF1A102B),
      focus: const Color(0xFF654C99),
      selection: const Color(0xFFC792FF),
    );
}

class SolarizedTheme extends OpencodeTheme {
  const SolarizedTheme();

  @override
  String get id => 'solarized';

  @override
  String get name => 'Solarized';

  @override
  ThemeData get lightTheme => buildBaseTheme(
      brightness: Brightness.light,
      primary: const Color(0xFF268BD2),
      secondary: const Color(0xFF2AA198),
      tertiary: const Color(0xFFB58900),
      error: const Color(0xFFDC322F),
      background: const Color(0xFFFDF6E3),
      surface: const Color(0xFFFAF3DC),
      card: const Color(0xFFFDF6E3),
      border: const Color(0xFFE3E0CD),
      text: const Color(0xFF586E75),
      textMuted: const Color(0xFF7A8C8E),
      textStrong: const Color(0xFF073642),
      inputFill: const Color(0xFFFDF6E3),
      hover: const Color(0xFFFDF6E3),
      focus: const Color(0xFF999382),
      selection: const Color(0xFF268BD2),
    );

  @override
  ThemeData get darkTheme => buildBaseTheme(
      brightness: Brightness.dark,
      primary: const Color(0xFF6C71C4),
      secondary: const Color(0xFF2AA198),
      tertiary: const Color(0xFFB58900),
      error: const Color(0xFFDC322F),
      background: const Color(0xFF001F27),
      surface: const Color(0xFF01222B),
      card: const Color(0xFF002B36),
      border: const Color(0xFF20373F),
      text: const Color(0xFF93A1A1),
      textMuted: const Color(0xFF6C7F80),
      textStrong: const Color(0xFFFDF6E3),
      inputFill: const Color(0xFF002B36),
      hover: const Color(0xFF002B36),
      focus: const Color(0xFF42657A),
      selection: const Color(0xFF6C71C4),
    );
}

class TokyonightTheme extends OpencodeTheme {
  const TokyonightTheme();

  @override
  String get id => 'tokyonight';

  @override
  String get name => 'Tokyonight';

  @override
  ThemeData get lightTheme => buildBaseTheme(
      brightness: Brightness.light,
      primary: const Color(0xFF2E7DE9),
      secondary: const Color(0xFF007197),
      tertiary: const Color(0xFF8C6C3E),
      error: const Color(0xFFC94060),
      background: const Color(0xFFE1E2E7),
      surface: const Color(0xFFE5E6EE),
      card: const Color(0xFFE1E2E7),
      border: const Color(0xFFCDD0DC),
      text: const Color(0xFF273153),
      textMuted: const Color(0xFF5C6390),
      textStrong: const Color(0xFF1C2544),
      inputFill: const Color(0xFFE1E2E7),
      hover: const Color(0xFFE1E2E7),
      focus: const Color(0xFF83889E),
      selection: const Color(0xFF2E7DE9),
    );

  @override
  ThemeData get darkTheme => buildBaseTheme(
      brightness: Brightness.dark,
      primary: const Color(0xFF7AA2F7),
      secondary: const Color(0xFF7DCFFF),
      tertiary: const Color(0xFFE0AF68),
      error: const Color(0xFFF7768E),
      background: const Color(0xFF0F111A),
      surface: const Color(0xFF101324),
      card: const Color(0xFF31385A),
      border: const Color(0xFF25283B),
      text: const Color(0xFFC0CAF5),
      textMuted: const Color(0xFF7A88CF),
      textStrong: const Color(0xFFEAEAFF),
      inputFill: const Color(0xFF1A1B26),
      hover: const Color(0xFF232840),
      focus: const Color(0xFF4F507F),
      selection: const Color(0xFF7AA2F7),
    );
}

class VesperTheme extends OpencodeTheme {
  const VesperTheme();

  @override
  String get id => 'vesper';

  @override
  String get name => 'Vesper';

  @override
  ThemeData get lightTheme => buildBaseTheme(
      brightness: Brightness.light,
      primary: const Color(0xFFFFC799),
      secondary: const Color(0xFFFFC799),
      tertiary: const Color(0xFFFFC799),
      error: const Color(0xFFFF8080),
      background: const Color(0xFFFFFFFF),
      surface: const Color(0xFFF0F0F0),
      card: const Color(0xFFF0F0F0),
      border: const Color(0xFFD0D0D0),
      text: const Color(0xFF101010),
      textMuted: const Color(0xFF606060),
      textStrong: const Color(0xFF000000),
      inputFill: const Color(0xFFF0F0F0),
      hover: const Color(0xFFF0F0F0),
      focus: const Color(0xFFB8B8B8),
      selection: const Color(0xFFFFC799),
    );

  @override
  ThemeData get darkTheme => buildBaseTheme(
      brightness: Brightness.dark,
      primary: const Color(0xFFFFC799),
      secondary: const Color(0xFFFFC799),
      tertiary: const Color(0xFFFFC799),
      error: const Color(0xFFFF8080),
      background: const Color(0xFF101010),
      surface: const Color(0xFF0C0C0C),
      card: const Color(0xFF101010),
      border: const Color(0xFF1C1C1C),
      text: const Color(0xFFFFFFFF),
      textMuted: const Color(0xFFA0A0A0),
      textStrong: const Color(0xFFFFFFFF),
      inputFill: const Color(0xFF101010),
      hover: const Color(0xFF101010),
      focus: const Color(0xFF404040),
      selection: const Color(0xFFFFC799),
    );
}
