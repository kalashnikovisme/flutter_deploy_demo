import 'package:equatable/equatable.dart';
import 'package:test_intern/domain/models/result_model.dart';

abstract class FavoritesEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class AddToFavoritesEvent extends FavoritesEvent {
  final ResultModel item;

  AddToFavoritesEvent(this.item);
}

class RemoveFromFavoritesEvent extends FavoritesEvent {
  final ResultModel item;

  RemoveFromFavoritesEvent(this.item);
}

class FavoritesLoadedEvent  extends FavoritesEvent{
  FavoritesLoadedEvent();
}
class UpdateUserEmailEvent extends FavoritesEvent {
  final String newEmail;

  UpdateUserEmailEvent(this.newEmail);

  @override
  List<Object> get props => [newEmail];
}
