import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import '../locale/model.dart';
import '../locale/providers.dart';
import 'model.dart';
import 'providers.dart';

class GeneralSection extends ConsumerWidget {
  const GeneralSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    // 通用设置集中管理与交互行为相关的偏好，这里直接 watch 细粒度 provider，
    // 让列表项文案和值能跟随设置变化即时刷新。
    final language = ref.watch(appLanguageProvider);
    final showReasoningSummaries = ref.watch(showReasoningSummariesProvider);
    final expandShellToolParts = ref.watch(expandShellToolPartsProvider);
    final expandEditToolParts = ref.watch(expandEditToolPartsProvider);
    final followUpBehavior = ref.watch(followUpBehaviorProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            localizations.settingsGeneralSectionTitle,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          title: Text(localizations.languageLabel),
          subtitle: Text(_languageLabel(localizations, language)),
          trailing: DropdownButton<AppLanguage>(
            key: const ValueKey('language-dropdown'),
            value: language,
            underline: const SizedBox(),
            items: [
              DropdownMenuItem(
                value: AppLanguage.system,
                child: Text(localizations.languageSystem),
              ),
              DropdownMenuItem(
                value: AppLanguage.english,
                child: Text(localizations.languageEnglish),
              ),
              DropdownMenuItem(
                value: AppLanguage.chinese,
                child: Text(localizations.languageChinese),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                ref.read(localeControllerProvider.notifier).setLanguage(value);
              }
            },
          ),
        ),
        SwitchListTile(
          title: Text(localizations.settingsShowReasoningSummariesTitle),
          subtitle: Text(localizations.settingsShowReasoningSummariesSubtitle),
          value: showReasoningSummaries,
          onChanged: (value) {
            ref
                .read(generalControllerProvider.notifier)
                .setShowReasoningSummaries(value);
          },
        ),
        SwitchListTile(
          title: Text(localizations.settingsExpandShellToolPartsTitle),
          subtitle: Text(localizations.settingsExpandShellToolPartsSubtitle),
          value: expandShellToolParts,
          onChanged: (value) {
            ref
                .read(generalControllerProvider.notifier)
                .setExpandShellToolParts(value);
          },
        ),
        SwitchListTile(
          title: Text(localizations.settingsExpandEditToolPartsTitle),
          subtitle: Text(localizations.settingsExpandEditToolPartsSubtitle),
          value: expandEditToolParts,
          onChanged: (value) {
            ref
                .read(generalControllerProvider.notifier)
                .setExpandEditToolParts(value);
          },
        ),
        ListTile(
          title: Text(localizations.settingsFollowUpBehaviorTitle),
          subtitle: Text(
            _followUpBehaviorLabel(localizations, followUpBehavior),
          ),
          trailing: DropdownButton<FollowUpBehavior>(
            value: followUpBehavior,
            underline: const SizedBox(),
            items: [
              DropdownMenuItem(
                value: FollowUpBehavior.auto,
                child: Text(localizations.settingsFollowUpBehaviorAuto),
              ),
              DropdownMenuItem(
                value: FollowUpBehavior.manual,
                child: Text(localizations.settingsFollowUpBehaviorManual),
              ),
              DropdownMenuItem(
                value: FollowUpBehavior.disabled,
                child: Text(localizations.settingsFollowUpBehaviorDisabled),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                ref
                    .read(generalControllerProvider.notifier)
                    .setFollowUpBehavior(value);
              }
            },
          ),
        ),
      ],
    );
  }

  String _languageLabel(AppLocalizations localizations, AppLanguage language) {
    switch (language) {
      case AppLanguage.system:
        return localizations.languageSystem;
      case AppLanguage.english:
        return localizations.languageEnglish;
      case AppLanguage.chinese:
        return localizations.languageChinese;
    }
  }

  String _followUpBehaviorLabel(
    AppLocalizations localizations,
    FollowUpBehavior behavior,
  ) {
    switch (behavior) {
      case FollowUpBehavior.auto:
        return localizations.settingsFollowUpBehaviorAuto;
      case FollowUpBehavior.manual:
        return localizations.settingsFollowUpBehaviorManual;
      case FollowUpBehavior.disabled:
        return localizations.settingsFollowUpBehaviorDisabled;
    }
  }
}
