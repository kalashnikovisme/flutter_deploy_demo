import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/presentation/favourite_bloc/favourite_bloc.dart';
import 'package:test_intern/presentation/favourite_bloc/favourite_event.dart';
import 'package:test_intern/presentation/favourite_bloc/favourite_state.dart';
import 'package:test_intern/presentation/home_bloc/home_bloc.dart';
import 'package:test_intern/presentation/home_bloc/home_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavouritesPage extends StatefulWidget {
  final String userEmail;
  const FavouritesPage({
    required this.userEmail,
    super.key,
  });

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FavoritesBloc>(context).add(FavoritesLoadedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.favourites ?? ''),
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final favoriteItems = state.favoriteItems;
            if (favoriteItems.isNotEmpty) {
              return ListView.builder(
                itemCount: favoriteItems.length,
                itemBuilder: (context, index) {
                  final item = favoriteItems[index];
                  return ListTile(
                    key: UniqueKey(),
                    title: Text(item.name ?? ''),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        BlocProvider.of<FavoritesBloc>(context)
                            .add(RemoveFromFavoritesEvent(item));
                        BlocProvider.of<HomeBloc>(context).add(
                          RemoveFromFavoritesHomeEvent(itemToRemove: item),
                        );
                      },
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text(AppLocalizations.of(context)?.emptyFavs ?? ''),
              );
            }
          }
        },
      ),
    );
  }
}
