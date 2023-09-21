import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/data/repositories/sql_service.dart';
import 'package:test_intern/presentation/favourite_bloc/favourite_bloc.dart';
import 'package:test_intern/presentation/favourite_bloc/favourite_event.dart';
import 'package:test_intern/presentation/favourite_bloc/favourite_state.dart';
import 'package:test_intern/presentation/home_bloc/home_bloc.dart';
import 'package:test_intern/presentation/home_bloc/home_event.dart';



class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key,});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  final SQLService service = SQLService();

  final userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
  Future<void> _loadFavoriteCharacters(String email) async {
    await service.getFavoriteCharacters(email);
  }

  @override
  void initState() {
    super.initState();
    _loadFavoriteCharacters(userEmail);
    BlocProvider.of<FavoritesBloc>(context)
        .add(FavoritesLoadedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites List'),
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          final favoritesBloc = BlocProvider.of<FavoritesBloc>(context);
          if (state is FavoritesLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is FavoritesLoaded) {
            final favoriteItems = state.favoriteItems;
            return ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final items = favoriteItems[index];
                return ListTile(
                  title: Text(items.name ?? ''),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      favoritesBloc.add(RemoveFromFavoritesEvent(items));
                      BlocProvider.of<HomeBloc>(context)
                          .add(RemoveFromFavoritesHomeEvent(
                        itemToRemove: items,
                      ));
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No favorite albums.'));
          }
        },
      ),
    );
  }
}
