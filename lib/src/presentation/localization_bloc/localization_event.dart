import 'dart:ui';

abstract class LanguageEvent {}

class ToggleLanguageEvent extends LanguageEvent {
  final List<Locale> language;

  ToggleLanguageEvent(this.language);
}
