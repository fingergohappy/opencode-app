import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opencode_app/theme/theme_catalog.dart';

void main() {
  testWidgets('Theme renders components without exceptions', (
    WidgetTester tester,
  ) async {
    final presets = ['oc-1', 'dracula'];

    for (final presetId in presets) {
      final themeDef = OpenCodeThemeCatalog.byId(presetId);

      for (final isDark in [false, true]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: themeDef.toThemeData(false),
            darkTheme: themeDef.toThemeData(true),
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            home: Scaffold(
              appBar: AppBar(title: Text('Test - $presetId')),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const TextField(
                      decoration: InputDecoration(hintText: 'Enter text'),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () {},
                      child: const Text('Filled Button'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Outlined Button'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Text Button'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Elevated Button'),
                    ),
                    const SizedBox(height: 12),
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Test Card'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const ListTile(
                      title: Text('Test ListTile'),
                      subtitle: Text('Subtitle'),
                    ),
                    const Divider(),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        );

        // Verify no exceptions
        expect(tester.takeException(), isNull);
      }
    }
  });

  testWidgets('Dialog theme renders correctly', (WidgetTester tester) async {
    final themeDef = OpenCodeThemeCatalog.byId('oc-1');

    await tester.pumpWidget(
      MaterialApp(
        theme: themeDef.toThemeData(false),
        darkTheme: themeDef.toThemeData(true),
        home: Scaffold(
          body: Center(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Test Dialog'),
                        content: const Text('Dialog content'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Show Dialog'),
                );
              },
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
