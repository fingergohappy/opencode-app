import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/generated/app_localizations.dart';
import 'general/section.dart';
import 'notifications/section.dart';
import 'sound/section.dart';
import 'theme/section.dart';
import 'updates/section.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.settingsTitle)),
      // 页面壳层只负责导航与基础布局，具体设置内容统一下沉到
      // SettingsScreenContent，方便后续复用或按分区继续拆分。
      body: const SafeArea(child: SettingsScreenContent()),
    );
  }
}

class SettingsScreenContent extends ConsumerWidget {
  const SettingsScreenContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: const [
        // 每个分区各自 watch 自己关心的 provider，避免把所有设置状态
        // 混在一个 build 方法里，后续新增设置项时也更容易定位修改点。
        GeneralSection(),
        Divider(),
        AppearanceSection(),
        Divider(),
        NotificationsSection(),
        Divider(),
        SoundSection(),
        Divider(),
        UpdatesSection(),
      ],
    );
  }
}
