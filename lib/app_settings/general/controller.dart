import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'model.dart';

class GeneralController extends Notifier<GeneralSettings> {
  @override
  GeneralSettings build() {
    return ref.read(appSettingsStorageProvider).load().general;
  }

  void setShowReasoningSummaries(bool value) {
    state = state.copyWith(showReasoningSummaries: value);
  }

  void setExpandShellToolParts(bool value) {
    state = state.copyWith(expandShellToolParts: value);
  }

  void setExpandEditToolParts(bool value) {
    state = state.copyWith(expandEditToolParts: value);
  }

  void setFollowUpBehavior(FollowUpBehavior behavior) {
    state = state.copyWith(followUpBehavior: behavior);
  }
}
