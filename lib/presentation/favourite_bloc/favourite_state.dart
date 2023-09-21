import 'package:test_intern/domain/models/result_model.dart';

abstract class FavoritesState {
  const FavoritesState();
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<ResultModel> favoriteItems;

  const FavoritesLoaded(this.favoriteItems);
}

class FavoritesError extends FavoritesState {
  final String errorMessage;

  const FavoritesError(this.errorMessage);
}
