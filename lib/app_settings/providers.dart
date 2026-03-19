import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'general/providers.dart';
import 'locale/providers.dart';
import 'model.dart';
import 'notifications/providers.dart';
import 'sound/providers.dart';
import 'storage.dart';
import 'theme/providers.dart';
import 'updates/providers.dart';

export 'general/providers.dart';
export 'locale/providers.dart';
export 'notifications/providers.dart';
export 'sound/providers.dart';
export 'theme/providers.dart';
export 'updates/providers.dart';

/// Must be overridden in main() via ProviderScope overrides after
/// SharedPreferences.getInstance() resolves.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider not initialized');
});

final appSettingsStorageProvider = Provider<AppSettingsStorage>((ref) {
  return AppSettingsStorage(ref.watch(sharedPreferencesProvider));
});

final currentAppSettingsProvider = Provider<AppSettings>((ref) {
  return AppSettings(
    theme: ref.watch(themeControllerProvider),
    locale: ref.watch(localeControllerProvider),
    general: ref.watch(generalControllerProvider),
    notifications: ref.watch(notificationControllerProvider),
    sound: ref.watch(soundControllerProvider),
    updates: ref.watch(updateControllerProvider),
  );
});

/// 监听整体设置变化，自动持久化
final settingsPersistenceProvider = Provider<void>((ref) {
  ref.listen<AppSettings>(currentAppSettingsProvider, (_, next) {
    ref.read(appSettingsStorageProvider).save(next);
  });
});
