import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'router.dart';
import 'data/settings_store.dart';
import 'models/settings.dart';
import 'theme/theme_catalog.dart';

/// Flutter 程序入口：先注入全局状态，再挂载根组件。
void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => AppState(), child: const MyApp()),
  );
}

/// 保存应用级设置，并在设置变化时通知依赖它的组件重建。
class AppState extends ChangeNotifier {
  final _settingsStore = SettingsStore();
  AppThemeMode _themeMode = AppThemeMode.system;
  AppThemePreset _themePreset = AppThemePreset.oc1;
  // 根组件会先检查 loaded，再决定是显示 loading 还是真正进入路由树。
  bool _loaded = false;

  AppThemeMode get themeMode => _themeMode;
  AppThemePreset get themePreset => _themePreset;
  bool get loaded => _loaded;

  AppState() {
    _loadSettings();
  }

  /// 启动时从本地存储恢复主题配置。
  Future<void> _loadSettings() async {
    _themeMode = await _settingsStore.getThemeMode();
    _themePreset = await _settingsStore.getThemePreset();
    _loaded = true;
    // 首次 notifyListeners 会把应用从“启动占位页”切到真实主题和真实路由。
    notifyListeners();
  }

  /// 更新主题模式并持久化，保证应用重启后仍然生效。
  Future<void> setThemeMode(AppThemeMode mode) async {
    _themeMode = mode;
    await _settingsStore.setThemeMode(mode);
    notifyListeners();
  }

  /// 主题预设也通过同样的流程同步到本地存储。
  Future<void> setThemePreset(AppThemePreset preset) async {
    _themePreset = preset;
    await _settingsStore.setThemePreset(preset);
    notifyListeners();
  }
}

/// 根组件只负责两件事：等待设置加载完毕，然后创建带路由的 MaterialApp。
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        if (!state.loaded) {
          // 主题配置是异步读取的，先展示一个最小可用的加载界面。
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        // 主题预设先查表，再生成亮色和暗色两套 ThemeData。
        final themeDef = OpenCodeThemeCatalog.byId(state.themePreset.value);

        return MaterialApp.router(
          title: 'OpenCode',
          theme: themeDef.toThemeData(false),
          darkTheme: themeDef.toThemeData(true),
          // AppState 里的枚举值会在这里映射成 Flutter 自己的 ThemeMode。
          themeMode: state.themeMode == AppThemeMode.system
              ? ThemeMode.system
              : (state.themeMode == AppThemeMode.dark
                    ? ThemeMode.dark
                    : ThemeMode.light),
          routerConfig: router,
        );
      },
    );
  }
}
