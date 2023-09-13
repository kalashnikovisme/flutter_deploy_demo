import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/l10n/l10n.dart';
import 'package:test_intern/presentation/home_bloc/home_bloc.dart';
import 'package:test_intern/presentation/localization_bloc/localization_bloc.dart';
import 'package:test_intern/presentation/localization_bloc/localization_state.dart';
import 'package:test_intern/presentation/pages/home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => LanguageBloc(),
        child: BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            return MaterialApp(
              locale: Locale(state.locale.first.languageCode,
                  state.locale.last.languageCode),
              supportedLocales: L10N.supportedLanguage,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: BlocProvider(
                create: (context) => HomeBloc(),
                child: const HomePage(),
              ),
            );
          },
        ));
  }
}
