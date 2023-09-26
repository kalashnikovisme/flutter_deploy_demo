import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/data/repositories/sql_service.dart';
import 'package:test_intern/presentation/favourite_bloc/favourite_event.dart';
import 'package:test_intern/presentation/favourite_bloc/favourite_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final SQLService service = SQLService();
  String userEmail;
  FavoritesBloc(this.userEmail)
      : super(const FavoritesState(
          favoriteItems: [],
          isFavourite: false,
          isLoading: false,
          email: '',
        )) {
    on<AddToFavoritesEvent>(_onAddToFavorites);
    on<RemoveFromFavoritesEvent>(_onRemoveFromFavorites);
    on<FavoritesLoadedEvent>(_onLoadFavsList);
  }

  void _onLoadFavsList(
      FavoritesLoadedEvent event, Emitter<FavoritesState> emit) async {
    final albumsList = await service.getFavoriteCharacters(userEmail);
    emit(FavoritesState(
        favoriteItems: albumsList ?? [],
        isFavourite: true,
        isLoading: false,
        email: userEmail));

    print('from bloc');
    print(albumsList);
  }

  void _onAddToFavorites(
      AddToFavoritesEvent event, Emitter<FavoritesState> emit) async {
    final updatedFavorites = List.of(state.favoriteItems);

    if (!updatedFavorites.contains(event.item)) {
      updatedFavorites.add(event.item);
    }

    emit(FavoritesState(
      favoriteItems: updatedFavorites,
      isLoading: false,
      email: userEmail,
      isFavourite: true,
    ));

    await service.saveToFavourite(event.item, userEmail);
  }

  void _onRemoveFromFavorites(
      RemoveFromFavoritesEvent event, Emitter<FavoritesState> emit) async {
    final updatedFavorites = List.of(state.favoriteItems);
    updatedFavorites.remove(event.item);

    if (updatedFavorites.contains(event.item)) {
      updatedFavorites.remove(event.item);
    }

    emit(FavoritesState(
      favoriteItems: updatedFavorites,
      isLoading: false,
      email: userEmail,
      isFavourite: false,
    ));

    await service.delete(event.item, userEmail);
  }
}
