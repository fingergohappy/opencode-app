# Android Theme -> Flutter Theme Migration (OpenCode)

## TL;DR

> **Quick Summary**: 将 Android Compose 项目 `/Users/finger/code/my-code/android/opencode-app` 的 16 套主题预设与派生规则迁移到 Flutter 项目 `/Users/finger/code/my-code/flutter/opencode-app`，并在 Flutter 中实现与 Android 接近的全局组件默认样式。
>
> **Deliverables**:
> - Flutter 主题目录补全 16 套 preset（light/dark）+ token->ThemeData 派生规则对齐 Android
> - Flutter `ThemeExtension` 暴露额外语义色（diffAdd/diffDelete/success/warning/info/...）并替换硬编码 `Colors.*`
> - Golden tests + GitHub Actions CI（analyze/format/test）确保主题不回归
>
> **Estimated Effort**: Large（颜色 token 数量大；但结构已有）
> **Parallel Execution**: YES - 2 waves
> **Critical Path**: 预设补全 -> ThemeData/组件主题 -> Golden -> CI

---

## Context

### Original Request
将 Android 项目的 theme 迁移到当前 Flutter 项目，并用中文沟通。

### Confirmed Decisions
- 迁移深度: **Token + 全局组件样式**（ThemeData component defaults），尽量不逐页改 UI
- 暗色模式: **跟随系统**（`ThemeMode.system` + `theme`/`darkTheme`）
- 字体: **保持 Flutter 默认字体**（不迁移字体资源）
- 主题预设: Flutter **完全对齐 Android 16 套**（不允许因为 catalog 缺失导致静默 fallback）
- 验证: **加 golden tests + CI**

### Source Of Truth (Android)
- 主题模型与派生规则: ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/theme/OpenCodeThemeSpec.kt `
- 主题预设注册表: ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/theme/OpenCodeThemeCatalog.kt `
- 16 套 preset token 文件: ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/theme/themes/*.kt `
- Typography token（很少，更多是各页面 inline）: ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/theme/Type.kt `

### Current State (Flutter)
- App root theme wiring: ` /Users/finger/code/my-code/flutter/opencode-app/lib/main.dart `
- ThemeData 构建位置: ` /Users/finger/code/my-code/flutter/opencode-app/lib/theme/theme_spec.dart `（已实现 `_mixColors` 与 `_contentColorFor` 的 Android 风格）
- Preset catalog: ` /Users/finger/code/my-code/flutter/opencode-app/lib/theme/theme_catalog.dart `（当前只定义 oc-1/oc-2）
- Preset enum 已列出 Android 16: ` /Users/finger/code/my-code/flutter/opencode-app/lib/models/settings.dart `
- 硬编码状态色示例: ` /Users/finger/code/my-code/flutter/opencode-app/lib/ui/screens/project/session/screen.dart `（diff added/deleted 使用 `Colors.green/red/orange`）

---

## Work Objectives

### Core Objective
在 Flutter 中实现与 Android 一致的主题 token 与派生规则，并将常用 Material3 组件的默认样式统一到主题层，确保切换 preset/亮暗模式后 UI 风格稳定一致。

### Must Have
- 16 套 preset 全量可选、可持久化、light/dark 都可用
- `OpenCodeThemeCatalog.byId()` 对所有 `AppThemePreset.value` 都能返回对应主题（不依赖 fallback）
- 关键 UI 不再出现硬编码 `Colors.*` 破坏主题语义
- Golden tests + CI 可以自动验证

### Must NOT Have (Guardrails)
- 不引入字体资源（不改 `pubspec.yaml` 的 fonts 部分）
- 不做逐页面布局/视觉重构（除非是把硬编码颜色替换成主题 token 的小改动）
- 不引入 “动态取色 / Material You dynamic color” 相关功能（明确 out-of-scope）
- 不更改业务逻辑/网络/状态流

---

## Verification Strategy (MANDATORY)

### Test Decision
- **Infrastructure exists**: YES (minimal) — `flutter_test` + `flutter_lints`
- **Automated tests**: YES (Tests-after) + Golden
- **Framework**: `flutter test` + built-in golden matcher (`matchesGoldenFile`)（优先不加额外依赖）

### Agent-Executed QA Scenarios (all tasks)

Scenario: App boots with persisted theme preset
  Tool: Bash (flutter)
  Preconditions: `flutter pub get` completed
  Steps:
    1. `flutter test` (after tasks) to ensure no startup crash regressions
    2. (Optional) `flutter run -d <simulator>` in executor environment
  Expected Result: App can start and load theme without exceptions
  Evidence: `.sisyphus/evidence/flutter-test.log`

Scenario: Theme preset switching does not crash
  Tool: Integration test OR widget test harness (flutter_test)
  Preconditions: Settings screen exists
  Steps:
    1. Open settings screen widget test
    2. Iterate `AppThemePreset.values` and apply to app state
    3. Pump and ensure no exceptions
  Expected Result: No exceptions; theme changes apply
  Evidence: test output log

---

## Execution Strategy

Wave 1 (foundation): presets + strictness + extension
- Task 1, 2, 3

Wave 2 (visual + guardrails): component theming + golden + CI
- Task 4, 5, 6

Critical Path: 1 -> 4 -> 5 -> 6

---

## TODOs

- [x] 1. 迁移 Android 16 套 preset token 到 Flutter catalog（light/dark 全量）

  **What to do**:
  - 从 Android 的 16 个 `themes/*.kt` 把每个 preset 的 light/dark token 值 1:1 复制到 Flutter。
  - 在 Flutter `OpenCodeThemeCatalog.themes` 中包含全部 16 个 `OpenCodeThemeDefinition`。
  - 保持 ID 完全一致（例如 `oc-1`, `shadesofpurple`）。

  **Must NOT do**:
  - 不要引入 “近似值/手调色” 作为默认；默认以 Android token 为准。

  **Recommended Agent Profile**:
  - Category: `unspecified-high`
  - Skills: `frontend-ui-ux`

  **Parallelization**:
  - Can Run In Parallel: YES (with Task 2 test scaffolding)

  **References**:
  - ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/theme/themes/Oc1Theme.kt ` - oc-1 token source
  - ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/theme/themes/Oc2Theme.kt ` - oc-2 token source
  - ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/theme/themes/AuraTheme.kt `
  - ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/theme/themes/AyuTheme.kt `
  - ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/theme/themes/CarbonfoxTheme.kt `
  - ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/theme/themes/CatppuccinTheme.kt `
  - ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/theme/themes/DraculaTheme.kt `
  - ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/theme/themes/GruvboxTheme.kt `
  - ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/theme/themes/MonokaiTheme.kt `
  - ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/theme/themes/NightowlTheme.kt `
  - ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/theme/themes/NordTheme.kt `
  - ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/theme/themes/OnedarkproTheme.kt `
  - ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/theme/themes/ShadesofpurpleTheme.kt `
  - ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/theme/themes/SolarizedTheme.kt `
  - ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/theme/themes/TokyonightTheme.kt `
  - ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/theme/themes/VesperTheme.kt `
  - ` /Users/finger/code/my-code/flutter/opencode-app/lib/theme/theme_catalog.dart ` - Flutter preset definition location
  - ` /Users/finger/code/my-code/flutter/opencode-app/lib/models/settings.dart ` - preset id contract (must match)

  **Acceptance Criteria**:
  - [ ] Flutter `OpenCodeThemeCatalog.themes` 包含 16 个 theme
  - [ ] 对每个 theme：light/dark 都具备 12 个 token（与 Android schema 一致）

  **Agent-Executed QA Scenarios**:
  - Scenario: 编译级校验（防止 typo）
    Tool: Bash (flutter)
    Preconditions: none
    Steps:
      1. `flutter analyze > .sisyphus/evidence/task-1-analyze.log`
    Expected Result: exit code 0
    Evidence: `.sisyphus/evidence/task-1-analyze.log`


- [x] 2. 增加“catalog 完整性”自动测试（防止静默 fallback）

  **What to do**:
  - 新增测试，遍历 `AppThemePreset.values`，对每个 preset:
    - 调用 `OpenCodeThemeCatalog.byId(preset.value)`
    - 断言返回的 theme.id == preset.value（避免 defaultTheme fallback）
    - 断言 light/dark token 非透明/非占位（基本 sanity checks）

  **Must NOT do**:
  - 不要让测试依赖 UI 渲染（保持单元测试快速）

  **Recommended Agent Profile**:
  - Category: `quick`
  - Skills: (none)

  **Parallelization**:
  - Can Run In Parallel: YES (with Task 1)

  **References**:
  - ` /Users/finger/code/my-code/flutter/opencode-app/lib/models/settings.dart ` - preset source
  - ` /Users/finger/code/my-code/flutter/opencode-app/lib/theme/theme_catalog.dart ` - byId implementation
  - ` /Users/finger/code/my-code/flutter/opencode-app/test/widget_test.dart ` - current test harness style

  **Acceptance Criteria**:
  - [ ] 新增测试文件: `test/theme/theme_catalog_test.dart`
  - [ ] `flutter test test/theme/theme_catalog_test.dart > .sisyphus/evidence/task-2-theme-catalog-test.log` 退出码为 0
  - [ ] 测试断言：对所有 `AppThemePreset.values`，`OpenCodeThemeCatalog.byId(preset.value).id == preset.value`

  **Agent-Executed QA Scenarios**:
  - Scenario: Catalog 不允许缺失 preset
    Tool: Bash (flutter)
    Preconditions: Task 1 已完成
    Steps:
      1. `flutter test test/theme/theme_catalog_test.dart > .sisyphus/evidence/task-2-theme-catalog-test.log`
    Expected Result: PASS (0 failures)
    Evidence: `.sisyphus/evidence/task-2-theme-catalog-test.log`


- [x] 3. 引入 `ThemeExtension` 暴露 OpenCode 语义色，并替换硬编码 diff/status 颜色

  **What to do**:
  - 在 Flutter 增加一个 `ThemeExtension`（例如 `OpenCodeSemanticColors`），包含：`success`, `warning`, `error`, `info`, `diffAdd`, `diffDelete`, `accent`, `interactive`, `border` 等（至少覆盖现有 UI 需要）。
  - 在 `ThemeData` 构建时挂载 extension。
  - 将 ` /Users/finger/code/my-code/flutter/opencode-app/lib/ui/screens/project/session/screen.dart ` 中的 `Colors.green/red/orange` 替换为主题语义色（建议 added->diffAdd, deleted->diffDelete, modified->warning 或 interactive，取决于 Android 的语义）。

  **Must NOT do**:
  - 不改变 diff/status 的业务含义（只改颜色来源）

  **Recommended Agent Profile**:
  - Category: `unspecified-high`
  - Skills: `frontend-ui-ux`

  **Parallelization**:
  - Can Run In Parallel: NO (依赖 Task 1 token 完整)

  **References**:
  - Android extra colors semantics: ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/theme/OpenCodeThemeSpec.kt `
  - Flutter ThemeData build: ` /Users/finger/code/my-code/flutter/opencode-app/lib/theme/theme_spec.dart `
  - Hardcoded colors location: ` /Users/finger/code/my-code/flutter/opencode-app/lib/ui/screens/project/session/screen.dart `

  **Acceptance Criteria**:
  - [ ] `flutter analyze` passes
  - [ ] `flutter test` passes
  - [ ] `screen.dart` 不再包含 `Colors.green`/`Colors.red`/`Colors.orange`（除非有明确 allowlist）

  **Agent-Executed QA Scenarios**:
  - Scenario: Diff 状态色走主题语义色
    Tool: Bash (flutter)
    Preconditions: Task 1 已完成
    Steps:
      1. `flutter test > .sisyphus/evidence/task-3-flutter-test.log`
      2. (静态校验) `dart run tool/check_no_hardcoded_colors.dart > .sisyphus/evidence/task-3-no-hardcoded-colors.log`（如选择脚本方式）
    Expected Result: tests PASS；静态校验 PASS
    Evidence: `.sisyphus/evidence/task-3-no-hardcoded-colors.log`


- [x] 4. 在 `ThemeData` 中补齐全局组件默认样式，使其更接近 Android Compose 表现

  **What to do**:
  - 在 ` /Users/finger/code/my-code/flutter/opencode-app/lib/theme/theme_spec.dart ` 扩展 `ThemeData(...)`:
    - `appBarTheme`（已存在）: 校准 `elevation`, `backgroundColor`, `foregroundColor`
    - `inputDecorationTheme`: Outlined 边框、focus/hover/disabled 颜色、圆角（参考 Android 常用 8dp/12dp）
    - `filledButtonTheme`/`elevatedButtonTheme`/`outlinedButtonTheme`/`textButtonTheme`: shape radius、foreground/background、overlay states
    - `dialogTheme`: surface/shape/title/content 文本色
    - `cardTheme`/`listTileTheme`/`dividerTheme`
    - `snackBarTheme`（如项目中有使用）
    - `textSelectionTheme`: cursor/selection/handles 与 interactive/accent 对齐
  - 保持 Material3 (`useMaterial3: true`)。
  - 派生规则对齐 Android：surface/surfaceVariant 的 mix、on* 颜色阈值（0.45）一致。

  **Must NOT do**:
  - 不引入字体资产；不做大量页面级 TextStyle 重写

  **Recommended Agent Profile**:
  - Category: `visual-engineering`
  - Skills: `frontend-ui-ux`

  **Parallelization**:
  - Can Run In Parallel: NO (依赖 Task 1)

  **References**:
  - Android mapping + contentColorFor threshold: ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/theme/OpenCodeThemeSpec.kt `
  - Android component styling examples:
    - ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/server/ServerListScreen.kt `
    - ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/project/ProjectListScreen.kt `
    - ` /Users/finger/code/my-code/android/opencode-app/app/src/main/java/com/finger/myapplication/ui/project/detail/ProjectDetailComposer.kt `
  - Flutter ThemeData build: ` /Users/finger/code/my-code/flutter/opencode-app/lib/theme/theme_spec.dart `

  **Acceptance Criteria**:
  - [ ] `flutter analyze` passes
  - [ ] `flutter test` passes
  - [ ] 手动/自动渲染的关键组件（按钮/输入框/对话框）在 light/dark 下均可读、对比合理（由 goldens 覆盖）

  **Agent-Executed QA Scenarios**:
  - Scenario: 组件主题渲染 smoke test
    Tool: Bash (flutter)
    Preconditions: Task 1 已完成
    Steps:
      1. `flutter test test/theme/theme_component_smoke_test.dart > .sisyphus/evidence/task-4-component-smoke.log`
    Expected Result: PASS
    Evidence: `.sisyphus/evidence/task-4-component-smoke.log`


- [x] 5. 增加 Theme Gallery golden tests（16*2）

  **What to do**:
  - 新建一个测试用 `ThemeGallery` widget，用固定尺寸渲染一组关键组件（建议：AppBar, Buttons, TextField, Dialog-like card, ListTile, diff row）。
  - 为每个 preset 的 light/dark 生成 golden：共 32 张。
  - Golden 稳定性处理：固定 `textScaleFactor=1.0`、固定 locale、禁用动画（或确保 pumpAndSettle 可控），固定 platform（如 `TargetPlatform.android`）。

  **Must NOT do**:
  - 不要把 golden 绑定到设备分辨率/字体变化导致脆弱

  **Recommended Agent Profile**:
  - Category: `visual-engineering`
  - Skills: `frontend-ui-ux`

  **Parallelization**:
  - Can Run In Parallel: NO (依赖 Task 4)

  **References**:
  - Preset list contract: ` /Users/finger/code/my-code/flutter/opencode-app/lib/models/settings.dart `
  - Theme wiring: ` /Users/finger/code/my-code/flutter/opencode-app/lib/main.dart `
  - ThemeData build: ` /Users/finger/code/my-code/flutter/opencode-app/lib/theme/theme_spec.dart `

  **Acceptance Criteria**:
  - [ ] 新增 golden 测试文件: `test/golden/theme_gallery_golden_test.dart`
  - [ ] Golden 文件命名规则固定（示例）:
    - `test/goldens/theme_gallery/oc-1_light.png`
    - `test/goldens/theme_gallery/oc-1_dark.png`
  - [ ] 生成 golden 基线: `flutter test --update-goldens test/golden/theme_gallery_golden_test.dart > .sisyphus/evidence/task-5-update-goldens.log`
  - [ ] CI 验证命令: `flutter test test/golden/theme_gallery_golden_test.dart > .sisyphus/evidence/task-5-golden.log`（不带 update）能通过
  - [ ] 至少包含 32 张 golden 文件（16 presets * light/dark）

  **Agent-Executed QA Scenarios**:
  - Scenario: Golden 回归验证
    Tool: Bash (flutter)
    Preconditions: Task 4 已完成
    Steps:
      1. `flutter test test/golden/theme_gallery_golden_test.dart > .sisyphus/evidence/task-5-golden.log`
    Expected Result: PASS
    Evidence: `.sisyphus/evidence/task-5-golden.log`


- [x] 6. 添加 GitHub Actions CI（analyze/format/test + golden diffs artifact）

  **What to do**:
  - 新建 `.github/workflows/flutter.yml`:
    - checkout
    - setup Flutter（pin 版本，避免 golden 漂移）
    - `flutter pub get`
    - `dart format --output=none --set-exit-if-changed .`
    - `flutter analyze`
    - `flutter test`
  - 当 golden 失败时，上传失败输出/差异图片为 artifact（如果可行）。

  **Recommended Agent Profile**:
  - Category: `quick`
  - Skills: (none)

  **Parallelization**:
  - Can Run In Parallel: YES (after Task 5 stable)

  **References**:
  - Lints: ` /Users/finger/code/my-code/flutter/opencode-app/analysis_options.yaml `
  - Test command baseline: ` /Users/finger/code/my-code/flutter/opencode-app/test/widget_test.dart `

  **Acceptance Criteria**:
  - [ ] workflow 在 PR/push 触发
  - [ ] workflow 运行 `flutter test` 成功

  **Agent-Executed QA Scenarios**:
  - Scenario: 本地模拟 CI 命令链
    Tool: Bash
    Preconditions: none
    Steps:
      1. `dart format --output=none --set-exit-if-changed . > .sisyphus/evidence/task-6-format.log`
      2. `flutter analyze > .sisyphus/evidence/task-6-analyze.log`
      3. `flutter test > .sisyphus/evidence/task-6-test.log`
    Expected Result: all exit code 0
    Evidence: `.sisyphus/evidence/task-6-test.log`

---

## Defaults Applied (override if needed)
- Token 值默认 **完全复制 Android**（非“接近就好”）
- Unknown preset id 行为：依赖 `AppThemePreset.fromValue` 的兜底会落到 `oc-1`；同时用测试保证正常路径不会发生缺失（避免“静默不知情”）
- 对比度策略：优先与 Android 一致（通过 `_contentColorFor` 阈值 + surface mixing），不引入 WCAG 计算与强制阈值
- 不引入 dynamic color

## Success Criteria
- [ ] Flutter 可以在 Settings 里切换 16 套主题预设与 system/light/dark 模式，且不会崩溃
- [ ] 关键屏幕不再使用硬编码 `Colors.*` 破坏主题
- [ ] `flutter analyze` / `dart format --output=none --set-exit-if-changed .` / `flutter test` 全通过
- [ ] Golden tests 覆盖 16*2 并在 CI 中稳定运行
