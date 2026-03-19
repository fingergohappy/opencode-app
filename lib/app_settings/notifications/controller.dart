import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'model.dart';

class NotificationController extends Notifier<NotificationSettings> {
  @override
  NotificationSettings build() {
    return ref.read(appSettingsStorageProvider).load().notifications;
  }

  void setAgentNotifications(bool value) {
    state = state.copyWith(agentNotifications: value);
  }

  void setPermissionNotifications(bool value) {
    state = state.copyWith(permissionNotifications: value);
  }

  void setErrorNotifications(bool value) {
    state = state.copyWith(errorNotifications: value);
  }
}
