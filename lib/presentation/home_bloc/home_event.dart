import 'package:equatable/equatable.dart';
import 'package:test_intern/domain/models/result_model.dart';

abstract class PagEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadListEvent extends PagEvent {}

class LoadNextPageEvent extends PagEvent {}

class UpdateCountEvent extends PagEvent {
  final int newCount;

  UpdateCountEvent(this.newCount);

  @override
  List<Object?> get props => [newCount];
}

class RefreshDataEvent extends PagEvent {}

class SearchNameEvent extends PagEvent {
  final String name;

  SearchNameEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class ClearSearchEvent extends PagEvent {}

class AddToFavoritesHomeEvent extends PagEvent {
  final ResultModel itemToAdd;

  AddToFavoritesHomeEvent({required this.itemToAdd});

  @override
  List<Object?> get props => [itemToAdd];
}

class RemoveFromFavoritesHomeEvent extends PagEvent {
  final ResultModel itemToRemove;

  RemoveFromFavoritesHomeEvent({required this.itemToRemove});

  @override
  List<Object?> get props => [itemToRemove];
}

class ClearFavoritesEvent extends PagEvent {
  ClearFavoritesEvent();
}