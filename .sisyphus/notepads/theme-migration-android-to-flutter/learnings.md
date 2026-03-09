# Learnings

## 2026-03-09

- Migrated all 16 Android theme presets into `lib/theme/theme_catalog.dart` with strict 1:1 hex token parity for both light and dark variants (12 tokens each).
- `OpenCodeThemeCatalog.themes` includes the full preset contract list matching `AppThemePreset.value` exactly: `oc-1`, `oc-2`, `aura`, `ayu`, `carbonfox`, `catppuccin`, `dracula`, `gruvbox`, `monokai`, `nightowl`, `nord`, `onedarkpro`, `shadesofpurple`, `solarized`, `tokyonight`, `vesper`.
- Existing Flutter `oc-1` values were not source-of-truth aligned; they were updated to match Android `Oc1Theme.kt` exactly.

- Added `test/theme/theme_catalog_test.dart` to guard catalog integrity against silent fallback behavior.
- The test iterates `AppThemePreset.values` and asserts `OpenCodeThemeCatalog.byId(preset.value).id == preset.value`.

- Added `OpenCodeThemeColors` `ThemeExtension` in `lib/theme/theme_spec.dart` and attached it in `OpenCodeThemeDefinition.toThemeData(...)` with values sourced from the active `OpenCodeThemeVariant` (light/dark).
- Updated diff status icon colors in `lib/ui/screens/project/session/screen.dart` to use semantic tokens (`added -> diffAdd`, `deleted -> diffDelete`, default/modified -> `warning`) instead of hardcoded `Colors.green/red/orange`.

## 2026-03-09 (Task 4)

- Added comprehensive component themes to `OpenCodeThemeDefinition.toThemeData(...)` to match Android Compose styling:
  - `inputDecorationTheme`: consistent border styling with 8px radius, primary color on focus.
  - Button themes (`filledButtonTheme`, `elevatedButtonTheme`, `outlinedButtonTheme`, `textButtonTheme`): 8px radius, state-aware colors using `WidgetStateProperty`.
  - `dialogTheme`/`cardTheme`: 12px radius, theme-aware background/surface colors.
  - `listTileTheme`, `dividerTheme`, `textSelectionTheme`: consistent styling derived from `ColorScheme`.
- Note: In this repo's Flutter version, `ThemeData.dialogTheme` expects `DialogThemeData` and `ThemeData.cardTheme` expects `CardThemeData`.
- Added `test/theme/theme_component_smoke_test.dart` verifying components render without exceptions across `oc-1`/`dracula` presets and light/dark modes.

## 2026-03-09 (Task 5)

- Added `test/golden/theme_gallery_golden_test.dart` to generate and verify 32 golden images (16 presets x light/dark).
- Goldens location: `test/goldens/theme_gallery/${presetId}_${mode}.png`.
- Determinism approach:
  - fixed surface size via `tester.binding.setSurfaceSize(const Size(400, 700))` with teardown reset.
  - fixed text scaling via `MediaQueryData(textScaler: TextScaler.linear(1.0))`.
  - Ahem test font applied via `ThemeData.copyWith(...textTheme.apply(fontFamily: 'Ahem')...)`.
  - capture target is a keyed `RepaintBoundary`.

## 2026-03-09 (Task 6)

- Added `.github/workflows/flutter.yml` with a single `ubuntu-latest` CI job on `push` + `pull_request` that runs `flutter pub get`, `dart format --output=none --set-exit-if-changed .`, `flutter analyze`, and `flutter test` using Flutter `3.41.4` stable via `subosito/flutter-action@v2` (with cache enabled).
- Added a best-effort golden diff artifact upload step using `actions/upload-artifact@v4` and `if-no-files-found: ignore` for common failure output patterns (`**/failures/**`, `**/*.diff.png`, `**/*_test_failure.png`).
