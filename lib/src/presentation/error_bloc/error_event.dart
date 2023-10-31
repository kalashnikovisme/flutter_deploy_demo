import 'package:equatable/equatable.dart';

class ErrorEvent extends Equatable {
  const ErrorEvent();
  @override
  List<Object?> get props => throw UnimplementedError();
}

class ShowErrorEvent extends ErrorEvent {
  final String message;

  const ShowErrorEvent({required this.message});

  @override
  List<Object?> get props => [message];
}

class ClearErrorEvent extends ErrorEvent {}
