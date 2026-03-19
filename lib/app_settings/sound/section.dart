import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import 'providers.dart';

class SoundSection extends ConsumerWidget {
  const SoundSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    // 当前声音设置只有单一开关，但仍保留独立分区，方便后续继续加入提示音类型
    // 或音量策略，而不需要重组页面结构。
    final soundEnabled = ref.watch(soundEnabledProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            localizations.settingsSoundSectionTitle,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SwitchListTile(
          title: Text(localizations.settingsEnableSoundTitle),
          subtitle: Text(localizations.settingsEnableSoundSubtitle),
          value: soundEnabled,
          onChanged: (value) {
            ref.read(soundControllerProvider.notifier).setSoundEnabled(value);
          },
        ),
      ],
    );
  }
}
