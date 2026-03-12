import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/settings_store.dart';
import '../../../models/settings.dart';
import '../../../main.dart';
import '../../widgets/app_scaffold.dart';

/// 设置页。
/// 这个页面既读取本地语言设置，也通过 AppState 控制全局主题切换。
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

  /// 语言设置目前不在 AppState 里，所以这里单独从 SettingsStore 读取。
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

  /// 主题模式属于全局状态，因此直接调用 AppState 更新。
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

  /// 主题预设同样走全局状态，变更后整个应用会立刻重建换肤。
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

  /// 语言目前只是写本地存储并刷新当前页面，还没有接入完整国际化系统。
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
