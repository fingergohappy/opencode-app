import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controller.dart';
import 'model.dart';

final notificationControllerProvider =
    NotifierProvider<NotificationController, NotificationSettings>(
  NotificationController.new,
);

final agentNotificationsProvider = Provider<bool>((ref) {
  return ref.watch(notificationControllerProvider).agentNotifications;
});

final permissionNotificationsProvider = Provider<bool>((ref) {
  return ref.watch(notificationControllerProvider).permissionNotifications;
});

final errorNotificationsProvider = Provider<bool>((ref) {
  return ref.watch(notificationControllerProvider).errorNotifications;
});
