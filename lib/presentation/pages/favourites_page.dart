import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/presentation/favourite_bloc/favourite_bloc.dart';
import 'package:test_intern/presentation/favourite_bloc/favourite_event.dart';
import 'package:test_intern/presentation/favourite_bloc/favourite_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/repositories/sql_service.dart';

class FavouritesPage extends StatefulWidget {
  final String userEmail;
  const FavouritesPage({
    required this.userEmail,
  });

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  late FavoritesBloc favoritesBloc;

  @override
  void initState() {
    super.initState();
    favoritesBloc = context.read<FavoritesBloc>();
    _loadFavoritesData();
  }

  Future<void> _loadFavoritesData() async {
    final favorites =
        await SQLService().getFavoriteCharacters(widget.userEmail);
    favoritesBloc.add(FavoritesLoadedEvent(favorites));
  }

  @override
  Widget build(BuildContext context) {
    final favoritesBloc = context.read<FavoritesBloc>();
    print(favoritesBloc.state);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.favourites ?? ''),
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        bloc: favoritesBloc,
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
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: const Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onDismissed: (direction) {
                      BlocProvider.of<FavoritesBloc>(context)
                          .add(RemoveFromFavoritesEvent(item));
                    },
                    child: ListTile(
                      title: Text(item.name ?? ''),
                    ),
                  );
                },
              );
            }
          }
          return Center(
            child: Text(AppLocalizations.of(context)?.emptyFavs ?? ''),
          );
        },
      ),
    );
  }
}
