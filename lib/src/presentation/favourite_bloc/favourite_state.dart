import 'package:equatable/equatable.dart';
import 'package:test_intern/src/domain/models/result_model.dart';

class FavoritesState extends Equatable {
  final List<ResultModel> favoriteItems;
  final String email;
  final bool isLoading;
  final bool isFavourite;

  const FavoritesState({
    required this.favoriteItems,
    required this.isFavourite,
    required this.isLoading,
    required this.email,
  });

  FavoritesState copyWith(
      {List<ResultModel>? favoriteItems,
      bool? isFavourite,
      String? email,
      bool? isLoading}) {
    return FavoritesState(
      favoriteItems: favoriteItems ?? this.favoriteItems,
      isFavourite: isFavourite ?? this.isFavourite,
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [favoriteItems, email, isLoading, isFavourite];
}
