# Servers Industrial Visual Refresh Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refresh the `servers` page into a restrained industrial style without changing its current structure or core interactions.

**Architecture:** Keep the existing `ServersScreen` layout and interaction flow intact. Update visual tokens at the page layer and widget layer so the search bar, cards, badges, FAB, and empty state all share the same hard-edge, thin-outline language while still following the active app theme.

**Tech Stack:** Flutter, Material 3, widget tests, Riverpod-managed screen state

---

### Task 1: Lock visual expectations with tests

**Files:**
- Modify: `test/servers/servers_screen_test.dart`

- [ ] **Step 1: Write the failing tests**
- [ ] **Step 2: Run targeted tests to verify they fail for the right reason**
- [ ] **Step 3: Assert industrial visual traits that are stable in tests**
- [ ] **Step 4: Re-run targeted tests after implementation**

### Task 2: Refresh the page shell and search bar

**Files:**
- Modify: `lib/servers/screen.dart`
- Modify: `lib/servers/widgets/server_search_bar.dart`

- [ ] **Step 1: Add page-surface styling without changing layout structure**
- [ ] **Step 2: Convert the search bar to a hard-edge rectangular control**
- [ ] **Step 3: Keep the fixed-position search behavior unchanged**

### Task 3: Refresh cards, badges, and empty state

**Files:**
- Modify: `lib/servers/widgets/server_tile.dart`
- Modify: `lib/servers/widgets/server_health_badge.dart`
- Modify: `lib/servers/widgets/servers_empty_state.dart`

- [ ] **Step 1: Convert cards to thin-outline industrial styling**
- [ ] **Step 2: Rework labels and badges toward mono/system markers**
- [ ] **Step 3: Make the empty state match the new visual language**
- [ ] **Step 4: Tame the FAB so it fits the new surface**

### Task 4: Verify end to end

**Files:**
- Verify: `test/servers/servers_screen_test.dart`
- Verify: `test/widget_test.dart`

- [ ] **Step 1: Run `dart format` on changed Dart files**
- [ ] **Step 2: Run `flutter test test/servers/servers_screen_test.dart`**
- [ ] **Step 3: Run full `flutter test`**
- [ ] **Step 4: Run `flutter analyze`**
- [ ] **Step 5: Run mobile validation on device**
