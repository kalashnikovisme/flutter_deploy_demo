import 'dart:ui';

abstract class LanguageState {
  final List<Locale> locale;
  const LanguageState(this.locale);
}

class LanguageLoaded extends LanguageState {
  const LanguageLoaded(super.locale);
}
