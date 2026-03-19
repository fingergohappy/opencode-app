import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller.dart';
import 'model.dart';

final localeControllerProvider =
    NotifierProvider<LocaleController, LocaleSettings>(LocaleController.new);

final appLanguageProvider = Provider<AppLanguage>((ref) {
  return ref.watch(localeControllerProvider).language;
});

final currentLocaleProvider = Provider<Locale?>((ref) {
  return switch (ref.watch(appLanguageProvider)) {
    AppLanguage.system => null,
    AppLanguage.english => const Locale('en'),
    AppLanguage.chinese => const Locale('zh'),
  };
});
