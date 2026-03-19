import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import 'providers.dart';

class UpdatesSection extends ConsumerWidget {
  const UpdatesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    // 更新设置与通知类似，既要展示当前偏好，也要在切换时立即写回持久化状态。
    final autoCheckUpdates = ref.watch(autoCheckUpdatesProvider);
    final showReleaseNotes = ref.watch(showReleaseNotesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            localizations.settingsUpdatesSectionTitle,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SwitchListTile(
          title: Text(localizations.settingsAutoCheckUpdatesTitle),
          subtitle: Text(localizations.settingsAutoCheckUpdatesSubtitle),
          value: autoCheckUpdates,
          onChanged: (value) {
            ref
                .read(updateControllerProvider.notifier)
                .setAutoCheckUpdates(value);
          },
        ),
        SwitchListTile(
          title: Text(localizations.settingsShowReleaseNotesTitle),
          subtitle: Text(localizations.settingsShowReleaseNotesSubtitle),
          value: showReleaseNotes,
          onChanged: (value) {
            ref
                .read(updateControllerProvider.notifier)
                .setShowReleaseNotes(value);
          },
        ),
      ],
    );
  }
}
