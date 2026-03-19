import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:opencode_app/app_settings/screen.dart';
import 'package:opencode_app/app_settings/providers.dart';
import 'package:opencode_app/l10n/generated/app_localizations.dart';
import 'package:opencode_app/main.dart';
import 'package:opencode_app/servers/screen.dart';
import 'package:opencode_app/servers/widgets/servers_empty_state.dart';

Future<SharedPreferences> _createPrefs() async {
  SharedPreferences.setMockInitialValues({});
  return SharedPreferences.getInstance();
}

Future<void> _pumpMyApp(WidgetTester tester, {Locale? systemLocale}) async {
  final prefs = await _createPrefs();

  if (systemLocale != null) {
    tester.binding.platformDispatcher.localesTestValue = [systemLocale];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);
  }

  await tester.pumpWidget(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const MyApp(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpSettingsScreen(
  WidgetTester tester, {
  Locale? systemLocale,
}) async {
  final prefs = await _createPrefs();

  if (systemLocale != null) {
    tester.binding.platformDispatcher.localesTestValue = [systemLocale];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);
  }

  await tester.pumpWidget(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: Consumer(
        builder: (context, ref, child) {
          return MaterialApp(
            locale: ref.watch(currentLocaleProvider),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SettingsScreen(),
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shows servers screen by default', (WidgetTester tester) async {
    await _pumpMyApp(tester);

    expect(find.text('服务器'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(ServersScreen), findsOneWidget);
    expect(find.byType(ServersEmptyState), findsOneWidget);
    expect(find.text('暂无服务器'), findsOneWidget);
  });

  testWidgets(
    'uses system locale on settings screen when language preference is system',
    (WidgetTester tester) async {
      await _pumpSettingsScreen(tester, systemLocale: const Locale('zh'));

      expect(find.text('设置'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('通用'), findsOneWidget);
      expect(find.text('外观'), findsOneWidget);
    },
  );

  testWidgets('settings screen switches localized copy to Chinese', (
    WidgetTester tester,
  ) async {
    await _pumpSettingsScreen(tester);

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('General'), findsOneWidget);
    expect(find.text('Appearance'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('language-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chinese').last);
    await tester.pumpAndSettle();

    expect(find.text('设置'), findsOneWidget);
    expect(find.text('通用'), findsOneWidget);
    expect(find.text('语言'), findsOneWidget);
    expect(find.text('外观'), findsOneWidget);
  });
}
