import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controller.dart';
import 'model.dart';

final soundControllerProvider =
    NotifierProvider<SoundController, SoundSettings>(
  SoundController.new,
);

final soundEnabledProvider = Provider<bool>((ref) {
  return ref.watch(soundControllerProvider).soundEnabled;
});
