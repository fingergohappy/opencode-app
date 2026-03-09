import 'package:flutter_test/flutter_test.dart';
import 'package:opencode_app/models/settings.dart';
import 'package:opencode_app/theme/theme_catalog.dart';

void main() {
  group('OpenCodeThemeCatalog integrity', () {
    test('contains every AppThemePreset id without fallback', () {
      for (final preset in AppThemePreset.values) {
        final theme = OpenCodeThemeCatalog.byId(preset.value);
        expect(
          theme.id,
          preset.value,
          reason: 'Missing preset in catalog: ${preset.value}',
        );
      }
    });

    test('catalog themes have usable light and dark backgrounds', () {
      for (final theme in OpenCodeThemeCatalog.themes) {
        expect(theme.light.background.a, greaterThan(0));
        expect(theme.dark.background.a, greaterThan(0));
      }
    });
  });
}
