import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controller.dart';
import 'model.dart';

final updateControllerProvider =
    NotifierProvider<UpdateController, UpdateSettings>(
  UpdateController.new,
);

final autoCheckUpdatesProvider = Provider<bool>((ref) {
  return ref.watch(updateControllerProvider).autoCheckUpdates;
});

final showReleaseNotesProvider = Provider<bool>((ref) {
  return ref.watch(updateControllerProvider).showReleaseNotes;
});
