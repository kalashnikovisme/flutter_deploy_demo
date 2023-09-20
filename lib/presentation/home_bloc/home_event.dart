import 'package:equatable/equatable.dart';

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
