import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/data/repositories/api_service.dart';
import 'package:test_intern/l10n/l10n.dart';
import 'package:test_intern/presentation/error_bloc/error_bloc.dart';
import 'package:test_intern/presentation/error_bloc/error_event.dart';
import 'package:test_intern/presentation/localization_bloc/localization_bloc.dart';
import 'package:test_intern/presentation/localization_bloc/localization_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:test_intern/root_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
            home: BlocProvider<ErrorBloc>(
              lazy: false,
              create: (context) => ErrorBloc(),
              child: RepositoryProvider<ApiService>(
                lazy: true,
                create: (context) => ApiService(
                  errorHandler: (String message) {
                    context.read<ErrorBloc>().add(
                          ShowErrorEvent(
                            message: message,
                          ),
                        );
                  },
                ),
                child: const RootScreen(),
              ),
            ),
          );
        },
      ),
    );
  }
}
