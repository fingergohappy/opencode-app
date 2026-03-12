/// 应用主题模式。
enum AppThemeMode {
  system('system'),
  light('light'),
  dark('dark');

  final String value;
  const AppThemeMode(this.value);

  /// 把持久化存储里的字符串还原成枚举，失败时回退到 system。
  static AppThemeMode fromValue(String? value) =>
      values.firstWhere((e) => e.value == value, orElse: () => system);
}

/// 主题预设枚举：value 用于存储，displayName 用于界面展示。
enum AppThemePreset {
  oc1('oc-1', 'OC-1'),
  oc2('oc-2', 'OC-2'),
  aura('aura', 'Aura'),
  ayu('ayu', 'Ayu'),
  carbonfox('carbonfox', 'Carbonfox'),
  catppuccin('catppuccin', 'Catppuccin'),
  dracula('dracula', 'Dracula'),
  gruvbox('gruvbox', 'Gruvbox'),
  monokai('monokai', 'Monokai'),
  nightowl('nightowl', 'Night Owl'),
  nord('nord', 'Nord'),
  onedarkpro('onedarkpro', 'One Dark Pro'),
  shadesOfPurple('shadesofpurple', 'Shades of Purple'),
  solarized('solarized', 'Solarized'),
  tokyonight('tokyonight', 'Tokyonight'),
  vesper('vesper', 'Vesper');

  final String value;
  final String displayName;
  const AppThemePreset(this.value, this.displayName);

  /// 兜底到 oc1，避免本地存储异常导致应用无法启动。
  static AppThemePreset fromValue(String? value) =>
      values.firstWhere((e) => e.value == value, orElse: () => oc1);
}

/// 当前项目只提供中英文两种语言选项。
enum AppLanguage {
  english('en'),
  chinese('zh');

  final String value;
  const AppLanguage(this.value);

  /// 语言值不合法时默认英文，保证设置页和未来国际化入口都有稳定默认值。
  static AppLanguage fromValue(String? value) =>
      values.firstWhere((e) => e.value == value, orElse: () => english);
}
