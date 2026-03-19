import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controller.dart';
import 'model.dart';

final generalControllerProvider =
    NotifierProvider<GeneralController, GeneralSettings>(
  GeneralController.new,
);

final showReasoningSummariesProvider = Provider<bool>((ref) {
  return ref.watch(generalControllerProvider).showReasoningSummaries;
});

final expandShellToolPartsProvider = Provider<bool>((ref) {
  return ref.watch(generalControllerProvider).expandShellToolParts;
});

final expandEditToolPartsProvider = Provider<bool>((ref) {
  return ref.watch(generalControllerProvider).expandEditToolParts;
});

final followUpBehaviorProvider = Provider<FollowUpBehavior>((ref) {
  return ref.watch(generalControllerProvider).followUpBehavior;
});
