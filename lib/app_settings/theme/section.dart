import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../theme/opencode_themes.dart';
import 'providers.dart';

class AppearanceSection extends ConsumerWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    // 外观分区只关心主题模式与主题方案，和其他设置解耦，便于后续继续扩展
    // 字体、密度或配色等 UI 偏好。
    final themeMode = ref.watch(themeModeProvider);
    final selectedThemeId = ref.watch(selectedThemeIdProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            localizations.settingsAppearanceSectionTitle,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          title: Text(localizations.settingsColorSchemeTitle),
          subtitle: Text(_themeModeLabel(localizations, themeMode)),
          trailing: DropdownButton<ThemeMode>(
            value: themeMode,
            underline: const SizedBox(),
            items: [
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text(localizations.themeModeSystem),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text(localizations.themeModeLight),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text(localizations.themeModeDark),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                ref.read(themeControllerProvider.notifier).setThemeMode(value);
              }
            },
          ),
        ),
        ListTile(
          title: Text(localizations.settingsThemeTitle),
          subtitle: Text(
            opencodeThemeById[selectedThemeId]?.name ??
                localizations.settingsUnknownTheme,
          ),
          trailing: DropdownButton<String>(
            value: selectedThemeId,
            underline: const SizedBox(),
            items: opencodeThemes.map((theme) {
              return DropdownMenuItem(value: theme.id, child: Text(theme.name));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                ref.read(themeControllerProvider.notifier).setThemeId(value);
              }
            },
          ),
        ),
      ],
    );
  }

  String _themeModeLabel(AppLocalizations localizations, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return localizations.themeModeSystem;
      case ThemeMode.light:
        return localizations.themeModeLight;
      case ThemeMode.dark:
        return localizations.themeModeDark;
    }
  }
}
