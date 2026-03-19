# AGENTS.md
Repository-specific guidance for coding agents working in this Flutter app.

## Overview
- Project type: Flutter application.
- Package name: `opencode_app`.
- Dart SDK: `^3.11.1` from `pubspec.yaml`.
- Main entrypoint: `lib/main.dart`.
- Test directory: `test/`.
- Lint config: `analysis_options.yaml`.
- No custom task runner, Makefile, or CI workflow was found.

## Existing Agent Rules
- Checked and not present: `.cursor/rules/`, `.cursorrules`, `.github/copilot-instructions.md`.
- No existing root `AGENTS.md` was present to merge from.

## Source of Truth
- `pubspec.yaml` for SDK, dependencies, and package metadata.
- `analysis_options.yaml` for lint and analyzer behavior.
- `lib/main.dart` for widget structure and naming style.
- `test/widget_test.dart` for test conventions and import style.

## Commands
Run all commands from the repository root.

### Setup
```bash
flutter pub get
```

### Run Locally
```bash
flutter run
```

### Analyze
```bash
flutter analyze
```
Current caveat: this currently fails because `analysis_options.yaml` contains unquoted glob excludes like `**/*.g.dart` and `**/*.freezed.dart`, which YAML parses incorrectly. Treat that as a repository issue, not as permission to skip analysis.

### Format
```bash
dart format .
```
Flutter wrapper also works:
```bash
flutter format .
```

### Run All Tests
```bash
flutter test
```

### Run One Test File
```bash
flutter test test/widget_test.dart
```
This command was validated successfully in this repository.

### Run One Named Test
```bash
flutter test test/widget_test.dart --plain-name "Counter increments smoke test"
```
This command was also validated successfully in this repository.

### Common Builds
```bash
flutter build apk
flutter build ios
flutter build macos
flutter build web
```
Only run the platform build relevant to the change and local environment.

## Testing Guidance
- Prefer targeted test runs while iterating, then run the broader relevant suite.
- Widget tests use `flutter_test` and currently live under `test/`.
- Match the current style of descriptive `testWidgets(...)` names.
- Test observable behavior: rendered text, interactions, and state changes.
- Use `pumpWidget`, `tap`, `pump`, and `pumpAndSettle` where appropriate.

## Code Style
The lint baseline is `package:flutter_lints/flutter.yaml` plus explicit local rules in `analysis_options.yaml`.

### Formatting
- Prefer single quotes.
- Require trailing commas where appropriate.
- Prefer `const` constructors and `const` literals when possible.
- Prefer final locals and final fields.
- Avoid unnecessary `new`, unnecessary `const`, and redundant argument values.
- Keep files compatible with standard Dart formatter output.
- Add comments at key code paths when the logic, boundary conditions, or design intent is not obvious.
- Use Chinese for code comments, and keep comments focused on the important reasoning rather than restating the code.

### Imports
- Use Flutter package imports such as `package:flutter/material.dart`.
- In tests, use package imports for app code, as shown by `package:opencode_app/main.dart`.
- Keep imports minimal and remove unused imports.
- Let formatter and linter drive import ordering.

### Naming
- Classes: UpperCamelCase.
- Methods, fields, locals, parameters: lowerCamelCase.
- Private members and private state classes: leading underscore.
- Test names: short, readable descriptions of behavior.

### Widget Conventions
- Put constructors before other members when practical.
- Include `key` parameters in widget constructors.
- Keep `child` and `children` near the end of widget argument lists.
- Avoid unnecessary `Container` wrappers.
- Use `StatelessWidget` by default; move to `StatefulWidget` only when local mutable UI state is needed.
- Keep mutable state private unless there is a clear reason not to.

### Types
- Preserve null-safety.
- Do not weaken types unnecessarily.
- `always_declare_return_types` is disabled, but explicit return types are still preferred on public or non-obvious APIs.
- Prefer concrete Flutter and Dart types over `dynamic` when the shape is known.

## Error Handling
- There is no custom error-handling framework yet, so keep it simple and explicit.
- Do not swallow exceptions silently.
- Do not add broad `catch` blocks without a clear recovery path.
- Fail clearly when input or state is invalid.
- Use Flutter-appropriate error surfacing for the layer you are editing.
- `avoid_print` is disabled, so debug prints are allowed, but do not let ad hoc printing become the logging strategy.

## Architecture Expectations
- This is currently a very small Flutter app close to the default scaffold.
- Keep architecture proportional to the app size.
- Prefer simple Flutter composition over premature abstraction.
- Write code with reasonable extensibility in mind; do not optimize only for the current narrow case when nearby requirements are likely to grow.
- Prefer boundaries and naming that can absorb adjacent settings, states, or features without forcing large rewrites later.
- When the future shape is already clear, implement the long-term structure directly instead of introducing a known temporary or transitional layout.
- For multi-domain app settings, prefer domain subdirectories such as `app_settings/theme/` and `app_settings/locale/` over flattening all controllers and providers into the `app_settings/` root.
- Do not introduce large frameworks or app-wide patterns without a concrete need.
- If you add files, group them in an obvious Flutter-friendly way.
- Keep diffs focused; do not mix bug fixes with unrelated cleanup.

## Recommended Directory Structure
- The current project uses a lightweight layered layout under `lib/`.
- Keep `main.dart` as the startup entry and move app assembly into `app/` as the project grows.
- Prefer a feature-first structure: group pages, widgets, providers, and data under the feature or module that owns them.
- Use `app/` for app-shell setup such as `MaterialApp`, global initialization, and top-level composition.
- Use `router/` for centralized navigation setup when routing is introduced.
- Use `theme/` for shared `ThemeData`, colors, typography, and theme-owned state such as theme providers/controllers.
- Use `core/` for cross-cutting, non-business helpers only.
- Under `core/`, use `constants/`, `extensions/`, `logger/`, and `utils/` for narrowly scoped shared code.
- Use `models/` for shared data structures reused across multiple features; keep feature-specific models inside their owning feature until there is a real need to promote them.
- Use feature-local `data/api/` and `data/storage/` for remote data access and local persistence; only create top-level shared data layers when they are truly cross-feature.
- Prefer placing providers next to the feature or module that owns the state. Use a shared `app/providers/` or `core/providers/` location only for truly app-level providers without a clear single-feature owner.
- Prefer feature-local `pages/` and `widgets/` directories. Only create top-level shared `pages/` or `widgets/` when those files are genuinely app-wide or cross-feature.
- Do not add `repositories/` yet; in this codebase, prefer `page -> feature provider -> feature api/storage` until multi-source coordination actually appears.
- Example: `user/` may own `pages/`, `widgets/`, `providers/`, `data/`, and feature-local `models/`; only promote code to top-level shared directories when it is reused across multiple features.
- Do not add `mock/` until local fake data is actively needed for UI development or decoupled feature work.

## Current Caveats
- `analysis_options.yaml` appears malformed because some analyzer exclude globs are unquoted.
- `lib/main.dart` should be treated carefully when validating edits; separate pre-existing issues from any issue introduced by your change.
- There is only one current test file, so repo conventions are based on a minimal sample.

## Recommended Agent Workflow
1. Read the relevant implementation file and nearby tests first.
2. Match the existing style before introducing a new pattern.
3. Follow the current page-first development workflow: build standalone pages first, mount each page onto `HomePage` for visual and interaction validation, and only assemble app-wide routing after the individual pages are validated.
4. Treat `HomePage` as a temporary validation shell during this phase. Keep it lightweight so feature pages can be swapped in and reviewed quickly.
5. Make the smallest change that fully solves the task.
6. Run `dart format` on changed Dart files.
7. Run targeted tests, then broader tests if the scope warrants it.
8. Run `flutter analyze` when possible and report clearly if pre-existing config issues block it.

## Do Not Assume
- Do not assume CI exists.
- Do not assume code generation is active just because `*.g.dart` and `*.freezed.dart` appear in analyzer excludes.
- Do not assume custom scripts exist for linting, testing, or building.
- Do not assume the project already uses a larger architecture than what is visible in `lib/main.dart`.

Update this file when CI, code generation, new test layers, Cursor rules, Copilot instructions, or additional architecture conventions are added.
