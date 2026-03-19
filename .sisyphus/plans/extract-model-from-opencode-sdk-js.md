# Extract Remote OpenCode Models

## TL;DR
> **Summary**: Port the minimum complete remote non-runtime model surface from `opencode-sdk-js` into this Flutter app as plain immutable Dart types under `lib/models/remote/`, with no provider wiring, no API client code, and no JSON/codegen layer.
> **Deliverables**:
> - Core Dart model files for `shared`, `app`, `config`, `file`, `find`, `session`, and `event`
> - Matching unit tests under `test/models/remote/`
> - One barrel export for the imported model surface
> **Effort**: Medium
> **Parallel**: YES - 2 waves
> **Critical Path**: Shared/App/Config/File/Find foundations -> Session unions -> Event unions -> Barrel and verification

## Context
### Original Request
The user asked to inspect `/Users/fingerfrings/code/open-source/opencode-sdk-js` and extract its models into this Flutter project.

### Interview Summary
- Scope is the minimum complete remote model set for SDK interaction: `shared + app + config + file + find + session + event`.
- Delivery depth is model-only migration: no serialization, no provider/repository wiring, no UI work.
- Test strategy is tests-after.

### Metis Review (gaps addressed)
- Locked scope to exported non-runtime types from the selected resource files only.
- Explicitly excluded runtime resource clients (`AppResource`, `SessionResource`, `Event`) and request infrastructure.
- Chose one union strategy up front so `session.ts` and `event.ts` do not drift during execution.
- Resolved naming-collision risk by prefixing ambiguous top-level Dart types with `Opencode`.

## Work Objectives
### Core Objective
Create a decision-complete implementation path for porting the minimum complete remote TypeScript model surface from `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/` into plain Dart model types under `lib/models/remote/`, preserving structure, nullability, and discriminator semantics while intentionally excluding transport/client behavior.

### Deliverables
- `lib/models/remote/shared_errors.dart`
- `lib/models/remote/app_models.dart`
- `lib/models/remote/config_models.dart`
- `lib/models/remote/file_models.dart`
- `lib/models/remote/find_models.dart`
- `lib/models/remote/session_primitives.dart`
- `lib/models/remote/session_parts.dart`
- `lib/models/remote/session_requests.dart`
- `lib/models/remote/session_messages.dart`
- `lib/models/remote/event_models.dart`
- `lib/models/remote/remote_models.dart`
- `test/models/remote/shared_errors_test.dart`
- `test/models/remote/app_models_test.dart`
- `test/models/remote/config_models_test.dart`
- `test/models/remote/file_models_test.dart`
- `test/models/remote/find_models_test.dart`
- `test/models/remote/session_primitives_test.dart`
- `test/models/remote/session_parts_test.dart`
- `test/models/remote/session_requests_test.dart`
- `test/models/remote/session_messages_test.dart`
- `test/models/remote/event_models_test.dart`

### Definition of Done (verifiable conditions with commands)
- All targeted model tests pass with `flutter test test/models/remote`.
- Whole-project tests still pass with `flutter test`.
- Changed files are formatted with `dart format --output=none --set-exit-if-changed lib/models/remote test/models/remote`.
- Model barrel imports compile in tests without touching UI/provider files.
- If `flutter analyze` is still blocked by the known repo-level `analysis_options.yaml` caveat documented in `/Users/fingerfrings/code/my-code/flutter/opencode-app/AGENTS.md:36`, the executor captures the blocker in evidence and verifies no new LSP diagnostics exist in changed model files.

### Must Have
- Port every exported non-runtime type from these files only:
  - `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/shared.ts`
  - `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/app.ts`
  - `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/config.ts`
  - `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/file.ts`
  - `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/find.ts`
  - `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts`
  - `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/event.ts`
- Include request/response DTO types and trivial alias types exported from the selected files, not just persisted entity types.
- Use immutable Dart classes with `final` fields and `const` constructors where practical.
- Represent discriminated unions with `sealed class` bases plus concrete `final class` variants.
- Preserve source field names conceptually; only rename Dart identifiers when needed for idiomatic casing or collision avoidance.
- Preserve TS optionality as nullable Dart fields.
- Prefix ambiguous public type names with `Opencode` to avoid collisions (`Model`, `Event`, `File`, `Session`, etc.).
- Keep nested TS namespace types as top-level prefixed Dart types.
- Treat this migration as remote transport models only; reserve `lib/models/local/` for app-owned persisted/local-state models.

### Must NOT Have (guardrails, AI slop patterns, scope boundaries)
- No work in `tui.ts` for this plan; it is optional and not required for minimum complete SDK interaction.
- No local persistence model work under `lib/models/local/` in this plan.
- No port of runtime classes or helpers from `../core/`, `../internal/`, or streaming/request infrastructure.
- No `fromJson`, `toJson`, `json_serializable`, `freezed`, `equatable`, `copyWith`, repository, provider, storage, router, or UI work.
- No attempt to redesign the source schema into app-specific domain objects.
- No flattening of event/session union structures into generic catch-all models.
- No new package dependencies unless execution discovers a hard compiler requirement, which is not expected for this scope.

## Verification Strategy
> ZERO HUMAN INTERVENTION — all verification is agent-executed.
- Test decision: tests-after with `flutter_test`
- QA policy: Every task includes a targeted unit test plus a command-based verification step.
- Evidence: `.sisyphus/evidence/task-{N}-{slug}.{ext}`
- Analyzer policy: Prefer `flutter analyze`; if the repo-wide analyzer caveat remains, capture output and fall back to LSP diagnostics plus passing tests/format checks for changed files.

## Execution Strategy
### Parallel Execution Waves
> Target: 5-8 tasks per wave. <3 per wave (except final) = under-splitting.
> Extract shared dependencies as Wave-1 tasks for max parallelism.

Wave 1: remote shared errors, remote app models, remote config models, remote file models, remote find models
Wave 2: remote session primitives, remote session parts, remote session request DTOs, remote session message/response union
Wave 3: remote event union, remote barrel export and convergence verification

### Dependency Matrix (full, all tasks)
- T1 Shared errors -> blocks T9, T10
- T2 App models -> blocks T11 verification only
- T3 Config models -> blocks T11 verification only
- T4 File models -> blocks T11 verification only
- T5 Find models -> blocks T11 verification only
- T6 Session primitives -> blocks T7, T8, T9, T10
- T7 Session parts -> blocks T8, T9, T10
- T8 Session request DTOs -> blocks T11 verification only
- T9 Session message union -> blocks T10, T11
- T10 Event union -> blocks T11
- T11 Barrel export and convergence verification -> final implementation task

### Agent Dispatch Summary (wave -> task count -> categories)
- Wave 1 -> 5 tasks -> `quick` for shared/app/config/file/find DTO slices
- Wave 2 -> 4 tasks -> `unspecified-high` for session primitive/part/message slices, `quick` for request DTO slice
- Wave 3 -> 2 tasks -> `unspecified-high` for event unions, `quick` for barrel export and convergence

## TODOs
> Implementation + Test = ONE task. Never separate.
> EVERY task MUST have: Agent Profile + Parallelization + QA Scenarios.

- [ ] 1. Port shared error models

  **What to do**: Create `lib/models/remote/shared_errors.dart` and `test/models/remote/shared_errors_test.dart`. Port `MessageAbortedError`, `ProviderAuthError`, `ProviderAuthError.Data`, `UnknownError`, and `UnknownError.Data` from the source into immutable Dart types. Use `Opencode` prefixes for all public types, keep `name` as a required `String`, and represent TS `unknown` as `Object?`.
  **Must NOT do**: Do not add JSON helpers, equality libraries, exception hierarchies, or any dependency outside `flutter_test`.

  **Recommended Agent Profile**:
  - Category: `quick` — Reason: small isolated file pair with no cross-module dependencies.
  - Skills: `[]` — no special skill required.
  - Omitted: `playwright-cli` — no browser/UI work involved.

  **Parallelization**: Can Parallel: YES | Wave 1 | Blocks: T9, T10 | Blocked By: none

  **References** (executor has NO interview context — be exhaustive):
  - Pattern: `/Users/fingerfrings/code/my-code/flutter/opencode-app/AGENTS.md:145` — `lib/models/` is the recommended location for data structures.
  - Pattern: `/Users/fingerfrings/code/my-code/flutter/opencode-app/lib/theme/opencode_theme.dart:3` — keep model files as plain Dart types without framework-heavy abstractions.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/shared.ts:3` — `MessageAbortedError` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/shared.ts:9` — `ProviderAuthError` root shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/shared.ts:16` — nested `ProviderAuthError.Data` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/shared.ts:23` — `UnknownError` root shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/shared.ts:30` — nested `UnknownError.Data` shape.

  **Acceptance Criteria** (agent-executable only):
  - [ ] `flutter test test/models/remote/shared_errors_test.dart` exits 0.
  - [ ] `dart format --output=none --set-exit-if-changed lib/models/remote/shared_errors.dart test/models/remote/shared_errors_test.dart` exits 0.

  **QA Scenarios** (MANDATORY — task incomplete without these):
  ```
  Scenario: Happy path shared error instantiation
    Tool: Bash
    Steps: Run `flutter test test/models/remote/shared_errors_test.dart` with tests that instantiate each shared error type and assert every field is exposed with the expected Dart type.
    Expected: Test output shows the shared error test file passes with exit code 0.
    Evidence: .sisyphus/evidence/task-1-shared-errors.txt

  Scenario: Edge case optional unknown payload retention
    Tool: Bash
    Steps: Include a test case that stores map and list values inside `Object? data` fields and asserts the values remain accessible without extra casting helpers.
    Expected: The edge-case test passes and no helper/serializer files are introduced.
    Evidence: .sisyphus/evidence/task-1-shared-errors-edge.txt
  ```

  **Commit**: NO | Message: `feat(models): add shared and app opencode models` | Files: `lib/models/remote/shared_errors.dart`, `test/models/remote/shared_errors_test.dart`

- [ ] 2. Port app models and alias DTOs

  **What to do**: Create `lib/models/remote/app_models.dart` and `test/models/remote/app_models_test.dart`. Port `App`, `App.Path`, `App.Time`, `Mode`, `Mode.Model`, `Model`, `Model.Cost`, `Model.Limit`, `Provider`, `AppInitResponse`, `AppLogResponse`, `AppModesResponse`, `AppProvidersResponse`, and `AppLogParams`. Use prefixed top-level type names such as `OpencodeApp`, `OpencodeModel`, and `OpencodeProvider`. Convert TS object index signatures into typed Dart maps: `Map<String, bool>`, `Map<String, OpencodeModel>`, `Map<String, String>`, and `Map<String, Object?>`.
  **Must NOT do**: Do not port `AppResource`, request methods, or `APIPromise`/request option types.

  **Recommended Agent Profile**:
  - Category: `quick` — Reason: bounded file with simple nested types and aliases.
  - Skills: `[]` — no special skill required.
  - Omitted: `git-master` — no git work belongs inside implementation.

  **Parallelization**: Can Parallel: YES | Wave 1 | Blocks: T11 | Blocked By: none

  **References** (executor has NO interview context — be exhaustive):
  - Pattern: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/index.ts:5` — confirms `App`, `Mode`, `Model`, `Provider`, response aliases, and `AppLogParams` are part of the exported surface.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/app.ts:44` — `App` root shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/app.ts:55` — `App.Path` nested shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/app.ts:67` — `App.Time` optional timestamp field.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/app.ts:72` — `Mode` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/app.ts:85` — `Mode.Model` nested shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/app.ts:92` — `Model` shape with mixed-case field names.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/app.ts:115` — `Model.Cost` nested shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/app.ts:125` — `Model.Limit` nested shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/app.ts:132` — `Provider` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/app.ts:146` — boolean/list alias responses.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/app.ts:152` — `AppProvidersResponse` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/app.ts:158` — `AppLogParams` literal-union field requirements.

  **Acceptance Criteria** (agent-executable only):
  - [ ] `flutter test test/models/remote/app_models_test.dart` exits 0.
  - [ ] `dart format --output=none --set-exit-if-changed lib/models/remote/app_models.dart test/models/remote/app_models_test.dart` exits 0.

  **QA Scenarios** (MANDATORY — task incomplete without these):
  ```
  Scenario: Happy path app model coverage
    Tool: Bash
    Steps: Run `flutter test test/models/remote/app_models_test.dart` with tests that instantiate representative `OpencodeApp`, `OpencodeModel`, `OpencodeProvider`, and alias wrappers using sample maps and optional fields.
    Expected: The app model test file passes with exit code 0 and proves all exported non-runtime app types are constructible.
    Evidence: .sisyphus/evidence/task-2-app-models.txt

  Scenario: Edge case optional and mixed-key maps
    Tool: Bash
    Steps: Add tests that leave optional fields like `initialized`, `model`, `prompt`, `temperature`, `api`, and `npm` unset while also asserting maps such as `tools`, `default`, and `options` retain their declared generic types.
    Expected: Tests pass without introducing serialization or helper packages.
    Evidence: .sisyphus/evidence/task-2-app-models-edge.txt
  ```

  **Commit**: YES | Message: `feat(models): add shared and app opencode models` | Files: `lib/models/remote/shared_errors.dart`, `lib/models/remote/app_models.dart`, `test/models/remote/shared_errors_test.dart`, `test/models/remote/app_models_test.dart`

- [ ] 3. Port config models

  **What to do**: Create `lib/models/remote/config_models.dart` and `test/models/remote/config_models_test.dart`. Port `Config`, `Config.Agent`, `Config.Agent.General`, `Config.Agent.AgentConfig`, `Config.Experimental`, `Config.Experimental.Hook`, `Config.Experimental.Hook.FileEdited`, `Config.Experimental.Hook.SessionCompleted`, `Config.Mode`, `Config.Provider`, `Config.Provider.Models`, `Config.Provider.Models.Cost`, `Config.Provider.Models.Limit`, `Config.Provider.Options`, `KeybindsConfig`, `McpLocalConfig`, `McpRemoteConfig`, and `ModeConfig`. Preserve the dictionary-heavy structure with typed maps and keep literal discriminators like `type: 'local' | 'remote'` intact.
  **Must NOT do**: Do not port `ConfigResource`, and do not collapse the nested config namespaces into unrelated domain abstractions.

  **Recommended Agent Profile**:
  - Category: `quick` — Reason: large surface but mostly plain DTOs and nested map shapes.
  - Skills: `[]` — no special skill required.
  - Omitted: `playwright-cli` — no UI/browser behavior involved.

  **Parallelization**: Can Parallel: YES | Wave 1 | Blocks: T11 | Blocked By: none

  **References** (executor has NO interview context — be exhaustive):
  - Pattern: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/index.ts:16` — confirms `Config`, `KeybindsConfig`, `McpLocalConfig`, `McpRemoteConfig`, and `ModeConfig` are exported remote types.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/config.ts:17` — `Config` root shape and nested config namespaces.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/config.ts:104` — `Config.Agent` and nested `General` / `AgentConfig` shapes.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/config.ts:132` — `Config.Experimental` and hook payloads.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/config.ts:161` — `Config.Mode` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/config.ts:169` — `Config.Provider` and nested `Models` / `Options`.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/config.ts:236` — `KeybindsConfig` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/config.ts:428` — `McpLocalConfig` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/config.ts:450` — `McpRemoteConfig` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/config.ts:472` — `ModeConfig` shape.

  **Acceptance Criteria** (agent-executable only):
  - [ ] `flutter test test/models/remote/config_models_test.dart` exits 0.
  - [ ] `dart format --output=none --set-exit-if-changed lib/models/remote/config_models.dart test/models/remote/config_models_test.dart` exits 0.

  **QA Scenarios** (MANDATORY — task incomplete without these):
  ```
  Scenario: Happy path config model coverage
    Tool: Bash
    Steps: Run `flutter test test/models/remote/config_models_test.dart` with tests that instantiate representative `OpencodeConfig`, MCP configs, provider configs, and keybind configs using nested maps.
    Expected: The config model test file passes with exit code 0.
    Evidence: .sisyphus/evidence/task-3-config-models.txt

  Scenario: Edge case nested optional config maps
    Tool: Bash
    Steps: Add tests that omit optional config sections like `experimental`, `instructions`, `provider`, `mcp`, `headers`, and `environment` while preserving required discriminators on MCP configs.
    Expected: Tests pass and confirm nullable config sections are represented without placeholder values.
    Evidence: .sisyphus/evidence/task-3-config-models-edge.txt
  ```

  **Commit**: YES | Message: `feat(models): add config remote models` | Files: `lib/models/remote/config_models.dart`, `test/models/remote/config_models_test.dart`

- [ ] 4. Port file models

  **What to do**: Create `lib/models/remote/file_models.dart` and `test/models/remote/file_models_test.dart`. Port `File`, `FileReadResponse`, `FileStatusResponse`, and `FileReadParams` from the SDK export surface. Prefix ambiguous names to avoid colliding with `dart:io` and Flutter symbols.
  **Must NOT do**: Do not port `FileResource`, and do not mix file DTOs into session part models.

  **Recommended Agent Profile**:
  - Category: `quick` — Reason: very small isolated remote DTO surface.
  - Skills: `[]` — no special skill required.
  - Omitted: `frontend-ui-ux` — no visual task.

  **Parallelization**: Can Parallel: YES | Wave 1 | Blocks: T11 | Blocked By: none

  **References** (executor has NO interview context — be exhaustive):
  - Pattern: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/index.ts:25` — confirms exported file model surface.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/file.ts:23` — `File` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/file.ts:33` — `FileReadResponse` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/file.ts:39` — `FileStatusResponse` alias.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/file.ts:41` — `FileReadParams` shape.

  **Acceptance Criteria** (agent-executable only):
  - [ ] `flutter test test/models/remote/file_models_test.dart` exits 0.
  - [ ] `dart format --output=none --set-exit-if-changed lib/models/remote/file_models.dart test/models/remote/file_models_test.dart` exits 0.

  **QA Scenarios** (MANDATORY — task incomplete without these):
  ```
  Scenario: Happy path file model coverage
    Tool: Bash
    Steps: Run `flutter test test/models/remote/file_models_test.dart` with tests that instantiate file status items, read responses, and read params using each allowed status/type discriminator.
    Expected: The file model test file passes with exit code 0.
    Evidence: .sisyphus/evidence/task-4-file-models.txt

  Scenario: Edge case file discriminator values
    Tool: Bash
    Steps: Add tests that cover all literal unions for `status` and `type` so no discriminator case is omitted.
    Expected: Tests pass and prove the remote file model surface covers every SDK literal value.
    Evidence: .sisyphus/evidence/task-4-file-models-edge.txt
  ```

  **Commit**: YES | Message: `feat(models): add file remote models` | Files: `lib/models/remote/file_models.dart`, `test/models/remote/file_models_test.dart`

- [ ] 5. Port find/search models

  **What to do**: Create `lib/models/remote/find_models.dart` and `test/models/remote/find_models_test.dart`. Port `Symbol`, `Symbol.Location`, `Symbol.Location.Range`, `Symbol.Location.Range.Start`, `Symbol.Location.Range.End`, `FindFilesResponse`, `FindSymbolsResponse`, `FindTextResponse`, `FindTextResponse.FindTextResponseItem`, `FindTextResponse.FindTextResponseItem.Lines`, `FindTextResponse.FindTextResponseItem.Path`, `FindTextResponse.FindTextResponseItem.Submatch`, `FindTextResponse.FindTextResponseItem.Submatch.Match`, `FindFilesParams`, `FindSymbolsParams`, and `FindTextParams`.
  **Must NOT do**: Do not port the runtime `Find` resource class, and do not merge these search DTOs into session symbol-source models just because they have similarly named range fields.

  **Recommended Agent Profile**:
  - Category: `quick` — Reason: standalone DTO surface with nested but conventional shapes.
  - Skills: `[]` — no special skill required.
  - Omitted: `playwright-cli` — no browser interaction involved.

  **Parallelization**: Can Parallel: YES | Wave 1 | Blocks: T11 | Blocked By: none

  **References** (executor has NO interview context — be exhaustive):
  - Pattern: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/index.ts:32` — confirms exported find/search model surface.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/find.ts:30` — `Symbol` shape and nested location/range types.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/find.ts:68` — `FindFilesResponse` alias.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/find.ts:70` — `FindSymbolsResponse` alias.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/find.ts:72` — `FindTextResponse` and nested item shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/find.ts:112` — `FindFilesParams` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/find.ts:116` — `FindSymbolsParams` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/find.ts:120` — `FindTextParams` shape.

  **Acceptance Criteria** (agent-executable only):
  - [ ] `flutter test test/models/remote/find_models_test.dart` exits 0.
  - [ ] `dart format --output=none --set-exit-if-changed lib/models/remote/find_models.dart test/models/remote/find_models_test.dart` exits 0.

  **QA Scenarios** (MANDATORY — task incomplete without these):
  ```
  Scenario: Happy path find model coverage
    Tool: Bash
    Steps: Run `flutter test test/models/remote/find_models_test.dart` with tests that instantiate symbol search results, text-search results, and every param DTO.
    Expected: The find model test file passes with exit code 0.
    Evidence: .sisyphus/evidence/task-5-find-models.txt

  Scenario: Edge case nested text-search spans
    Tool: Bash
    Steps: Add tests that cover nested range, line, path, and submatch match-text fields so the deeply nested search result shape is fully represented.
    Expected: Tests pass and prove the nested search result types are complete.
    Evidence: .sisyphus/evidence/task-5-find-models-edge.txt
  ```

  **Commit**: YES | Message: `feat(models): add find remote models` | Files: `lib/models/remote/find_models.dart`, `test/models/remote/find_models_test.dart`

- [ ] 6. Port session primitives and stable entity models

  **What to do**: Create `lib/models/remote/session_primitives.dart` and `test/models/remote/session_primitives_test.dart`. Port the session types that do not depend on the `Part` or `Message` unions: `Session`, `Session.Time`, `Session.Revert`, `Session.Share`, `FilePartSourceText`, `FileSource`, `SymbolSource`, `SymbolSource.Range`, `SymbolSource.Range.Start`, `SymbolSource.Range.End`, `UserMessage`, `SessionListResponse`, `SessionDeleteResponse`, `SessionAbortResponse`, and `SessionInitResponse`. Define `OpencodeFilePartSource` here as a sealed base with exactly two variants: `OpencodeFileSource` and `OpencodeSymbolSource`. Keep raw numeric time fields as Dart numeric fields; do not upgrade them to `DateTime`.
  **Must NOT do**: Do not include `AssistantMessage`, any `Part` variant, `ToolPart`, or request-param models in this file.

  **Recommended Agent Profile**:
  - Category: `unspecified-high` — Reason: the file is larger and establishes naming conventions reused by later union work.
  - Skills: `[]` — no special skill required.
  - Omitted: `playwright-cli` — unit-model task with no UI.

  **Parallelization**: Can Parallel: YES | Wave 2 | Blocks: T7, T8, T9, T10 | Blocked By: none

  **References** (executor has NO interview context — be exhaustive):
  - Pattern: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/index.ts:42` — confirms the selected session surface and exported alias names.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:204` — `FilePartSourceText` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:212` — `FileSource` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:247` — `Session` root shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:264` — `Session.Time` nested shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:270` — `Session.Revert` nested shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:280` — `Session.Share` nested shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:341` — `SymbolSource` and nested range types.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:499` — `UserMessage` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:515` — list/bool alias responses.

  **Acceptance Criteria** (agent-executable only):
  - [ ] `flutter test test/models/remote/session_primitives_test.dart` exits 0.
  - [ ] `dart format --output=none --set-exit-if-changed lib/models/remote/session_primitives.dart test/models/remote/session_primitives_test.dart` exits 0.

  **QA Scenarios** (MANDATORY — task incomplete without these):
  ```
  Scenario: Happy path primitive session model coverage
    Tool: Bash
    Steps: Run `flutter test test/models/remote/session_primitives_test.dart` with tests that construct representative session, source-text, file-source, symbol-source, and user-message instances.
    Expected: The primitive session model test file passes with exit code 0.
    Evidence: .sisyphus/evidence/task-3-session-primitives.txt

  Scenario: Edge case nullable nested session metadata
    Tool: Bash
    Steps: Add tests that omit `parentID`, `revert`, `share`, `diff`, `partID`, and `snapshot` while keeping required fields present.
    Expected: Tests pass and confirm optional TS fields map to nullable Dart fields without placeholder defaults.
    Evidence: .sisyphus/evidence/task-3-session-primitives-edge.txt
  ```

  **Commit**: NO | Message: `feat(models): add session primitives and part unions` | Files: `lib/models/remote/session_primitives.dart`, `test/models/remote/session_primitives_test.dart`

- [ ] 7. Port session part unions and tool state hierarchy

  **What to do**: Create `lib/models/remote/session_parts.dart` and `test/models/remote/session_parts_test.dart`. Port `FilePart`, `Part`, `Part.PatchPart`, `SnapshotPart`, `StepStartPart`, `TextPart`, `ToolPart`, `StepFinishPart`, `StepFinishPart.Tokens`, `StepFinishPart.Tokens.Cache`, `ToolStatePending`, `ToolStateRunning`, `ToolStateRunning.Time`, `ToolStateCompleted`, `ToolStateCompleted.Time`, `ToolStateError`, and `ToolStateError.Time`. Implement `OpencodeSessionPart` as a sealed base with concrete variants for `text`, `file`, `tool`, `step-start`, `step-finish`, `snapshot`, and `patch`. Implement `OpencodeToolState` as a separate sealed base keyed by `status`.
  **Must NOT do**: Do not place `TextPartInput`, `FilePartInput`, `AssistantMessage`, or request DTOs in this file.

  **Recommended Agent Profile**:
  - Category: `unspecified-high` — Reason: sealed-union design with multiple cross-type references and higher drift risk.
  - Skills: `[]` — no special skill required.
  - Omitted: `frontend-ui-ux` — no presentation work.

  **Parallelization**: Can Parallel: YES | Wave 2 | Blocks: T8, T9, T10 | Blocked By: T6

  **References** (executor has NO interview context — be exhaustive):
  - Pattern: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:222` — `Part` union membership.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:170` — `FilePart` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:231` — `Part.PatchPart` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:285` — `SnapshotPart` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:297` — `StepFinishPart` and token nesting.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:331` — `StepStartPart` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:311` — `StepFinishPart.Tokens` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:377` — `TextPart` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:421` — `ToolPart` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:437` — `ToolStateCompleted` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:459` — `ToolStateError` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:477` — `ToolStatePending` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:481` — `ToolStateRunning` shape.

  **Acceptance Criteria** (agent-executable only):
  - [ ] `flutter test test/models/remote/session_parts_test.dart` exits 0.
  - [ ] `dart format --output=none --set-exit-if-changed lib/models/remote/session_parts.dart test/models/remote/session_parts_test.dart` exits 0.

  **QA Scenarios** (MANDATORY — task incomplete without these):
  ```
  Scenario: Happy path sealed part coverage
    Tool: Bash
    Steps: Run `flutter test test/models/remote/session_parts_test.dart` with tests that instantiate each `OpencodeSessionPart` subclass and each `OpencodeToolState` subclass, then assert exhaustive pattern matching over the sealed bases.
    Expected: The part-union test file passes with exit code 0.
    Evidence: .sisyphus/evidence/task-4-session-parts.txt

  Scenario: Edge case nested optional runtime metadata
    Tool: Bash
    Steps: Add tests that omit `synthetic`, `time.end`, `input`, `metadata`, and `title` where optional, while preserving required discriminators.
    Expected: Tests pass and prove optional nested metadata does not force placeholder values.
    Evidence: .sisyphus/evidence/task-4-session-parts-edge.txt
  ```

  **Commit**: NO | Message: `feat(models): add session primitives and part unions` | Files: `lib/models/remote/session_primitives.dart`, `lib/models/remote/session_parts.dart`, `test/models/remote/session_primitives_test.dart`, `test/models/remote/session_parts_test.dart`

- [ ] 8. Port session request DTOs and source-input unions

  **What to do**: Create `lib/models/remote/session_requests.dart` and `test/models/remote/session_requests_test.dart`. Port `FilePartInput`, `TextPartInput`, `SessionChatParams`, `SessionInitParams`, `SessionRevertParams`, and `SessionSummarizeParams`. Reuse the `OpencodeFilePartSource` sealed base established in T3 for `source` fields, and keep request DTOs separate from read-only message/part models.
  **Must NOT do**: Do not merge request DTOs into `session_parts.dart`, and do not pull in any request option or network-layer types.

  **Recommended Agent Profile**:
  - Category: `quick` — Reason: mostly DTO and alias plumbing once session primitives exist.
  - Skills: `[]` — no special skill required.
  - Omitted: `git-master` — commits happen only at the planned milestone.

  **Parallelization**: Can Parallel: YES | Wave 2 | Blocks: T11 | Blocked By: T6

  **References** (executor has NO interview context — be exhaustive):
  - Pattern: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/index.ts:43` — confirms the exported request/input and alias session surface.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:188` — `FilePartInput` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:202` — `FilePartSource` union alias.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:401` — `TextPartInput` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:535` — `SessionChatParams` request DTO.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:551` — `SessionInitParams` request DTO.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:559` — `SessionRevertParams` request DTO.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:565` — `SessionSummarizeParams` request DTO.

  **Acceptance Criteria** (agent-executable only):
  - [ ] `flutter test test/models/remote/session_requests_test.dart` exits 0.
  - [ ] `dart format --output=none --set-exit-if-changed lib/models/remote/session_requests.dart test/models/remote/session_requests_test.dart` exits 0.

  **QA Scenarios** (MANDATORY — task incomplete without these):
  ```
  Scenario: Happy path request DTO coverage
    Tool: Bash
    Steps: Run `flutter test test/models/remote/session_requests_test.dart` with tests that instantiate every request DTO and both `FilePartSource` variants using concrete source-text fixtures.
    Expected: The request DTO test file passes with exit code 0.
    Evidence: .sisyphus/evidence/task-5-session-requests.txt

  Scenario: Edge case omitted optional request metadata
    Tool: Bash
    Steps: Add tests that leave `id`, `filename`, `source`, `messageID`, `mode`, `system`, `tools`, and `partID` unset where optional.
    Expected: Tests pass and confirm the Dart constructors mirror TS optionality exactly.
    Evidence: .sisyphus/evidence/task-5-session-requests-edge.txt
  ```

  **Commit**: YES | Message: `feat(models): add session primitives and part unions` | Files: `lib/models/remote/session_primitives.dart`, `lib/models/remote/session_parts.dart`, `lib/models/remote/session_requests.dart`, `test/models/remote/session_primitives_test.dart`, `test/models/remote/session_parts_test.dart`, `test/models/remote/session_requests_test.dart`

- [ ] 9. Port session message union, assistant error hierarchy, and message response wrappers

  **What to do**: Create `lib/models/remote/session_messages.dart` and `test/models/remote/session_messages_test.dart`. Port `AssistantMessage`, `AssistantMessage.Path`, `AssistantMessage.Time`, `AssistantMessage.Tokens`, `AssistantMessage.Tokens.Cache`, `AssistantMessage.MessageOutputLengthError`, `Message`, `SessionMessagesResponse`, `SessionMessagesResponse.SessionMessagesResponseItem`, and `SessionSummarizeResponse`. Implement `OpencodeMessage` as a sealed base with exactly two variants: `OpencodeUserMessage` from T3 and `OpencodeAssistantMessage` from this task. Model the `AssistantMessage.error` union as a sealed base that can wrap `OpencodeProviderAuthError`, `OpencodeUnknownError`, `OpencodeMessageAbortedError`, and a new `OpencodeMessageOutputLengthError`.
  **Must NOT do**: Do not redefine `UserMessage`, `Part`, or shared error models already created in earlier tasks; import and reuse them.

  **Recommended Agent Profile**:
  - Category: `unspecified-high` — Reason: cross-file union composition with the highest risk of duplicate or conflicting type names.
  - Skills: `[]` — no special skill required.
  - Omitted: `frontend-ui-ux` — non-visual task.

  **Parallelization**: Can Parallel: YES | Wave 2 | Blocks: T10, T11 | Blocked By: T1, T6, T7

  **References** (executor has NO interview context — be exhaustive):
  - Pattern: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/index.ts:43` — confirms `AssistantMessage`, `Message`, and `Part` are exported session models.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:100` — `AssistantMessage` root shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:132` — `AssistantMessage.Path` nested shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:139` — `AssistantMessage.Time` nested shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:145` — `AssistantMessage.Tokens` nested shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:156` — `AssistantMessage.Tokens.Cache` nested shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:163` — `AssistantMessage.MessageOutputLengthError` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:220` — `Message` union membership.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:523` — `SessionMessagesResponse` alias.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:526` — `SessionMessagesResponseItem` nested shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/session.ts:533` — `SessionSummarizeResponse` alias.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/shared.ts:3` — shared error types reused by `AssistantMessage.error`.

  **Acceptance Criteria** (agent-executable only):
  - [ ] `flutter test test/models/remote/session_messages_test.dart` exits 0.
  - [ ] `dart format --output=none --set-exit-if-changed lib/models/remote/session_messages.dart test/models/remote/session_messages_test.dart` exits 0.

  **QA Scenarios** (MANDATORY — task incomplete without these):
  ```
  Scenario: Happy path message union coverage
    Tool: Bash
    Steps: Run `flutter test test/models/remote/session_messages_test.dart` with tests that instantiate a user message and an assistant message, store them behind `OpencodeMessage`, build a `SessionMessagesResponse` wrapper, and verify exhaustive `switch` handling over the sealed union.
    Expected: The session message test file passes with exit code 0.
    Evidence: .sisyphus/evidence/task-6-session-messages.txt

  Scenario: Edge case assistant error variants
    Tool: Bash
    Steps: Add tests that attach each supported assistant error variant, including `OpencodeMessageOutputLengthError`, and assert that nullable `error` and `summary` fields can also be absent.
    Expected: Tests pass and prove the assistant message union composes existing shared errors instead of duplicating them.
    Evidence: .sisyphus/evidence/task-6-session-messages-edge.txt
  ```

  **Commit**: NO | Message: `feat(models): add session message and event unions` | Files: `lib/models/remote/session_messages.dart`, `test/models/remote/session_messages_test.dart`

- [ ] 10. Port event union models with session/shared composition

  **What to do**: Create `lib/models/remote/event_models.dart` and `test/models/remote/event_models_test.dart`. Port `EventListResponse` and every nested variant from `EventListResponse.EventInstallationUpdated` through `EventListResponse.EventIdeInstalled`, plus all nested `Properties` types and the event-local `MessageOutputLengthError` shape under `EventSessionError.Properties`. Implement one sealed base `OpencodeEventListResponse` with a concrete Dart type per TS event variant. Reuse session/shared models for nested `info`, `part`, and error fields.
  **Must NOT do**: Do not port the runtime `Event` API class from `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/event.ts:10`, and do not invent fallback event wrappers.

  **Recommended Agent Profile**:
  - Category: `unspecified-high` — Reason: largest union surface and highest dependency count.
  - Skills: `[]` — no special skill required.
  - Omitted: `playwright-cli` — no browser interaction involved.

  **Parallelization**: Can Parallel: NO | Wave 3 | Blocks: T11 | Blocked By: T1, T6, T7, T9

  **References** (executor has NO interview context — be exhaustive):
  - Pattern: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/index.ts:24` — only `EventListResponse` is in scope, not the runtime `Event` resource.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/event.ts:19` — complete `EventListResponse` union membership.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/event.ts:37` — `EventInstallationUpdated` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/event.ts:49` — `EventLspClientDiagnostics` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/event.ts:63` — `EventMessageUpdated` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/event.ts:75` — `EventMessageRemoved` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/event.ts:89` — `EventMessagePartUpdated` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/event.ts:101` — `EventMessagePartRemoved` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/event.ts:115` — `EventStorageWrite` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/event.ts:129` — `EventPermissionUpdated` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/event.ts:155` — `EventFileEdited` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/event.ts:167` — `EventSessionUpdated` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/event.ts:179` — `EventSessionDeleted` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/event.ts:191` — `EventSessionIdle` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/event.ts:203` — `EventSessionError` and nested local error type.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/event.ts:229` — `EventFileWatcherUpdated` shape.
  - API/Type: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/event.ts:243` — `EventIdeInstalled` shape.

  **Acceptance Criteria** (agent-executable only):
  - [ ] `flutter test test/models/remote/event_models_test.dart` exits 0.
  - [ ] `dart format --output=none --set-exit-if-changed lib/models/remote/event_models.dart test/models/remote/event_models_test.dart` exits 0.

  **QA Scenarios** (MANDATORY — task incomplete without these):
  ```
  Scenario: Happy path event union coverage
    Tool: Bash
    Steps: Run `flutter test test/models/remote/event_models_test.dart` with tests that instantiate at least one representative variant for every event family and verify exhaustive switching over `OpencodeEventListResponse`.
    Expected: The event model test file passes with exit code 0.
    Evidence: .sisyphus/evidence/task-7-event-models.txt

  Scenario: Edge case nested shared/session reuse
    Tool: Bash
    Steps: Add tests that use `OpencodeSession`, `OpencodeMessage`, `OpencodeSessionPart`, and shared error variants inside event payloads such as `message.updated`, `message.part.updated`, `session.updated`, and `session.error`.
    Expected: Tests pass and no duplicate local copies of session/shared models are introduced.
    Evidence: .sisyphus/evidence/task-7-event-models-edge.txt
  ```

  **Commit**: YES | Message: `feat(models): add session message and event unions` | Files: `lib/models/remote/session_messages.dart`, `lib/models/remote/event_models.dart`, `test/models/remote/session_messages_test.dart`, `test/models/remote/event_models_test.dart`

- [ ] 11. Add barrel exports and run convergence verification

  **What to do**: Create `lib/models/remote/remote_models.dart` as the sole barrel for the new remote model layer, exporting the seven model files in dependency order. Add or update any minimal import smoke tests needed so every new model file is reachable from the barrel without touching `lib/main.dart` or provider/theme files. Do not create any files under `lib/models/local/`; that directory remains reserved for future local-only models. Run the targeted model test directory, full test suite, formatting verification, and analyzer/LSP verification policy from this plan.
  **Must NOT do**: Do not wire the barrel into UI code, and do not alter theme/provider files just to “use” the new models.

  **Recommended Agent Profile**:
  - Category: `quick` — Reason: small export surface plus repository-wide verification.
  - Skills: `[]` — no special skill required.
  - Omitted: `agent-tmux` — no long-lived service is required.

  **Parallelization**: Can Parallel: NO | Wave 3 | Blocks: none | Blocked By: T2, T3, T4, T5, T8, T9, T10

  **References** (executor has NO interview context — be exhaustive):
  - Pattern: `/Users/fingerfrings/code/open-source/opencode-sdk-js/src/resources/index.ts:3` — source-side export boundary to mirror as a Dart barrel.
  - Pattern: `/Users/fingerfrings/code/my-code/flutter/opencode-app/lib/main.dart:1` — current app entry should remain untouched by this model-only migration.
  - Pattern: `/Users/fingerfrings/code/my-code/flutter/opencode-app/lib/theme/theme_provider.dart:1` — provider/theme layer is explicitly out of scope.
  - Test: `/Users/fingerfrings/code/my-code/flutter/opencode-app/test/widget_test.dart:15` — existing widget test should keep passing after the model-only addition.
  - Guardrail: `/Users/fingerfrings/code/my-code/flutter/opencode-app/AGENTS.md:36` — known analyzer caveat and command guidance.

  **Acceptance Criteria** (agent-executable only):
  - [ ] `flutter test test/models/remote` exits 0.
  - [ ] `flutter test` exits 0.
  - [ ] `dart format --output=none --set-exit-if-changed lib/models/remote test/models/remote` exits 0.
  - [ ] `flutter analyze` exits 0, or its pre-existing blocker is captured to `.sisyphus/evidence/task-8-analyze-blocker.txt` and changed files show no new LSP diagnostics.

  **QA Scenarios** (MANDATORY — task incomplete without these):
  ```
  Scenario: Happy path barrel import convergence
    Tool: Bash
    Steps: Run `flutter test test/models/remote` after adding a smoke test that imports only `package:opencode_app/models/remote/remote_models.dart` and instantiates representative types from shared, app, session, and event files.
    Expected: The full model test directory passes with exit code 0.
    Evidence: .sisyphus/evidence/task-8-model-suite.txt

  Scenario: Edge case repository verification with analyzer caveat
    Tool: Bash
    Steps: Run `flutter test`, `dart format --output=none --set-exit-if-changed lib/models/remote test/models/remote`, and `flutter analyze`; if analyze still fails because of the known root config caveat, save the exact output and confirm changed model files have no LSP errors.
    Expected: Tests and format checks pass; analyzer either passes or the pre-existing blocker is documented with no new model-file diagnostics.
    Evidence: .sisyphus/evidence/task-8-repo-verification.txt
  ```

  **Commit**: YES | Message: `test(models): add barrel exports and verification coverage` | Files: `lib/models/remote/remote_models.dart`, `test/models/remote/*`

## Final Verification Wave (4 parallel agents, ALL must APPROVE)
- [ ] F1. Plan Compliance Audit — oracle
- [ ] F2. Code Quality Review — unspecified-high
- [ ] F3. Real Manual QA — unspecified-high
- [ ] F4. Scope Fidelity Check — deep

## Commit Strategy
- Commit 1: `feat(models): add shared and app remote models`
- Commit 2: `feat(models): add config file and find remote models`
- Commit 3: `feat(models): add session primitives parts and request models`
- Commit 4: `feat(models): add session message and event remote unions`
- Commit 5: `test(models): add remote barrel exports and verification coverage`

## Success Criteria
- The selected TS export surface is mirrored in Dart for `shared`, `app`, `session`, and `event` non-runtime types.
- All new remote model files live under `lib/models/remote/` and are importable from one barrel.
- All new tests live under `test/models/remote/` and pass.
- No source files outside the model/test surface are required for the migration.
- No runtime client, serialization, or UI/provider concerns leak into the implementation.
