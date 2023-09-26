import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/data/repositories/api_service.dart';
import 'package:test_intern/l10n/l10n.dart';
import 'package:test_intern/presentation/auth_bloc/auth_bloc.dart';
import 'package:test_intern/presentation/connectivity_cubit/connectivity_cubit.dart';
import 'package:test_intern/presentation/error_bloc/error_bloc.dart';
import 'package:test_intern/presentation/error_bloc/error_event.dart';
import 'package:test_intern/presentation/favourite_bloc/favourite_bloc.dart';
import 'package:test_intern/presentation/home_bloc/home_bloc.dart';
import 'package:test_intern/presentation/localization_bloc/localization_bloc.dart';
import 'package:test_intern/presentation/localization_bloc/localization_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:test_intern/presentation/pages/enter_page.dart';

import 'data/repositories/sql_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SQLService().initDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
    final favoritesBloc = FavoritesBloc(userEmail);

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
          BlocProvider<HomeBloc>(
            create: (context) => HomeBloc(context.read<ApiService>()),
          ),
          BlocProvider<ConnectionCubit>(
            create: (context) => ConnectionCubit(),
          ),
          BlocProvider<FavoritesBloc>(
            create:  (context) => FavoritesBloc(userEmail),
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
                locale: Locale(state.locale.first.languageCode,
                    state.locale.last.languageCode),
                supportedLocales: L10N.supportedLanguage,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                title: 'Flutter Demo',
                theme: ThemeData(
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                  useMaterial3: true,
                ),
                home: EnterPage(),
              );
            },
          ),
        ),
      ),
    );
  }
}
