import 'package:equatable/equatable.dart';

class ErrorState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ShowErrorState extends ErrorState {
  final String message;

  ShowErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
