import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/data/repositories/api_service.dart';
import 'package:test_intern/l10n/l10n.dart';
import 'package:test_intern/presentation/auth_bloc/auth_bloc.dart';
import 'package:test_intern/presentation/connectivity_cubit/connectivity_cubit.dart';
import 'package:test_intern/presentation/error_bloc/error_bloc.dart';
import 'package:test_intern/presentation/error_bloc/error_event.dart';
import 'package:test_intern/presentation/localization_bloc/localization_bloc.dart';
import 'package:test_intern/presentation/localization_bloc/localization_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:test_intern/presentation/pages/enter_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.appName}) : super(key: key);

  final String appName;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiService>(
          create: (context) => ApiService(
            errorHandler: (String message) {
              context.read<ErrorBloc>().add(
                    ShowErrorEvent(
                      message: message,
                    ),
                  );
            },
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(),
          ),
          BlocProvider<ConnectionCubit>(
            create: (context) => ConnectionCubit(),
          ),
          BlocProvider<ErrorBloc>(
            create: (context) => ErrorBloc(),
          ),
        ],
        child: BlocProvider(
          create: (context) => LanguageBloc(),
          child: BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                locale: Locale(state.locale.first.languageCode, state.locale.last.languageCode),
                supportedLocales: L10N.supportedLanguage,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                title: appName,
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                  useMaterial3: true,
                ),
                home: const EnterPage(),
              );
            },
          ),
        ),
      ),
    );
  }
}
