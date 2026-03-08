import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'router.dart';
import 'data/settings_store.dart';
import 'models/settings.dart';
import 'theme/theme_catalog.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => AppState(),
    child: const MyApp(),
  ));
}

class AppState extends ChangeNotifier {
  final _settingsStore = SettingsStore();
  AppThemeMode _themeMode = AppThemeMode.system;
  AppThemePreset _themePreset = AppThemePreset.oc1;
  bool _loaded = false;

  AppThemeMode get themeMode => _themeMode;
  AppThemePreset get themePreset => _themePreset;
  bool get loaded => _loaded;

  AppState() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _themeMode = await _settingsStore.getThemeMode();
    _themePreset = await _settingsStore.getThemePreset();
    _loaded = true;
    notifyListeners();
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    _themeMode = mode;
    await _settingsStore.setThemeMode(mode);
    notifyListeners();
  }

  Future<void> setThemePreset(AppThemePreset preset) async {
    _themePreset = preset;
    await _settingsStore.setThemePreset(preset);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        if (!state.loaded) {
          return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
        }

        final themeDef = OpenCodeThemeCatalog.byId(state.themePreset.value);

        return MaterialApp.router(
          title: 'OpenCode',
          theme: themeDef.toThemeData(false),
          darkTheme: themeDef.toThemeData(true),
          themeMode: state.themeMode == AppThemeMode.system
              ? ThemeMode.system
              : (state.themeMode == AppThemeMode.dark ? ThemeMode.dark : ThemeMode.light),
          routerConfig: router,
        );
      },
    );
  }
}
