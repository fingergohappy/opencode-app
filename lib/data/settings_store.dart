import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings.dart';

/// SharedPreferences 封装层。
/// UI 不直接接触 key，而是统一通过这个类读写设置。
class SettingsStore {
  static const _keyThemeMode = 'theme_mode';
  static const _keyThemePreset = 'theme_preset';
  static const _keyLanguage = 'language';

  /// 读取主题模式；如果本地还没有值，会回退到枚举里的默认值。
  Future<AppThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return AppThemeMode.fromValue(prefs.getString(_keyThemeMode));
  }

  Future<AppThemePreset> getThemePreset() async {
    final prefs = await SharedPreferences.getInstance();
    // Store 只负责保存字符串，真正的默认值和解析规则交给枚举自己维护。
    return AppThemePreset.fromValue(prefs.getString(_keyThemePreset));
  }

  /// set 系列方法都返回 Future，调用方可以在需要时等待写盘完成。
  Future<void> setThemeMode(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, mode.value);
  }

  Future<void> setThemePreset(AppThemePreset preset) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemePreset, preset.value);
  }

  Future<AppLanguage> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return AppLanguage.fromValue(prefs.getString(_keyLanguage));
  }

  Future<void> setLanguage(AppLanguage language) async {
    final prefs = await SharedPreferences.getInstance();
    // 语言暂时还没有挂到全局状态里，但持久化接口已经先准备好了。
    await prefs.setString(_keyLanguage, language.value);
  }
}
