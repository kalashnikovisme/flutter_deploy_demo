import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/components/color_style.dart';
import 'package:test_intern/components/text_styles.dart';
import 'package:test_intern/data/repositories/sql_service.dart';
import 'package:test_intern/presentation/auth_bloc/auth_bloc.dart';
import 'package:test_intern/presentation/auth_bloc/auth_event.dart';
import 'package:test_intern/presentation/connectivity_cubit/connectivity_cubit.dart';
import 'package:test_intern/presentation/error_bloc/error_bloc.dart';
import 'package:test_intern/presentation/error_bloc/error_event.dart';
import 'package:test_intern/presentation/error_bloc/error_state.dart';
import 'package:test_intern/presentation/favourite_bloc/favourite_event.dart';
import 'package:test_intern/presentation/home_bloc/home_bloc.dart';
import 'package:test_intern/presentation/home_bloc/home_event.dart';
import 'package:test_intern/presentation/home_bloc/home_state.dart';
import 'package:test_intern/presentation/pages/favourites_page.dart';
import 'package:test_intern/presentation/pages/widget/error_text_widget.dart';
import 'package:test_intern/presentation/pages/widget/image_grid_widget.dart';
import 'package:test_intern/presentation/pages/widget/language_switcher.dart';
import 'package:test_intern/presentation/pages/widget/text_field_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../favourite_bloc/favourite_bloc.dart';

class HomePage extends StatefulWidget {
  final String email;
  const HomePage({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController controller = TextEditingController();


  @override
  void initState() {
    super.initState();
    if (mounted) {
      BlocProvider.of<HomeBloc>(context).add(LoadListEvent());
      context.read<FavoritesBloc>().add(FavoritesLoadEvent());
      final connectionCubit = context.read<ConnectionCubit>();
      connectionCubit.stream.listen((connectionState) {
        if (mounted) {
          if (connectionState.result == ConnectivityResult.mobile ||
              connectionState.result == ConnectivityResult.wifi ||
              connectionState.result == ConnectivityResult.none) {
            BlocProvider.of<ErrorBloc>(context).add(ClearErrorEvent());
            BlocProvider.of<HomeBloc>(context).add(LoadListEvent());
          }
        }
      });
    }
  }
  @override
  void dispose() {
    _scrollController.dispose();
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          LanguageSwitcher(),
        ],
        leading: IconButton(
          icon: const Icon(Icons.favorite),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FavouritesPage(
                  userEmail: widget.email,
                ),
              ),
            );
          },
        ),
      ),
      body: BlocBuilder<ErrorBloc, ErrorState>(
        builder: (context, errorState) {
          if (errorState is ShowErrorState) {
            return ErrorTextWidget(
              message: errorState.message,
            );
          } else {
            return BlocBuilder<HomeBloc, PagState>(
              builder: (context, state) {
                if (!state.isLoading && state.result.isNotEmpty) {
                  return NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification &&
                          _scrollController.position.extentAfter == 0) {
                        context.read<HomeBloc>().add(LoadNextPageEvent());
                      }
                      return false;
                    },
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<HomeBloc>().add(RefreshDataEvent());
                      },
                      child: Column(
                        children: [
                          TextFieldWidget(
                            controller: controller,
                          ),
                          Expanded(
                            child: GridView.builder(
                              controller: _scrollController,
                              itemCount: state.result.length + 1,
                              itemBuilder: (context, index) {
                                if (index < state.result.length) {
                                  final item = state.result[index];
                                  return ImageGridWidget(
                                    resultModel: item,
                                  );
                                }
                                if (state.next.isEmpty) {
                                  return Center(
                                    child: Text(
                                      AppLocalizations.of(context)
                                              ?.allDataLoadedString ??
                                          '',
                                      style: TextsStyles.allDataLoadedString,
                                    ),
                                  );
                                }
                                if (state.isCached) {
                                  WidgetsBinding.instance.addPostFrameCallback(
                                    (_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: state.isCached
                                              ? Colors.red
                                              : Colors.green,
                                          content: state.isCached
                                              ? Text(
                                                  AppLocalizations.of(context)
                                                          ?.dataApi ??
                                                      '')
                                              : Text(
                                                  AppLocalizations.of(context)
                                                          ?.dataCache ??
                                                      ''),
                                        ),
                                      );
                                    },
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showExitDialog(context);
        },
        label: Text(
          AppLocalizations.of(context)?.exitButtonString ?? '',
        ),
      ),
    );
  }

  Future<void> _showExitDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorStyle.modalSheetColor,
          title: Text(
            AppLocalizations.of(context)?.exitModalString ?? '',
            style: TextsStyles.modalSheet,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)?.no ?? '',
                style: TextsStyles.modalSheet,
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(SignOutEvent());
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)?.yes ?? '',
                style: TextsStyles.modalSheet,
              ),
            ),
          ],
        );
      },
    );
  }
}
