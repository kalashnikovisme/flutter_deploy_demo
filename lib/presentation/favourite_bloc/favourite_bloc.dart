import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_intern/data/repositories/sql_service.dart';
import 'package:test_intern/domain/models/result_model.dart';
import 'package:test_intern/presentation/favourite_bloc/favourite_event.dart';
import 'package:test_intern/presentation/favourite_bloc/favourite_state.dart';


class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final SQLService service = SQLService();
  List<ResultModel> result = [];
  String email;
  FavoritesBloc(this.email) : super(FavoritesLoading()) {
    on<AddToFavoritesEvent>(addToFavs);
    on<RemoveFromFavoritesEvent>(removeFromFav);
    on<FavoritesLoadedEvent>(loadFavsList);
  }


  void loadFavsList(FavoritesLoadedEvent event, Emitter<FavoritesState> emit) async {
    final albumsList = await service.getFavoriteCharacters(email);
    if (albumsList!.isNotEmpty) {
      result = albumsList;
    }
    emit(FavoritesLoaded(result));
  }

  void addToFavs(AddToFavoritesEvent event, Emitter<FavoritesState> emit) async {
    if (event.item.isFavorite) {
      await  service.saveToFavourite(event.item, email);
    }
  }

  void removeFromFav(RemoveFromFavoritesEvent event, Emitter<FavoritesState> emit) async {
    result.removeWhere((element) => element.id == event.item.id);
    await service.delete(event.item, email);
    emit(FavoritesLoaded(result));
  }
}
