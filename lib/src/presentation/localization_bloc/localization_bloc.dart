import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/src/l10n/l10n.dart';
import 'package:test_intern/src/presentation/localization_bloc/localization_event.dart';
import 'package:test_intern/src/presentation/localization_bloc/localization_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageLoaded(L10N.supportedLanguage)) {
    on<ToggleLanguageEvent>(_toggleLanguage);
  }

  void _toggleLanguage(ToggleLanguageEvent event, Emitter<LanguageState> emit) {
    emit(LanguageLoaded(event.language));
  }
}
