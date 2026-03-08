enum AppThemeMode {
  system('system'),
  light('light'),
  dark('dark');

  final String value;
  const AppThemeMode(this.value);

  static AppThemeMode fromValue(String? value) =>
      values.firstWhere((e) => e.value == value, orElse: () => system);
}

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

  static AppThemePreset fromValue(String? value) =>
      values.firstWhere((e) => e.value == value, orElse: () => oc1);
}

enum AppLanguage {
  english('en'),
  chinese('zh');

  final String value;
  const AppLanguage(this.value);

  static AppLanguage fromValue(String? value) =>
      values.firstWhere((e) => e.value == value, orElse: () => english);
}
