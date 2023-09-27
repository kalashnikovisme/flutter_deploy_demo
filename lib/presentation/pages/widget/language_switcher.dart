import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/l10n/l10n.dart';
import 'package:test_intern/presentation/localization_bloc/localization_bloc.dart';
import 'package:test_intern/presentation/localization_bloc/localization_event.dart';
import 'package:test_intern/presentation/localization_bloc/localization_state.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, currentLocale) {
        return PopupMenuButton<Locale>(
          onSelected: (locale) {
            context.read<LanguageBloc>().add(ToggleLanguageEvent([locale]));
          },
          itemBuilder: (BuildContext context) {
            return L10N.supportedLanguage.map((Locale locale) {
              return PopupMenuItem<Locale>(
                value: locale,
                child: Text(
                  _getLocaleName(locale),
                ),
              );
            }).toList();
          },
        );
      },
    );
  }

  String _getLocaleName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'ru':
        return 'Русский';
      default:
        return 'Unknown';
    }
  }
}
