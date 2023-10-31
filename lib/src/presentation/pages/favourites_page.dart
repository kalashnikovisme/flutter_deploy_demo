import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/src/presentation/favourite_bloc/favourite_bloc.dart';
import 'package:test_intern/src/presentation/favourite_bloc/favourite_event.dart';
import 'package:test_intern/src/presentation/favourite_bloc/favourite_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavouritesPage extends StatefulWidget {
  final String userEmail;

  const FavouritesPage({
    super.key,
    required this.userEmail,
  });

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesBloc>().add(FavoritesLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    final favoritesBloc = context.read<FavoritesBloc>();
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
                      BlocProvider.of<FavoritesBloc>(context).add(RemoveFromFavoritesEvent(item));
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
