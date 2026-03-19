import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:opencode_app/app_settings/model.dart';
import 'package:opencode_app/app_settings/providers.dart';

Future<ProviderContainer> _createContainer() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  return ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
}

void main() {
  test('locale controller defaults to system locale', () async {
    final container = await _createContainer();
    addTearDown(container.dispose);

    expect(container.read(appLanguageProvider), AppLanguage.system);
    expect(container.read(currentLocaleProvider), isNull);
  });

  test('locale controller updates selected language', () async {
    final container = await _createContainer();
    addTearDown(container.dispose);

    container
        .read(localeControllerProvider.notifier)
        .setLanguage(AppLanguage.chinese);

    expect(container.read(appLanguageProvider), AppLanguage.chinese);
    expect(container.read(currentLocaleProvider)?.languageCode, 'zh');
  });

  test('locale controller can switch back to system locale', () async {
    final container = await _createContainer();
    addTearDown(container.dispose);

    container
        .read(localeControllerProvider.notifier)
        .setLanguage(AppLanguage.english);
    container
        .read(localeControllerProvider.notifier)
        .setLanguage(AppLanguage.system);

    expect(container.read(appLanguageProvider), AppLanguage.system);
    expect(container.read(currentLocaleProvider), isNull);
  });

  test('locale provider maps English and Chinese languages', () async {
    final container = await _createContainer();
    addTearDown(container.dispose);

    container
        .read(localeControllerProvider.notifier)
        .setLanguage(AppLanguage.english);

    final locale = container.read(currentLocaleProvider);

    expect(locale?.languageCode, 'en');

    container
        .read(localeControllerProvider.notifier)
        .setLanguage(AppLanguage.chinese);

    final chineseLocale = container.read(currentLocaleProvider);

    expect(chineseLocale?.languageCode, 'zh');
  });
}
