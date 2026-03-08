import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/settings_store.dart';
import '../../../models/settings.dart';
import '../../../main.dart';
import '../../widgets/app_drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _settingsStore = SettingsStore();
  AppLanguage _language = AppLanguage.english;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final language = await _settingsStore.getLanguage();
    setState(() {
      _language = language;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return AppScaffold(
      showDrawer: false,
      title: 'Settings',
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                ListTile(
                  title: const Text('Theme Mode'),
                  subtitle: Text(appState.themeMode.value),
                  onTap: () => _showThemeModeDialog(appState),
                ),
                ListTile(
                  title: const Text('Theme Preset'),
                  subtitle: Text(appState.themePreset.displayName),
                  onTap: () => _showThemePresetDialog(appState),
                ),
                ListTile(
                  title: const Text('Language'),
                  subtitle: Text(_language.value),
                  onTap: () => _showLanguageDialog(),
                ),
              ],
            ),
    );
  }

  void _showThemeModeDialog(AppState appState) {
    showDialog(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Select Theme Mode'),
        children: AppThemeMode.values.map((mode) {
          return SimpleDialogOption(
            onPressed: () {
              appState.setThemeMode(mode);
              Navigator.pop(dialogContext);
            },
            child: Text(mode.value),
          );
        }).toList(),
      ),
    );
  }

  void _showThemePresetDialog(AppState appState) {
    showDialog(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Select Theme'),
        children: AppThemePreset.values.map((preset) {
          return SimpleDialogOption(
            onPressed: () {
              appState.setThemePreset(preset);
              Navigator.pop(dialogContext);
            },
            child: Text(preset.displayName),
          );
        }).toList(),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Select Language'),
        children: AppLanguage.values.map((lang) {
          return SimpleDialogOption(
            onPressed: () async {
              await _settingsStore.setLanguage(lang);
              if (!mounted) return;
              setState(() => _language = lang);
              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }
            },
            child: Text(lang.value),
          );
        }).toList(),
      ),
    );
  }
}
