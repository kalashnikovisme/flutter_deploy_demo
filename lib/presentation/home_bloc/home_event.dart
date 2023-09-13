import 'package:equatable/equatable.dart';

abstract class PagEvent extends Equatable {}

class LoadListEvent extends PagEvent {
  @override
  List<Object?> get props => [];
}

class LoadNextPageEvent extends PagEvent {
  @override
  List<Object?> get props => [];
}

class UpdateCountEvent extends PagEvent {
  final int newCount;

  UpdateCountEvent(this.newCount);

  @override
  List<Object?> get props => [newCount];
}

class RefreshDataEvent extends PagEvent {
  @override
  List<Object?> get props => [];
}

class SearchNameEvent extends PagEvent {
  final String name;
  SearchNameEvent(this.name);
  List<Object?> get props => [];
}

class ClearSearchEven extends PagEvent {
  @override
  List<Object?> get props => [];
}
