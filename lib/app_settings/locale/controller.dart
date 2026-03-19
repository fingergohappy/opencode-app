import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'model.dart';

class LocaleController extends Notifier<LocaleSettings> {
  @override
  LocaleSettings build() {
    return ref.read(appSettingsStorageProvider).load().locale;
  }

  void setLanguage(AppLanguage language) {
    state = state.copyWith(language: language);
  }
}
