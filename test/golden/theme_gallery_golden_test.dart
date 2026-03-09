import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opencode_app/models/settings.dart';
import 'package:opencode_app/theme/theme_catalog.dart';
import 'package:opencode_app/theme/theme_spec.dart';

/// Golden tests for all 16 theme presets in both light and dark modes.
///
/// Generates 32 golden images (16 presets × 2 modes) to visually verify
/// theme consistency across all components.
void main() {
  group('Theme Gallery Golden Tests', () {
    const surfaceSize = Size(400, 700);

    for (final preset in AppThemePreset.values) {
      for (final isDark in [false, true]) {
        final mode = isDark ? 'dark' : 'light';
        final testName = '${preset.value}_$mode';

        testWidgets(testName, (tester) async {
          // Set fixed surface size for determinism
          await tester.binding.setSurfaceSize(surfaceSize);
          addTearDown(() => tester.binding.setSurfaceSize(null));

          // Get theme definition and build ThemeData
          final definition = OpenCodeThemeCatalog.byId(preset.value);
          final baseTheme = definition.toThemeData(isDark);
          // Apply Ahem font for deterministic rendering
          final themeData = _applyTestFont(baseTheme);

          await tester.pumpWidget(
            MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: themeData,
              home: MediaQuery(
                // Fix text scaling for determinism
                data: const MediaQueryData(textScaler: TextScaler.linear(1.0)),
                child: RepaintBoundary(
                  key: const Key('themeGallery'),
                  child: ThemeGalleryWidget(
                    presetName: preset.displayName,
                    themeColors: themeData.extension<OpenCodeThemeColors>()!,
                  ),
                ),
              ),
            ),
          );

          // Wait for any pending frame
          await tester.pumpAndSettle();

          await expectLater(
            find.byKey(const Key('themeGallery')),
            matchesGoldenFile('../goldens/theme_gallery/$testName.png'),
          );
        });
      }
    }
  });
}

/// A gallery widget showcasing key theme components.
///
/// Includes: AppBar, TextField, buttons, Card + ListTile, and diff status icons.
class ThemeGalleryWidget extends StatelessWidget {
  const ThemeGalleryWidget({
    super.key,
    required this.presetName,
    required this.themeColors,
  });

  final String presetName;
  final OpenCodeThemeColors themeColors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(title: Text(presetName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TextField
            const TextField(
              decoration: InputDecoration(
                labelText: 'Input Label',
                hintText: 'Placeholder text',
              ),
            ),
            const SizedBox(height: 16),

            // Buttons row
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton(onPressed: () {}, child: const Text('Filled')),
                ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
                OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
                TextButton(onPressed: () {}, child: const Text('Text')),
              ],
            ),
            const SizedBox(height: 16),

            // Card + ListTile
            Card(
              child: ListTile(
                leading: Icon(Icons.palette, color: colorScheme.primary),
                title: const Text('Card Title'),
                subtitle: const Text('Card subtitle text'),
                trailing: Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Diff status row using semantic tokens (Wrap to prevent overflow)
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                _DiffStatusChip(
                  label: 'Added',
                  color: themeColors.diffAdd,
                  icon: Icons.add_circle,
                ),
                const SizedBox(width: 4),
                _DiffStatusChip(
                  label: 'Deleted',
                  color: themeColors.diffDelete,
                  icon: Icons.remove_circle,
                ),
                const SizedBox(width: 4),
                _DiffStatusChip(
                  label: 'Modified',
                  color: themeColors.warning,
                  icon: Icons.edit,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Semantic token showcase
            Text('Semantic Tokens', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _TokenChip(label: 'Success', color: themeColors.success),
                _TokenChip(label: 'Warning', color: themeColors.warning),
                _TokenChip(label: 'Error', color: themeColors.error),
                _TokenChip(label: 'Info', color: themeColors.info),
                _TokenChip(label: 'Accent', color: themeColors.accent),
                _TokenChip(
                  label: 'Interactive',
                  color: themeColors.interactive,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DiffStatusChip extends StatelessWidget {
  const _DiffStatusChip({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}

class _TokenChip extends StatelessWidget {
  const _TokenChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontFamily: 'Ahem'),
      ),
    );
  }
}

/// Applies the Ahem test font to all text styles in the theme.
ThemeData _applyTestFont(ThemeData theme) {
  return theme.copyWith(
    textTheme: theme.textTheme.apply(fontFamily: 'Ahem'),
    primaryTextTheme: theme.primaryTextTheme.apply(fontFamily: 'Ahem'),
  );
}
