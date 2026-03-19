import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'model.dart';

class UpdateController extends Notifier<UpdateSettings> {
  @override
  UpdateSettings build() {
    return ref.read(appSettingsStorageProvider).load().updates;
  }

  void setAutoCheckUpdates(bool value) {
    state = state.copyWith(autoCheckUpdates: value);
  }

  void setShowReleaseNotes(bool value) {
    state = state.copyWith(showReleaseNotes: value);
  }
}
