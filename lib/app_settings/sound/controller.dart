import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'model.dart';

class SoundController extends Notifier<SoundSettings> {
  @override
  SoundSettings build() {
    return ref.read(appSettingsStorageProvider).load().sound;
  }

  void setSoundEnabled(bool value) {
    state = state.copyWith(soundEnabled: value);
  }
}
