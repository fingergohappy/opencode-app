import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import 'providers.dart';

class NotificationsSection extends ConsumerWidget {
  const NotificationsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    // 通知开关保持独立 provider，可以避免任意一个通知项变化时牵连其他分区的
    // 控制逻辑一起变复杂。
    final agentNotifications = ref.watch(agentNotificationsProvider);
    final permissionNotifications = ref.watch(permissionNotificationsProvider);
    final errorNotifications = ref.watch(errorNotificationsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            localizations.settingsNotificationsSectionTitle,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SwitchListTile(
          title: Text(localizations.settingsNotificationAgentTitle),
          subtitle: Text(localizations.settingsNotificationAgentSubtitle),
          value: agentNotifications,
          onChanged: (value) {
            ref
                .read(notificationControllerProvider.notifier)
                .setAgentNotifications(value);
          },
        ),
        SwitchListTile(
          title: Text(localizations.settingsNotificationPermissionsTitle),
          subtitle: Text(localizations.settingsNotificationPermissionsSubtitle),
          value: permissionNotifications,
          onChanged: (value) {
            ref
                .read(notificationControllerProvider.notifier)
                .setPermissionNotifications(value);
          },
        ),
        SwitchListTile(
          title: Text(localizations.settingsNotificationErrorsTitle),
          subtitle: Text(localizations.settingsNotificationErrorsSubtitle),
          value: errorNotifications,
          onChanged: (value) {
            ref
                .read(notificationControllerProvider.notifier)
                .setErrorNotifications(value);
          },
        ),
      ],
    );
  }
}
