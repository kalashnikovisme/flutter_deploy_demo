import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/data/repositories/api_service.dart';
import 'package:test_intern/presentation/error_bloc/error_bloc.dart';
import 'package:test_intern/presentation/error_bloc/error_event.dart';
import 'package:test_intern/presentation/favourite_bloc/favourite_bloc.dart';
import 'package:test_intern/presentation/home_bloc/home_bloc.dart';
import 'package:test_intern/presentation/pages/home_page.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({Key? key}) : super(key: key);

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
          BlocProvider(
            create: (context) => FavoritesBloc(),
          ),
          BlocProvider(
            create: (context) => HomeBloc(
              context.read<ApiService>(),
            ),
          ),
        ],
        child: Navigator(
          onGenerateRoute: (RouteSettings settings) {
            builder(BuildContext _) => const HomePage(email: '');
            return MaterialPageRoute(builder: builder, settings: settings);
          },
        ),
      ),
    );
  }
}
